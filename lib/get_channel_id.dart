import 'package:http/http.dart' as http;
import 'dart:convert';

void main() async {
  final apiKey = 'AIzaSyA8blvcii6-hg1SufDHKUWUQGuETTn3PZQ'; // Replace with your actual API key
  final query = 'glitterscreations731'; // Replace with the YouTube username or handle

  final url = 'https://www.googleapis.com/youtube/v3/search?part=snippet&type=channel&q=$query&key=$apiKey';

  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      print('Response JSON: $jsonData'); // Print the entire JSON response

      if (jsonData['items'] != null && jsonData['items'].isNotEmpty) {
        for (var item in jsonData['items']) {
          final channelId = item['id']['channelId'];
          final title = item['snippet']['title'];
          print('Channel Title: $title');
          print('Channel ID: $channelId');
        }
      } else {
        print('No channels found for query: $query');
      }
    } else {
      print('Failed to load channel ID: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}
