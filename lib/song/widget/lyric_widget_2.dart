import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_audio/model/song_model.dart';
import 'package:test_audio/song/provider/lyric_provider.dart';

class LyricWidget2 extends ConsumerWidget {
  final AudioPlayer player;
  const LyricWidget2({super.key, required this.player});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLineIndex = ref.watch(currentLineProvider);
    final lines = ref.watch(lyricProvider);

    if (lines.isEmpty || currentLineIndex >= lines.length) {
      return const Center(
          child: Text(
        'Đang tải lời bài hát...',
        style: TextStyle(color: Colors.white),
      ));
    }
    final currentLine = lines[currentLineIndex];

    return StreamBuilder<Duration>(
      stream: player.onPositionChanged,
      builder: (context, snapshot) {
        final position = snapshot.data ?? Duration.zero;

        return AnimatedSwitcher(
          key: ValueKey(currentLine.time),
          duration: const Duration(milliseconds: 100),
          child: RichText(
            key: ValueKey(currentLine.time),
            text: TextSpan(
              children: _buildTextSpans(currentLine, position),
            ),
          ),
        );
      },
    );
  }

  List<TextSpan> _buildTextSpans(LyricModel currentLine, Duration position) {
    List<TextSpan> spans = [];
    for (var indexedWord in currentLine.words.indexed) {
      LineModel word = indexedWord.$2;

      for (var indexedChar in word.chars.indexed) {
        CharModel char = indexedChar.$2;

        bool isHighlighted = position >= char.time;

        spans.add(
          TextSpan(
            text: char.char,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: isHighlighted ? Colors.amberAccent : Colors.white,
            ),
          ),
        );
      }
      spans.add(const TextSpan(text: " "));
    }
    return spans;
  }
}
