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

class CharModel {
  final Duration time;
  final String char;

  CharModel({required this.time, required this.char});
}

class LineModel {
  final Duration time;
  final String word;
  final List<CharModel> chars;

  LineModel({
    required this.time,
    required this.word,
  }) : chars = _splitWordIntoChars(word, time);

  static List<CharModel> _splitWordIntoChars(String word, Duration startTime) {
    List<CharModel> chars = [];
    Duration step = const Duration(milliseconds: 100);
    for (int i = 0; i < word.length; i++) {
      chars.add(CharModel(time: startTime + (step * i), char: word[i]));
    }
    return chars;
  }
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
