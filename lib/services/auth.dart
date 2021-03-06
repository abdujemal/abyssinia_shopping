// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// FirebaseAuth auth = FirebaseAuth.instance;
// final gooleSignIn = GoogleSignIn();

// // a simple sialog to be visible everytime some error occurs
// showErrDialog(BuildContext context, String err) {
//   // to hide the keyboard, if it is still p
//   FocusScope.of(context).requestFocus(new FocusNode());
//   return showDialog(
//     context: context,
//     child: AlertDialog(
//       title: Text("Error"),
//       content: Text(err),
//       actions: <Widget>[
//         OutlineButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           child: Text("Ok"),
//         ),
//       ],
//     ),
//   );
// }

// // many unhandled google error exist
// // will push them soon
// Future<bool> googleSignIn() async {
//   GoogleSignInAccount googleSignInAccount = await gooleSignIn.signIn();

//   if (googleSignInAccount != null) {
//     GoogleSignInAuthentication googleSignInAuthentication =
//         await googleSignInAccount.authentication;

//     AuthCredential credential = GoogleAuthProvider.getCredential(
//         idToken: googleSignInAuthentication.idToken,
//         accessToken: googleSignInAuthentication.accessToken);

//     final result = await auth.signInWithCredential(credential);

//     FirebaseUser user = await auth.currentUser;
//     print(user.uid);

//     return Future.value(true);
//   }
// }

// // instead of returning true or false
// // returning user to directly access UserID
// Future<FirebaseUser> signin(
//     String email, String password, BuildContext context) async {
//   try {
//     final result =
//         await auth.signInWithEmailAndPassword(email: email, password: email);
//     FirebaseUser user = result.user;
//     // return Future.value(true);
//     return Future.value(user);
//   } catch (e) {
//     // simply passing error code as a message
//     print(e.code);
//     switch (e.code) {
//       case 'ERROR_INVALID_EMAIL':
//         showErrDialog(context, e.code);
//         break;
//       case 'ERROR_WRONG_PASSWORD':
//         showErrDialog(context, e.code);
//         break;
//       case 'ERROR_USER_NOT_FOUND':
//         showErrDialog(context, e.code);
//         break;
//       case 'ERROR_USER_DISABLED':
//         showErrDialog(context, e.code);
//         break;
//       case 'ERROR_TOO_MANY_REQUESTS':
//         showErrDialog(context, e.code);
//         break;
//       case 'ERROR_OPERATION_NOT_ALLOWED':
//         showErrDialog(context, e.code);
//         break;
//     }
//     // since we are not actually continuing after displaying errors
//     // the false value will not be returned
//     // hence we don't have to check the valur returned in from the signin function
//     // whenever we call it anywhere
//     return Future.value(null);
//   }
// }

// // change to Future<FirebaseUser> for returning a user
// Future<FirebaseUser> signUp(
//     String email, String password, BuildContext context) async {
//   try {
//     final result = await auth.createUserWithEmailAndPassword(
//         email: email, password: email);
//     FirebaseUser user = result.user;
//     return Future.value(user);
//     // return Future.value(true);
//   } catch (error) {
//     switch (error.code) {
//       case 'ERROR_EMAIL_ALREADY_IN_USE':
//         showErrDialog(context, "Email Already Exists");
//         break;
//       case 'ERROR_INVALID_EMAIL':
//         showErrDialog(context, "Invalid Email Address");
//         break;
//       case 'ERROR_WEAK_PASSWORD':
//         showErrDialog(context, "Please Choose a stronger password");
//         break;
//     }
//     return Future.value(null);
//   }
// }

// Future<bool> signOutUser() async {
//   FirebaseUser user = await auth.currentUser;
//   print(user.providerData[1].providerId);
//   if (user.providerData[1].providerId == 'google.com') {
//     await gooleSignIn.disconnect();
//   }
//   await auth.signOut();
//   return Future.value(true);
// }
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authentication {
  final _auth = FirebaseAuth.instance;
  //google signin
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<UserCredential> SignInWithEmailAndPassword(
      {@required email, @required password, @required state}) async {
    try {
      UserCredential userCredential;
      if (state == "login") {
        userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
      } else {
        userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
      }
      User user = FirebaseAuth.instance.currentUser;

      if (!user.emailVerified) {
        await user.sendEmailVerification();
        print("Email is sent");
      }
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      return e;
    }
  }
}
