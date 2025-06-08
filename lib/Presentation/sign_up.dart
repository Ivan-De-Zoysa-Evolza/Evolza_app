import 'package:email_validator/email_validator.dart';
import 'package:evolza_app/core/authentication.dart';
import 'package:evolza_app/Presentation/app_router.dart';
import 'package:evolza_app/Presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final AuthService auth = AuthService();
  String email = "";
  String password = "";
  String confirmPassowrd = "";

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    if (formKey.currentState != null && formKey.currentState!.validate()) {
      // ignore: avoid_print
      setState(() {
        email = _emailController.text;
        password = _passwordController.text;
        confirmPassowrd = _confirmPasswordController.text;
      });
      var result = await auth.signUpWithEmailAndPassword(email, password);
      if (result == true){
        print("New user login");
        if (mounted){
          context.go(AppRouter.profilePath);
        }

      } else {
        print("Something wrong");
      }
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign-up Page",style: TextStyle(
          fontWeight: FontWeight.bold,
        ),),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Your Email"),
              TextFormField(
                controller: _emailController,
                decoration: textInputDecoration.copyWith(
                  prefixIcon: Icon(Icons.email)
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
                  prefixIcon: Icon(Icons.password)
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
              SizedBox(height: 30),
              Text("Confirm Password"),
              TextFormField(
                obscureText: true,
                controller: _confirmPasswordController,
                decoration: textInputDecoration.copyWith(
                  prefixIcon: Icon(Icons.password)
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  if (value != _passwordController.text){
                    return "Enter same password";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(child: Text("Login now", style: TextStyle(color: Colors.blue)),onTap: () {
                    context.go(AppRouter.loginPath);
                  },),
                ],
              ),
              SizedBox(height: 20),
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
                  child: Text("Register"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}