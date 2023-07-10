import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ExpenseProvider with ChangeNotifier {
  final CollectionReference _expenseCollection =
      FirebaseFirestore.instance.collection('expenses');

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String selectedCategory = "Insurance";
  DateTime? selectedDate = DateTime.now();
  TextEditingController amountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  bool _isLoading = false;

  bool get isLoading => _isLoading;
  User? _user;

  User? get user => _user;
  final List<String> _expenseList = [
    "Insurance",
    "Entertainment",
    "Interest",
    "Utilities",
    "Business",
  ];

  List<String>? get expenseList => _expenseList;

  ExpenseProvider() {
    _checkCurrentUser();
    selectedCategory = _expenseList!.first;
  }

  Future<void> _checkCurrentUser() async {
    _user = FirebaseAuth.instance.currentUser;
    if (_user == null) {
      await _signInAnonymously();
    }
  }

  Future<void> _signInAnonymously() async {
    try {
      final result = await FirebaseAuth.instance.signInAnonymously();
      _user = result.user;
    } catch (error) {
      print('Error signing in anonymously: $error');
    }
  }

  String? validateAmount(String? value) {
    if (value!.isEmpty) {
      return 'Please enter an amount';
    }
    return null;
  }

  String? validateDescription(String? value) {
    if (value!.isEmpty) {
      return 'Please enter a description';
    }
    return null;
  }

  String? validateCategory(String? value) {
    if (value == null) {
      return 'Please select a category';
    }
    return null;
  }

  String? validateDate(DateTime? value) {
    if (value == null) {
      return 'Please select a date';
    }
    return null;
  }

  Future<void> submitForm() async {
    if (formKey.currentState!.validate()) {
      final expense = {
        'amount': double.parse(amountController.text),
        'description': descriptionController.text,
        'category': selectedCategory,
        'date': selectedDate,
        'userRef': FirebaseAuth.instance.currentUser!.uid,
      };

      try {
        _isLoading = true;
        notifyListeners();

        await _expenseCollection.add(expense);
        resetForm();
      } catch (error) {
        print('Error adding expense: $error');
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  void resetForm() {
    amountController.clear();
    descriptionController.clear();
    selectedCategory = "Insurance";
    selectedDate = DateTime.now();
  }

  void updateSelectedDate(DateTime? newDate) {
    selectedDate = newDate;
    notifyListeners();
  }
}
