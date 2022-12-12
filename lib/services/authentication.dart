import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final _user = FirebaseAuth.instance.currentUser;

  static  User? get user => _user;
}