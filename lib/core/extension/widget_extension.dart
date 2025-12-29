import 'package:flutter/material.dart';

extension ContextExtenstion on BuildContext{
  showSnackbar(String text)=>ScaffoldMessenger.of(this).showSnackBar(SnackBar(content: Text(text)));
}