import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';  // Import per autenticazione Firebase
import 'constants.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/home/home_screen.dart';
import 'package:ParodiPub/profile/AuthCheckScreen.dart';  // Schermata di controllo autenticazione

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,  // Inizializza Firebase
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Parodi Pub',

      // Definisci il tema chiaro
      theme: ThemeData(
        brightness: Brightness.light,
        textTheme: Theme.of(context).textTheme.apply(bodyColor: kTextColor),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),

      // Definisci il tema scuro
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        textTheme: Theme.of(context).textTheme.apply(bodyColor: Colors.white),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),

      // Decidi il tema di default
      themeMode: ThemeMode.system,  // Usa il tema di sistema (scuro o chiaro)

      // Controlla se l'utente è autenticato
      home: const AuthCheckScreen(),  // Inizialmente vai alla schermata di controllo autenticazione
    );
  }
}
