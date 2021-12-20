import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Functions {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Map<String, bool> bookmarks = {};

  Future<bool> signin(String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }

      return false;
    }
  }

  Future<bool> register(String email, String password) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<void> getitems() async {

    await firestore
        .collection("items")
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var element in querySnapshot.docs) {
        bookmarks[element["name"].toString()] = false;
      }
    });

    await firestore
        .collection("users")
        .add({"email": auth.currentUser!.email, "bookmarks": bookmarks});

  }

  Future<void> getitmeslogin() async {
    await firestore
        .collection("users")
        .where("email", isEqualTo: auth.currentUser!.email)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var element in querySnapshot.docs) {
        bookmarks = Map.from(element["bookmarks"]);
      }
    });
  }

  Future<void> update(String email, String item) async {
    Map<String, bool> bookmark = {};

    await firestore
        .collection("users")
        .where("email", isEqualTo: email)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var element in querySnapshot.docs) {
        bookmark = Map.from(element["bookmarks"]);
        print(bookmark);
      }
    });

    for (var element in bookmark.keys) {
      if (element == item) {
        bookmark[item] = bookmark[item]! ? false : true;
      }
    }

    await firestore
        .collection("users")
        .where("email", isEqualTo: email)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var element in querySnapshot.docs) {
        element.reference.update({"bookmarks": bookmark});
      }
    });

    await getitmeslogin();
  }
}
