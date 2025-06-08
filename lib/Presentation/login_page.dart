import 'package:email_validator/email_validator.dart';
import 'package:evolza_app/Presentation/app_router.dart';
import 'package:evolza_app/core/authentication.dart';
import 'package:evolza_app/Presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService auth = AuthService();
  String email = "";
  String password = "";

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    if (formKey.currentState != null && formKey.currentState!.validate()) {
      setState(() {
        email = _emailController.text;
        password = _passwordController.text;
      });
      var result = await auth.signWithEmailAndPassword(email, password);
      if (result == true) {
        // ignore: avoid_print
        print("Login successfully");
        if (mounted) {
          context.go(AppRouter.profilePath);
        }
      } else {
        // ignore: avoid_print
        print("Login Failed");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            SizedBox(height: 40),
            Text("Login",style: headings),
            SizedBox(height: 40),
            Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Your Email"),
                  TextFormField(
                    controller: _emailController,
                    decoration: textInputDecoration.copyWith(
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your email";
                      }
                      if (!EmailValidator.validate(value)) {
                        return "Please enter a valid email address";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 30),
                  Text("Password"),
                  TextFormField(
                    obscureText: true,
                    controller: _passwordController,
                    decoration: textInputDecoration.copyWith(
                      prefixIcon: Icon(Icons.password),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Text("Don't have an account"),
                      SizedBox(width: 10),
                      GestureDetector(
                        child: Text(
                          "Register",
                          style: TextStyle(color: Colors.blue),
                        ),
                        onTap: () {
                          context.go(AppRouter.signUpPath);
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 39),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 5,
                      ),
                      child: Text("Login"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
