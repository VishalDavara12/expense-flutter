import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/home_provider.dart';
import 'history_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<ExpenseProvider>(
          builder: (context, expenseProvider, _) => Form(
            key: expenseProvider.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 15.0),
                TextFormField(
                  controller: expenseProvider.amountController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter an amount';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Expense Amount',
                  ),
                ),
                const SizedBox(height: 15.0),
                TextFormField(
                  controller: expenseProvider.descriptionController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Description',
                  ),
                ),
                const SizedBox(height: 15.0),
                DropdownButtonFormField<String>(
                  value: expenseProvider.selectedCategory,
                  onChanged: (newValue) {
                    expenseProvider.selectedCategory = newValue!;
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a category';
                    }
                    return null;
                  },
                  items: expenseProvider.expenseList!
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    labelText: 'Category',
                  ),
                ),
                const SizedBox(height: 15.0),
                ListTile(
                  title: const Text('Date'),
                  trailing: Text(
                    expenseProvider.selectedDate != null
                        ? DateFormat('MMM d, yyyy')
                            .format(expenseProvider.selectedDate!)
                        : 'Select date',
                  ),
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate:
                          expenseProvider.selectedDate ?? DateTime.now(),
                      firstDate: DateTime(2010),
                      lastDate: DateTime(2030),
                    );
                    if (picked != null) {
                      expenseProvider.updateSelectedDate(picked);
                    }
                  },
                ),
                const SizedBox(height: 15.0),
                ElevatedButton(
                  onPressed: expenseProvider.submitForm,
                  child: const Text('Submit'),
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HistoryScreen(),
                        ));
                  },
                  child: const Text('History'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
