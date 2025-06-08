import 'package:email_validator/email_validator.dart';
import 'package:evolza_app/Presentation/app_router.dart';
import 'package:evolza_app/core/authentication.dart';
import 'package:evolza_app/Presentation/widgets/auth_styles.dart';
import 'package:evolza_app/Presentation/widgets/auth_widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService auth = AuthService();
  String email = "";
  String password = "";

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _login() async {
    if (formKey.currentState != null && formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        email = _emailController.text;
        password = _passwordController.text;
      });

      var result = await auth.signWithEmailAndPassword(email, password);

      setState(() {
        _isLoading = false;
      });

      if (result == true) {
        // ignore: avoid_print
        print("Login successfully");
        if (mounted) {
          context.go(AppRouter.profilePath);
        }
      } else {
        // ignore: avoid_print
        print("Login Failed");
        // Show error snackbar
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Login failed. Please check your credentials.'),
              backgroundColor: Colors.red.shade400,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: AuthStyles.gradientColors,
            stops: AuthStyles.gradientStops,
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 60),

                      AuthContainer(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Evolza",
                              style: AuthStyles.titleStyle,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              "Welcome Back",
                              style: AuthStyles.subtitleStyle,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 50),

                      AuthFormContainer(
                        child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Sign In",
                                style: AuthStyles.formTitleStyle,
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "Enter your credentials to continue",
                                style: AuthStyles.formSubtitleStyle,
                              ),
                              const SizedBox(height: 32),

                              AuthTextField(
                                controller: _emailController,
                                label: "Email Address",
                                hintText: "Enter your email",
                                prefixIcon: Icons.email_outlined,
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

                              const SizedBox(height: 24),

                              AuthTextField(
                                controller: _passwordController,
                                label: "Password",
                                hintText: "Enter your password",
                                prefixIcon: Icons.lock_outline,
                                obscureText: true,
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

                              const SizedBox(height: 32),

                              AuthButton(
                                text: "Sign In",
                                onPressed: _login,
                                isLoading: _isLoading,
                              ),

                              const SizedBox(height: 24),

                              AuthLink(
                                text: "Don't have an account? ",
                                linkText: "Sign Up",
                                onTap: () {
                                  context.go(AppRouter.signUpPath);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}