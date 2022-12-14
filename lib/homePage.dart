import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _audioQuery = new OnAudioQuery();
  final AudioPlayer _audioPlayer = AudioPlayer();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestPermission();
  }

  void requestPermission() {
    Permission.storage.request();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Audio Listing'),
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<List<SongModel>>(
        future: _audioQuery.querySongs(
          sortType: null,
          orderType: OrderType.ASC_OR_SMALLER,
          uriType: UriType.EXTERNAL,
          ignoreCase: true,
        ),
        builder: (context, items) {
          if (items.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (items.data!.isEmpty) {
            return Center(child: Text('No Songs Identified'));
          }
          return ListView.builder(
            itemBuilder: (context, index) => ListTile(
              leading: Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              title: Text(
                items.data![index].displayNameWOExt,
                style: TextStyle(color: Colors.black),
              ),
              subtitle: Text(items.data![index].artist.toString(),
                  style: TextStyle(color: Colors.black)),
              trailing: Icon(
                Icons.more_vert,
                color: Colors.black,
                size: 30,
              ),
              onTap: () {
                playSong(items.data![index].uri);
              },
            ),
            itemCount: items.data!.length,
          );
        },
      ),
    );
  }

  playSong(String? uri) {
    try{
      _audioPlayer.setAudioSource(
      AudioSource.uri(
        Uri.parse(uri!),
      ),
    );
    _audioPlayer.play();
    }on Exception {
      print('Error While passing song');
    }
  }
}
