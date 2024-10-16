import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency_converter/services/currency_services2.dart';
import 'package:currency_converter/services/select_currency_service.dart';
import 'package:currency_converter/ui/widgets/button.dart';
import 'package:currency_converter/ui/widgets/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  FirebaseFirestore _instance = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
  String? baseCurrency; // Holds the base currency value
  
  // In _buildTable method of _HistoryPageState

IconButton buildDeleteIcon(String historyId) {
  return IconButton(
    icon: Icon(Icons.delete),
    color: Colors.red,
    onPressed: () {
      _deleteHistory(historyId);
    },
  );
}

void _deleteHistory(String historyId) async {
  String userId = user!.uid;
  await SelectCurrencyService.deleteHistory(userId, historyId);
  setState(() {
    // Refresh the UI after deleting the history entry
  });
}

@override
  void initState() {
    super.initState();
    String userId = user!.uid; // Replace this with the user's ID
     // Call the function to fetch the base currency when the page loads
    CurrencyServices2().fetchBaseCurrency2(userId).then((currency) {
      setState(() {
        baseCurrency = currency; // Update the state with the fetched base currency
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffffbc0d),
        actions: [
          // Display the base currency button on the app bar
          if (baseCurrency != null)
             MyAppbar(),
        ],
      ),
       drawer: const AppDrawer(),
      
      backgroundColor:const Color(0xff121331),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchConversionHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            return const Center(child: Text('No conversion history available.', style: TextStyle(color: Colors.white),));
          } else {
            // Display conversion history in a beautiful table format
            return _buildTable(snapshot.data!);
          }
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _fetchConversionHistory() async {
    List<Map<String, dynamic>> history = [];
    String userId = user!.uid;
    QuerySnapshot querySnapshot = await _instance.collection("users").doc(userId).collection("conversionHistory").get();
    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Add document ID to the map
      history.add(data);
    });
    return history;
  }

Widget _buildTable(List<Map<String, dynamic>> history) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Container(
        color: const Color(0xffffbc0d), // Use the app bar color
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: const Center(
          child: Text(
            'Conversion History',
            style: TextStyle(
              color: Color(0xff121331), // Text color
              fontWeight: FontWeight.bold, // Bold font weight
              fontSize: 20.0, // Font size
              
            ),
          ),
        ),
      ),
      Expanded(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xff121331), // Set background color to blue
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 2, color: Color(0xffffbc0d)), // Border color
                  ),
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Amount', style: TextStyle(color: Color(0xffffbc0d)), textAlign: TextAlign.center)),
                      DataColumn(label: Text('From Currency', style: TextStyle(color: Color(0xffffbc0d)), textAlign: TextAlign.center)),
                      DataColumn(label: Text('To Currency', style: TextStyle(color: Color(0xffffbc0d)), textAlign: TextAlign.center)),
                      DataColumn(label: Text('Converted', style: TextStyle(color: Color(0xffffbc0d)), textAlign: TextAlign.center)),
                      DataColumn(label: Text('Timestamp', style: TextStyle(color: Color(0xffffbc0d)), textAlign: TextAlign.center)),
                      DataColumn(label: Text('', style: TextStyle(color: Color(0xffffbc0d)), textAlign: TextAlign.center)),
                    ],
                    rows: history.map<DataRow>((entry) {
                      // Format the timestamp
                      DateTime timestamp = (entry['timestamp'] as Timestamp).toDate();
                      String formattedTimestamp = timestamp.toString();
                      // Format the converted value with two decimal places
                      String convertedValue = double.parse(entry['converted'].toString()).toStringAsFixed(2);
              
                      return DataRow(cells: [
                        DataCell(Text(entry['amount'].toString(), style: const TextStyle(color: Colors.white), textAlign: TextAlign.center)),
                        DataCell(Text(entry['fromCurrency'], style: const TextStyle(color: Colors.white), textAlign: TextAlign.center)),
                        DataCell(Text(entry['toCurrency'], style: const TextStyle(color: Colors.white), textAlign: TextAlign.center)),
                        DataCell(Text(convertedValue, style: const TextStyle(color: Colors.white), textAlign: TextAlign.center)),
                        DataCell(Text(formattedTimestamp, style: const TextStyle(color: Colors.white), textAlign: TextAlign.center)),
                        DataCell(buildDeleteIcon(entry['id'])), // Accessing the document ID
                      ]);
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}





}
