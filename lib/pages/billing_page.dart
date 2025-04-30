import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../../models/invoice.dart';
import '../../providers/app_state.dart';
import 'package:uuid/uuid.dart';

class BillingPage extends StatefulWidget {
  const BillingPage({super.key});

  @override
  State<BillingPage> createState() => _BillingPageState();
}

class _BillingPageState extends State<BillingPage> {
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _customerPhoneController = TextEditingController();
  List<Product> _products = [];

  void _addProductDialog() async {
    String? name;
    double? price;
    double gstRate = 0.05;
    final _formKey = GlobalKey<FormState>();
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Product'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Product Name'),
                  validator: (v) => v == null || v.isEmpty ? 'Enter name' : null,
                  onSaved: (v) => name = v,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  validator: (v) => v == null || v.isEmpty ? 'Enter price' : null,
                  onSaved: (v) => price = double.tryParse(v ?? ''),
                ),
                DropdownButtonFormField<double>(
                  value: gstRate,
                  items: const [
                    DropdownMenuItem(value: 0.05, child: Text('5%')),
                    DropdownMenuItem(value: 0.12, child: Text('12%')),
                    DropdownMenuItem(value: 0.18, child: Text('18%')),
                    DropdownMenuItem(value: 0.28, child: Text('28%')),
                  ],
                  onChanged: (v) => gstRate = v ?? 0.05,
                  decoration: const InputDecoration(labelText: 'GST Type'),
                )
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: const Text('Add'),
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  _formKey.currentState?.save();
                  if (name != null && price != null) {
                    setState(() {
                      _products.add(Product(name: name!, price: price!, gstRate: gstRate));
                    });
                    Navigator.pop(context);
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  double get total => _products.fold(0, (sum, p) => sum + p.total);

  void _saveInvoice() {
    final customerName = _customerNameController.text.trim();
    final customerPhone = _customerPhoneController.text.trim();
    if (customerName.isEmpty || customerPhone.isEmpty || _products.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter customer name, phone and add at least one product.')));
      return;
    }
    final invoice = Invoice(
      id: const Uuid().v4(),
      customerName: customerName,
      customerPhone: customerPhone,
      date: DateTime.now(),
      products: List<Product>.from(_products),
    );
    Provider.of<AppState>(context, listen: false).addInvoice(invoice);
    setState(() {
      _products.clear();
      _customerNameController.clear();
      _customerPhoneController.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invoice saved!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Billing')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Customer Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(
              controller: _customerNameController,
              decoration: const InputDecoration(labelText: 'Customer Name'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _customerPhoneController,
              decoration: const InputDecoration(labelText: 'Customer Phone Number'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Products', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ElevatedButton(
                  onPressed: _addProductDialog,
                  child: const Text('Add Product'),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  final p = _products[index];
                  return ListTile(
                    title: Text(p.name),
                    subtitle: Text('₹${p.price.toStringAsFixed(2)} | GST: ${(p.gstRate * 100).toStringAsFixed(0)}%'),
                    trailing: Text('Total: ₹${p.total.toStringAsFixed(2)}'),
                  );
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _products.isEmpty ? null : () => setState(() {}),
                    child: const Text('Calculate Total'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _products.isEmpty ? null : _saveInvoice,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text('Save Invoice'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text('Total Bill: ₹${total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
