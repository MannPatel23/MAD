import 'product.dart';
import 'dart:convert';

class Invoice {
  final String id;
  final String customerName;
  final String customerPhone;
  final DateTime date;
  final List<Product> products;

  Invoice({required this.id, required this.customerName, required this.customerPhone, required this.date, required this.products});

  double get totalCGST => products.fold(0, (sum, p) => sum + p.cgst);
  double get totalSGST => products.fold(0, (sum, p) => sum + p.sgst);
  double get totalAmount => products.fold(0, (sum, p) => sum + p.total);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'date': date.toIso8601String(),
      'products': products.map((p) => p.toMap()).toList(),
    };
  }

  factory Invoice.fromMap(Map<String, dynamic> map) {
    return Invoice(
      id: map['id'] ?? '',
      customerName: map['customerName'] ?? '',
      customerPhone: map['customerPhone'] ?? '',
      date: DateTime.parse(map['date']),
      products: (map['products'] as List).map((p) => Product.fromMap(p)).toList(),
    );
  }

  String toJson() => json.encode(toMap());
  factory Invoice.fromJson(String source) => Invoice.fromMap(json.decode(source));
}
