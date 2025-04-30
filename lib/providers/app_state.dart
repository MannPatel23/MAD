import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/product.dart';
import '../models/invoice.dart';

class AppState extends ChangeNotifier {
  final List<Product> products = [];
  final List<Invoice> invoices = [];

  AppState() {
    _loadInvoices();
  }

  Future<void> addProduct(Product product) async {
    products.add(product);
    notifyListeners();
  }

  Future<void> addInvoice(Invoice invoice) async {
    invoices.add(invoice);
    notifyListeners();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('invoices')
          .doc(invoice.id)
          .set(invoice.toMap());
    }
  }

  Future<void> _loadInvoices() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('invoices')
        .get();
    invoices.clear();
    for (var doc in snapshot.docs) {
      invoices.add(Invoice.fromMap(doc.data()));
    }
    notifyListeners();
  }
}
