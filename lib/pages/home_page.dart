import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TATA GST Billing App')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text('Billing'),
              onPressed: () => Navigator.pushNamed(context, '/billing'),
            ),
            ElevatedButton(
              child: const Text('Invoices'),
              onPressed: () => Navigator.pushNamed(context, '/invoices'),
            ),
            ElevatedButton(
              child: const Text('Logout'),
              onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
            ),
          ],
        ),
      ),
    );
  }
}
