import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../models/invoice.dart';

class InvoicesPage extends StatelessWidget {
  const InvoicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final invoices = Provider.of<AppState>(context).invoices;
    return Scaffold(
      appBar: AppBar(title: const Text('Invoices')),
      body: invoices.isEmpty
          ? const Center(child: Text('No invoices found.'))
          : ListView.builder(
              itemCount: invoices.length,
              itemBuilder: (context, index) {
                final Invoice invoice = invoices[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(invoice.customerName),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Date: ${invoice.date.toLocal()}'),
                        Text('Products: ${invoice.products.length}'),
                        Text('Total: ₹${invoice.totalAmount.toStringAsFixed(2)}'),
                        Text('CGST: ₹${invoice.totalCGST.toStringAsFixed(2)} | SGST: ₹${invoice.totalSGST.toStringAsFixed(2)}'),
                      ],
                    ),
                    isThreeLine: true,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text('Invoice for ${invoice.customerName}'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Date: ${invoice.date.toLocal()}'),
                              const SizedBox(height: 8),
                              ...invoice.products.map((p) => Text(
                                  '${p.name}: ₹${p.price.toStringAsFixed(2)} + GST ${(p.gstRate * 100).toStringAsFixed(0)}% (CGST: ₹${p.cgst.toStringAsFixed(2)}, SGST: ₹${p.sgst.toStringAsFixed(2)}) = ₹${p.total.toStringAsFixed(2)}',
                                )),
                              const Divider(),
                              Text('Total: ₹${invoice.totalAmount.toStringAsFixed(2)}'),
                              Text('CGST: ₹${invoice.totalCGST.toStringAsFixed(2)}'),
                              Text('SGST: ₹${invoice.totalSGST.toStringAsFixed(2)}'),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
