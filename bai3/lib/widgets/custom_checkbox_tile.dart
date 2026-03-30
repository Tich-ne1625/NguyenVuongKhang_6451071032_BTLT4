import 'package:flutter/material.dart';

class CustomCheckboxTile extends StatelessWidget {
  final String title;
  final bool value;
  final void Function(bool?) onChanged;
  final Color? activeColor;

  const CustomCheckboxTile({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(title),
      value: value,
      activeColor: activeColor ?? Colors.orange,
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: onChanged,
    );
  }
}
