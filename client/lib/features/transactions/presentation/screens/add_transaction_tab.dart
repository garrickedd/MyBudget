import 'package:flutter/material.dart';
import 'package:mybudget/core/utils/failure.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:mybudget/features/auth/presentation/providers/auth_provider.dart';
import 'package:mybudget/features/jars/presentation/providers/jars_provider.dart';
import 'package:mybudget/features/transactions/domain/entities/transaction.dart';
import 'package:mybudget/features/transactions/presentation/providers/transaction_provider.dart';

class AddTransactionTab extends StatefulWidget {
  const AddTransactionTab({super.key});

  @override
  _AddTransactionTabState createState() => _AddTransactionTabState();
}

class _AddTransactionTabState extends State<AddTransactionTab> {
  final _formKey = GlobalKey<FormState>();
  String _type = 'expense';
  int? _jarId;
  DateTime _transactionDate = DateTime.now();
  TextEditingController _amountController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _transactionDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _transactionDate) {
      setState(() {
        _transactionDate = picked;
      });
    }
  }

  void _submitTransaction() {
    if (_formKey.currentState!.validate() &&
        (_type == 'income' || _jarId != null)) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userId = authProvider.user?.id.toString();
      if (userId == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('User not logged in')));
        Navigator.pushReplacementNamed(context, '/login');
        return;
      }

      final transaction = Transaction(
        userId: userId,
        jarId: _jarId ?? 0, // jarId không cần thiết cho Income, sẽ được bỏ qua
        type: _type,
        amount: double.tryParse(_amountController.text) ?? 0.0,
        description:
            _descriptionController.text.isEmpty
                ? (_type == 'income' ? 'Income' : 'Expense')
                : _descriptionController.text,
        transactionDate: _transactionDate,
      );

      Provider.of<TransactionProvider>(context, listen: false)
          .addTransaction(transaction, context)
          .then((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '${_type == 'income' ? 'Income' : 'Expense'} added successfully',
                ),
              ),
            );
            Navigator.pop(context); // Quay lại HomeTab
          })
          .catchError((e) {
            if (e is Failure && e.message.contains('Server error: 201')) {
              // Bỏ qua lỗi từ mã 201 vì đây là thành công
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '${_type == 'income' ? 'Income' : 'Expense'} added successfully',
                  ),
                ),
              );
              Navigator.pop(context);
            } else if (e.toString().contains('insufficient balance in jar')) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Insufficient balance in the selected jar. Please choose a different jar or reduce the amount.',
                  ),
                ),
              );
            } else {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
            }
          });
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final jarsProvider = Provider.of<JarsProvider>(context);
    final transactionProvider = Provider.of<TransactionProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Add Transaction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => setState(() => _type = 'income'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _type == 'income' ? Colors.teal : Colors.grey[300],
                      foregroundColor:
                          _type == 'income' ? Colors.white : Colors.black,
                    ),
                    child: const Text('Income'),
                  ),
                  ElevatedButton(
                    onPressed: () => setState(() => _type = 'expense'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _type == 'expense'
                              ? Colors.red[300]
                              : Colors.grey[300],
                      foregroundColor:
                          _type == 'expense' ? Colors.white : Colors.black,
                    ),
                    child: const Text('Expense'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (_type == 'expense')
                DropdownButtonFormField<int>(
                  value: _jarId,
                  hint: const Text('Necessities'),
                  items:
                      jarsProvider.jars.map((jar) {
                        return DropdownMenuItem<int>(
                          value: jar.id,
                          child: Text(jar.name),
                        );
                      }).toList(),
                  onChanged: (value) => setState(() => _jarId = value),
                  validator:
                      (value) => value == null ? 'Please select a jar' : null,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.category),
                  ),
                ),
              const SizedBox(height: 16),
              TextFormField(
                readOnly: true,
                controller: TextEditingController(
                  text: DateFormat('dd-MM-yyyy').format(_transactionDate),
                ),
                decoration: const InputDecoration(
                  labelText: 'Date',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.currency_exchange),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  final amount = double.tryParse(value);
                  if (amount == null || amount <= 0) {
                    return 'Amount must be a positive number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Note',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.note),
                ),
              ),
              const SizedBox(height: 16),
              if (_type == 'expense')
                DropdownButtonFormField<int>(
                  value: null,
                  hint: const Text('Others'),
                  items:
                      jarsProvider.jars.where((jar) => jar.id != _jarId).map((
                        jar,
                      ) {
                        return DropdownMenuItem<int>(
                          value: jar.id,
                          child: Text(jar.name),
                        );
                      }).toList(),
                  onChanged: (value) => setState(() => _jarId = value),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.category),
                  ),
                ),
              const Spacer(),
              transactionProvider.isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                    onPressed: _submitTransaction,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _type == 'income' ? Colors.teal : Colors.red,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: Text(
                      _type == 'income' ? 'Add Income' : 'Add Expense',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
