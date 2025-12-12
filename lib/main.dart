import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(SadikCalculator());
}

class SadikCalculator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Sadik Calculator",
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blueAccent,
      ),
      home: CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String input = "";
  String output = "";

  void buttonPressed(String value) {
    setState(() {
      if (value == "C") {
        input = "";
        output = "";
      } else if (value == "⌫") {
        if (input.isNotEmpty) {
          input = input.substring(0, input.length - 1);
        }
      } else if (value == "=") {
        try {
          Parser p = Parser();
          Expression exp = p.parse(input.replaceAll('×', '*').replaceAll('÷', '/'));
          ContextModel cm = ContextModel();
          double result = exp.evaluate(EvaluationType.REAL, cm);
          output = result.toString();
        } catch (e) {
          output = "Error";
        }
      } else {
        input += value;
      }
    });
  }

  Widget buildButton(String text,
      {Color color = const Color(0xff1e1e1e), bool isEqual = false}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () => buttonPressed(text),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 22),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: isEqual ? Colors.blueAccent : color,
          ),
          child: Text(
            text,
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sadik Calculator"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              alignment: Alignment.bottomRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    input,
                    style: TextStyle(fontSize: 32, color: Colors.white70),
                  ),
                  SizedBox(height: 10),
                  Text(
                    output,
                    style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),

          // Buttons
          Column(
            children: [
              Row(
                children: [
                  buildButton("C", color: Colors.redAccent),
                  buildButton("⌫", color: Colors.orange),
                  buildButton("÷", color: Colors.blueGrey),
                  buildButton("×", color: Colors.blueGrey),
                ],
              ),
              Row(
                children: [
                  buildButton("7"),
                  buildButton("8"),
                  buildButton("9"),
                  buildButton("-", color: Colors.blueGrey),
                ],
              ),
              Row(
                children: [
                  buildButton("4"),
                  buildButton("5"),
                  buildButton("6"),
                  buildButton("+", color: Colors.blueGrey),
                ],
              ),
              Row(
                children: [
                  buildButton("1"),
                  buildButton("2"),
                  buildButton("3"),
                  buildButton("=", isEqual: true),
                ],
              ),
              Row(
                children: [
                  buildButton("0"),
                  buildButton("."),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
