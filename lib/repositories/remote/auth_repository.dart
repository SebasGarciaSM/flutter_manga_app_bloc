import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final _auth = FirebaseAuth.instance;

  //INICIA SESIÓN
  Future<UserCredential> signInWithCredential(AuthCredential credential)=>
  _auth.signInWithCredential(credential);

  //SALE DE LA SESIÓN
  Future<void> logout() => _auth.signOut();

  //VERIFICA EL ESTADO EN QUE ESTÁ EL USUARIO, SI ESTÁ CON SESIÓN INICIDA O NO
  Stream<User> get currentUser => _auth.authStateChanges();


}