import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

import 'popup_dialog.dart';

class MultiplicationScreen extends StatefulWidget {
  const MultiplicationScreen({Key?  key}) : super(key: key);
  @override
  State<MultiplicationScreen> createState() => _MultiplicationScreen();
}

class _MultiplicationScreen extends State<MultiplicationScreen> {
  int selectedValue = 1;
  int selectedModeValue = 0;
  List<int> numbers = [1,2,3,4,5,6,7,8,9,10];
  int currentIndex = 0;
  String question = '1 X 1';
  int intResult = 1;
  String strResult = '';
  Color unswerStringColor = Colors.blue;
  bool inputFlag = true;
  bool learningFlag = true;
  bool trainingFlag = false;
  bool testingFlag = false;
  List<int> questionForTesting = [1,2,3,4,5,6,7,8,9,10];
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
    Future.delayed(Duration.zero,() async {
      ByteData bytesTrue = await rootBundle.load(audioassetTrue); //load audio from assets
      audiobytesTrue = bytesTrue.buffer.asUint8List(bytesTrue.offsetInBytes, bytesTrue.lengthInBytes);
      ByteData bytesFalse = await rootBundle.load(audioassetFalse);
      audiobytesFalse = bytesFalse.buffer.asUint8List(bytesFalse.offsetInBytes,bytesFalse.lengthInBytes);
    }
    );
    super.initState();
  }

  void startTimer() {
    setState(() {
      timer = Timer(timerDuration,generateQuestion);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<ElevatedButton> buttonsWidget = [
      for(String str in ["7","8","9","4","5","6","1","2","3","OK","0","C"])
        ElevatedButton(
            onPressed: () async {await buttonAsyncPressed(str);},
            child: Text(str)
        )
    ];
    //double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
          appBar: AppBar(
            title: const Text('????????????????'),
            actions: [
              DropdownButton(
                  value: selectedModeValue,
                  icon: const Icon(Icons.menu),
                  style: const TextStyle(color: Colors.white),
                  items: const [
                    DropdownMenuItem(value: 0,child: Text('????????????????',style:TextStyle(color:Colors.black))
                    ),
                    DropdownMenuItem(value: 1,child: Text('????????????????????',style:TextStyle(color:Colors.black)),

                    ),
                    DropdownMenuItem(value: 2,child: Text('????????????????????',style:TextStyle(color:Colors.black)),
                    )
                  ],
                  onChanged: (int? value) {
                    setState(() {
                      selectedModeValue = value!;
                      if(value == 0) {
                        learningFlag = true;
                        trainingFlag = false;
                        testingFlag = false;
                        currentIndex = 0;
                      }
                      if(value == 1) {
                        learningFlag = false;
                        trainingFlag = true;
                        testingFlag = false;
                        currentIndex = 0;
                      }
                      if(value == 2) {
                        learningFlag = false;
                        trainingFlag = false;
                        testingFlag = true;
                        currentIndex = 0;
                        questionForTesting = [0,1,2,3,4,5,6,7,8,9];
                        questionCount = questionForTesting.length;
                        resultCount = 0;
                      }
                      generateQuestion();
                    });
                  }
              )
            ],
          ),
          body: Center(
            child: Stack(
                children: [
                  //Positioned(left:50,top:50, child: SizedBox(width:100,height: 100,child: Column(children:[Text('temp text'),ElevatedButton(onPressed: () {}, child: const Text('OK'))]) )),
                  Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          //const Text("????????????????",style: TextStyle(fontSize: 20)),
                          const SizedBox(width: 10),
                          DropdownButton(
                            value: selectedValue,
                            items: [for(int i=1;i<10;++i) DropdownMenuItem(value:i,child: Text(i.toString(),style: const TextStyle(fontSize: 20))),],
                            onChanged: (int? value) {setState(() {
                              selectedValue = value!;
                              currentIndex = 0;
                              question = '$selectedValue X ${numbers[currentIndex]}';
                              intResult = selectedValue * numbers[currentIndex];
                            });},
                          ),
                          const Spacer(),
                        ],),

                      const SizedBox(height:10),
                      Text(question,style:const TextStyle(color:Colors.blue,fontSize:40)),
                      const SizedBox(height:10),
                      Text(strResult,style:TextStyle(color: unswerStringColor,fontSize:30)),
                      //const SizedBox(height:10),
                      const SizedBox(height:10),
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
                      const SizedBox(height:10)
                    ],
                  ),
                ]
            ),
          ),
        );
  }

  playSound(bool typeSound) async {
    if(typeSound) {
      await audioPlayer.playBytes(audiobytesTrue);
    }
    else {
      await audioPlayer.playBytes(audiobytesFalse);
    }
  }

  buttonAsyncPressed (String nameButton) async {
    if(inputFlag) {
      if (nameButton == 'OK') {
        if (strResult == intResult.toString()) {
          await playSound(true);
        }
        else {
          await playSound(false);
        }
      }
    }
    onButtonPressed(nameButton);
  }

  void generateQuestion() {
    setState(() {
      inputFlag = true;
      if (learningFlag) {
        currentIndex++;
        if (currentIndex > numbers.length - 1) {
          currentIndex = 0;
        }
      }
      if(trainingFlag){
        currentIndex = Random().nextInt(9) + 1;
      }
      if(testingFlag) {
        if(questionForTesting.isNotEmpty) {
          questionForTesting.shuffle(Random());
          currentIndex = questionForTesting.removeLast();
        }
        else {
          strResult = '';
          question = '';
          showResultDialog();
          return;
        }
      }
      question = '$selectedValue X ${numbers[currentIndex]}';
      intResult = selectedValue * numbers[currentIndex];
      unswerStringColor = Colors.blue;
      strResult = '';
    });
  }

  void showResultDialog() {
    setState(() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext dialogContext) {
            return PopUpDialog(
                title: '??????????????????',
                content: '$resultCount/$questionCount',
                actions: <Widget>[
                  ElevatedButton(
                    child: const Text('???? ??????'),
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      learningFlag = false;
                      trainingFlag = false;
                      testingFlag = true;
                      currentIndex = 0;
                      questionForTesting = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
                      questionCount = questionForTesting.length;
                      resultCount = 0;
                      generateQuestion();
                    },
                  ),
                  ElevatedButton(
                    child: const Text('??????????????????'),
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      Navigator.of(context).pop();
                    },
                  ),
                ]);
          });
    });
  }

  void onButtonPressed(String nameButton) {
    //debugPrint("i am pressed - $nameButton");
    if(inputFlag) {
      setState(() {
        if (nameButton == 'OK') {
          if(strResult.isNotEmpty) {
            if (strResult == intResult.toString()) {
              unswerStringColor = Colors.green;
              if(testingFlag) {
                resultCount++;
              }
            }
            else {
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
        }
        else {
          strResult += nameButton;
        }
      });
    }
  }
}