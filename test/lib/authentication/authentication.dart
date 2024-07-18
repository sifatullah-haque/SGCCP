import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/authentication/ApiService.dart';
import 'package:test/authentication/constant.dart';
import 'package:test/browser_page.dart';
import 'package:test/homepage.dart';

class NewAuthentication extends StatefulWidget {
  const NewAuthentication({super.key});

  @override
  _NewAuthenticationState createState() => _NewAuthenticationState();
}

class _NewAuthenticationState extends State<NewAuthentication> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    String? password = prefs.getString('password');

    if (email != null && password != null) {
      // Try to log in with saved credentials
      await login(context, email, password);
    }
  }

  Future<void> login(
      BuildContext context, String email, String password) async {
    setState(() {
      isLoading = true;
    });

    final response = await ApiService.login(email, password);

    if (response['success'] == true) {
      // Save login details
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('email', email);
      prefs.setString('password', password);

      // Navigate to homepage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                BrowserPage(url: 'https://app.sgccp-bd.com/1/portal')),
      );
    } else {
      // Show error dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Login Failed'),
          content: Text('Error: ${response['message']}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/bg.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 100),
                      // logo
                      const Center(
                        child: Image(
                          image: AssetImage(
                            "assets/logo.png",
                          ),
                          height: 120.0,
                        ),
                      ),
                      const SizedBox(height: 30),
                      // email field
                      InputField(
                        controller: emailController,
                        hintText: "Email",
                        labelText: "Email",
                      ),
                      const SizedBox(height: 20),
                      // password field
                      InputField(
                        controller: passwordController,
                        hintText: "Password",
                        labelText: "Password",
                        obscureText: true,
                      ),
                      const SizedBox(height: 20),
                      // login button
                      LoadingButton(
                        isLoading: isLoading,
                        text: 'Login',
                        onPressed: () {
                          final email = emailController.text;
                          final password = passwordController.text;
                          login(context, email, password);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (isLoading) const FullScreenLoader(),
        ],
      ),
    );
  }
}
