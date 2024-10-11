import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ParodiPub/widgets/MyTextField.dart';
import 'package:ParodiPub/profile/auth.dart';
import 'package:get/get.dart';

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

  // Metodo per l'accesso dell'utente
  void SignInUser() async {
    String input = _emailController.text.trim();
    String? email;

    if (input.contains('@')) {
      // L'input è un'email
      email = input;
    } else {
      // L'input è uno username, cerca l'email corrispondente
      email = await _authService.getEmailByUsername(input);
    }

    if (email != null) {
      User? user = await _authService.signInUser(
        email,
        _passwordController.text.trim(),
      );
      if (user != null) {
        print('Accesso effettuato con successo: ${user.email}');
      } else {
        print('Errore durante il login');
      }
    } else {
      print('Nessun utente trovato con questo username');
    }
  }

  // Metodo per la creazione dell'utente
  void CreateUser() async {
    User? user = await _authService.createUser(
      _emailController.text.trim(),
      _passwordController.text.trim(),
      _usernameController.text.trim()
    );
    if (user != null) {
      print('Registrazione effettuata con successo: ${user.displayName}');
    } else {
      print('Errore durante la registrazione');
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
