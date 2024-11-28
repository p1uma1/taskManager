import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

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
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create credentials for Firebase authentication
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with the Google credentials in Firebase
      final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);

      // Return the Firebase user
      return userCredential.user;
    } catch (e) {
      // Handle any errors that occur during the sign-in process
      print("Error during Google sign-in: $e");
      return null; // Return null in case of failure
    }
  }

  // Email and password sign-in
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      // Sign in the user with email and password
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
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
}
