import 'dart:async';
import 'package:flutter/material.dart';
import '../Screens/homescreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [

          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [

                Icon(
                  Icons.headphones,
                  size: 80,
                  color: Color.fromARGB(255, 251, 172, 139),
                ),

                SizedBox(height: 20),

                Text(
                  "Peaceful Tunes",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 251, 172, 139),
                    letterSpacing: 1,
                  ),
                ),

                SizedBox(height: 10),

                Text(
                  "Listen. Relax. Repeat.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                  ),
                ),

              ],
            ),
          ),

        ],
      ),
    );
  }
}