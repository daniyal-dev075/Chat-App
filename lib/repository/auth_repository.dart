import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/model/user_model.dart';
import 'package:whatsapp_clone/repository/common_firebase_storage_repository.dart';
import 'package:whatsapp_clone/utils/routes/route_name.dart';
import 'package:whatsapp_clone/utils/utils.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  ),
);

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthRepository({required this.auth, required this.firestore});

  Future<UserModel?> getCurrentUserData() async {
    var userData = await firestore
        .collection('users')
        .doc(auth.currentUser?.uid)
        .get();
    UserModel? user;
    if (userData.data() != null) {
      user = UserModel.fromMap(userData.data()!);
    }
    return user;
  }

  Future<void> signInWithPhone(BuildContext context, String phoneNumber) async {
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
        },
        verificationFailed: (e) {
          throw Exception(e.toString());
        },
        codeSent: ((String verificationId, int? resendToken) async {
          Navigator.pushNamed(
            context,
            RouteName.otpView,
            arguments: verificationId,
          );
        }),
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      Utils().toastMessage(e.toString());
    }
  }

  void verifyOtp({
    required BuildContext context,
    required String verificationId,
    required String userOtp,
  }) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: userOtp,
      );
      await auth.signInWithCredential(credential);
      Navigator.pushNamedAndRemoveUntil(
        context,
        RouteName.userInfoView,
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      Utils().toastMessage(e.toString());
    }
  }

  void saveUserDataToFirebase({
    required String name,
    required File? profilePic,
    required ProviderRef ref,
    required BuildContext context,
  }) async {
    try {
      String uid = auth.currentUser!.uid;
      String photoUrl = '';
      String? phone = auth.currentUser!.phoneNumber;

      if (phone == null) {
        Utils().toastMessage("Phone number missing, cannot save user!");
        return;
      }
      if (profilePic != null) {
        photoUrl = await ref
            .read(commonFirebaseStorageRepositoryProvider)
            .storeFileToFirebase('profilePic/$uid', profilePic);
      }
      var user = UserModel(
        name: name,
        profilePic: photoUrl,
        uid: uid,
        isOnline: true,
        phoneNumber: auth.currentUser!.phoneNumber!,
        groupId: [],
      );
      await firestore.collection('users').doc(uid).set(user.toMap());
      Navigator.pushNamedAndRemoveUntil(
        context,
        RouteName.homeView,
        (route) => false,
      );
    } catch (e) {
      Utils().toastMessage(e.toString());
    }
  }

  Stream<UserModel> userData(String userId) {
    return firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((event) => UserModel.fromMap(event.data()!));

  }
  
  void setUserState (bool isOnline)async{
    await firestore.collection('users').doc(auth.currentUser!.uid).update({
      'isOnline' : isOnline
    });
  }
}
