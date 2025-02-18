import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_audio/common/constant/constant.dart';
import 'package:test_audio/model/song_model.dart';

enum TypeLyric { type1, type2, type3 }

extension TypeLyricExtension on TypeLyric {
  String get typeName =>
      {
        TypeLyric.type1: 'Lyric 1',
        TypeLyric.type2: 'Lyric 2',
        TypeLyric.type3: 'Lyric 3',
      }[this] ??
      '';
}

final typeLyricProvider = StateProvider<TypeLyric>((ref) => TypeLyric.type1);

final songListProvider = Provider<List<SongModel>>((ref) {
  ///Songs Temp
  return [
    SongModel(
      title: 'Về đâu mái tóc người thương',
      url: SONG_URL,
      fileName: FILE_NAME,
      lyricsUrl: LYRIC_URL,
    ),
  ];
});
