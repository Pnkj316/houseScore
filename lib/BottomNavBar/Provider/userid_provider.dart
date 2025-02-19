import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProvider with ChangeNotifier {
  String _userId = '';

  String get userId => _userId;

  UserProvider() {
    _fetchUserId();
  }

  Future<void> _fetchUserId() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _userId = user.uid;
      notifyListeners();
    }
  }

  void setUserId(String id) {
    _userId = id;
    notifyListeners();
  }
}
