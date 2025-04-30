class Product {
  final String name;
  final double price;
  final double gstRate; // e.g. 0.05, 0.12, 0.18, 0.28

  Product({required this.name, required this.price, required this.gstRate});

  double get cgst => (price * gstRate) / 2;
  double get sgst => (price * gstRate) / 2;
  double get total => price + cgst + sgst;
}
