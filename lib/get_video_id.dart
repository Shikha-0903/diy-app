String? getYouTubeVideoId(String url) {
  RegExp regExp = RegExp(
    r'(?:(?:youtube\.com\/(?:[^\/\n\s]+\/\S+\/|(?:v|e(?:mbed)?)\/|\S*?[?&]v=)|youtu\.be\/)([a-zA-Z0-9_-]{11}))',
    caseSensitive: false,
    multiLine: false,
  );
  final match = regExp.firstMatch(url);
  return match != null ? match.group(1) : null;
}

void main() {
  String url1 = "https://www.youtube.com/watch?v=GC7xMulhq7c";
  String url2 = "https://www.youtube.com/watch?v=k-2_nkbey8Y";

  String? videoId1 = getYouTubeVideoId(url1);
  String? videoId2 = getYouTubeVideoId(url2);

  print("Video ID 1: $videoId1"); // Output: Video ID 1: abc123
  print("Video ID 2: $videoId2"); // Output: Video ID 2: def456
}