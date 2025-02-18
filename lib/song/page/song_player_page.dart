import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_audio/model/song_model.dart';
import 'package:test_audio/song/provider/lyric_provider.dart';
import 'package:test_audio/song/provider/song_provider.dart';
import 'package:test_audio/song/widget/lyric_widget.dart';
import 'package:test_audio/song/widget/lyric_widget_2.dart';
import 'package:test_audio/song/widget/lyric_widget_3.dart';
import 'package:test_audio/song/widget/play_widget.dart';

class SongPlayerPage extends ConsumerStatefulWidget {
  final SongModel song;
  const SongPlayerPage({super.key, required this.song});

  @override
  _SongPlayerPageState createState() => _SongPlayerPageState();
}

class _SongPlayerPageState extends ConsumerState<SongPlayerPage> {
  final scrollCtl = ScrollController();
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _audioPlayer.setSource(AssetSource('${widget.song.fileName}.mp3'));
      await _audioPlayer.resume();
    });

    Future.microtask(() =>
        ref.read(lyricProvider.notifier).loadLines(widget.song.lyricsUrl));

    _audioPlayer.onPositionChanged.listen((Duration position) {
      final lines = ref.read(lyricProvider);
      for (int i = 0; i < lines.length; i++) {
        if (position.inMilliseconds >= lines[i].time.inMilliseconds) {
          if (i == lines.length - 1 ||
              position.inMilliseconds < lines[i + 1].time.inMilliseconds) {
            ref.read(currentLineProvider.notifier).updateLine(lines[i].line);
          }
        }
      }
    });
  }

  @override
  void dispose() {
    scrollCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final typeLyric = ref.watch(typeLyricProvider);

    List<dynamic> widgets = [
      LyricWidget(player: _audioPlayer),
      LyricWidget2(player: _audioPlayer),
      LyricWidget3(scrollController: scrollCtl, player: _audioPlayer),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Hero(
          tag: widget.song.title,
          child: Material(
            type: MaterialType.transparency,
            child: Text(
              widget.song.title,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            ref.read(currentLineProvider.notifier).state = 0;
            _audioPlayer.stop();
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      extendBody: true,
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        height: 180,
        child: PlayerWidget(player: _audioPlayer),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 120, left: 20, right: 20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue, Colors.purple, Colors.pink],
          ),
        ),
        child: Center(
          child: widgets[typeLyric.index],
        ),
      ),
    );
  }
}
