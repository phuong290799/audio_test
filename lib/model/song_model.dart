class SongModel {
  String title;
  String url;
  String fileName;
  String lyricsUrl;

  SongModel({
    required this.title,
    required this.url,
    required this.fileName,
    required this.lyricsUrl,
  });
}

class LyricModel {
  final Duration time;
  final int line;
  List<LineModel> words;

  LyricModel({
    required this.time,
    required this.line,
    required this.words,
  });
}

class CharModel {
  final Duration time;
  final String char;

  CharModel({required this.time, required this.char});
}

class LineModel {
  final Duration time;
  final String word;
  final bool isFirstInLine;
  final List<CharModel> chars;
  final Duration? previousWordEndTime;

  LineModel({
    required this.time,
    required this.word,
    required this.isFirstInLine,
    this.previousWordEndTime,
  }) : chars =
            _splitWordIntoChars(word, time, previousWordEndTime, isFirstInLine);

  static List<CharModel> _splitWordIntoChars(
    String word,
    Duration startTime,
    Duration? previousWordEndTime,
    bool isFirstInLine,
  ) {
    List<CharModel> chars = [];
    Duration step = const Duration(milliseconds: 100);

    Duration adjustedStartTime = isFirstInLine
        ? startTime
        : (previousWordEndTime != null && previousWordEndTime >= startTime)
            ? previousWordEndTime + step
            : startTime;

    for (int i = 0; i < word.length; i++) {
      chars.add(CharModel(time: adjustedStartTime + (step * i), char: word[i]));
    }

    return chars;
  }
}
