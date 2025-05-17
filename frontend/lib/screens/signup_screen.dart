import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../utils/constants.dart';
import 'login_screen.dart';
import '../services/user_service.dart'; // import the service

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController =
      TextEditingController(); // 👈 added email controller
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String _selectedRole = 'Senior';
  final List<String> _roles = ['Senior', 'Aidant'];
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text('Créer un compte'),
        backgroundColor: AppColors.primaryColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 36),
          child: Column(
            children: [
              CustomTextField(
                hintText: "Nom d'utilisateur",
                controller: _usernameController,
              ),
              SizedBox(height: 20),
              CustomTextField(
                hintText: "Email",
                controller: _emailController, // 👈 email input
              ),
              SizedBox(height: 20),
              CustomTextField(
                hintText: "Mot de passe",
                controller: _passwordController,
                isPassword: true,
              ),
              SizedBox(height: 20),
              CustomTextField(
                hintText: "Confirmer mot de passe",
                controller: _confirmPasswordController,
                isPassword: true,
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedRole,
                items: _roles.map((String role) {
                  return DropdownMenuItem<String>(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedRole = newValue!;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Rôle',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(height: 30),
              _isLoading
                  ? CircularProgressIndicator()
                  : CustomButton(
                      text: "S'inscrire",
                      onPressed: () async {
                        if (_usernameController.text.isEmpty ||
                            _usernameController.text.length < 3) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Nom d\'utilisateur trop court (min 3 caractères)')),
                          );
                        } else if (!_emailController.text.contains('@')) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Email invalide')),
                          );
                        } else if (_passwordController.text.length < 6) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Mot de passe trop court (min 6 caractères)')),
                          );
                        } else if (_passwordController.text !=
                            _confirmPasswordController.text) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Les mots de passe ne correspondent pas')),
                          );
                        } else {
                          setState(() {
                            _isLoading = true;
                          });

                          bool success = await UserService.addUser(
                            _usernameController.text,
                            _emailController.text, // 👈 pass email
                            _passwordController.text,
                            _selectedRole,
                          );

                          setState(() {
                            _isLoading = false;
                          });

                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Compte créé avec succès ✅')),
                            );
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Erreur lors de la création du compte ❌')),
                            );
                          }
                        }
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
