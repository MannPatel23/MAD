import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/invoice.dart';

class AppState extends ChangeNotifier {
  final List<Product> products = [];
  final List<Invoice> invoices = [];

  void addProduct(Product product) {
    products.add(product);
    notifyListeners();
  }

  void addInvoice(Invoice invoice) {
    invoices.add(invoice);
    notifyListeners();
  }
}
