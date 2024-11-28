import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Logout Method
  Future<void> logout() async {
    try {
      // Sign out from Firebase and Google
      await GoogleSignIn().signOut();
      await _firebaseAuth.signOut();

      // Navigate to the login screen
    } catch (e) {
      print(e);
    }
  }

  // Google sign-in
  Future<User?> signInWithGoogle() async {
    try {
      // Start the Google sign-in process
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      print(googleUser);

      // Check if user canceled the sign-in process
      if (googleUser == null) {
        // Sign-in was canceled by the user
        return null;
      }

      // Get the authentication details from the Google user
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create credentials for Firebase authentication
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with the Google credentials in Firebase
      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      // Return the Firebase user
      return userCredential.user;
    } catch (e) {
      // Handle any errors that occur during the sign-in process
      print("Error during Google sign-in: $e");
      return null; // Return null in case of failure
    }
  }

  // Email and password sign-in
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      // Sign in the user with email and password
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      // Return the authenticated user
      return userCredential.user;
    } catch (e) {
      // If an error occurs, print and return null
      print('Error during email sign-in: ${e.toString()}');
      return null;
    }
  }

  Future<User?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      // Create a new user with email and password
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      // Return the newly created user
      return userCredential.user;
    } catch (e) {
      // Handle specific Firebase authentication errors
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'email-already-in-use':
            print('The email address is already in use.');
            break;
          case 'invalid-email':
            print('The email address is invalid.');
            break;
          case 'weak-password':
            print('The password is too weak.');
            break;
          default:
            print('Error: ${e.message}');
        }
      } else {
        print('Unexpected error: $e');
      }
      return null; // Return null in case of an error
    }
  }
}
