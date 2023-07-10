import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense/providers/history_provider.dart';
import 'package:expense/providers/home_provider.dart';
import 'package:expense/screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ExpenseProvider>(
          create: (context) => ExpenseProvider(),
        ),
        ChangeNotifierProvider<HistoryProvider>(
          create: (context) => HistoryProvider(),
        ),
      ],
      child: MaterialApp(
        home: HomeScreen(),
      ),
    ),
  );
}
