import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:transcript_app/widget/audio_player_widget.dart';
import 'package:transcript_app/widget/transcript_item.dart';

class TranscriptPage extends StatefulWidget {
  static const route = "/transcript";

  const TranscriptPage({super.key});

  @override
  State<TranscriptPage> createState() => _TranscriptPageState();
}

class _TranscriptPageState extends State<TranscriptPage> {
  late final AudioPlayer audioPlayer;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Transcript Page'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 8,
        children: [
          AudioPlayerWidget(audioPlayer: audioPlayer),
          Expanded(
            child: ListView.separated(
              itemCount: 5,
              itemBuilder: (context, index) {
                return TranscriptItem(
                  speakerName: "Speaker's name",
                  timecode: "00:00:04",
                  caption: "This is a caption in the audio",
                );
              },
              separatorBuilder: (context, index) {
                return Divider(height: 24);
              },
            ),
          ),
        ],
      ),
    );
  }
}
