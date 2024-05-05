import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthSerive {
  static siginWithGoole() async {
    //intialize google sign in
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    //obtain the crendentials
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    //takes the credentials
    final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken, idToken: gAuth.idToken);

    //finally lets sign in
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  static Future<void> logout() async {
    await GoogleSignIn().signOut();
  }
}
