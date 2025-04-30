import 'product.dart';

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
}
