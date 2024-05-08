import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final Function()? onPressed;
  const CustomButton({super.key, required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
      child: Text(title),
    );
  }
}
