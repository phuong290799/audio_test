import 'package:test_audio/model/song_model.dart';
import 'package:xml/xml.dart';

class SongService {
  List<LyricModel> parseXmlToLyricModels(String xmlString) {
    final document = XmlDocument.parse(xmlString);
    final params = document.findAllElements('param');

    List<LyricModel> lyricModels = [];
    int lineNumber = 0;

    for (final param in params) {
      final iElements = param.findElements('i');
      List<LineModel> lineModels = [];

      for (final iElement in iElements) {
        final word = iElement.text.trim();
        final timeString = iElement.getAttribute('va')!;
        final time =
            Duration(milliseconds: (double.parse(timeString) * 1000).toInt());

        lineModels.add(LineModel(time: time, word: word));
      }

      Duration lineStartTime = Duration.zero;
      if (lineModels.isNotEmpty) {
        lineStartTime = lineModels.first.time;
      }

      lyricModels.add(
          LyricModel(time: lineStartTime, line: lineNumber, words: lineModels));
      lineNumber++;
    }

    return lyricModels;
  }
}
