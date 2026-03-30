import 'package:flutter/material.dart';
import '../Services/apiservice.dart';
import '../Models/songmodel.dart';
import '../Screens/PlayerScreen.dart';

class SearchScreen extends StatefulWidget {
  final bool isSelectingSong;
  const SearchScreen({super.key, this.isSelectingSong = false});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  List<Song> songs = [];
  List<String> recentSearches = [];
  TextEditingController searchController = TextEditingController();

  void searchSongs(String query) async {

    if(query.isEmpty) return;

    final result = await ApiService().searchSongs(query);

    setState(() {

      songs = result;

      if(!recentSearches.contains(query)){
        recentSearches.insert(0, query);
      }

    });

  }

  Widget buildCenterUI(){

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          const Icon(
            Icons.search,
            size: 100,
            color: Color.fromARGB(255, 251, 172, 139),
          ),

          const SizedBox(height: 20),

          const Text(
            "Search Your Favourite Songs",
            style: TextStyle(
              color: Color.fromARGB(255, 251, 172, 139),
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 10),


          if(recentSearches.isNotEmpty)
          Column(
            children: [

              const Text(
                "Recent Searches",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 10),

              ...recentSearches.map((e){

                return ListTile(

                  leading: const Icon(
                    Icons.history,
                    color: Colors.white54,
                  ),

                  title: Text(
                    e,
                    style: const TextStyle(color: Colors.white),
                  ),

                  onTap: (){
                    searchController.text = e;
                    searchSongs(e);
                  },

                );

              }).toList()

            ],
          )

        ],
      ),
    );

  }

  Widget buildSongList(){

    return ListView.builder(

      itemCount: songs.length,

      itemBuilder: (context,index){

        final song = songs[index];

        return ListTile(

          leading: Image.network(song.image),

          title: Text(
            song.title,
            style: const TextStyle(color: Color.fromARGB(255, 251, 172, 139) ,fontSize: 13,fontWeight: FontWeight.w500),
          ),

          subtitle: Text(
            song.channel,
            style: const TextStyle(color: Colors.white,fontSize: 11,fontWeight: FontWeight.w500),
          ),

          onTap: () {

  if(widget.isSelectingSong){

      Navigator.pop(context, {
      "title": song.title,
      "artist": song.channel,
      "image": song.image,
      "videoId": song.videoId
    });

  }else{

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            PlayerScreen(videoId: song.videoId),
      ),
    );

  }

},

        );

      },
    );

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.black,

      body: Column(

        children: [

          const SizedBox(height: 25),

          Padding(
            padding: const EdgeInsets.all(12),

            child: TextField(

              controller: searchController,

              style: const TextStyle(color: Colors.white),

              decoration: InputDecoration(

  hintText: "Search Songs...",
  hintStyle: const TextStyle(color: Colors.white54),

  prefixIcon: const Icon(Icons.search,color: Colors.white),

  filled: true,
  fillColor: Colors.grey[900],

  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(30),
    borderSide: const BorderSide(
      color: Color.fromARGB(255, 251, 172, 139),
      width: 2,
    ),
  ),

  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(30),
    borderSide: const BorderSide(
      color: Color.fromARGB(255, 251, 172, 139),
      width: 2,
    ),
  ),

),

              onSubmitted: (value){
                searchSongs(value);
              },

            ),
          ),

          Expanded(
            child: songs.isEmpty
                ? buildCenterUI()
                : buildSongList(),
          )

        ],
      ),
    );
  }
}