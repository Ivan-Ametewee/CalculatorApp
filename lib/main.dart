import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});
  @override
  CalculatorScreenState createState() => CalculatorScreenState();
}

class CalculatorScreenState extends State<CalculatorScreen> {
  String equation = '';
  //double result = 0.0;
  String expression = '';
  double equationFontSize = 20.0;
  double resultFontSize = 40.0;

  String displayedText = '';


  void handleButtonPress(String text) {
    setState(() {
      if(text == '='){
        expression = displayedText.replaceAll('×', '*');
        try {
          Parser p = Parser();
          Expression exp = p.parse(expression);

          ContextModel cm = ContextModel();
          double result = exp.evaluate(EvaluationType.REAL, cm);

          if (result % 1 == 0) {
            displayedText = '${result.toInt()}';
          }
          else {
            displayedText = '$result';
          }
        }
        catch(e) {
          setState(() {
            displayedText = 'Error';
          });

          Timer(const Duration(milliseconds: 1000), () {
            setState(() {
              displayedText = '';
            });
          });
        }

      }
      else{
        if(displayedText == ''){
          displayedText = text;
        }
        /*else if(displayedText == 'Error'){

        }*/
        else{
          displayedText = displayedText + text;
        }
      }
  }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(200, 0, 0, 0),
      appBar: AppBar(
          backgroundColor: const Color.fromARGB(50, 0, 0, 0),
          
          title: const Text(
          'Calculator',
            style: TextStyle(
              color: Colors.white,
            ),
              ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            // Displayed Text
            Container(
              //color: Colors.blue[900],
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.bottomRight,
              child: Text(
                displayedText,
                style: const TextStyle(
                  fontSize: 50.0,
                  color: Colors.white,
                ),
              ),
            ),

            // Calculator Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                buildButtonWithIcon(Icons.cancel, (){
                  setState(() {
                    displayedText = '';
                  });
                }),
                buildButton('('),
                buildButton(')'),
                buildButtonWithIcon(Icons.backspace, (){
                  setState(() {
                    if (displayedText.isEmpty) {
                      displayedText = '';
                    } else if (displayedText.length == 1) {
                      displayedText = '';
                    } else if(displayedText == 'Error'){
                      displayedText = '';
                    }
                    else {
                      displayedText = displayedText.substring(0, displayedText.length - 1);
                    }
                  });
                }),
              ],
            ),
            // Add more rows of buttons as needed
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                buildButton('7'),
                buildButton('8'),
                buildButton('9'),
                buildButton('+'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                buildButton('4'),
                buildButton('5'),
                buildButton('6'),
                buildButton('-'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                buildButton('1'),
                buildButton('2'),
                buildButton('3'),
                buildButton('×'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                buildButton('0'),
                buildButton('.'),
                buildButton('/'),
                buildButton('='),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButton(String text) {
    return GestureDetector(
      onTap: () {
        handleButtonPress(text);
      },
      child: Container(
        width: 80.0,
        height: 80.0,
        decoration: BoxDecoration(
          color: const Color.fromARGB(50, 0, 0, 0),
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(50, 0, 0, 0).withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(2, 2), // changes position of shadow
            ),
          ],
          border: Border.all(
           //color: Colors.white,
            color: const Color.fromARGB(50, 0, 0, 0),
            width: 1.0,
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 40.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

Widget buildButtonWithIcon(IconData icon, VoidCallback onPressed) {
  return GestureDetector(
    onTap: onPressed,
    child: Container(
      width: 80.0,
      height: 80.0,
      decoration: BoxDecoration(
        color: const Color.fromARGB(50, 0, 0, 0),
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(50, 0, 0, 0).withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(2, 2), // changes position of shadow
            ),
          ],
          border: Border.all(
            color: const Color.fromARGB(50, 0, 0, 0),
            width: 1.0,
          ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            icon,
            size: 30.0,
            color: Colors.white,
          ),
        ],
      ),
    ),
  );
}