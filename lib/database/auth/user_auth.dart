import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  //
  final auth = FirebaseAuth.instance;

  //signin
  SignIn(String email, String password) async {
    await auth.signInWithEmailAndPassword(email: email, password: password);
  }

  //signup
  SignUp(String email, String password) async {
    await auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  //SignOut
  SignOut() async {
    await auth.signOut();
  }
}

class User {
  //
  final currentUser = FirebaseAuth.instance.currentUser!;
  //
  final id = FirebaseAuth.instance.currentUser!.uid;
  final email = FirebaseAuth.instance.currentUser!.email;
  final username = FirebaseAuth.instance.currentUser!.displayName;
}