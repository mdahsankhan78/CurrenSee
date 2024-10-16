import 'package:cloud_firestore/cloud_firestore.dart';

class SelectCurrencyService {
  FirebaseFirestore _instance = FirebaseFirestore.instance;
  
  
  // Function to add currency
  Future addCurrency(String? userId, String? curr) async {
    CollectionReference userCollection = _instance.collection("users").doc(userId).collection("basecurrency");
    await userCollection.doc(DateTime.now().microsecondsSinceEpoch.toString()).set({
      "curr": curr,
    });
  }
// Function to fetch user's base currency
  Future<String?> fetchBaseCurrency(String? userId) async {
    CollectionReference userCollection =
        _instance.collection("users").doc(userId).collection("basecurrency");

    QuerySnapshot querySnapshot = await userCollection.get();
    if (querySnapshot.docs.isNotEmpty) {
      // Assuming only one document is present in the collection
      var data = querySnapshot.docs.first.data() as Map<String, dynamic>?; // Explicit type casting
      if (data != null && data.containsKey("curr")) {
        return data["curr"] as String?;
      } else {
        return null;
      }
    } else {
      return null; // If no documents are found
    }
  }

  // Function to update user's base currency
  Future<void> updateBaseCurrency(String? userId, String? newCurrency) async {
    CollectionReference userCollection = _instance.collection("users").doc(userId).collection("basecurrency");

    // Fetch existing document
    QuerySnapshot querySnapshot = await userCollection.get();
    if (querySnapshot.docs.isNotEmpty) {
      // Assuming only one document is present in the collection
      String docId = querySnapshot.docs.first.id;
      await userCollection.doc(docId).update({"curr": newCurrency});
    } else {
      // If no documents are found, add new document
      await addCurrency(userId, newCurrency);
    }
  }
  
  // Function to save conversion history
  Future<void> saveConversionHistory(
      String? userId, double amount, String fromCurrency, String toCurrency, double? converted) async {
    CollectionReference historyCollection =
        _instance.collection("users").doc(userId).collection("conversionHistory");
    await historyCollection.doc(DateTime.now().microsecondsSinceEpoch.toString()).set({
      "amount": amount,
      "fromCurrency": fromCurrency,
      "toCurrency": toCurrency,
      "converted": converted,
      "timestamp": DateTime.now(),
    });
  }
   static Future<void> deleteHistory(String userId, String historyId) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("conversionHistory")
        .doc(historyId)
        .delete();
  }
}




