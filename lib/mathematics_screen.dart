import 'package:flutter/material.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

class MathematicsScreen extends StatefulWidget {
  const MathematicsScreen({Key? key}) : super(key: key);
  @override
  State<MathematicsScreen> createState() => _MathematicsScreen();
}

class _MathematicsScreen extends State <MathematicsScreen> {

  String audioassetTrue = 'assets/audio/Write1.mp3';
  String audioassetFalse = 'assets/audio/Wrong1.mp3';
  late Uint8List audiobytesTrue;
  late Uint8List audiobytesFalse;

  final timerDuration = const Duration(seconds: 3);
  late Timer timer;

  AudioPlayer audioPlayer = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return const Text('');
  }

  @override
  void initState() {
    Future.delayed(Duration.zero,() async {
      ByteData bytesTrue = await rootBundle.load(audioassetTrue); //load audio from assets
      audiobytesTrue = bytesTrue.buffer.asUint8List(bytesTrue.offsetInBytes, bytesTrue.lengthInBytes);
      ByteData bytesFalse = await rootBundle.load(audioassetFalse);
      audiobytesFalse = bytesFalse.buffer.asUint8List(bytesFalse.offsetInBytes,bytesFalse.lengthInBytes);
    }
    );
  }

  void startTimer() {
    timer = Timer(timerDuration,generateQuestion);
  }

  playSound(bool typeSound) async {
    if(typeSound) {
      await audioPlayer.playBytes(audiobytesTrue);
    }
    else {
      await audioPlayer.playBytes(audiobytesFalse);
    }
  }

  void generateQuestion() {

  }
}