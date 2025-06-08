import 'package:flutter/material.dart';
import 'auth_styles.dart';

class AuthContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const AuthContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(32),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: AuthStyles.containerDecoration,
      child: child,
    );
  }
}

class AuthFormContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const AuthFormContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(32),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: AuthStyles.formContainerDecoration,
      child: child,
    );
  }
}

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final IconData prefixIcon;
  final bool obscureText;
  final String? Function(String?)? validator;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hintText,
    required this.prefixIcon,
    this.obscureText = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AuthStyles.labelStyle,
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          style: const TextStyle(color: Color(0xFF111827)),
          decoration: AuthStyles.textFieldDecoration.copyWith(
            prefixIcon: Icon(
              prefixIcon,
              color: const Color(0xFF6b7280),
            ),
            hintText: hintText,
          ),
          validator: validator,
        ),
      ],
    );
  }
}

class AuthButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;

  const AuthButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: AuthStyles.primaryButtonStyle,
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                text,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}

class AuthLink extends StatelessWidget {
  final String text;
  final String linkText;
  final VoidCallback onTap;

  const AuthLink({
    super.key,
    required this.text,
    required this.linkText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: AuthStyles.textStyle,
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            linkText,
            style: AuthStyles.linkStyle,
          ),
        ),
      ],
    );
  }
} 