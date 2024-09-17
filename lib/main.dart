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
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: const CalculatorScreen(),
    );
  }
}

// Light Theme Definition
  ThemeData lightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.blue,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        color: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: Colors.black, fontSize: 18),
        bodySmall: TextStyle(color: Colors.black, fontSize: 16),
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: Colors.blueAccent,
        textTheme: ButtonTextTheme.primary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent, // Background color
          textStyle: const TextStyle(color: Colors.white), // Text color
        ),
      ),
    );
  }
// Dark Theme Definition
  ThemeData darkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.black,
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: const AppBarTheme(
        color: Colors.teal,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: Colors.white, fontSize: 18),
        bodySmall: TextStyle(color: Colors.white70, fontSize: 16),
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: Colors.tealAccent,
        textTheme: ButtonTextTheme.primary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.tealAccent, // Background color
          textStyle: const TextStyle(color: Colors.black,) // Text color
        ),
      ),
    );
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
    if (text == '=') {
      // Add implicit multiplication for cases like '2(9)' by replacing it with '2*(9)'
      expression = displayedText.replaceAll('×', '*');
      expression = addImplicitMultiplication(expression);
      
      try {
        Parser p = Parser();
        Expression exp = p.parse(expression);

        ContextModel cm = ContextModel();
        double result = exp.evaluate(EvaluationType.REAL, cm);

        if (result % 1 == 0) {
          displayedText = '${result.toInt()}';
        } else {
          displayedText = '$result';
        }
      } catch (e) {
        setState(() {
          displayedText = 'Error';
        });

        Timer(const Duration(milliseconds: 1000), () {
          setState(() {
            displayedText = '';
          });
        });
      }

    } else {
      if (displayedText == '') {
        displayedText = text;
      } else {
        displayedText = displayedText + text;
      }
    }
  });
}

// Helper function to insert the '*' for implicit multiplication
String addImplicitMultiplication(String expression) {
  // Insert '*' between number and '(' (e.g., '2(9)' -> '2*(9)')
  return expression.replaceAllMapped(
    RegExp(r'(\d)(\()'),  // Look for number followed by opening parenthesis
    (Match m) => '${m[1]}*${m[2]}',  // Insert '*' between the number and '('
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          
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
                style: TextStyle(
                  fontSize: 50.0,
                  color: Theme.of(context).textTheme.bodyMedium?.color, // Dynamic text color
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
          color: Theme.of(context).buttonTheme.colorScheme?.surface ?? Colors.grey,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.2), // Theme-based shadow color
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(2, 2), // changes position of shadow
            ),
          ],
          border: Border.all(
           //color: Colors.white,
            color: Theme.of(context).dividerColor, // Theme-based border color
            width: 1.0,
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 40.0,
              color: Theme.of(context).textTheme.bodyMedium?.color, // Dynamic text color
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
          color: const Color.fromARGB(50, 0, 0, 0).withOpacity(0.2),
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