import 'package:flutter/material.dart';
import '../Services/apiservice.dart';
import '../Screens/SearchScreen.dart';
import '../Screens/FavouriteScreen.dart';
import '../Screens/ProfileScreen.dart';
import '../Screens/PlayListScreen.dart';
import '../Screens/PlayerScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List songs = [];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    loadSongs();
  }

  Future<void> loadSongs() async {

final data = await ApiService().searchSongs("tamil songs");
    setState(() {
      songs = data;
    });

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
                fontWeight: FontWeight.w500,
              ),
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

  Widget searchPage() {
    return const SearchScreen();
  }

  Widget favoritePage() {
    return const FavoriteScreen();
  }

  Widget profilePage() {
    return const ProfileScreen();
  }

  Widget playlistPage() {
    return const PlaylistScreen();
  }

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
                fontSize: 28,
                fontWeight: FontWeight.w600,
              ),
            ),

          ],
        ),

        backgroundColor: Colors.black,
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
        },

        items: const [

          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Search",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Favorites",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.queue_music),
            label: "Playlist",
          ),

        ],
      ),
    );
  }
}