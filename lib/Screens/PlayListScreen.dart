import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Screens/SearchScreen.dart';
import '../Screens/PlayerScreen.dart';
import 'dart:convert';

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({super.key});

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {

  List<String> playlists = [];

  @override
  void initState() {
    super.initState();
    loadPlaylists();
  }

  void loadPlaylists() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? saved = prefs.getStringList("playlists");

    if (saved != null) {
      setState(() {
        playlists = saved;
      });
    }
  }

  void savePlaylists() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList("playlists", playlists);
  }

  void createPlaylist() {

    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context){

        return AlertDialog(

          backgroundColor: Colors.black,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: const BorderSide(
              color: Color.fromARGB(255, 251, 172, 139),
              width: 2,
            ),
          ),

          title: const Text(
            "Create Playlist",
            style: TextStyle(color: Colors.white),
          ),

          content: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),

            decoration: const InputDecoration(
              hintText: "Playlist Name",
              hintStyle: TextStyle(color: Colors.white54),
            ),
          ),

          actions: [

            TextButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: const Text(
                "Cancel",
                style: TextStyle(
                  color: Color.fromARGB(255, 251, 172, 139),
                ),
              ),
            ),

            TextButton(
              onPressed: (){

                if(controller.text.isNotEmpty){

                  setState(() {
                    playlists.add(controller.text);
                  });

                  savePlaylists();
                }

                Navigator.pop(context);

              },
              child: const Text(
                "Create",
                style: TextStyle(
                  color: Color.fromARGB(255, 251, 172, 139),
                ),
              ),
            )

          ],
        );

      },
    );

  }

  void deletePlaylist(int index){

    showDialog(
      context: context,
      builder: (context){

        return AlertDialog(

          backgroundColor: Colors.black,
         shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(15),
    side: const BorderSide(
      color: Color.fromARGB(255, 251, 172, 139),
      width: 2,
    ),
  ),
          title: const Text(
            "Delete Playlist?",
            style: TextStyle(color: Colors.white),
          ),

          actions: [

            TextButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: const Text(
                "Cancel",
                style: TextStyle(
                    color: Color.fromARGB(255, 251, 172, 139)),
              ),
            ),

            TextButton(
              onPressed: (){

                setState(() {
                  playlists.removeAt(index);
                });

                savePlaylists();

                Navigator.pop(context);

              },
              child: const Text(
                "Delete",
                style: TextStyle(
                    color: Color.fromARGB(255, 251, 172, 139)),
              ),
            )

          ],
        );

      },
    );

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Playlists",
          style: TextStyle(
            color: Color.fromARGB(255, 251, 172, 139),
          ),
        ),

        actions: [

          IconButton(
            icon: const Icon(
              Icons.add,
              color: Color.fromARGB(255, 251, 172, 139),
              size: 28,
            ),
            onPressed: createPlaylist,
          )

        ],
      ),

      body: playlists.isEmpty
          ? const Center(
              child: Text(
                "No Playlist Created",
                style: TextStyle(color: Colors.white54),
              ),
            )
          : ListView.builder(

              itemCount: playlists.length,

              itemBuilder: (context,index){

                return ListTile(

                  leading: const Icon(
                    Icons.queue_music,
                    color: Colors.white,
                  ),

                  title: Text(
                    playlists[index],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),

                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                  ),

                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                        PlaylistDetailScreen(name: playlists[index]),
                      ),
                    );
                  },

                  onLongPress: (){
                    deletePlaylist(index);
                  },

                );

              },
            ),
    );
  }
}



class PlaylistDetailScreen extends StatefulWidget {

  final String name;

  const PlaylistDetailScreen({super.key, required this.name});

  @override
  State<PlaylistDetailScreen> createState() => _PlaylistDetailScreenState();
}

class _PlaylistDetailScreenState extends State<PlaylistDetailScreen> {

List<Map<String, dynamic>> songs = [];
  @override
  void initState() {
    super.initState();
    loadSongs();
  }

void loadSongs() async {

  final prefs = await SharedPreferences.getInstance();

  List<String>? savedSongs = prefs.getStringList(widget.name);

  if (savedSongs != null) {

    setState(() {

      songs = savedSongs
          .map((song) => jsonDecode(song) as Map<String, dynamic>)
          .toList();

    });

  }

}

 void saveSongs() async {

  final prefs = await SharedPreferences.getInstance();

  List<String> encodedSongs =
      songs.map((song) => jsonEncode(song)).toList();

  prefs.setStringList(widget.name, encodedSongs);

}

void addSong() async {

  final selectedSong = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const SearchScreen(
        isSelectingSong: true,
      ),
    ),
  );

  if (selectedSong != null) {

    setState(() {
      songs.add(selectedSong);
    });

    saveSongs();

  }

}

  void deleteSong(int index){

    setState(() {
      songs.removeAt(index);
    });

    saveSongs();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,

        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 251, 172, 139),
        ),

        title: Text(
          widget.name,
          style: const TextStyle(
            color: Color.fromARGB(255, 251, 172, 139),
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),

        actions: [
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Color.fromARGB(255, 251, 172, 139),
              size: 28,
            ),
            onPressed: addSong,
          )
        ],
      ),

      body: songs.isEmpty
          ? const Center(
              child: Text(
                "No Songs Added",
                style: TextStyle(color: Colors.white54),
              ),
            )
          : ListView.builder(

              itemCount: songs.length,

              itemBuilder: (context,index){

                return ListTile(

  leading: ClipRRect(
    borderRadius: BorderRadius.circular(6),
    child: Image.network(
      songs[index]["image"],
      width: 50,
      height: 50,
      fit: BoxFit.cover,
    ),
  ),

  title: Text(
    songs[index]["title"],
    style: const TextStyle(
      color: Color.fromARGB(255, 251, 172, 139),
      fontSize: 13,
    ),
  ),

  subtitle: Text(
    songs[index]["artist"],
    style: const TextStyle(
      color: Colors.white54,
      fontSize: 11,
    ),
  ),

  onTap: (){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
        PlayerScreen(videoId: songs[index]["videoId"]),
      ),
    );
  },

  onLongPress: (){
    deleteSong(index);
  },

);

              },
            ),
    );
  }
}