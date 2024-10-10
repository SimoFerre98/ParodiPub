import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class AuthService {
  // Prendo un'istanza di firebaseAuth, si occupa dell'autenticazione
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  // Istanza che permette di interagire con il databese cloudfurestore di firebase
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// Metodo per l'accesso dell'utente (Login)
  Future<User?> signInUser(String email, String password) async {
    try {
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print('Errore durante il login: $e');
      return null;
    }
  }
// Metodo per la registrazione dell'utente (Sign Up)
  Future<User?> createUser(String email, String password, String username) async {
    try {
      UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      if (user != null) {
        // Aggiorna il profilo dell'utente con lo username
        await user.updateProfile(displayName: username);
        await user.reload(); // Ricarica il profilo aggiornato
        return _firebaseAuth.currentUser; // Ritorna l'utente aggiornato
      }
      return null;
    } catch (e) {
      print('Errore durante la registrazione: $e');
      return null;
    }
  }

  // Metodo per l'accesso dell'utente (Login)
  Future<String?> getEmailByUsername(String username) async {
    try {
      // Recupera tutti gli utenti da Firebase (Firebase non supporta query su displayName direttamente)
      // Qui potresti voler creare una struttura dati separata o utilizzare Firestore per gestire questa ricerca
      List<User> users = (await _firebaseAuth.fetchSignInMethodsForEmail(username)) as List<User>;

      // Trova l'email corrispondente allo username
      for (var user in users) {
        if (user.displayName == username) {
          return user.email;
        }
      }
      return null;
    } catch (e) {
      print('Errore nella ricerca dell\'email per username: $e');
      return null;
    }
  }
}
