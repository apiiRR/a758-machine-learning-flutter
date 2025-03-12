import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transcript_app/controller/gemini_controller.dart';
import 'package:transcript_app/utils/utils.dart';
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
            // todo-04-ui-03: consume the list with Consumer and set the empty transcript.
            child: Consumer<GeminiController>(
              builder: (_, gemini, _) {
                final segments = gemini.transcript?.segments;
                if (segments == null || segments.isEmpty) {
                  return Text("Empty transcript.");
                }

                // todo-04-ui-04: change the list value based on the state
                return ListView.separated(
                  itemCount: segments.length,
                  itemBuilder: (context, index) {
                    final segment = segments[index];
                    return TranscriptItem(
                      speakerName: segment.speaker,
                      timecode: segment.timecode,
                      caption: segment.caption,
                      onTapped: () => onTimecodeChange(segment.timecode),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider(height: 24);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void onTimecodeChange(String timecode) async {
    final secondTime = timecodeToSeconds(timecode);
    final newPosition = Duration(seconds: secondTime);
    await audioPlayer.seek(newPosition);
    await audioPlayer.resume();
  }
}
