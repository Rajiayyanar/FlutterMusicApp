import 'package:flutter/material.dart';
import '../Services/AuthService.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLogin = true;
  bool isLoading = false;

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> handleAuth() async {

    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showError("Please enter email & password");
      return;
    }

    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(email)) {
      showError("Enter valid email");
      return;
    }

    if (password.length < 6) {
      showError("Password must be at least 6 characters");
      return;
    }

    setState(() => isLoading = true);

    try {
      if (isLogin) {

        await AuthService.login(email, password);

        Navigator.pushReplacementNamed(context, "/home");

      } else {

        await AuthService.register(email, password);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Registered successfully! Please login."),
          ),
        );

        setState(() {
          isLogin = true;
        });
      }

    } catch (e) {

      if (e == "email-already-in-use") {
        showError("Email already registered");

      } else if (e == "user-not-found") {
        showError("Invalid user, please register");

      } else if (e == "wrong-password") {
        showError("Incorrect password");

      } else if (e == "invalid-email") {
        showError("Invalid email format");

      } else {
        showError("Login failed");
      }
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            children: [

              const SizedBox(height: 80),

              const Icon(
                Icons.headphones,
                size: 80,
                color: Color.fromARGB(255, 251, 172, 139),
              ),

              const SizedBox(height: 10),

              const Text(
                "Peaceful Tunes",
                style: TextStyle(
                  color: Color.fromARGB(255, 251, 172, 139),
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 40),

              TextField(
                controller: emailController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Email",
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.white10,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.white10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 251, 172, 139),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              TextField(
                controller: passwordController,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Password",
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.white10,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.white10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 251, 172, 139),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : handleAuth,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color.fromARGB(255, 251, 172, 139),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.black)
                      : Text(
                          isLogin ? "Login" : "Register",
                          style: const TextStyle(color: Colors.black),
                        ),
                ),
              ),

              TextButton(
                onPressed: () {
                  setState(() {
                    isLogin = !isLogin;
                  });
                },
                child: Text(
                  isLogin
                      ? "Create account"
                      : "Already have account?",
                  style: const TextStyle(
                    color: Color.fromARGB(255, 251, 172, 139),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "OR",
                style: TextStyle(color: Colors.white54),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await AuthService.signInWithGoogle();
                    Navigator.pushReplacementNamed(context, "/home");
                  },
                  icon: Image.asset(
                    "assets/images/google.png",
                    height: 22,
                  ),
                  label: const Text(
                    "Continue with Google",
                    style: TextStyle(color: Colors.black),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}