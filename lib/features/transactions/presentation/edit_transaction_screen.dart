import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../data/transaction_repository.dart';

class EditTransactionScreen extends ConsumerStatefulWidget {
  final String transactionId;
  final String initialTitle;
  final double initialAmount;
  final String initialType;
  final String initialCategory;

  const EditTransactionScreen({
    super.key,
    required this.transactionId,
    required this.initialTitle,
    required this.initialAmount,
    required this.initialType,
    required this.initialCategory,
  });

  @override
  ConsumerState<EditTransactionScreen> createState() =>
      _EditTransactionScreenState();
}

class _EditTransactionScreenState extends ConsumerState<EditTransactionScreen> {
  late final TextEditingController titleController;
  late final TextEditingController amountController;

  late String selectedType;
  late String selectedCategory;

  bool isLoading = false;

  final List<String> categories = [
    "Food",
    "Transport",
    "Shopping",
    "Bills",
    "Education",
    "Health",
    "Entertainment",
    "Other",
  ];

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.initialTitle);
    amountController = TextEditingController(text: widget.initialAmount.toString());
    selectedType = widget.initialType;
    selectedCategory = widget.initialCategory;
  }

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    super.dispose();
  }

  Future<void> updateTransaction() async {
    if (titleController.text.trim().isEmpty ||
        amountController.text.trim().isEmpty) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await ref.read(transactionRepositoryProvider).updateTransaction(
        transactionId: widget.transactionId,
        title: titleController.text.trim(),
        amount: double.parse(amountController.text.trim()),
        type: selectedType,
        category: selectedCategory,
      );

      if (mounted) {
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Transaction"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "Title",
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Amount",
              ),
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField<String>(
              value: selectedType,
              decoration: const InputDecoration(
                labelText: "Type",
              ),
              items: const [
                DropdownMenuItem(value: "income", child: Text("Income")),
                DropdownMenuItem(value: "expense", child: Text("Expense")),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => selectedType = value);
                }
              },
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              decoration: const InputDecoration(
                labelText: "Category",
              ),
              items: categories
                  .map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => selectedCategory = value);
                }
              },
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading ? null : updateTransaction,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Update"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
