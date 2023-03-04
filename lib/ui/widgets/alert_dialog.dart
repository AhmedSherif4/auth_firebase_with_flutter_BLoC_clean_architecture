import 'package:flutter/material.dart';

final AlertDialog alert = AlertDialog(
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
  content: const SizedBox(
    width: 20,
    height: 20,
    child: CircularProgressIndicator(),
  ),
);
