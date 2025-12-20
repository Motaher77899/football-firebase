// // // import 'package:flutter/material.dart';
// // // import 'package:firebase_auth/firebase_auth.dart';
// // // import 'package:cloud_firestore/cloud_firestore.dart';
// // // import 'package:shared_preferences/shared_preferences.dart';
// // // import '../models/user_model.dart';
// // //
// // // class AuthProvider extends ChangeNotifier {
// // //   final FirebaseAuth _auth = FirebaseAuth.instance;
// // //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// // //
// // //   UserModel? _currentUser;
// // //   bool _isLoading = false;
// // //   String? _errorMessage;
// // //
// // //   UserModel? get currentUser => _currentUser;
// // //   bool get isLoading => _isLoading;
// // //   String? get errorMessage => _errorMessage;
// // //   bool get isLoggedIn => _currentUser != null;
// // //
// // //   // Sign Up
// // //   Future<bool> signUp({
// // //     required String fullName,
// // //     required String email,
// // //     required String password,
// // //     required String division,
// // //     required String district,
// // //     required String upazila,
// // //     required String gender,
// // //     required DateTime dateOfBirth,
// // //   }) async {
// // //     _isLoading = true;
// // //     _errorMessage = null;
// // //     notifyListeners();
// // //
// // //     try {
// // //       // Create user in Firebase Auth
// // //       UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
// // //         email: email,
// // //         password: password,
// // //       );
// // //
// // //       // Create user model
// // //       UserModel user = UserModel(
// // //         uid: userCredential.user!.uid,
// // //         fullName: fullName,
// // //         email: email,
// // //         division: division,
// // //         district: district,
// // //         upazila: upazila,
// // //         gender: gender,
// // //         dateOfBirth: dateOfBirth,
// // //         createdAt: DateTime.now(),
// // //       );
// // //
// // //       // Save to Firestore
// // //       await _firestore.collection('users').doc(user.uid).set(user.toMap());
// // //
// // //       // Update display name
// // //       await userCredential.user!.updateDisplayName(fullName);
// // //
// // //       _currentUser = user;
// // //
// // //       // Save login status
// // //       await _saveLoginStatus(true, user.uid);
// // //
// // //       _isLoading = false;
// // //       notifyListeners();
// // //       return true;
// // //     } on FirebaseAuthException catch (e) {
// // //       _errorMessage = _getErrorMessage(e.code);
// // //       _isLoading = false;
// // //       notifyListeners();
// // //       return false;
// // //     } catch (e) {
// // //       _errorMessage = 'একটি সমস্যা হয়েছে। আবার চেষ্টা করুন।';
// // //       _isLoading = false;
// // //       notifyListeners();
// // //       return false;
// // //     }
// // //   }
// // //
// // //   // Sign In
// // //   Future<bool> signIn({
// // //     required String email,
// // //     required String password,
// // //   }) async {
// // //     _isLoading = true;
// // //     _errorMessage = null;
// // //     notifyListeners();
// // //
// // //     try {
// // //       UserCredential userCredential = await _auth.signInWithEmailAndPassword(
// // //         email: email,
// // //         password: password,
// // //       );
// // //
// // //       // Fetch user data from Firestore
// // //       DocumentSnapshot doc = await _firestore
// // //           .collection('users')
// // //           .doc(userCredential.user!.uid)
// // //           .get();
// // //
// // //       if (doc.exists) {
// // //         _currentUser = UserModel.fromFirestore(doc);
// // //         await _saveLoginStatus(true, _currentUser!.uid);
// // //         _isLoading = false;
// // //         notifyListeners();
// // //         return true;
// // //       } else {
// // //         _errorMessage = 'ব্যবহারকারীর তথ্য পাওয়া যায়নি';
// // //         _isLoading = false;
// // //         notifyListeners();
// // //         return false;
// // //       }
// // //     } on FirebaseAuthException catch (e) {
// // //       _errorMessage = _getErrorMessage(e.code);
// // //       _isLoading = false;
// // //       notifyListeners();
// // //       return false;
// // //     } catch (e) {
// // //       _errorMessage = 'একটি সমস্যা হয়েছে। আবার চেষ্টা করুন।';
// // //       _isLoading = false;
// // //       notifyListeners();
// // //       return false;
// // //     }
// // //   }
// // //
// // //   // Sign Out
// // //   Future<void> signOut() async {
// // //     await _auth.signOut();
// // //     await _saveLoginStatus(false, null);
// // //     _currentUser = null;
// // //     notifyListeners();
// // //   }
// // //
// // //   // Check if user is logged in
// // //   Future<void> checkLoginStatus() async {
// // //     SharedPreferences prefs = await SharedPreferences.getInstance();
// // //     bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
// // //     String? uid = prefs.getString('uid');
// // //
// // //     if (isLoggedIn && uid != null) {
// // //       try {
// // //         DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
// // //         if (doc.exists) {
// // //           _currentUser = UserModel.fromFirestore(doc);
// // //           notifyListeners();
// // //         }
// // //       } catch (e) {
// // //         debugPrint('Error checking login status: $e');
// // //       }
// // //     }
// // //   }
// // //
// // //   // Update Profile
// // //   Future<bool> updateProfile({
// // //     required String fullName,
// // //     required String division,
// // //     required String district,
// // //     required String upazila,
// // //     required String gender,
// // //     required DateTime dateOfBirth,
// // //   }) async {
// // //     if (_currentUser == null) return false;
// // //
// // //     _isLoading = true;
// // //     _errorMessage = null;
// // //     notifyListeners();
// // //
// // //     try {
// // //       UserModel updatedUser = _currentUser!.copyWith(
// // //         fullName: fullName,
// // //         division: division,
// // //         district: district,
// // //         upazila: upazila,
// // //         gender: gender,
// // //         dateOfBirth: dateOfBirth,
// // //       );
// // //
// // //       await _firestore.collection('users').doc(_currentUser!.uid).update({
// // //         'fullName': fullName,
// // //         'division': division,
// // //         'district': district,
// // //         'upazila': upazila,
// // //         'gender': gender,
// // //         'dateOfBirth': Timestamp.fromDate(dateOfBirth),
// // //       });
// // //
// // //       _currentUser = updatedUser;
// // //       _isLoading = false;
// // //       notifyListeners();
// // //       return true;
// // //     } catch (e) {
// // //       _errorMessage = 'প্রোফাইল আপডেট করতে সমস্যা হয়েছে';
// // //       _isLoading = false;
// // //       notifyListeners();
// // //       return false;
// // //     }
// // //   }
// // //
// // //   // Save login status to SharedPreferences
// // //   Future<void> _saveLoginStatus(bool isLoggedIn, String? uid) async {
// // //     SharedPreferences prefs = await SharedPreferences.getInstance();
// // //     await prefs.setBool('isLoggedIn', isLoggedIn);
// // //     if (uid != null) {
// // //       await prefs.setString('uid', uid);
// // //     } else {
// // //       await prefs.remove('uid');
// // //     }
// // //   }
// // //
// // //   // Get error message in Bengali
// // //   String _getErrorMessage(String code) {
// // //     switch (code) {
// // //       case 'email-already-in-use':
// // //         return 'এই ইমেইল আগে থেকেই ব্যবহৃত হচ্ছে';
// // //       case 'invalid-email':
// // //         return 'ইমেইল সঠিক নয়';
// // //       case 'weak-password':
// // //         return 'পাসওয়ার্ড অন্তত ৬ অক্ষরের হতে হবে';
// // //       case 'user-not-found':
// // //         return 'ব্যবহারকারী পাওয়া যায়নি';
// // //       case 'wrong-password':
// // //         return 'পাসওয়ার্ড ভুল';
// // //       default:
// // //         return 'একটি সমস্যা হয়েছে। আবার চেষ্টা করুন।';
// // //     }
// // //   }
// // //
// // //   void clearError() {
// // //     _errorMessage = null;
// // //     notifyListeners();
// // //   }
// // // }
// //
// //
// // import 'package:flutter/material.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_storage/firebase_storage.dart'; // নতুন
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'dart:io'; // নতুন
// // import '../models/user_model.dart';
// //
// // class AuthProvider extends ChangeNotifier {
// //   final FirebaseAuth _auth = FirebaseAuth.instance;
// //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// //   final FirebaseStorage _storage = FirebaseStorage.instance; // নতুন
// //
// //   UserModel? _currentUser;
// //   bool _isLoading = false;
// //   String? _errorMessage;
// //
// //   UserModel? get currentUser => _currentUser;
// //   bool get isLoading => _isLoading;
// //   String? get errorMessage => _errorMessage;
// //   bool get isLoggedIn => _currentUser != null;
// //
// //
// //   // ছবি আপলোড ফাংশন
// //   Future<String?> _uploadProfileImage(String uid, File imageFile) async {
// //     try {
// //       Reference storageRef = _storage.ref().child('profile_photos').child('$uid.jpg');
// //       UploadTask uploadTask = storageRef.putFile(imageFile);
// //       TaskSnapshot snapshot = await uploadTask;
// //       String downloadUrl = await snapshot.ref.getDownloadURL();
// //       return downloadUrl;
// //     } catch (e) {
// //       debugPrint('Error uploading profile image: $e');
// //       return null;
// //     }
// //   }
// //
// //   // প্রোফাইল ফটো আপডেট ফাংশন (নতুন)
// //   Future<bool> updateProfilePhoto(File imageFile) async {
// //     if (_currentUser == null) return false;
// //
// //     _isLoading = true;
// //     _errorMessage = null;
// //     notifyListeners();
// //
// //     try {
// //       String? photoUrl = await _uploadProfileImage(_currentUser!.uid, imageFile);
// //
// //       if (photoUrl != null) {
// //         // Firestore এ URL আপডেট
// //         await _firestore.collection('users').doc(_currentUser!.uid).update({
// //           'profilePhotoUrl': photoUrl,
// //         });
// //
// //         // লোকাল মডেল আপডেট
// //         _currentUser = _currentUser!.copyWith(profilePhotoUrl: photoUrl);
// //         _isLoading = false;
// //         notifyListeners();
// //         return true;
// //       } else {
// //         _errorMessage = 'ছবি আপলোড ব্যর্থ হয়েছে';
// //         _isLoading = false;
// //         notifyListeners();
// //         return false;
// //       }
// //     } catch (e) {
// //       _errorMessage = 'প্রোফাইল ফটো আপডেট করতে সমস্যা হয়েছে';
// //       _isLoading = false;
// //       notifyListeners();
// //       return false;
// //     }
// //   }
// //
// //   // Sign Up
// //   Future<bool> signUp({
// //     required String fullName,
// //     required String email,
// //     required String password,
// //     required String division,
// //     required String district,
// //     required String upazila,
// //     required String gender,
// //     required DateTime dateOfBirth,
// //   }) async {
// //     _isLoading = true;
// //     _errorMessage = null;
// //     notifyListeners();
// //
// //     try {
// //       // Create user in Firebase Auth
// //       UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
// //         email: email,
// //         password: password,
// //       );
// //
// //       // Create user model
// //       UserModel user = UserModel(
// //         uid: userCredential.user!.uid,
// //         fullName: fullName,
// //         email: email,
// //         division: division,
// //         district: district,
// //         upazila: upazila,
// //         gender: gender,
// //         dateOfBirth: dateOfBirth,
// //         profilePhotoUrl: null, // নতুন ব্যবহারকারীর জন্য ডিফল্ট null
// //         createdAt: DateTime.now(),
// //       );
// //
// //       // Save to Firestore
// //       await _firestore.collection('users').doc(user.uid).set(user.toMap());
// //
// //       // Update display name
// //       await userCredential.user!.updateDisplayName(fullName);
// //
// //       _currentUser = user;
// //
// //       // Save login status
// //       await _saveLoginStatus(true, user.uid);
// //
// //       _isLoading = false;
// //       notifyListeners();
// //       return true;
// //     } on FirebaseAuthException catch (e) {
// //       _errorMessage = _getErrorMessage(e.code);
// //       _isLoading = false;
// //       notifyListeners();
// //       return false;
// //     } catch (e) {
// //       _errorMessage = 'একটি সমস্যা হয়েছে। আবার চেষ্টা করুন।';
// //       _isLoading = false;
// //       notifyListeners();
// //       return false;
// //     }
// //   }
// //
// //   // Sign In (অপরিবর্তিত)
// //   Future<bool> signIn({
// //     required String email,
// //     required String password,
// //   }) async {
// //     _isLoading = true;
// //     _errorMessage = null;
// //     notifyListeners();
// //
// //     try {
// //       UserCredential userCredential = await _auth.signInWithEmailAndPassword(
// //         email: email,
// //         password: password,
// //       );
// //
// //       // Fetch user data from Firestore
// //       DocumentSnapshot doc = await _firestore
// //           .collection('users')
// //           .doc(userCredential.user!.uid)
// //           .get();
// //
// //       if (doc.exists) {
// //         _currentUser = UserModel.fromFirestore(doc);
// //         await _saveLoginStatus(true, _currentUser!.uid);
// //         _isLoading = false;
// //         notifyListeners();
// //         return true;
// //       } else {
// //         _errorMessage = 'ব্যবহারকারীর তথ্য পাওয়া যায়নি';
// //         _isLoading = false;
// //         notifyListeners();
// //         return false;
// //       }
// //     } on FirebaseAuthException catch (e) {
// //       _errorMessage = _getErrorMessage(e.code);
// //       _isLoading = false;
// //       notifyListeners();
// //       return false;
// //     } catch (e) {
// //       _errorMessage = 'একটি সমস্যা হয়েছে। আবার চেষ্টা করুন।';
// //       _isLoading = false;
// //       notifyListeners();
// //       return false;
// //     }
// //   }
// //
// //   // Sign Out (অপরিবর্তিত)
// //   Future<void> signOut() async {
// //     await _auth.signOut();
// //     await _saveLoginStatus(false, null);
// //     _currentUser = null;
// //     notifyListeners();
// //   }
// //
// //   // Check if user is logged in (অপরিবর্তিত)
// //   Future<void> checkLoginStatus() async {
// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
// //     String? uid = prefs.getString('uid');
// //
// //     if (isLoggedIn && uid != null) {
// //       try {
// //         DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
// //         if (doc.exists) {
// //           _currentUser = UserModel.fromFirestore(doc);
// //           notifyListeners();
// //         }
// //       } catch (e) {
// //         debugPrint('Error checking login status: $e');
// //       }
// //     }
// //   }
// //
// //   // Update Profile (অপরিবর্তিত)
// //   Future<bool> updateProfile({
// //     required String fullName,
// //     required String division,
// //     required String district,
// //     required String upazila,
// //     required String gender,
// //     required DateTime dateOfBirth,
// //   }) async {
// //     if (_currentUser == null) return false;
// //
// //     _isLoading = true;
// //     _errorMessage = null;
// //     notifyListeners();
// //
// //     try {
// //       UserModel updatedUser = _currentUser!.copyWith(
// //         fullName: fullName,
// //         division: division,
// //         district: district,
// //         upazila: upazila,
// //         gender: gender,
// //         dateOfBirth: dateOfBirth,
// //       );
// //
// //       await _firestore.collection('users').doc(_currentUser!.uid).update({
// //         'fullName': fullName,
// //         'division': division,
// //         'district': district,
// //         'upazila': upazila,
// //         'gender': gender,
// //         'dateOfBirth': Timestamp.fromDate(dateOfBirth),
// //       });
// //
// //       _currentUser = updatedUser;
// //       _isLoading = false;
// //       notifyListeners();
// //       return true;
// //     } catch (e) {
// //       _errorMessage = 'প্রোফাইল আপডেট করতে সমস্যা হয়েছে';
// //       _isLoading = false;
// //       notifyListeners();
// //       return false;
// //     }
// //   }
// //
// //   // Save login status to SharedPreferences (অপরিবর্তিত)
// //   Future<void> _saveLoginStatus(bool isLoggedIn, String? uid) async {
// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     await prefs.setBool('isLoggedIn', isLoggedIn);
// //     if (uid != null) {
// //       await prefs.setString('uid', uid);
// //     } else {
// //       await prefs.remove('uid');
// //     }
// //   }
// //
// //   // Get error message in Bengali (অপরিবর্তিত)
// //   String _getErrorMessage(String code) {
// //     switch (code) {
// //       case 'email-already-in-use':
// //         return 'এই ইমেইল আগে থেকেই ব্যবহৃত হচ্ছে';
// //       case 'invalid-email':
// //         return 'ইমেইল সঠিক নয়';
// //       case 'weak-password':
// //         return 'পাসওয়ার্ড অন্তত ৬ অক্ষরের হতে হবে';
// //       case 'user-not-found':
// //         return 'ব্যবহারকারী পাওয়া যায়নি';
// //       case 'wrong-password':
// //         return 'পাসওয়ার্ড ভুল';
// //       default:
// //         return 'একটি সমস্যা হয়েছে। আবার চেষ্টা করুন।';
// //     }
// //   }
// //
// //   void clearError() {
// //     _errorMessage = null;
// //     notifyListeners();
// //   }
// // }
//
//
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:io';
// import '../models/user_model.dart';
//
// class AuthProvider extends ChangeNotifier {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseStorage _storage = FirebaseStorage.instance;
//
//   UserModel? _currentUser;
//   bool _isLoading = false;
//   String? _errorMessage;
//
//   UserModel? get currentUser => _currentUser;
//   bool get isLoading => _isLoading;
//   String? get errorMessage => _errorMessage;
//   bool get isLoggedIn => _currentUser != null;
//
//   // ছবি আপলোড ফাংশন
//   Future<String?> _uploadProfileImage(String uid, File imageFile) async {
//     try {
//       Reference storageRef = _storage.ref().child('profile_photos').child('$uid.jpg');
//       UploadTask uploadTask = storageRef.putFile(imageFile);
//       TaskSnapshot snapshot = await uploadTask;
//       String downloadUrl = await snapshot.ref.getDownloadURL();
//       return downloadUrl;
//     } catch (e) {
//       debugPrint('❌ Error uploading profile image: $e');
//       return null;
//     }
//   }
//
//   // ✅ প্রোফাইল ফটো আপডেট ফাংশন (আপডেটেড - Player Profile এও ছবি আপডেট হবে)
//   Future<bool> updateProfilePhoto(File imageFile) async {
//     if (_currentUser == null) return false;
//
//     _isLoading = true;
//     _errorMessage = null;
//     notifyListeners();
//
//     try {
//       String? photoUrl = await _uploadProfileImage(_currentUser!.uid, imageFile);
//
//       if (photoUrl != null) {
//         // 1️⃣ Users Collection এ URL আপডেট
//         await _firestore.collection('users').doc(_currentUser!.uid).update({
//           'profilePhotoUrl': photoUrl,
//         });
//
//         // 2️⃣ Players Collection এও URL আপডেট (যদি player profile থাকে)
//         QuerySnapshot playerQuery = await _firestore
//             .collection('players')
//             .where('userId', isEqualTo: _currentUser!.uid)
//             .limit(1)
//             .get();
//
//         if (playerQuery.docs.isNotEmpty) {
//           await playerQuery.docs.first.reference.update({
//             'profilePhotoUrl': photoUrl,
//           });
//           debugPrint('✅ Player profile photo updated');
//         }
//
//         // 3️⃣ লোকাল মডেল আপডেট
//         _currentUser = _currentUser!.copyWith(profilePhotoUrl: photoUrl);
//         _isLoading = false;
//         notifyListeners();
//         return true;
//       } else {
//         _errorMessage = 'ছবি আপলোড ব্যর্থ হয়েছে';
//         _isLoading = false;
//         notifyListeners();
//         return false;
//       }
//     } catch (e) {
//       debugPrint('❌ Error updating profile photo: $e');
//       _errorMessage = 'প্রোফাইল ফটো আপডেট করতে সমস্যা হয়েছে';
//       _isLoading = false;
//       notifyListeners();
//       return false;
//     }
//   }
//
//   // Sign Up
//   Future<bool> signUp({
//     required String fullName,
//     required String email,
//     required String password,
//     required String division,
//     required String district,
//     required String upazila,
//     required String gender,
//     required DateTime dateOfBirth,
//   }) async {
//     _isLoading = true;
//     _errorMessage = null;
//     notifyListeners();
//
//     try {
//       // Create user in Firebase Auth
//       UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//
//       // Create user model
//       UserModel user = UserModel(
//         uid: userCredential.user!.uid,
//         fullName: fullName,
//         email: email,
//         division: division,
//         district: district,
//         upazila: upazila,
//         gender: gender,
//         dateOfBirth: dateOfBirth,
//         profilePhotoUrl: null,
//         createdAt: DateTime.now(),
//       );
//
//       // Save to Firestore
//       await _firestore.collection('users').doc(user.uid).set(user.toMap());
//
//       // Update display name
//       await userCredential.user!.updateDisplayName(fullName);
//
//       _currentUser = user;
//
//       // Save login status
//       await _saveLoginStatus(true, user.uid);
//
//       _isLoading = false;
//       notifyListeners();
//       return true;
//     } on FirebaseAuthException catch (e) {
//       _errorMessage = _getErrorMessage(e.code);
//       _isLoading = false;
//       notifyListeners();
//       return false;
//     } catch (e) {
//       _errorMessage = 'একটি সমস্যা হয়েছে। আবার চেষ্টা করুন।';
//       _isLoading = false;
//       notifyListeners();
//       return false;
//     }
//   }
//
//   // Sign In
//   Future<bool> signIn({
//     required String email,
//     required String password,
//   }) async {
//     _isLoading = true;
//     _errorMessage = null;
//     notifyListeners();
//
//     try {
//       UserCredential userCredential = await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//
//       // Fetch user data from Firestore
//       DocumentSnapshot doc = await _firestore
//           .collection('users')
//           .doc(userCredential.user!.uid)
//           .get();
//
//       if (doc.exists) {
//         _currentUser = UserModel.fromFirestore(doc);
//         await _saveLoginStatus(true, _currentUser!.uid);
//         _isLoading = false;
//         notifyListeners();
//         return true;
//       } else {
//         _errorMessage = 'ব্যবহারকারীর তথ্য পাওয়া যায়নি';
//         _isLoading = false;
//         notifyListeners();
//         return false;
//       }
//     } on FirebaseAuthException catch (e) {
//       _errorMessage = _getErrorMessage(e.code);
//       _isLoading = false;
//       notifyListeners();
//       return false;
//     } catch (e) {
//       _errorMessage = 'একটি সমস্যা হয়েছে। আবার চেষ্টা করুন।';
//       _isLoading = false;
//       notifyListeners();
//       return false;
//     }
//   }
//
//   // Sign Out
//   Future<void> signOut() async {
//     await _auth.signOut();
//     await _saveLoginStatus(false, null);
//     _currentUser = null;
//     notifyListeners();
//   }
//
//   // Check if user is logged in
//   Future<void> checkLoginStatus() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
//     String? uid = prefs.getString('uid');
//
//     if (isLoggedIn && uid != null) {
//       try {
//         DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
//         if (doc.exists) {
//           _currentUser = UserModel.fromFirestore(doc);
//           notifyListeners();
//         }
//       } catch (e) {
//         debugPrint('❌ Error checking login status: $e');
//       }
//     }
//   }
//
//   // Update Profile
//   Future<bool> updateProfile({
//     required String fullName,
//     required String division,
//     required String district,
//     required String upazila,
//     required String gender,
//     required DateTime dateOfBirth,
//   }) async {
//     if (_currentUser == null) return false;
//
//     _isLoading = true;
//     _errorMessage = null;
//     notifyListeners();
//
//     try {
//       UserModel updatedUser = _currentUser!.copyWith(
//         fullName: fullName,
//         division: division,
//         district: district,
//         upazila: upazila,
//         gender: gender,
//         dateOfBirth: dateOfBirth,
//       );
//
//       await _firestore.collection('users').doc(_currentUser!.uid).update({
//         'fullName': fullName,
//         'division': division,
//         'district': district,
//         'upazila': upazila,
//         'gender': gender,
//         'dateOfBirth': Timestamp.fromDate(dateOfBirth),
//       });
//
//       _currentUser = updatedUser;
//       _isLoading = false;
//       notifyListeners();
//       return true;
//     } catch (e) {
//       _errorMessage = 'প্রোফাইল আপডেট করতে সমস্যা হয়েছে';
//       _isLoading = false;
//       notifyListeners();
//       return false;
//     }
//   }
//
//   // Save login status to SharedPreferences
//   Future<void> _saveLoginStatus(bool isLoggedIn, String? uid) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('isLoggedIn', isLoggedIn);
//     if (uid != null) {
//       await prefs.setString('uid', uid);
//     } else {
//       await prefs.remove('uid');
//     }
//   }
//
//   // Get error message in Bengali
//   String _getErrorMessage(String code) {
//     switch (code) {
//       case 'email-already-in-use':
//         return 'এই ইমেইল আগে থেকেই ব্যবহৃত হচ্ছে';
//       case 'invalid-email':
//         return 'ইমেইল সঠিক নয়';
//       case 'weak-password':
//         return 'পাসওয়ার্ড অন্তত ৬ অক্ষরের হতে হবে';
//       case 'user-not-found':
//         return 'ব্যবহারকারী পাওয়া যায়নি';
//       case 'wrong-password':
//         return 'পাসওয়ার্ড ভুল';
//       default:
//         return 'একটি সমস্যা হয়েছে। আবার চেষ্টা করুন।';
//     }
//   }
//
//   void clearError() {
//     _errorMessage = null;
//     notifyListeners();
//   }
// }
//
//
//
//


