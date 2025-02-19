import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_audio/model/song_model.dart';
import 'package:test_audio/song/service/song_service.dart';

class LyricNotifier extends StateNotifier<List<LyricModel>> {
  LyricNotifier() : super([]);

  Future<void> loadLines(String lyricsXmlUrl) async {
    try {
      final Dio dio = Dio();
      final response = await dio.get(lyricsXmlUrl);
      if (response.statusCode == 200) {
        final lyricData = SongService().parseXmlToLyricModels(response.data);

        state = lyricData;
      } else {
        throw Exception('Failed to load lyrics');
      }
    } catch (_) {}
  }
}

final lyricProvider = StateNotifierProvider<LyricNotifier, List<LyricModel>>(
  (ref) => LyricNotifier(),
);

class CurrentLineNotifier extends StateNotifier<int> {
  CurrentLineNotifier() : super(0);

  void updateLine(int index) {
    state = index;
  }
}

final currentLineProvider =
    StateNotifierProvider<CurrentLineNotifier, int>((ref) {
  return CurrentLineNotifier();
});
