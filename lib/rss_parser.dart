import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'package:collection/collection.dart';

class RssParser {
  static Future<List<Map<String, String>>> fetchEpisodes(String feedUrl) async {
    try {
      print('Fetching episodes from: $feedUrl');
      final response = await http.get(Uri.parse(feedUrl));

      if (response.statusCode == 200) {
        final document = xml.XmlDocument.parse(response.body);
        final items = document.findAllElements('item');

        final episodes = items.map((item) {
          final titleElement = item.findElements('title').firstOrNull;
          final enclosureElement = item.findElements('enclosure').firstOrNull;
          final urlElement = enclosureElement?.getAttribute('url');

          print('Episode title: ${titleElement?.text}');
          print('Episode URL: ${urlElement}');

          return {
            'title': titleElement?.text ?? 'Untitled Episode',
            'url': urlElement ?? '',
          };
        }).toList();

        return episodes;
      } else {
        print('Request failed with status: ${response.statusCode}.');
        throw Exception(
            'Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      print('Error fetching episodes: $e');
      throw Exception('Error fetching episodes: $e');
    }
  }
}