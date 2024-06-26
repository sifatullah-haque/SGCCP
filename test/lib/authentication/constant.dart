import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final bool obscureText;

  const InputField({
    required this.controller,
    required this.hintText,
    required this.labelText,
    this.obscureText = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          focusColor: Color(0xff034d77),
          fillColor: Colors.white70,
          hintText: hintText,
          labelStyle: const TextStyle(color: Colors.black87),
          labelText: labelText,
          hintStyle: const TextStyle(color: Colors.black54)),
      obscureText: obscureText,
    );
  }
}

class LoadingButton extends StatelessWidget {
  final bool isLoading;
  final String text;
  final VoidCallback onPressed;

  const LoadingButton({
    required this.isLoading,
    required this.text,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200.0,
      height: 50.0,
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          backgroundColor: MaterialStateProperty.all<Color>(
            const Color(0xff034d77),
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        'assets/loader.json', // Path to your Lottie file
        width: 150,
        height: 150,
      ),
    );
  }
}

class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Lottie.asset(
          'assets/loader.json', // Path to your Lottie file
          width: 150,
          height: 150,
        ),
      ),
    );
  }
}
