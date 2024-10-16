import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency_converter/services/currency_services2.dart';
import 'package:currency_converter/services/notification_service.dart';
import 'package:currency_converter/ui/widgets/button.dart';
import 'package:currency_converter/ui/widgets/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

User? user = FirebaseAuth.instance.currentUser;
String userId = user!.uid;
final userUid = userId; // Replace with actual user UID
  String? baseCurrency; // Holds the base currency value
  FirebaseFirestore _instance = FirebaseFirestore.instance;

class Currencies extends StatefulWidget {
  const Currencies({Key? key}) : super(key: key);

  @override
  _CurrenciesState createState() => _CurrenciesState();
}

class _CurrenciesState extends State<Currencies> {
  late Future<Map<String, dynamic>> _fetchCurrencies;
  TextEditingController searchController = TextEditingController();
  String sortOption = 'A to Z';
  String searchQuery = '';

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin(); // Initialize the plugin

  @override
  void initState() {
    super.initState();

    _fetchCurrencies = _fetchCurrencyData();
    // Initialize the plugin
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    CurrencyServices2().fetchBaseCurrency2(userId).then((currency) {
      setState(() {
        baseCurrency = currency; // Update the state with the fetched base currency
      });
    });
  }

  void _showNotification(String currency, String from, String to) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'currency_channel', 'Currency Channel', 'Channel for currency notifications',
        importance: Importance.max, priority: Priority.high, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'Currency Notification', '$currency rates updated from $from to $to', platformChannelSpecifics,
        payload: 'currency_notification');
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
        backgroundColor: Color(0xffffbc0d),
      ),
    );
  }

  Future<Map<String, dynamic>> _fetchCurrencyData() async {
    final api = "https://api.exchangerate-api.com/v4/latest/USD";
    final response = await http.get(Uri.parse(api));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load currency data');
    }
  }

  Future<void> _compareRatesAndSendNotifications(Map<String, dynamic> currentRates) async {
    final notificationPreferences = await FirebaseFirestore.instance
        .collection('notificationPreferences')
        .doc(userUid)
        .get();
    final preferences = notificationPreferences.data();
    if (preferences != null) {
      final notifications = preferences['notifications'];
      if (notifications != null) {
        notifications.forEach((currency, data) {
          final bool isEnabled = data['enabled'];
          final double savedRate = data['rate'];
          final double currentRate = currentRates[currency] ?? 0.0;
          if (isEnabled && currentRate != savedRate) {
            NotificationService.updateCurrencyRates(currentRates);
            _showNotification(currency, savedRate.toString(), currentRate.toString());
            // _showErrorSnackbar('$currency rates changed from $savedRate to $currentRate');
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Currencies'),
        backgroundColor: const Color(0xffffbc0d),
        actions: [
          // Display the base currency button on the app bar
          if (baseCurrency != null)
             MyAppbar(),
        ],
      ),
      drawer: const AppDrawer(),
      backgroundColor: const Color(0xff121331),
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Search Box
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value.toLowerCase();
                      });
                    },
                    textAlign: TextAlign.center,
                    controller: searchController,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Search',
                      labelStyle: TextStyle(
                        color: Color(0xffffbc0d),
                        fontSize: 15,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                          width: 2,
                          color: Color(0xFF837E93),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                          width: 2,
                          color: Color(0xffffbc0d),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    onChanged: (String? newValue) {
                      setState(() {
                        sortOption = newValue!;
                      });
                    },
                    items: [
                      'A to Z',
                      'Z to A',
                      'Lowest Rate',
                      'Highest Rate',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Sort',
                      labelStyle: TextStyle(
                        color: Color(0xffffbc0d),
                        fontSize: 15,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                          width: 2,
                          color: Color(0xFF837E93),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                          width: 2,
                          color: Color(0xffffbc0d),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xff121331),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 2, color: Color(0xffffbc0d)),
                  ),
                  child: FutureBuilder(
                    future: _fetchCurrencies,
                    builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        final Map<String, dynamic> currencyData = snapshot.data!;
                        final Map<String, dynamic> rates = currencyData['rates'];
                        // Compare rates and send notifications
                        _compareRatesAndSendNotifications(rates);
                        List<String> filteredAndSortedCurrencies = rates.keys
                            .where((currency) =>
                                currency.toLowerCase().contains(searchQuery))
                            .toList();
                        filteredAndSortedCurrencies.sort((a, b) {
                          if (sortOption == 'A to Z') {
                            return a.compareTo(b);
                          } else if (sortOption == 'Z to A') {
                            return b.compareTo(a);
                          } else {
                            double rateA = rates[a];
                            double rateB = rates[b];
                            return sortOption == 'Lowest Rate'
                                ? rateA.compareTo(rateB)
                                : rateB.compareTo(rateA);
                          }
                        });

                        return DataTable(
                          columns: const [
                            DataColumn(label: Text('Currency', style: TextStyle(color: Colors.white))),
                            DataColumn(label: Text('Rate', style: TextStyle(color: Colors.white))),
                            DataColumn(label: Text('', style: TextStyle(color: Colors.white))),
                          ],
                          rows: filteredAndSortedCurrencies.map<DataRow>((currency) {
                            return DataRow(cells: [
                              DataCell(Text(currency, style: const TextStyle(color: Colors.white))),
                              DataCell(Text(rates[currency].toString(), style: const TextStyle(color: Colors.white))),
                              DataCell(GestureDetector(
                                onTap: () async {
                                  bool isEnabled = await NotificationService.isNotificationEnabled(userUid, currency);
                                  if (isEnabled) {
                                    await NotificationService.deleteNotificationPreference(userUid, currency);
                                    _showErrorSnackbar('$currency notifications are turned off');
                                  } else {
                                    await NotificationService.saveNotificationPreference(currency, true, 200);
                                    _showErrorSnackbar('$currency notifications are turned on');
                                  }
                                  setState(() {}); // Refresh UI after toggling notification preference
                                },
                                child: FutureBuilder<bool>(
                                  future: NotificationService.isNotificationEnabled(userUid, currency),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    }
                                    return Icon(
                                      snapshot.data ?? false ? Icons.notifications_off : Icons.notifications,
                                      color: Colors.white,
                                    );
                                  },
                                ),
                              )),
                            ]);
                          }).toList(),
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
