import 'dart:io';
import 'package:xml/xml.dart' as xml;
import 'podcast.dart';

class PodcastStorage {
  static const String xmlPath = 'podcasts.xml';

  static Future<void> savePodcasts(List<Podcast> podcasts) async {
    final builder = xml.XmlBuilder();
    builder.processing('xml', 'version="1.0"');
    builder.element('podcasts', nest: () {
      for (final podcast in podcasts) {
        builder.element('podcast', nest: () {
          builder.element('name', nest: podcast.name);
          builder.element('feed', nest: podcast.feed);
          builder.element('imageUrl', nest: podcast.imageUrl);
        });
      }
    });

    final document = builder.buildDocument();
    await File(xmlPath).writeAsString(document.toString());
  }

  static Future<List<Podcast>> loadPodcasts() async {
    try {
      final file = File(xmlPath);
      if (!await file.exists()) {
        return [];
      }

      final xmlString = await file.readAsString();
      final document = xml.XmlDocument.parse(xmlString);
      final podcasts = <Podcast>[];

      for (final podcastElement in document.findAllElements('podcast')) {
        final name = podcastElement.findElements('name').single.innerText;
        final feed = podcastElement.findElements('feed').single.innerText;
        final imageUrl = podcastElement.findElements('imageUrl').single.innerText;

        podcasts.add(Podcast(
          name: name,
          feed: feed,
          imageUrl: imageUrl,
        ));
      }

      return podcasts;
    } catch (e) {
      print('Error loading podcasts: $e');
      return [];
    }
  }
}
