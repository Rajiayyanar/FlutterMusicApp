import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Services/apiservice.dart';
import '../Screens/SearchScreen.dart';
import '../Screens/FavouriteScreen.dart';
import '../Screens/ProfileScreen.dart';
import '../Screens/PlayListScreen.dart';
import '../Screens/PlayerScreen.dart';
import '../Services/FavoriteManager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List songs = [];
  int currentIndex = 0;

  File? profileImage;
  final user = FirebaseAuth.instance.currentUser;
  bool isGoogleUser = false;

  @override
  void initState() {
    super.initState();
    loadSongs();
    FavoriteManager.loadFavorites();
    loadProfileImage();
  }

  Future<void> loadSongs() async {
    final data = await ApiService().searchSongs("tamil songs");
    setState(() {
      songs = data;
    });
  }

  // 👤 Load Profile Image
  Future<void> loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();

    final uid = FirebaseAuth.instance.currentUser?.uid;

    String? path = prefs.getString("profile_image_$uid");

    isGoogleUser = user?.providerData.any(
          (e) => e.providerId == "google.com",
        ) ??
        false;

    if (path != null) {
      setState(() {
        profileImage = File(path);
      });
    }
  }

  Widget homePage() {
    return Container(
      color: Colors.black,
      child: ListView.builder(
        itemCount: songs.length,
        itemBuilder: (context, index) {

          final song = songs[index];

          return ListTile(
            leading: Image.network(song.image),

            title: Text(
              song.title,
              style: const TextStyle(
                color: Color.fromARGB(255, 251, 172, 139),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),

            subtitle: Text(
              song.channel,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
              ),
            ),

            trailing: IconButton(
              icon: Icon(
                FavoriteManager.isFavorite(song)
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: const Color.fromARGB(255, 251, 172, 139),
              ),
              onPressed: () async {
                if (FavoriteManager.isFavorite(song)) {
                  await FavoriteManager.remove({
                    "videoId": song.videoId
                  });
                } else {
                  await FavoriteManager.add(song);
                }
                setState(() {});
              },
            ),

            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      PlayerScreen(videoId: song.videoId),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget searchPage() => const SearchScreen();
  Widget favoritePage() => const FavoriteScreen();
  Widget profilePage() => const ProfileScreen();
  Widget playlistPage() => const PlaylistScreen();

  @override
  Widget build(BuildContext context) {

    final List pages = [
      homePage(),
      searchPage(),
      favoritePage(),
      profilePage(),
      playlistPage(),
    ];

    return Scaffold(

      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,

        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [

            Icon(
              Icons.headphones,
              color: Color.fromARGB(255, 251, 172, 139),
              size: 28,
            ),

            SizedBox(width: 8),

            Text(
              "Peaceful Tunes",
              style: TextStyle(
                color: Color.fromARGB(255, 251, 172, 139),
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),

          ],
        ),
      ),

      body: pages[currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,

        selectedItemColor: const Color.fromARGB(255, 251, 172, 139),
        unselectedItemColor: Colors.white70,

        onTap: (index) {
          setState(() {
            currentIndex = index;
          });

          if (index == 3) {
            loadProfileImage();
          }
        },

        items: [

          BottomNavigationBarItem(
            icon: AnimatedContainer(
  duration: const Duration(milliseconds: 300),
  curve: Curves.easeInOut,
  transform: Matrix4.identity()
    ..scale(currentIndex == 0 ? 1.3 : 1.0),

  child: Icon(
    Icons.home,
    color: currentIndex == 0
        ? Color.fromARGB(255, 251, 172, 139)
        : Colors.white70,
  ),
),
            label: "Home",
          ),

          BottomNavigationBarItem(
            icon: AnimatedContainer(
  duration: const Duration(milliseconds: 300),
  curve: Curves.easeInOut,
  transform: Matrix4.identity()
    ..scale(currentIndex == 1 ? 1.3 : 1.0),

  child: Icon(
    Icons.search,
    color: currentIndex == 1
        ? Color.fromARGB(255, 251, 172, 139)
        : Colors.white70,
  ),
),
            label: "Search",
          ),

          BottomNavigationBarItem(
            icon: AnimatedContainer(
  duration: const Duration(milliseconds: 300),
  curve: Curves.easeInOut,
  transform: Matrix4.identity()
    ..scale(currentIndex == 2 ? 1.3 : 1.0),

  child: Icon(
    Icons.favorite,
    color: currentIndex == 2
        ? Color.fromARGB(255, 251, 172, 139)
        : Colors.white70,
  ),
),
            label: "Favorites",
          ),

          BottomNavigationBarItem(
          icon: AnimatedContainer(
  duration: const Duration(milliseconds: 300),
  curve: Curves.easeInOut,
  transform: Matrix4.identity()
    ..scale(currentIndex == 3 ? 1.3 : 1.0),

  child: CircleAvatar(
    radius: 12,
    backgroundColor: Colors.white24,

    backgroundImage: isGoogleUser
        ? (user?.photoURL != null
            ? NetworkImage(user!.photoURL!)
            : null)
        : (profileImage != null
            ? FileImage(profileImage!)
            : null) as ImageProvider?,

    child: (!isGoogleUser && profileImage == null)
        ? const Icon(Icons.person, size: 16, color: Colors.white)
        : null,
  ),
),
            label: "Profile",
          ),

          BottomNavigationBarItem(
            icon: AnimatedContainer(
  duration: const Duration(milliseconds: 300),
  curve: Curves.easeInOut,
  transform: Matrix4.identity()
    ..scale(currentIndex == 4 ? 1.3 : 1.0),

  child: Icon(
    Icons.queue_music,
    color: currentIndex == 4
        ? Color.fromARGB(255, 251, 172, 139)
        : Colors.white70,
  ),
),
            label: "Playlist",
          ),

        ],
      ),
    );
  }
}