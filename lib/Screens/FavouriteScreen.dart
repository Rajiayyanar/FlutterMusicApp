import 'package:flutter/material.dart';
import '../Services/FavoriteManager.dart';
import '../Screens/PlayerScreen.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {

  @override
  void initState() {
    super.initState();
    FavoriteManager.loadFavorites().then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,

      body: FavoriteManager.favorites.isEmpty
          ? const Center(
              child: Text(
                "No Favorites Yet",
                style: TextStyle(color: Colors.white54),
              ),
            )
          : ListView.builder(
              itemCount: FavoriteManager.favorites.length,
              itemBuilder: (context, index) {

                final song = FavoriteManager.favorites[index];

                return ListTile(
                  leading: Image.network(song['image']),

                  title: Text(
                    song['title'],
                    style: const TextStyle(
                      color: Color.fromARGB(255, 251, 172, 139),
                      fontSize: 13,
                    ),
                  ),

                  subtitle: Text(
                    song['channel'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                    ),
                  ),
        onTap: (){
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) =>
          PlayerScreen(videoId: song["videoId"]),
    ),
  );
},

                  trailing: IconButton(
                    icon: const Icon(Icons.favorite, color: Color.fromARGB(255, 251, 172, 139)),

                    onPressed: () async {
                      await FavoriteManager.remove(song);
                      setState(() {});
                    },
                  ),
                );
              },
            ),
    );
  }
}