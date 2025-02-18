import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_audio/model/song_model.dart';
import 'package:test_audio/song/provider/lyric_provider.dart';

class LyricWidget extends ConsumerWidget {
  final AudioPlayer player;

  const LyricWidget({super.key, required this.player});

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
    LyricModel? nextLine;

    if (currentLineIndex + 1 < lines.length) {
      nextLine = lines[currentLineIndex + 1];
    }

    return AnimatedSwitcher(
      key: ValueKey(currentLine.time),
      duration: const Duration(milliseconds: 100),
      child: RichText(
        key: ValueKey(currentLine.time),
        textAlign: TextAlign.center,
        text: TextSpan(
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          children: [
            TextSpan(
              text: currentLine.words.map((w) => w.word).join(" "),
              style: const TextStyle(color: Colors.white),
            ),
            if (nextLine != null)
              TextSpan(
                text: "\n${nextLine.words.map((w) => w.word).join(" ")}",
                style: TextStyle(color: Colors.white.withOpacity(0.5)),
              ),
          ],
        ),
      ),
    );
  }
}
