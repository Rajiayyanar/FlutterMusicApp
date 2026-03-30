class Song {

  final String title;
  final String channel;
  final String image;
  final String videoId;

  Song({
    required this.title,
    required this.channel,
    required this.image,
    required this.videoId,
  });

  factory Song.fromJson(Map<String, dynamic> json) {

    return Song(
      title: json["snippet"]["title"] ?? "",
      channel: json["snippet"]["channelTitle"] ?? "",
      image: json["snippet"]["thumbnails"]["high"]["url"] ?? "",
      videoId: json["id"]["videoId"] ?? "",
    );

  }
}