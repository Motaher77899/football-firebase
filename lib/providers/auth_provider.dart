import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _currentUser != null;

  // Sign Up
  Future<bool> signUp({
    required String fullName,
    required String email,
    required String password,
    required String division,
    required String district,
    required String upazila,
    required String gender,
    required DateTime dateOfBirth,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Create user in Firebase Auth
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create user model
      UserModel user = UserModel(
        uid: userCredential.user!.uid,
        fullName: fullName,
        email: email,
        division: division,
        district: district,
        upazila: upazila,
        gender: gender,
        dateOfBirth: dateOfBirth,
        createdAt: DateTime.now(),
      );

      // Save to Firestore
      await _firestore.collection('users').doc(user.uid).set(user.toMap());

      // Update display name
      await userCredential.user!.updateDisplayName(fullName);

      _currentUser = user;

      // Save login status
      await _saveLoginStatus(true, user.uid);

      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getErrorMessage(e.code);
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'একটি সমস্যা হয়েছে। আবার চেষ্টা করুন।';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Sign In
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Fetch user data from Firestore
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (doc.exists) {
        _currentUser = UserModel.fromFirestore(doc);
        await _saveLoginStatus(true, _currentUser!.uid);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'ব্যবহারকারীর তথ্য পাওয়া যায়নি';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getErrorMessage(e.code);
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'একটি সমস্যা হয়েছে। আবার চেষ্টা করুন।';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
    await _saveLoginStatus(false, null);
    _currentUser = null;
    notifyListeners();
  }

  // Check if user is logged in
  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    String? uid = prefs.getString('uid');

    if (isLoggedIn && uid != null) {
      try {
        DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
        if (doc.exists) {
          _currentUser = UserModel.fromFirestore(doc);
          notifyListeners();
        }
      } catch (e) {
        debugPrint('Error checking login status: $e');
      }
    }
  }

  // Update Profile
  Future<bool> updateProfile({
    required String fullName,
    required String division,
    required String district,
    required String upazila,
    required String gender,
    required DateTime dateOfBirth,
  }) async {
    if (_currentUser == null) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      UserModel updatedUser = _currentUser!.copyWith(
        fullName: fullName,
        division: division,
        district: district,
        upazila: upazila,
        gender: gender,
        dateOfBirth: dateOfBirth,
      );

      await _firestore.collection('users').doc(_currentUser!.uid).update({
        'fullName': fullName,
        'division': division,
        'district': district,
        'upazila': upazila,
        'gender': gender,
        'dateOfBirth': Timestamp.fromDate(dateOfBirth),
      });

      _currentUser = updatedUser;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'প্রোফাইল আপডেট করতে সমস্যা হয়েছে';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Save login status to SharedPreferences
  Future<void> _saveLoginStatus(bool isLoggedIn, String? uid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', isLoggedIn);
    if (uid != null) {
      await prefs.setString('uid', uid);
    } else {
      await prefs.remove('uid');
    }
  }

  // Get error message in Bengali
  String _getErrorMessage(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'এই ইমেইল আগে থেকেই ব্যবহৃত হচ্ছে';
      case 'invalid-email':
        return 'ইমেইল সঠিক নয়';
      case 'weak-password':
        return 'পাসওয়ার্ড অন্তত ৬ অক্ষরের হতে হবে';
      case 'user-not-found':
        return 'ব্যবহারকারী পাওয়া যায়নি';
      case 'wrong-password':
        return 'পাসওয়ার্ড ভুল';
      default:
        return 'একটি সমস্যা হয়েছে। আবার চেষ্টা করুন।';
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}