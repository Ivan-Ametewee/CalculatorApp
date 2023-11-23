import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
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
        catch(e){
          displayedText = 'Error';
        }
      }
      else{
        if(displayedText == ''){
          displayedText = text;
        }
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
      backgroundColor: Colors.white10,
      appBar: AppBar(
          backgroundColor: Colors.white10,
        title: const Text(
          'Calculator',
            selectionColor: Colors.lightGreen,
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
                  color: Colors.lightGreen,
                ),
              ),
            ),
            // Calculator Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                    } else {
                      displayedText = displayedText.substring(0, displayedText.length - 1);
                    }
                  });
                }),
              ],
            ),
            // Add more rows of buttons as needed
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                buildButton('7'),
                buildButton('8'),
                buildButton('9'),
                buildButton('+'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                buildButton('4'),
                buildButton('5'),
                buildButton('6'),
                buildButton('-'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                buildButton('1'),
                buildButton('2'),
                buildButton('3'),
                buildButton('×'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
      child: SizedBox(
        width: 80.0,
        height: 80.0,
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 40.0,
              color: Colors.lightGreen,
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
    child: SizedBox(
      width: 80.0,
      height: 80.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            icon,
            size: 30.0,
            color: Colors.lightGreen,
          ),
        ],
      ),
    ),
  );
}