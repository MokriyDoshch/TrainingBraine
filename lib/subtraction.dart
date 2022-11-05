import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

class SubstractionScreen extends StatefulWidget {
  const SubstractionScreen({Key? key}) : super(key: key);

  @override
  State<SubstractionScreen> createState() => _SubstractionScreen();
}

class _SubstractionScreen extends State<SubstractionScreen> {
  int firstSelectedValue = 1;
  int secondSelectedValue = 1;
  int selectedModeValue = 0;
  List<int> numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  int currentIndex = 0;
  String question = '1 - 1';
  int intResult = 0;
  String strResult = '';
  Color unswerStringColor = Colors.blue;
  bool inputFlag = true;
  bool trainingFlag = true;
  bool testingFlag = false;
  List<int> questionForTesting = [];
  int questionCount = 0;
  int resultCount = 0;
  String audioassetTrue = 'assets/audio/Write1.mp3';
  String audioassetFalse = 'assets/audio/Wrong1.mp3';
  late Uint8List audiobytesTrue;
  late Uint8List audiobytesFalse;

  final timerDuration = const Duration(seconds: 3);
  late Timer timer;

  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      ByteData bytesTrue =
          await rootBundle.load(audioassetTrue); //load audio from assets
      audiobytesTrue = bytesTrue.buffer
          .asUint8List(bytesTrue.offsetInBytes, bytesTrue.lengthInBytes);
      ByteData bytesFalse = await rootBundle.load(audioassetFalse);
      audiobytesFalse = bytesFalse.buffer
          .asUint8List(bytesFalse.offsetInBytes, bytesFalse.lengthInBytes);
    });
    super.initState();
    questionCount = questionForTesting.length;
  }

  void startTimer() {
    setState(() {
      timer = Timer(timerDuration, generateQuestion);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<ElevatedButton> buttonsWidget = [
      for (String str in [
        "7",
        "8",
        "9",
        "4",
        "5",
        "6",
        "1",
        "2",
        "3",
        "OK",
        "0",
        "C"
      ])
        ElevatedButton(
            onPressed: () async {
              await buttonAsyncPressed(str);
            },
            child: Text(str))
    ];
    //double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Віднімання'),
        actions: [
          DropdownButton(
              value: selectedModeValue,
              icon: const Icon(Icons.menu),
              style: const TextStyle(color: Colors.white),
              items: const [
                DropdownMenuItem(
                  value: 0,
                  child:
                      Text('Тренування', style: TextStyle(color: Colors.black)),
                ),
                DropdownMenuItem(
                  value: 1,
                  child:
                      Text('Тестування', style: TextStyle(color: Colors.black)),
                )
              ],
              onChanged: (int? value) {
                setState(() {
                  selectedModeValue = value!;
                  resultCount = 0;
                  questionCount = 0;
                  if (value == 0) {
                    trainingFlag = true;
                    testingFlag = false;
                    currentIndex = 0;
                  }
                  if (value == 1) {
                    trainingFlag = false;
                    testingFlag = true;
                    currentIndex = 0;
                    for (int i = 0; i < 20; ++i) {
                      List numbers = generateNumbers();
                      questionForTesting.add(numbers[0]);
                      questionForTesting.add(numbers[1]);
                    }
                    questionCount = questionForTesting.length ~/ 2;
                  }
                  generateQuestion();
                });
              })
        ],
      ),
      body: Center(
        child: Stack(children: [
          //Positioned(left:50,top:50, child: SizedBox(width:100,height: 100,child: Column(children:[Text('temp text'),ElevatedButton(onPressed: () {}, child: const Text('OK'))]) )),
          Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const Text("Перше число", style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 10),
                  DropdownButton(
                    value: firstSelectedValue,
                    items: [
                      for (int i = 1; i < 10; ++i)
                        DropdownMenuItem(
                            value: i,
                            child: Text(i.toString(),
                                style: const TextStyle(fontSize: 20))),
                    ],
                    onChanged: (int? value) {
                      setState(() {
                        firstSelectedValue = value!;
                      });
                      //generate question
                      generateQuestion();
                    },
                  ),
                  const Spacer(),
                  const Text('Друге число', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 10),
                  DropdownButton(
                    value: secondSelectedValue,
                    items: [
                      for (int i = 1; i < 10; ++i)
                        DropdownMenuItem(
                            value: i,
                            child: Text(i.toString(),
                                style: const TextStyle(fontSize: 20))),
                    ],
                    onChanged: (int? value) {
                      setState(() {
                        secondSelectedValue = value!;
                        //generate question
                      });
                      generateQuestion();
                    },
                  ),
                ],
              ),

              const SizedBox(height: 10),
              Text(question,
                  style: const TextStyle(color: Colors.blue, fontSize: 40)),
              const SizedBox(height: 10),
              Text(strResult,
                  style: TextStyle(color: unswerStringColor, fontSize: 30)),
              //const SizedBox(height:10),
              const SizedBox(height: 10),
              Expanded(
                child: GridView.count(
                  childAspectRatio: 1.0,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                  padding: const EdgeInsets.fromLTRB(55, 0, 55, 0),
                  crossAxisCount: 3,
                  physics: const NeverScrollableScrollPhysics(),
                  children: buttonsWidget,
                ),
              ),
              const SizedBox(height: 10)
            ],
          ),
        ]),
      ),
    );
  }

  playSound(bool typeSound) async {
    if (typeSound) {
      await audioPlayer.playBytes(audiobytesTrue);
    } else {
      await audioPlayer.playBytes(audiobytesFalse);
    }
  }

  buttonAsyncPressed(String nameButton) async {
    if (inputFlag) {
      if (nameButton == 'OK') {
        if (strResult == intResult.toString()) {
          await playSound(true);
        } else {
          await playSound(false);
        }
      }
    }
    onButtonPressed(nameButton);
  }

  void generateQuestion() {
    setState(() {
      inputFlag = true;
      unswerStringColor = Colors.blue;
      //add generate question code here

      if (trainingFlag) {
        List numbers = generateNumbers();
        intResult = numbers[0] - numbers[1];
        question = '${numbers[0]} - ${numbers[1]}';
      }
      if (testingFlag) {
        if (questionForTesting.isNotEmpty) {
          int first = questionForTesting.removeAt(0);
          int second = questionForTesting.removeAt(0);
          intResult = first - second;
          question = '$first - $second';
        } else {
          question = '$resultCount/$questionCount';
        }
      }
      strResult = '';
    });
  }

  List<int> generateNumbers() {
    int resultMaxValue = pow(10, firstSelectedValue).toInt() - 1;
    int resultMinValue = pow(10, firstSelectedValue - 1).toInt();
    int secondMaxValue = pow(10, secondSelectedValue).toInt() - 1;
    int secondMinValue = pow(10, secondSelectedValue - 1).toInt();
    int resultValue = Random().nextInt(resultMaxValue);
    if (resultValue < resultMinValue) {
      resultValue += resultMinValue;
    }
    int secondValue = Random().nextInt(secondMaxValue);
    if (secondValue < secondMinValue) {
      secondValue += secondMinValue;
    }
    return [resultValue + secondValue, secondValue];
  }

  void onButtonPressed(String nameButton) {
    //debugPrint("i am pressed - $nameButton");
    if (inputFlag) {
      setState(() {
        if (nameButton == 'OK') {
          if (strResult.isNotEmpty) {
            if (strResult == intResult.toString()) {
              unswerStringColor = Colors.green;
              if (testingFlag) {
                resultCount++;
              }
            } else {
              unswerStringColor = Colors.red;
              strResult = intResult.toString();
            }
            inputFlag = false;
            startTimer();
            return;
          }
          return;
        }
        if (nameButton == 'C') {
          if (strResult.isNotEmpty) {
            strResult = strResult.substring(0, strResult.length - 1);
          }
          return;
        } else {
          strResult += nameButton;
        }
      });
    }
  }
}
