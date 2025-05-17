import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../utils/constants.dart';
import '../services/auth_service.dart'; // ajout
import '../models/User.dart'; // ajout
import 'signup_screen.dart';
import 'forgot_password_screen.dart';
import 'home_screen_senior.dart';
import 'home_screen_aidant.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService(); // ajout
  bool _loading = false; // ajout pour loading

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Icon(Icons.health_and_safety,
                  size: 80, color: AppColors.primaryColor),
              SizedBox(height: 20),
              Text(
                "Senior Care",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor),
              ),
              SizedBox(height: 8),
              Text(
                "Une main tendue au bon moment",
                style: TextStyle(fontSize: 18, color: Colors.grey[700]),
              ),
              SizedBox(height: 30),
              Text(
                "Bienvenue ! Connectez-vous pour continuer.",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 30),
              CustomTextField(
                hintText: "Nom d'utilisateur",
                controller: _usernameController,
              ),
              SizedBox(height: 20),
              CustomTextField(
                hintText: "Mot de passe",
                controller: _passwordController,
                isPassword: true,
              ),
              SizedBox(height: 30),
              _loading
                  ? CircularProgressIndicator()
                  : CustomButton(
                      text: 'Se connecter',
                      onPressed: _handleLogin,
                    ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ForgotPasswordScreen()));
                },
                child: Text("Mot de passe oublié ?"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => SignupScreen()));
                },
                child: Text("Créer un compte"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleLogin() async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      return;
    } else if (_passwordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mot de passe trop court (min 6 caractères)')),
      );
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      User user = (await _authService.login(
        email: _usernameController.text.trim(),
        password: _passwordController.text,
      ));

      // Navigation selon le rôle reçu du serveur
      if (user.roles.contains('ROLE_ADMIN')) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomeScreenAidant()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomeScreenSenior()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }
}
