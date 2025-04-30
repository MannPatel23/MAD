import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'providers/app_state.dart';
import 'login_page.dart';
import 'pages/home_page.dart';
import 'pages/billing_page.dart';
import 'pages/products_page.dart';
import 'pages/invoices_page.dart';
import 'pages/invoice_detail_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyDLrLdw3GcFI3ZkVSFfxihIgoebnvU7O3s',
      appId: '1:972666895346:web:cb73656222a3436c82c96b',
      messagingSenderId: '972666895346',
      projectId: 'exam-b0219',
      authDomain: 'exam-b0219.firebaseapp.com',
      storageBucket: 'exam-b0219.firebasestorage.app',
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TATA GST Billing App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => StreamBuilder<User?>(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Scaffold(
                      body: Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (snapshot.hasData) {
                    return const HomePage();
                  }
                  return const LoginPage();
                },
              ),
          '/home': (context) => const HomePage(),
          '/billing': (context) => const BillingPage(),
          '/invoices': (context) => const InvoicesPage(),
          '/invoiceDetail': (context) => const InvoiceDetailPage(),
          '/login': (context) => const LoginPage(),
        },
      ),
    );
  }
}

// Console info for static port:
// To run on a static port, use:
// flutter run -d chrome --web-port=52218
// Then open http://localhost:52218 in your browser.
