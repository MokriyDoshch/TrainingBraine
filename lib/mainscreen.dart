import 'package:flutter/material.dart';
//import 'dart:async';
//import 'dart:math';
//import 'package:audioplayers/audioplayers.dart';
//import 'package:flutter/rendering.dart';
//import 'package:flutter/services.dart';
//import 'dart:typed_data';

import 'multiplication.dart';
import 'addition.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key?  key}) : super(key: key);
  @override
  State<MainScreen> createState() => _MainScreen();
}

class _MainScreen extends State<MainScreen> {
  Map<String,WidgetBuilder> screens = {
    '/Таблиці множення': (context) => const MultiplicationScreen(),
    '/Додавання': (context) => const AdditionScreen(),
    '/Віднімання': (context) => const MultiplicationScreen(),
  };

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //double screenWidth = MediaQuery.of(context).size.width;
    return MaterialApp(
      title: "TrainingBraine",
      routes: screens,
      /*{
        '/Таблиці множення': (context) => const Multiplication(),
        '/Додавання': (context) => const Multiplication(),
      },*/
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Мозковий тренажер'),

        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20,10,20,10),

      child: ListView.builder(
        itemCount: screens.keys.length,
        //prototypeItem: ListTile(title: Text('n')),
        itemBuilder: (context,index) {
          String nameItem = screens.keys.elementAt(index);//screens[index];
          return ListTile(title: Text(nameItem.substring(1,nameItem.length),
              style: const TextStyle(
                  color: Colors.black
              ),
          ),
            onTap: () {
              Navigator.pushNamed(context,nameItem);
              /*Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) {
                    return const Multiplication();
                  }
                )
              );*/
            },
          );
        },
      ),
    ),
        ),
      )
    );
  }
}