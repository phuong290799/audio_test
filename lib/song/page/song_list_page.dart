import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_audio/common/constant/gradient.dart';
import 'package:test_audio/song/provider/song_provider.dart';

import 'song_player_page.dart';

class SongListPage extends ConsumerStatefulWidget {
  const SongListPage({super.key});
  @override
  _SongListPageState createState() => _SongListPageState();
}

class _SongListPageState extends ConsumerState<SongListPage> {
  @override
  Widget build(BuildContext context) {
    final songs = ref.watch(songListProvider);
    final typeLyric = ref.watch(typeLyricProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách nhạc'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          DropdownButton<TypeLyric>(
            value: typeLyric,
            onChanged: (TypeLyric? newValue) {
              ref.read(typeLyricProvider.notifier).state =
                  newValue ?? TypeLyric.type1;
            },
            items: TypeLyric.values
                .map<DropdownMenuItem<TypeLyric>>((TypeLyric value) {
              return DropdownMenuItem<TypeLyric>(
                value: value,
                child: Text(
                  value.typeName,
                ),
              );
            }).toList(),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        padding: const EdgeInsets.only(top: 120),
        decoration: const BoxDecoration(gradient: appGradient),
        child: ListView.builder(
          padding: const EdgeInsets.only(top: 10),
          itemCount: songs.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(color: Colors.grey, width: 0.5),
              ),
              elevation: 2,
              child: ListTile(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SongPlayerPage(
                      song: songs[index],
                    ),
                  ),
                ),
                leading: const Icon(Icons.music_note_rounded),
                title: Hero(
                    tag: songs[index].title,
                    child: Material(
                      type: MaterialType.transparency,
                      child: Text(
                        songs[index].title,
                        style: const TextStyle(fontSize: 18),
                      ),
                    )),
                trailing: const Icon(Icons.play_circle),
              ),
            );
          },
        ),
      ),
    );
  }
}
