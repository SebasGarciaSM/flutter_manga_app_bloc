import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:flutter_manga_app_bloc/repositories/remote/auth_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthBloc {
  final authService = AuthRepository();
  final googleSignIn = GoogleSignIn(scopes: ['email']);
  final facebookLogin = FacebookLogin();

  Stream<User> get currentUser => authService.currentUser;

  loginGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

      //Firebase SignIn
      final result = await authService.signInWithCredential(credential);

      print('${result.user.displayName}');
    } catch (error) {
      print(error);
    }
  }

  loginFacebook() async {
    print('Starting Facebook Login');

    final res = await facebookLogin.logIn(
      permissions: [
        FacebookPermission.publicProfile,
        FacebookPermission.email
      ]
    );

    switch(res.status){
      case FacebookLoginStatus.Success:
      print('It worked');

      //Get Token
      final FacebookAccessToken fbToken = res.accessToken;

      //Convert to Auth Credential
      final AuthCredential credential 
        = FacebookAuthProvider.credential(fbToken.token);

      //User Credential to Sign in with Firebase
      final result = await authService.signInWithCredential(credential);

      print('${result.user.displayName} is now logged in');

      break;
      case FacebookLoginStatus.Cancel:
      print('The user canceled the login');
      break;
      case FacebookLoginStatus.Error:
      print('There was an error');
      break;
    }
  }

  logout() {
    authService.logout();
    googleSignIn.signOut();
  }
}
