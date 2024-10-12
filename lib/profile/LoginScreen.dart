import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ParodiPub/widgets/MyTextField.dart';
import 'package:ParodiPub/profile/auth.dart';
import 'package:get/get.dart';
import 'package:ParodiPub/screens/home/home_screen.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Login variable
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  //Variabile booleana per controllare il login
  bool isLogin = true;

  // Istanza di AuthService per gestire le connessioni con Firebase
  final AuthService _authService = AuthService();

  // Funzione per validare la password
  bool isValidPassword(String password) {
    // Verifica che la password sia di almeno 6 caratteri, contenga una lettera maiuscola e un carattere speciale
    final RegExp passwordRegExp = RegExp(r'^(?=.*?[A-Z])(?=.*?[!@#\$&*~]).{6,}$');
    return passwordRegExp.hasMatch(password);
  }

// Funzione per validare l'email
  bool isValidEmail(String email) {
    // Verifica che l'email sia in un formato valido
    final RegExp emailRegExp = RegExp(r'^[a-zA-Z0-9._]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
    return emailRegExp.hasMatch(email);
  }

// Metodo per la creazione dell'utente
  void CreateUser() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    // Controlla la validità della password
    if (!isValidPassword(password)) {
      Get.snackbar('Errore', 'La password deve essere di almeno 6 caratteri, contenere una lettera maiuscola e un carattere speciale.', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // Controlla la validità dell'email
    if (!isValidEmail(email)) {
      Get.snackbar('Errore', 'Inserisci un\'email valida.', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // Se i controlli sono validi, procedi con la registrazione
    User? user = await _authService.createUser(
        email,
        password,
        _usernameController.text.trim()
    );
    if (user != null) {
      print('Registrazione effettuata con successo: ${user.displayName}');
      Get.offAllNamed('/home'); // Reindirizza alla schermata home
    } else {
      print('Errore durante la registrazione');
    }
  }

// Metodo per l'accesso dell'utente
  void SignInUser() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    // Controlla la validità della password
    if (!isValidPassword(password)) {
      Get.snackbar('Errore', 'La password deve essere di almeno 6 caratteri, contenere una lettera maiuscola e un carattere speciale.', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // Controlla la validità dell'email
    if (!isValidEmail(email)) {
      Get.snackbar('Errore', 'Inserisci un\'email valida.', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    User? user = await _authService.signInUser(
      email,
      password,
    );
    if (user != null) {
      print('Accesso effettuato con successo: ${user.email}');
      Get.offAllNamed('/home'); // Reindirizza alla schermata home
    } else {
      print('Errore durante il login');
    }
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Spazio vuoto
              const SizedBox(height: 50),

              // logo
              const Icon(
                Icons.lock,
                size: 100,
                color: Color(0xff003366),
              ),

              //Spazio vuoto
              const SizedBox(height: 50),

              Text(
                'Benvenuto, puoi accedere o registrarti qui',
                style: TextStyle(
                  color: Color(0xff003366),
                  fontSize: 18,
                ),
              ),

              //Spazio vuoto
              const SizedBox(height: 25),

              // Campo di testo personalizzato
              MyTextField(
                controller: _usernameController,
                hintText: 'Username',
                obscureText: false,
              ),

              //Spazio vuoto
              const SizedBox(height: 10),

              // Campo di testo personalizzato
              MyTextField(
                controller: _emailController,
                hintText: 'Email',
                obscureText: false,
              ),

              //Spazio vuoto
              const SizedBox(height: 10),

              // Campo di testo personalizzato
              MyTextField(
                controller: _passwordController,
                hintText: 'Password',
                obscureText: true,
              ),

              //Spazio vuoto
              const SizedBox(height: 10),

              // Password dimenticata. (Da gestire anche con firebase)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Password dimenticata?',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),

              //Spazio vuoto
              const SizedBox(height: 25),

              //Bottone per il Login/registrazione, fa anche un controllo sull'autenticazione
              ElevatedButton(
                onPressed: () {
                  isLogin ? SignInUser() : CreateUser();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff003366), // Colore di sfondo del pulsante
                  foregroundColor: Colors.white, // Colore del testo del pulsante
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                child: Text(isLogin ? 'Accedi' : 'Registrati'),
              ),

              //Spazio vuoto
              const SizedBox(height: 25),

              //Testo selezionabiler pe cambiare da Login a Registrazione
              TextButton(
                onPressed: () {
                  setState(() {
                    isLogin = !isLogin;
                  });
                },
                child: Text(
                  isLogin ? 'Non hai un account? registrati' : 'Hai un account? Accedi',
                  style: TextStyle(color: Color(0xff003366)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
