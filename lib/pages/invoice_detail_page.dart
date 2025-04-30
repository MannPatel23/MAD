import 'package:flutter/material.dart';

class InvoiceDetailPage extends StatelessWidget {
  const InvoiceDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Invoice Detail')),
      body: const Center(
        child: Text('Invoice Detail Page'),
      ),
    );
  }
}
