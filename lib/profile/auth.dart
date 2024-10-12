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

        // Aggiungi l'utente al database Firestore
        await _firestore.collection('Users').doc(user.uid).set({
          'id': user.uid,               // Auto-generated user ID from Firebase Auth
          'username': username,         // Username provided during sign up
          'email': email,               // Email provided during sign up
          'firstName': '',              // Placeholder, to be filled by the user
          'lastName': '',               // Placeholder, to be filled by the user
          'phoneNumber': '',            // Placeholder, to be filled by the user
          'streetAddress': '',          // Placeholder, to be filled by the user
          'postalCode': '',             // Placeholder, to be filled by the user
          'city': '',                   // Placeholder, to be filled by the user
          'country': '',                // Placeholder, to be filled by the user
          'accountStatus': 'active',    // Default value, can be changed later
          'notificationPreferences': {}, // Default empty map for notification preferences
          'paymentMethods': [],         // Default empty array for payment methods
          'accountCreationDate': FieldValue.serverTimestamp(), // Automatically sets the current time
        });

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


  // Metodo per effettuare il logout
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut(); // Effettua il logout dell'utente
    } catch (e) {
      print('Errore durante il logout: $e');
    }
  }

  // Metodo per ottendere username utente
  Future<String> fetchUsername() async {
    User? currentUser = _firebaseAuth.currentUser;
    if (currentUser == null) {
      throw Exception('No user logged in');
    }

    DocumentSnapshot userDoc = await _firestore.collection('Users').doc(currentUser.uid).get();
    if (!userDoc.exists) {
      throw Exception('User document does not exist');
    }

    Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>? ?? {};
    return userData['username'] as String? ?? 'Username non disponibile';
  }

  // ########## USER METODS ##########
  // Qui ci osno tutti i metodi di modifica e per cancellare i dati relativi agli utenti
  // Nel caso si voglia eliminare un singolo campo basta inserire il campo vuoto,
  // l'eliminazione dei campi avviene solo quando si elimina completamente un accont

  // Metodo per aggiornare il nome
  Future<void> updateFirstName(String userId, String firstName) async {
    try {
      await FirebaseFirestore.instance.collection('Users').doc(userId).update({
        'firstName': firstName,
      });
      print('First name updated successfully');
    } catch (e) {
      print('Error updating first name: $e');
    }
  }

  // Metodo per aggiornare il cognome
  Future<void> updateLastName(String userId, String lastName) async {
    try {
      await FirebaseFirestore.instance.collection('Users').doc(userId).update({
        'lastName': lastName,
      });
      print('Last name updated successfully');
    } catch (e) {
      print('Error updating last name: $e');
    }
  }

  // Metodo per aggiornare il numero di telefono
  Future<void> updatePhoneNumber(String userId, String phoneNumber) async {
    try {
      await FirebaseFirestore.instance.collection('Users').doc(userId).update({
        'phoneNumber': phoneNumber,
      });
      print('Phone number updated successfully');
    } catch (e) {
      print('Error updating phone number: $e');
    }
  }

  // Metodo per aggiornare l'indirizzo
  Future<void> updateStreetAddress(String userId, String streetAddress) async {
    try {
      await FirebaseFirestore.instance.collection('Users').doc(userId).update({
        'streetAddress': streetAddress,
      });
      print('Street address updated successfully');
    } catch (e) {
      print('Error updating street address: $e');
    }
  }

  // Metodo per aggiornare il codice postale
  Future<void> updatePostalCode(String userId, String postalCode) async {
    try {
      await FirebaseFirestore.instance.collection('Users').doc(userId).update({
        'postalCode': postalCode,
      });
      print('Postal code updated successfully');
    } catch (e) {
      print('Error updating postal code: $e');
    }
  }

  // Metodo per aggiornare la città
  Future<void> updateCity(String userId, String city) async {
    try {
      await FirebaseFirestore.instance.collection('Users').doc(userId).update({
        'city': city,
      });
      print('City updated successfully');
    } catch (e) {
      print('Error updating city: $e');
    }
  }

  // Metodo per aggiornare il paese
  Future<void> updateCountry(String userId, String country) async {
    try {
      await FirebaseFirestore.instance.collection('Users').doc(userId).update({
        'country': country,
      });
      print('Country updated successfully');
    } catch (e) {
      print('Error updating country: $e');
    }
  }

  //Metodo per aggiornare le preferenze di notifica
  Future<void> updateNotificationPreferences(String userId, Map<String, dynamic> preferences) async {
    try {
      await FirebaseFirestore.instance.collection('Users').doc(userId).update({
        'notificationPreferences': preferences,
      });
      print('Notification preferences updated successfully');
    } catch (e) {
      print('Error updating notification preferences: $e');
    }
  }

  // Metodo per aggiornare i metodi di pagamento
  Future<void> updatePaymentMethods(String userId, List<Map<String, dynamic>> paymentMethods) async {
    try {
      await FirebaseFirestore.instance.collection('Users').doc(userId).update({
        'paymentMethods': paymentMethods,
      });
      print('Payment methods updated successfully');
    } catch (e) {
      print('Error updating payment methods: $e');
    }
  }

  //Metodo per aggiornare lo statp dell'account
  Future<void> updateAccountStatus(String userId, String accountStatus) async {
    try {
      await FirebaseFirestore.instance.collection('Users').doc(userId).update({
        'accountStatus': accountStatus,
      });
      print('Account status updated successfully');
    } catch (e) {
      print('Error updating account status: $e');
    }
  }

  // Metodo per aggiornare l'email
  // Fare il controllo in piu solo per email
  Future<void> updateEmail(String newEmail) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        await user.updateEmail(newEmail);
        await FirebaseFirestore.instance.collection('Users').doc(user.uid).update({
          'email': newEmail,
        });
        print('Email updated successfully');
      } catch (e) {
        print('Error updating email: $e');
      }
    }
  }

  // Metodo per aggiornare lo username dell'utente
  Future<void> updateUsername(String userId, String username) async {
    try {
      await FirebaseFirestore.instance.collection('Users').doc(userId).update({
        'username': username,
      });
      print('Username updated successfully');
    } catch (e) {
      print('Error updating username: $e');
    }
  }

  // Metodo per eliminare l'utente e i suoi dati
  /*
  Come funziona:
  1. Verifica dell'utente corrente: Il metodo verifica se l'utente attualmente autenticato corrisponde a userId. In questo modo, eviti di eliminare i dati di un altro utente.
  2. Eliminazione dei dati da Firestore: Prima elimina il documento dell'utente dalla collezione users in Firestore.
  3. Eliminazione dell'account Firebase: Successivamente, elimina l'utente anche da Firebase Authentication.
  4. Gestione degli errori: Il metodo cattura eventuali errori e stampa un messaggio di errore.

  Nota importante:
  L'utente deve essere autenticato di recente per eseguire l'eliminazione del proprio account in Firebase.
  Se l'autenticazione è vecchia, Firebase potrebbe chiedere di ri-autenticare l'utente per motivi di sicurezza. In tal caso, potresti aggiungere un metodo per ri-autenticare
  l'utente prima di eseguire questa operazione.*/
  Future<void> deleteUser(String userId) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null && user.uid == userId) {
      try {
        // Elimina i dati dell'utente dalla collezione Firestore
        await FirebaseFirestore.instance.collection('Users').doc(userId).delete();

        // Elimina l'utente da Firebase Authentication
        await user.delete();

        print('User and their data deleted successfully');
      } catch (e) {
        print('Error deleting user: $e');
      }
    } else {
      print('No user is currently signed in or userId does not match');
    }
  }
//########## FINISH USER METHODS ##########






}
