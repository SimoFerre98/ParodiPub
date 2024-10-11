import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'auth.dart'; // Assicurati che auth.dart gestisca Firebase Authentication
import 'EditProfile.dart';
import 'package:ParodiPub/profile/ProfileMenuWidget.dart';
import 'package:get/get.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final AuthService _authService = AuthService(); // Usa il servizio di autenticazione Firebase
  User? user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser; // Ottieni l'utente corrente
  }

  // Metodo che fa il logout dell'utente
  Future<void> signOut() async {
    await _authService.signOut(); // Chiama il metodo signOut nel tuo auth.dart

    // Naviga verso la schermata home
    Get.offAllNamed('/home');

    // Mostra un messaggio di successo
    Get.snackbar(
      'Logout',
      'Logout effettuato con successo',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.only(bottom: 10, left: 5, right: 5),
    );
  }

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(LineAwesomeIcons.angle_left),
        ),
        title: const Text("Account"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.asset('assets/icons/AccountAvatar.png'), // Immagine dell'account
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.white),
                    child: const Icon(
                      LineAwesomeIcons.alternate_pencil,
                      color: Color(0xff001f3f),
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Mostra lo username dell'utente
            FutureBuilder<String>(
              future: _authService.fetchUsername(), // Supponendo che tu abbia un metodo per ottenere lo username
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return const Text("Errore nel recupero dello Username");
                } else {
                  return Text(
                    "${snapshot.data}",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 26,
                    ),
                  );
                }
              },
            ),
            Text(
              user != null
                  ? (user!.email ?? "Email non disponibile")
                  : "Utente non autenticato",
              style: Theme.of(context).textTheme.bodyMedium,  // Usa bodyMedium al posto di bodyText2
            ),
            const SizedBox(height: 20),
            // Tasto per editare il profilo
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  Get.toNamed('/edit-profile');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff001f3f),
                  side: BorderSide.none,
                  shape: const StadiumBorder(),
                ),
                child: const Text(
                  "Edit Profile",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 30),
            const Divider(),
            const SizedBox(height: 10),
            // Menu delle opzioni dell'account
            ProfileMenuWidget(
                title: "Wallet Address",
                icon: LineAwesomeIcons.cog,
                onPress: () {}),
            ProfileMenuWidget(
                title: "Trading",
                icon: LineAwesomeIcons.bar_chart,
                onPress: () {}),
            ProfileMenuWidget(
                title: "Payment Methods",
                icon: LineAwesomeIcons.wallet,
                onPress: () {}),
            ProfileMenuWidget(
                title: "Learn Cripto",
                icon: LineAwesomeIcons.book,
                onPress: () {}),
            ProfileMenuWidget(
                title: "Information",
                icon: LineAwesomeIcons.info,
                onPress: () {}),
            const Divider(),
            GestureDetector(
              onTap: () {
                Get.defaultDialog(
                  title: "LOGOUT",
                  titleStyle: const TextStyle(fontSize: 20),
                  content: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    child: Text("Sei sicuro di voler fare il Logout?"),
                  ),
                  confirm: ElevatedButton(
                    onPressed: () async {
                      await signOut();
                      Get.back(); // Chiudi il dialogo
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      side: BorderSide.none,
                    ),
                    child: const Text("Yes"),
                  ),
                  cancel: OutlinedButton(
                    onPressed: () => Get.back(),
                    child: const Text("No"),
                  ),
                );
              },
              child: ProfileMenuWidget(
                title: "Logout",
                icon: LineAwesomeIcons.alternate_sign_out,
                textColor: const Color(0xffBB0A21),
                endIcon: false,
                onPress: () {
                  // Esegui il logout
                  signOut();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
