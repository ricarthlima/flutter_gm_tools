import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_gm_tools/models/public_user.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<String?> entrarUsuario(
      {required String email, required String senha}) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: senha);

      if (!userCredential.user!.emailVerified) {
        userCredential.user!.sendEmailVerification();
        _firebaseAuth.signOut();
        return "E-mail não verificado. Verifique sua caixa de entrada.";
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "user-not-found":
          return "O e-mail não está cadastrado.";
        case "wrong-password":
          return "Senha incorreta.";
      }
      return e.code;
    }

    return null;
  }

  Future<String?> cadastrarUsuario({
    required String email,
    required String senha,
    required String nome,
  }) async {
    try {
      // Cadastrar no Authentication
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );

      await userCredential.user!.updateDisplayName(nome);

      // Cadastrar no Cloud Firestore
      PublicUser user = PublicUser(
        uid: userCredential.user!.uid,
        displayName: nome,
        urlPhoto: "",
      );
      _firebaseFirestore.collection("users").doc(user.uid).set(user.toMap());

      // Verificar e-mail
      await userCredential.user!.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "email-already-in-use":
          return "O e-mail já está em uso.";
      }
      return e.code;
    }

    return null;
  }

  Future<String?> redefincaoSenha({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        return "E-mail não cadastrado.";
      }
      return e.code;
    }
    return null;
  }

  Future<String?> deslogar() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      return e.code;
    }

    return null;
  }

  Future<String?> removerConta({required String senha}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: _firebaseAuth.currentUser!.email!,
        password: senha,
      );
      await _firebaseAuth.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
    return null;
  }

  Future<String?> uploadUserImage({
    required Uint8List image,
  }) async {
    try {
      TaskSnapshot snapshot = await _firebaseStorage
          .ref("avatars/${_firebaseAuth.currentUser!.uid}.png")
          .putData(
            image,
            SettableMetadata(contentType: 'image/png'),
          );

      String urlDownload = await snapshot.ref.getDownloadURL();

      await _firebaseAuth.currentUser!.updatePhotoURL(urlDownload);
      await _firebaseFirestore
          .collection("users")
          .doc(_firebaseAuth.currentUser!.uid)
          .update({
        "urlPhoto": urlDownload,
      });
      return null;
    } on FirebaseException catch (e) {
      return e.message;
    }
  }
}
