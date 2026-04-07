import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Services/AuthService.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final user = FirebaseAuth.instance.currentUser;

  File? image;
  String username = "";

  bool get isGoogleUser =>
      user?.providerData.any((p) => p.providerId == "google.com") ?? false;

  @override
  void initState() {
    super.initState();
    loadImage();
    loadUsername();
  }

  // 🔄 Load Image
  Future<void> loadImage() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = user?.uid;

    String? path = prefs.getString("profile_image_$uid");

    if (path != null) {
      setState(() {
        image = File(path);
      });
    }
  }

  // 🔄 Load Username
  Future<void> loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = user?.uid;

    String? name = prefs.getString("username_$uid");

    if (name != null) {
      setState(() {
        username = name;
      });
    }
  }

  // 📸 Pick Image
  Future<void> pickImage() async {

    if (isGoogleUser) {
      showMsg("Google users can't change profile");
      return;
    }

    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (picked != null) {
      final file = File(picked.path);

      setState(() {
        image = file;
      });

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("profile_image_${user?.uid}", picked.path);
    }
  }

  // ❌ Delete Image
  Future<void> deleteImage() async {

    final prefs = await SharedPreferences.getInstance();

    await prefs.remove("profile_image_${user?.uid}");

    setState(() {
      image = null;
    });
  }

  // ✏️ Edit Username
  Future<void> editUsername() async {

    if (isGoogleUser) {
      showMsg("Google users can't edit name");
      return;
    }

    TextEditingController controller =
        TextEditingController(text: username);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: const BorderSide(color: Color.fromARGB(255, 251, 172, 139))),
        title: const Text(
          "Edit Username",
          style: TextStyle(color: Color.fromARGB(255, 251, 172, 139)),
          ),
        content: TextField(
          style: const TextStyle(color: Colors.white),
          controller: controller,
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString(
                  "username_${user?.uid}", controller.text);

              setState(() {
                username = controller.text;
              });

              Navigator.pop(context);
            },
            child: const Text(
              "Save",
              style: TextStyle(color: Color.fromARGB(255, 251, 172, 139)),
            ),
          )
        ],
      ),
    );
  }

  void showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Profile",
          style: TextStyle(color: Color.fromARGB(255, 251, 172, 139)),
        ),
      ),

      body: Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [


          const SizedBox(height: 40),

          Stack(
            alignment: Alignment.bottomRight,
            children: [

              GestureDetector(
                onTap: pickImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white24,
                  backgroundImage: image != null
                      ? FileImage(image!)
                      : (user?.photoURL != null
                          ? NetworkImage(user!.photoURL!)
                          : null) as ImageProvider?,
                  child: image == null && user?.photoURL == null
                      ? const Icon(Icons.person,
                          size: 60, color: Colors.white)
                      : null,
                ),
              ),

              if (!isGoogleUser)
  Positioned(
    bottom: 0,
    right: 0,
    child: GestureDetector(
      onTap: pickImage,
      child: CircleAvatar(
        radius: 14,
        backgroundColor: Color.fromARGB(255, 251, 172, 139),
        child: const Icon(
          Icons.edit,
          size: 16,
          color: Colors.black,
        ),
      ),
    ),
  ),

if (!isGoogleUser && image != null)
  Positioned(
    bottom: 0,
    left: 0,
    child: GestureDetector(
      onTap: deleteImage,
      child: CircleAvatar(
        radius: 14,
        backgroundColor: Color.fromARGB(255, 251, 172, 139),
        child: const Icon(
          Icons.delete,
          size: 16,
          color: Colors.black,
        ),
      ),
    ),
  ),
            ],
          ),

          const SizedBox(height: 20),

          GestureDetector(
            onTap: editUsername,
            child: Text(
              username.isNotEmpty
                  ? username
                  : (user?.displayName ?? "Tap to add name"),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),

          const SizedBox(height: 5),

          Text(
            user?.email ?? "",
            style: const TextStyle(color: Colors.white54),
          ),

          const SizedBox(height: 40),

          ElevatedButton(
            onPressed: () async {
              await AuthService.logout();
              Navigator.pushReplacementNamed(context, "/login");
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  const Color.fromARGB(255, 251, 172, 139),
            ),
            child: const Text(
              "Logout",
              style: TextStyle(color: Colors.black),
            ),
          )
        ],
      ),
    )
    );
  }
}