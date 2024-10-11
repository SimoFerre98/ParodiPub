import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';  // Importa GetX

class AuthCheckScreen extends StatelessWidget {
  const AuthCheckScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Controlla se lo stato della connessione è attivo
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;

          if (user == null) {
            // Se l'utente non è loggato, naviga alla schermata di login
            Future.microtask(() => Get.offNamed('/login'));
          } else {
            // Se l'utente è loggato, naviga alla schermata Home
            Future.microtask(() => Get.offNamed('/home'));
          }
        }

        // Mostra una schermata di caricamento mentre si controlla l'autenticazione
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
