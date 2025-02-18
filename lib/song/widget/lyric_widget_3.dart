import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_audio/model/song_model.dart';
import 'package:test_audio/song/provider/lyric_provider.dart';

class LyricWidget3 extends ConsumerWidget {
  final ScrollController scrollController;
  final AudioPlayer player;
  const LyricWidget3({
    super.key,
    required this.player,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int lastScrolledLine = 0;
    final currentLineIndex = ref.watch(currentLineProvider);
    final lines = ref.watch(lyricProvider);

    if (lines.isEmpty || currentLineIndex >= lines.length) {
      return const Center(
          child: Text(
        'Đang tải lời bài hát...',
        style: TextStyle(color: Colors.white),
      ));
    }

    void scrollToCurrentLine(int index) {
      if (lastScrolledLine == index) return;
      lastScrolledLine = index;

      Future.delayed(const Duration(milliseconds: 200), () {
        if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
          return;
        }
        scrollController.animateTo(
          index * 50.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToCurrentLine(currentLineIndex);
    });

    return StreamBuilder<Duration>(
      stream: player.onPositionChanged,
      builder: (context, snapshot) {
        final position = snapshot.data ?? Duration.zero;

        return Padding(
          padding: const EdgeInsets.only(bottom: 190),
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 10),
            controller: scrollController,
            itemCount: lines.length,
            itemBuilder: (context, index) {
              final line = lines[index];
              bool isCurrentLine = index == currentLineIndex;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                  child: RichText(
                    key: ValueKey(index),
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isCurrentLine ? Colors.orange : Colors.white,
                      ),
                      children: _buildTextSpans(line, position),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  List<InlineSpan> _buildTextSpans(LyricModel currentLine, Duration position) {
    List<InlineSpan> spans = [];

    for (var indexedWord in currentLine.words.indexed) {
      LineModel word = indexedWord.$2;

      for (var indexedChar in word.chars.indexed) {
        CharModel char = indexedChar.$2;
        bool isHighlighted = position >= char.time;

        spans.add(
          WidgetSpan(
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 300),
              tween: Tween<double>(
                begin: isHighlighted ? 0.0 : 1.0,
                end: isHighlighted ? 1.0 : 0.0,
              ),
              builder: (context, value, child) {
                return Text(
                  char.char,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Color.lerp(Colors.white, Colors.orange, value),
                  ),
                );
              },
            ),
          ),
        );
      }

      spans.add(const TextSpan(text: " "));
    }

    return spans;
  }
}
