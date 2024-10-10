import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ParodiPub/screens/home/home_screen.dart';
import 'package:ParodiPub/profile/LoginScreen.dart';  // Schermata di login

class AuthCheckScreen extends StatelessWidget {
  const AuthCheckScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Se l'utente è autenticato, vai alla HomeScreen
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          if (user == null) {
            // Se non è loggato, mostra la schermata di login
            return const LoginScreen();
          } else {
            // Se è loggato, mostra la HomeScreen
            return const HomeScreen();
          }
        } else {
          // Mostra una schermata di caricamento mentre si controlla l'autenticazione
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