import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;

  // ✅ অ্যাপ ওপেন হওয়ার সময় লগইন স্ট্যাটাস চেক করা
  Future<void> checkLoginStatus() async {
    _isLoading = true;
    notifyListeners();

    try {
      final User? firebaseUser = _auth.currentUser;
      if (firebaseUser != null) {
        DocumentSnapshot doc = await _firestore
            .collection('users')
            .doc(firebaseUser.uid)
            .get();

        if (doc.exists) {
          _currentUser = UserModel.fromFirestore(doc);
        }
      }
    } catch (e) {
      debugPrint('❌ Error checking login status: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // ✅ নতুন ইউজার রেজিস্ট্রেশন (Role: user)
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
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      UserModel user = UserModel(
        uid: userCredential.user!.uid,
        fullName: fullName,
        email: email,
        division: division,
        district: district,
        upazila: upazila,
        gender: gender,
        dateOfBirth: dateOfBirth,
        profilePhotoUrl: null,
        createdAt: DateTime.now(),
        role: 'user', // ডিফল্ট রোল 'user' হিসেবে সেট করা হলো
      );

      await _firestore.collection('users').doc(user.uid).set(user.toMap());
      await userCredential.user!.updateDisplayName(fullName);

      _currentUser = user;
      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getErrorMessage(e.code);
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'রেজিস্ট্রেশন ব্যর্থ হয়েছে। আবার চেষ্টা করুন।';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // ✅ লগইন ফাংশন
  Future<bool> signIn({required String email, required String password}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (doc.exists) {
        _currentUser = UserModel.fromFirestore(doc);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'ব্যবহারকারীর তথ্য পাওয়া যায়নি।';
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
      _errorMessage = 'লগইন করতে সমস্যা হয়েছে।';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // ✅ প্রোফাইল ফটো আপলোড ও আপডেট
// ✅ প্রোফাইল ফটো আপলোড ও আপডেট (ইউজার এবং প্লেয়ার উভয় কালেকশনে ফিক্সড)
  Future<bool> updateProfilePhoto(File imageFile) async {
    if (_currentUser == null) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // ১. স্টোরেজ রেফারেন্স তৈরি
      Reference storageRef = _storage
          .ref()
          .child('profile_photos')
          .child('${_currentUser!.uid}.jpg');

      // ২. ফাইল আপলোড করা
      UploadTask uploadTask = storageRef.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      String photoUrl = await snapshot.ref.getDownloadURL();

      // ৩. 'users' কালেকশন আপডেট (UID অনুযায়ী)
      await _firestore.collection('users').doc(_currentUser!.uid).update({
        'profilePhotoUrl': photoUrl,
      });

      // ৪. 'players' কালেকশন আপডেট (Query ব্যবহার করে কারণ ID আলাদা হতে পারে)
      // আমরা 'userId' ফিল্ড দিয়ে সার্চ করে ওই প্লেয়ারের সঠিক ডকুমেন্ট আইডি বের করব
      final playerQuery = await _firestore
          .collection('players')
          .where('userId', isEqualTo: _currentUser!.uid)
          .limit(1)
          .get();

      if (playerQuery.docs.isNotEmpty) {
        // সঠিক ডকুমেন্ট আইডি দিয়ে আপডেট
        String playerDocId = playerQuery.docs.first.id;
        await _firestore.collection('players').doc(playerDocId).update({
          'profilePhotoUrl': photoUrl,
        });
        debugPrint('✅ Players collection updated for: $playerDocId');
      }

      // ৫. লোকাল মডেল আপডেট
      _currentUser = _currentUser!.copyWith(profilePhotoUrl: photoUrl);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('❌ Detailed Upload Error: $e');
      _errorMessage = 'ছবি আপলোড ব্যর্থ হয়েছে।';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  // ✅ লগ আউট
  Future<void> signOut() async {
    await _auth.signOut();
    _currentUser = null;
    notifyListeners();
  }

  // ✅ এরর মেসেজ হ্যান্ডলিং
  String _getErrorMessage(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'এই ইমেইলটি আগে থেকেই ব্যবহৃত হচ্ছে।';
      case 'invalid-email':
        return 'ইমেইলটি সঠিক নয়।';
      case 'weak-password':
        return 'পাসওয়ার্ড অন্তত ৬ অক্ষরের হতে হবে।';
      case 'user-not-found':
        return 'এই ইমেইলে কোনো অ্যাকাউন্ট পাওয়া যায়নি।';
      case 'wrong-password':
        return 'ভুল পাসওয়ার্ড। আবার চেষ্টা করুন।';
      default:
        return 'একটি সমস্যা হয়েছে। আবার চেষ্টা করুন।';
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // ✅ প্রোফাইল আপডেট করার জন্য এই মেথডটি AuthProvider এ যোগ করুন
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
      // ১. ফায়ারস্টোরে ডাটা আপডেট করা
      await _firestore.collection('users').doc(_currentUser!.uid).update({
        'fullName': fullName,
        'division': division,
        'district': district,
        'upazila': upazila,
        'gender': gender,
        'dateOfBirth': Timestamp.fromDate(dateOfBirth),
      });

      // ২. লোকাল মডেল আপডেট করা (copyWith ব্যবহার করে)
      _currentUser = _currentUser!.copyWith(
        fullName: fullName,
        division: division,
        district: district,
        upazila: upazila,
        gender: gender,
        dateOfBirth: dateOfBirth,
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('❌ Profile Update Error: $e');
      _errorMessage = 'প্রোফাইল আপডেট করতে সমস্যা হয়েছে।';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}