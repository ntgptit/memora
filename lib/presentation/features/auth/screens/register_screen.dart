import 'package:flutter/material.dart';
import 'package:memora/presentation/features/auth/providers/auth_state.dart';
import 'package:memora/presentation/features/auth/screens/login_screen.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key, this.onAuthenticated});

  final VoidCallback? onAuthenticated;

  @override
  Widget build(BuildContext context) {
    return LoginScreen(
      initialMode: AuthViewMode.register,
      onAuthenticated: onAuthenticated,
    );
  }
}
