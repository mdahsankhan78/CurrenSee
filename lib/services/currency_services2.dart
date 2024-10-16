import 'package:cloud_firestore/cloud_firestore.dart';

  FirebaseFirestore _instance = FirebaseFirestore.instance;
class CurrencyServices2{
  Future<String?> fetchBaseCurrency2(String? userId) async {
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
}