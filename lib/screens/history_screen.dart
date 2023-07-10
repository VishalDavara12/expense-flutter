import 'package:expense/providers/history_provider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/home_provider.dart';

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<HistoryProvider>(builder: (context, historyProvider, _) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Expense History'),
          actions: [
            IconButton(
              icon: Icon(Icons.filter_list),
              onPressed: () {
                _showFilterPopup(historyProvider, context);
              },
            ),
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('expenses')
              .where('userRef',
                  isEqualTo: context.watch<ExpenseProvider>().user!.uid)
              .orderBy('date', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            final expenses = snapshot.data?.docs ?? [];

            if (expenses.isEmpty) {
              return Center(
                child: Text('No expenses found.'),
              );
            }
            print(historyProvider.selectedCategory);
            final filteredExpenses = historyProvider.selectedCategory !=
                    "All Categories"
                ? expenses
                    .where((expense) =>
                        expense['category'] == historyProvider.selectedCategory)
                    .toList()
                : expenses;

            return ListView.builder(
              itemCount: filteredExpenses.length,
              itemBuilder: (context, index) {
                final expense =
                    filteredExpenses[index].data() as Map<String, dynamic>;

                final amount = expense['amount'] ?? '';
                final description = expense['description'] ?? '';
                final category = expense['category'] ?? '';
                final timestamp = expense['date'] as Timestamp?;
                final date = timestamp != null
                    ? DateFormat('MMM d, yyyy').format(timestamp.toDate())
                    : '';

                return Card(
                  elevation: 2,
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(8),
                    title: Text(
                      'Amount: $amount',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Description: $description'),
                        Text('Category: $category'),
                        Text('Date: $date'),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      );
    });
  }

  Future<void> _showFilterPopup(
      HistoryProvider provider, BuildContext context) async {
    final selectedValue = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Filter Category'),
          content: DropdownButtonFormField<String>(
            value: provider.selectedCategory,
            onChanged: (newValue) {
              provider.updateCategoriesValue(newValue!);
            },
            items: <String>[
              'All Categories', // Add an option for all categories
              "Insurance",
              "Entertainment",
              "Interest",
              "Utilities",
              "Business",
              // Add more categories as needed
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            decoration: const InputDecoration(
              labelText: 'Category',
            ),
          ),
          actions: [
            TextButton(
              child: Text('Apply'),
              onPressed: () {
                Navigator.of(context).pop(provider.selectedCategory);
              },
            ),
          ],
        );
      },
    );
    print(selectedValue);
    if (selectedValue != null) {
      provider.updateCategoriesValue(
          selectedValue != 'All Categories' ? selectedValue : "All Categories");
    } else {
      provider.updateCategoriesValue('All Categories');
    }
  }
}
