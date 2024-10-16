import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// class NotificationService {
//   FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<void> initialize() async {
//     await Firebase.initializeApp();

//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print("Notification received: ${message.notification!.body}");
//     });

//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print("Notification opened from terminated state: ${message.notification!.body}");
//       // Handle navigation here if needed
//     });
//   }

//   Future<void> subscribeToCurrency(String currency) async {
//     await _firebaseMessaging.subscribeToTopic(currency);
//   }

//   Future<void> unsubscribeFromCurrency(String currency) async {
//     await _firebaseMessaging.unsubscribeFromTopic(currency);
//   }

//   Future<void> handleCurrencyRateChange(String currency) async {
//     // Fetch currency rate change
//     // Determine if there's a rate change for the subscribed currency
//     // If there's a change, send notification
//     await _firestore.collection('subscriptions').doc(currency).get().then((snapshot) {
//       if (snapshot.exists) {
//         List<String> subscribedUsers = List.from(snapshot.data()!['users']);
//         for (String userId in subscribedUsers) {
//           // Send notification to each subscribed user
//           _sendNotification(userId, 'Currency rate for $currency has changed');
//         }
//       }
//     });
//   }

//   Future<void> _sendNotification(String userId, String message) async {
//     // Send notification to the user with the given userId
//     // You need to implement this method using Firebase Cloud Messaging
//   }
// }




///////////////////////////////
///import 'package:cloud_firestore/cloud_firestore.dart';

 User? user = FirebaseAuth.instance.currentUser;
  String userId = user!.uid;
class NotificationService {
  static Future<void> saveNotificationPreference(String currency, bool isEnabled, double rate) async {
    final userUid = userId; // Replace with actual user UID
    final collectionReference = FirebaseFirestore.instance.collection('notificationPreferences');
    
    try {
      await collectionReference.doc(userUid).set({
        'notifications': {
          currency: {
            'enabled': isEnabled,
            'rate': rate,
          }
        }
      }, SetOptions(merge: true));
    } catch (e) {
      print("Error saving notification preference: $e");
      throw e;
    }
  }

  /////update
  ///
  //
  static Future<void> updateCurrencyRates(Map<String, dynamic> rates) async {
    final userUid = userId;
    final collectionReference =
        FirebaseFirestore.instance.collection('notificationPreferences');

    try {
      final documentSnapshot =
          await collectionReference.doc(userUid).get(); // Get current document
      final data = documentSnapshot.data();

      if (data != null && data['notifications'] != null) {
        final Map<String, dynamic> notifications = Map<String, dynamic>.from(
            data['notifications']); // Get current notifications
        notifications.forEach((currency, _) {
          if (rates.containsKey(currency)) {
            notifications[currency]['rate'] = rates[currency];
          }
        });

        await collectionReference.doc(userUid).set({
          'notifications': notifications,
        }, SetOptions(merge: true));
      }
    } catch (e) {
      print("Error updating currency rates: $e");
      throw e;
    }
  }
  

  ///check which currency's notification are on
  //
   static Future<bool> isNotificationEnabled(String userUid, String currency) async {
  final DocumentSnapshot snapshot = await FirebaseFirestore.instance
      .collection('notificationPreferences')
      .doc(userUid)
      .get();
  final Map<String, dynamic>? preferences = snapshot.data() as Map<String, dynamic>?;

  if (preferences != null && preferences['notifications'] != null) {
    final Map<String, dynamic> notifications = preferences['notifications'];
    if (notifications[currency] != null) {
      return notifications[currency]['enabled'];
    }
  }
  return false;
}

  
  ////remove
  //
   static Future<void> deleteNotificationPreference(String userUid, String currency) async {
    final collectionReference = FirebaseFirestore.instance.collection('notificationPreferences');
    try {
      await collectionReference.doc(userUid).update({
        'notifications.$currency.enabled': false,
      });
    } catch (e) {
      print("Error deleting notification preference: $e");
      throw e;
    }
  }
}
