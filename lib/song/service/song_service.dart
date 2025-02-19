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
      Duration? previousWordEndTime;

      for (int i = 0; i < iElements.length; i++) {
        final word = iElements.elementAt(i).text.trim();
        final timeString = iElements.elementAt(i).getAttribute('va')!;
        final time =
            Duration(milliseconds: (double.parse(timeString) * 1000).toInt());

        bool isFirstInLine = i == 0;

        LineModel lineModel = LineModel(
          time: time,
          word: word,
          previousWordEndTime: previousWordEndTime,
          isFirstInLine: isFirstInLine,
        );
        previousWordEndTime = lineModel.chars.last.time;

        lineModels.add(lineModel);
      }

      Duration lineStartTime = lineModels.first.time;
      lyricModels.add(
          LyricModel(time: lineStartTime, line: lineNumber, words: lineModels));
      lineNumber++;
    }

    return lyricModels;
  }
}
