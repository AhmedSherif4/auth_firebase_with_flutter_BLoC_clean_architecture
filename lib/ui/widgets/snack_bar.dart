import 'package:flutter/material.dart';

SnackBar snackBarWidget(String label) => SnackBar(
      action: SnackBarAction(
          label: label, onPressed: () {}, textColor: Colors.white),
      behavior: SnackBarBehavior.floating,
      width: 200.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: const Text('Error!'),
      duration: const Duration(seconds: 1),
    );
