import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
//import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
//import 'dart:typed_data';

class AdditionScreen extends StatefulWidget {
  const AdditionScreen({Key?  key}) : super(key: key);
  @override
  State<AdditionScreen> createState() => _AdditionScreen();
}

class _AdditionScreen extends State<AdditionScreen> {
  int firstSelectedValue = 1;
  int secondSelectedValue = 1;
  int selectedModeValue = 0;
  List<int> numbers = [1,2,3,4,5,6,7,8,9,10];
  int currentIndex = 0;
  String question = '1 + 1';
  int intResult = 1;
  String strResult = '';
  Color unswerStringColor = Colors.blue;
  bool inputFlag = true;
  bool learningFlag = true;
  bool trainingFlag = false;
  bool testingFlag = false;
  List<int> questionForTesting = [0,1,2,3,4,5,6,7,8,9];
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
    questionCount = questionForTesting.length;
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
        title: const Text('Додавання'),
        actions: [
          DropdownButton(
              value: selectedModeValue,
              icon: const Icon(Icons.menu),
              style: const TextStyle(color: Colors.white),
              items: const [
                DropdownMenuItem(value: 0,child: Text('Тренування',style:TextStyle(color:Colors.black)),
                ),
                DropdownMenuItem(value: 1,child: Text('Тестування',style:TextStyle(color:Colors.black)),
                )
              ],
              onChanged: (int? value) {
                setState(() {
                  selectedModeValue = value!;
                  if(value == 0) {
                    trainingFlag = true;
                    testingFlag = false;
                    currentIndex = 0;
                  }
                  if(value == 1) {
                    trainingFlag = false;
                    testingFlag = true;
                    currentIndex = 0;
                  }
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
                      const Text("Перше число",style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 10),
                      DropdownButton(
                        value: firstSelectedValue,
                        items: [for(int i=1;i<10;++i) DropdownMenuItem(value:i,child: Text(i.toString(),style: const TextStyle(fontSize: 20))),],
                        onChanged: (int? value) {setState(() {
                          firstSelectedValue = value!;
                          //generate question
                          generateQuestion();
                        });},
                      ),
                      const Spacer(),
                      const Text('Друге число',style: TextStyle(fontSize: 20)),
                      const SizedBox(width:10),
                      DropdownButton(
                        value: secondSelectedValue,
                        items: [for(int i=1;i<10;++i) DropdownMenuItem(value:i,child: Text(i.toString(),style: const TextStyle(fontSize: 20))),],
                        onChanged: (int? value) {setState(() {
                          secondSelectedValue = value!;
                          //generate question
                        });
                        generateQuestion();
                          },
                      ),
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
      //add generate question code here
      int firstMaxValue = pow(10,firstSelectedValue).toInt() - 1;
      int secondMaxValue = pow(10,secondSelectedValue).toInt() - 1;
      if(trainingFlag) {
        int firstValue = Random().nextInt(firstMaxValue);
        int secondValue = Random().nextInt(secondMaxValue);
        intResult = firstMaxValue + secondMaxValue;
        question = '$firstValue + $secondValue';
      }
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