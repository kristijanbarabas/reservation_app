import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reservation_app/screens/home.dart';
import 'package:reservation_app/screens/test.dart';
import 'package:reservation_app/screens/welcome_screen.dart';
import '../components/rounded_button.dart';
import '../constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reservation_app/components/google_sign_in.dart';

// firebase auth
final _auth = FirebaseAuth.instance;
// creating our user
late User loggedInUser;
//firestore instance
final _firestore = FirebaseFirestore.instance;

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  // email and password variables
  late String email;
  late String password;
  late String userID;

  // profile data
  late String? profilePicture;
  late String? username;

  getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  getProfile() async {
    final docRef = _firestore
        .collection('user')
        .doc(loggedInUser.uid)
        .collection('profile')
        .get();
    await docRef.then(
      (QuerySnapshot snapshot) {
        for (var documentSnapshot in snapshot.docs) {
          setState(() {
            fireProfile = documentSnapshot.data() as Map<String, dynamic>;
            profilePicture = fireProfile['userProfilePicture'];
            username = fireProfile['username'];
          });
        }
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }

  // PROFILE DATA
  late Map<String, dynamic> firebaseData = {};
  late Map<String, dynamic> fireProfile = {};
  late String? phoneNumber = fireProfile['userPhoneNumber'];

  // button radius
  double buttonRadius = 35.0;

  //
  void customSignInWithGoogle() async {
    try {
      await signInWithGoogle();
      if (_auth.currentUser?.uid != null) {
        final docRef = _firestore
            .collection('user')
            .doc(_auth.currentUser?.uid)
            .collection('profile')
            .doc(_auth.currentUser?.uid);
        await docRef.get().then(
          (DocumentSnapshot document) {
            if (document.exists) {
              // DO NOTHING
            } else {
              docRef.set(
                {
                  'username': _auth.currentUser?.displayName,
                  'phoneNumber': _auth.currentUser?.phoneNumber,
                  'userProfilePicture': _auth.currentUser?.photoURL,
                },
              );
            }
            Navigator.pushNamed(context, HomeScreen.id);
          },
        );
      }
    } catch (e) {
      Alert(context: context, title: "Error", desc: "Try again!").show();
    }
  }

  void customSignInWithEmailAndPassword() async {
    try {
      final existingUser = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (existingUser != null) {
        Navigator.pushNamed(context, HomeScreen.id);
      }
    } catch (e) {
      Alert(context: context, title: "Error", desc: "Try again!").show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, WelcomeScreen.id);
            },
            child: const Icon(Icons.arrow_back)),
        automaticallyImplyLeading: false,
        title: Text(
          kLoginTitle,
          style: kGoogleFonts,
        ),
        centerTitle: true,
        backgroundColor: kBackgroundColor,
      ),
      backgroundColor: kBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Flexible(
              child: Hero(
                tag: 'logo',
                child: SizedBox(
                  height: 100,
                  child: Image.asset('images/logo.png'),
                ),
              ),
            ),
            const SizedBox(
              height: 54.0,
            ),
            // EMAIL INPUT
            TextField(
              style: kTextFieldInputStyle,
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.center,
              onChanged: (value) {
                email = value;
              },
              decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your email...'),
            ),
            const SizedBox(
              height: 8.0,
            ),
            // PASSWORD INPUT
            TextField(
                style: kTextFieldInputStyle,
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your password...')),
            const SizedBox(
              height: 24.0,
            ),
            // LOGIN BUTTON
            CustomRoundedButton(
              iconData: Icons.login,
              textStyle: kGoogleFonts,
              color: kButtonColor,
              title: kLoginTitle,
              onPressed: customSignInWithEmailAndPassword,
            ),
            const SizedBox(
              height: 24.0,
            ),
            Center(
              child: Text(
                'Sign in with Google:',
                style: kGoogleLoginStyle,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            // GOOGLE LOGIN BUTTON
            CustomGoogleSignInButton(
              function: customSignInWithGoogle,
            ),
          ],
        ),
      ),
    );
  }
}
