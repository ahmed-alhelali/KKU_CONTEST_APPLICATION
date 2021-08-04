import 'package:connected/imports.dart';
import 'package:flutter/foundation.dart';

class Authentication {
  Authentication() {
    Firebase.initializeApp();
  }

  String _userID;

  UserModel _userModel;

  String get currentUserId => _userID;

  UserModel get loggedInUserModel => _userModel;

  GoogleSignIn googleSignIn = GoogleSignIn();
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<User> signInWithGoogle() async {


    User user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount googleSignInAccount =
    await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
        await auth.signInWithCredential(credential);

        user = userCredential.user;
        FirebaseUtilities.saveUserName(user.displayName);
        FirebaseUtilities.saveUserEmail(user.email);
        FirebaseUtilities.saveUserImageUrl(user.photoURL);
        FirebaseUtilities.saveUserId(user.uid);
        FirestoreDB.saveUserToFirebase(user.displayName,user.uid,"online");
        _userModel = UserModel(
          id: user.uid,
          displayName: user.displayName,
          email: user.email,
          photoUrl: user.photoURL,
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          // ...
        } else if (e.code == 'invalid-credential') {
          // ...
        }
      } catch (e) {
        // ...
      }

    return user;
  }
  }

  void signOut() async {

    await FirebaseAuth.instance.signOut();

    await googleSignIn.signOut().then((value){
      FirebaseFirestore.instance
          .collection("Users")
          .doc(_userModel.id).update({
        "status" : "offline",
        "last_seen" : DateTime.now()
      });
    });

    _userModel = null;
  }


}
