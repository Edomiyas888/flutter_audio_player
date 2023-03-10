import 'dart:html';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:rxdart/rxdart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class PositionedData {
  const PositionedData(this.position, this.bufferedPosition, this.duration);
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late AudioPlayer _audioPlayer;
  final _playList = ConcatenatingAudioSource(children: [
    AudioSource.uri(
      Uri.parse('asset:///assets/audio/11.mp3'),
      tag: MediaItem(
          id: '0',
          title: 'God DId',
          artUri: Uri.parse(
              'data:image/jpeg;base64,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')),
    ),
    AudioSource.uri(
      Uri.parse('asset:///assets/audio/2.mp3'),
      tag: MediaItem(
          id: '1',
          title: 'God DId',
          artUri: Uri.parse(
              'data:image/jpeg;base64,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')),
    ),
    AudioSource.uri(
      Uri.parse('asset:///assets/audio/3.mp3'),
      tag: MediaItem(
          id: '2',
          title: 'God DId',
          artUri: Uri.parse(
              'data:image/jpeg;base64,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')),
    ),
  ]);
  Stream<PositionedData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionedData>(
        _audioPlayer.positionStream,
        _audioPlayer.bufferedPositionStream,
        _audioPlayer.durationStream,
        (position, bufferedPosition, duration) => PositionedData(
          position,
          bufferedPosition,
          duration ?? Duration.zero,
        ),
      );

  @override
  void initState() {
    // TODO: implement initState

    _audioPlayer = AudioPlayer()..setAsset('audio/11.mp3');
  }

  Future<void> _init() async {
    await _audioPlayer.setLoopMode(LoopMode.all);
    await _audioPlayer.setAudioSource(_playList);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _audioPlayer.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          onPressed: () {},
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_horiz))
        ],
        title: Text(widget.title),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF144771), Color(0xFF071A2C)])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder<SequenceState?>(
              stream: _audioPlayer.sequenceStateStream,
              builder: (context, snapshot) {
                final state = snapshot.data;
                if (state?.sequence.isEmpty ?? true) {
                  return const SizedBox();
                }
                final metaData = state!.currentSource!.tag as MediaItem;
                return Container();
              },
            ),
            StreamBuilder<PositionedData>(
              stream: _positionDataStream,
              builder: (context, snapshot) {
                final PositionedData = snapshot.data;
                return ProgressBar(
                  barHeight: 10,
                  baseBarColor: Colors.grey,
                  bufferedBarColor: Colors.grey,
                  progressBarColor: Colors.red,
                  thumbColor: Colors.red,
                  timeLabelTextStyle: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600),
                  progress: PositionedData?.position ?? Duration.zero,
                  buffered: PositionedData?.bufferedPosition ?? Duration.zero,
                  total: PositionedData?.duration ?? Duration.zero,
                  onSeek: _audioPlayer.seek,
                );
              },
            ),
            const SizedBox(height: 20),
            Controls(audioPlayer: _audioPlayer)
          ],
        ),
      ),
    );
  }
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key, required this.imageUrl, required this.title});
  final String imageUrl;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const DecoratedBox(
          decoration: const BoxDecoration(
            boxShadow: [
              const BoxShadow(
                  color: Colors.black12, offset: Offset(2, 4), blurRadius: 4)
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: CachedNetworkImage(imageUrl: imageUrl),
          ),
        ),
        Text(
          title,
          style: const TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class Controls extends StatelessWidget {
  const Controls({super.key, required this.audioPlayer});
  final AudioPlayer audioPlayer;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerState>(
      stream: audioPlayer.playerStateStream,
      builder: (context, snapshot) {
        final playerState = snapshot.data;
        final processingState = playerState?.processingState;
        final playing = playerState?.playing;
        if (!(playing ?? false)) {
          return IconButton(
            onPressed: audioPlayer.play,
            iconSize: 80,
            color: Colors.white,
            icon: const Icon(Icons.play_arrow_rounded),
          );
        } else if (processingState != ProcessingState.completed) {
          return IconButton(
              onPressed: audioPlayer.pause,
              iconSize: 80,
              color: Colors.white,
              icon: const Icon(Icons.pause_rounded));
        }
        return const Icon(Icons.play_arrow_rounded,
            size: 80, color: Colors.white);
      },
    );
  }
}
