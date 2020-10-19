import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DbHelper {
  static User currentUser;
  static Future<List<String>> getUserWatchlist(User user) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection("watchlist")
        .doc(user.uid)
        .get();
    List<String> list = List<String>();
    final result = querySnapshot.data()["watched_stocks"];
    if (result is String) {
      list.add(result);
    } else {
      list = List<String>.from(result);
    }
    return list;
  }

  static void setUser(User user) {
    currentUser = user;
  }

  static void addToWatchlist(String ticker) async {
    final userRef =
        FirebaseFirestore.instance.collection("watchlist").doc(currentUser.uid);
    // Append to watched_stocks
    userRef
        .update({
          'watched_stocks': FieldValue.arrayUnion(['$ticker'])
        })
        .then((value) => print("Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }
}
