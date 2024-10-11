import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';  // Import per autenticazione Firebase
import 'constants.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/home/home_screen.dart';
import 'package:get/get.dart';
import 'package:ParodiPub/profile/AuthCheckScreen.dart';  // Schermata di controllo autenticazione
import 'package:ParodiPub/profile/Account.dart';  // Schermata account
import 'package:ParodiPub/profile/EditProfile.dart';

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
    return GetMaterialApp(  // Usa GetMaterialApp invece di MaterialApp
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

      // Definisci le rotte con GetX
      initialRoute: '/',  // Rotta iniziale
      getPages: [
        GetPage(name: '/', page: () => const AuthCheckScreen()),  // Schermata di controllo autenticazione
        GetPage(name: '/home', page: () => const HomeScreen()),  // Schermata home
        GetPage(name: '/account', page: () => const Account()),  // Schermata account
        GetPage(name: '/edit-profile', page: () => const EditProfile()), // Schermata modifica del profilo personale
      ],
    );
  }
}
