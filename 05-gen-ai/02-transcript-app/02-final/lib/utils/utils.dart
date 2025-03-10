import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

Future<File> getFileFromAssets(String path) async {
  final byteData = await rootBundle.load('assets/$path');

  final file = File('${(await getTemporaryDirectory()).path}/$path');
  if (file.existsSync()) {
    return file;
  }

  await file.create(recursive: true);
  await file.writeAsBytes(
    byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
  );

  return file;
}

String durationToTime(Duration value) {
  final minute = value.inMinutes % 60;
  final second = value.inSeconds % 60;

  final minuteString = minute.toString().padLeft(2, '0');
  final secondString = second.toString().padLeft(2, '0');

  return "$minuteString:$secondString";
}

int timecodeToSeconds(String timecode) {
  List<String> parts = timecode.split(':');
  if (parts.length != 3) {
    throw FormatException("Format timecode harus HH:MM:SS");
  }

  int hours = int.parse(parts[0]);
  int minutes = int.parse(parts[1]);
  int seconds = int.parse(parts[2]);

  return (hours * 3600) + (minutes * 60) + seconds;
}
