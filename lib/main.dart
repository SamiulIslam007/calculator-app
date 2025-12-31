import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(SamiulCalculator());
}

class SamiulCalculator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Samiul Calculator",
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Color(0xFF1C1C1C),
        primaryColor: Color(0xFF4E9FFF),
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
  List<String> history = [];

  void buttonPressed(String value) {
    setState(() {
      if (value == "AC") {
        input = "";
        output = "";
      } else if (value == "⌫") {
        if (input.isNotEmpty) {
          input = input.substring(0, input.length - 1);
          output = "";
        }
      } else if (value == "=") {
        if (input.isEmpty) return;
        try {
          Parser p = Parser();
          String processedInput = input
              .replaceAll('×', '*')
              .replaceAll('÷', '/')
              .replaceAll('%', '/100');
          Expression exp = p.parse(processedInput);
          ContextModel cm = ContextModel();
          double result = exp.evaluate(EvaluationType.REAL, cm);
          
          // Format result to remove unnecessary decimals
          output = result % 1 == 0 
              ? result.toInt().toString() 
              : result.toStringAsFixed(8).replaceAll(RegExp(r'0*$'), '').replaceAll(RegExp(r'\.$'), '');
          
          // Add to history
          history.insert(0, "$input = $output");
          if (history.length > 10) history.removeLast();
        } catch (e) {
          output = "Error";
        }
      } else if (value == "±") {
        if (input.isNotEmpty) {
          if (input.startsWith('-')) {
            input = input.substring(1);
          } else {
            input = '-$input';
          }
        }
      } else if (value == "%") {
        input += value;
      } else {
        // Prevent multiple operators in a row
        if (input.isNotEmpty && 
            RegExp(r'[+\-×÷]$').hasMatch(input) && 
            RegExp(r'[+\-×÷]').hasMatch(value)) {
          input = input.substring(0, input.length - 1);
        }
        input += value;
        output = "";
      }
    });
  }

  void showHistoryDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF2C2C2C),
          title: Text('History', style: TextStyle(color: Colors.white)),
          content: Container(
            width: double.maxFinite,
            child: history.isEmpty
                ? Text('No history yet', style: TextStyle(color: Colors.white70))
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: history.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          history[index],
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                        onTap: () {
                          String calculation = history[index].split(' = ')[0];
                          setState(() {
                            input = calculation;
                          });
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
          ),
          actions: [
            TextButton(
              child: Text('Clear', style: TextStyle(color: Colors.redAccent)),
              onPressed: () {
                setState(() {
                  history.clear();
                });
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('Close', style: TextStyle(color: Color(0xFF4E9FFF))),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  Widget buildButton(String text,
      {Color color = const Color(0xFF2C2C2C),
      Color textColor = Colors.white,
      bool isEqual = false,
      int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => buttonPressed(text),
            borderRadius: BorderRadius.circular(20),
            splashColor: Colors.white24,
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: isEqual ? Color(0xFF4E9FFF) : color,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: isEqual 
                        ? Color(0xFF4E9FFF).withOpacity(0.3)
                        : Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: text.length > 2 ? 20 : 28,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text("Samiul Calculator"),
      centerTitle: true,
      backgroundColor: const Color(0xFF2C2C2C),
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.history),
          onPressed: showHistoryDialog,
          tooltip: 'History',
        ),
      ],
    ),
    body: SafeArea(
      child: Column(
        children: [
          // Display area
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              alignment: Alignment.bottomRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    reverse: true,
                    child: Text(
                      input.isEmpty ? "0" : input,
                      style: const TextStyle(fontSize: 36, color: Colors.white70),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    reverse: true,
                    child: Text(
                      output,
                      style: const TextStyle(fontSize: 56, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Buttons area (scroll if needed => no overflow)
          Expanded(
            flex: 5,
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 8,
                right: 8,
                top: 8,
                bottom: 8 + MediaQuery.of(context).padding.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(children: [
                    buildButton("AC", color: const Color(0xFFFF5252)),
                    buildButton("±",
                        color: const Color(0xFF3A3A3A),
                        textColor: const Color(0xFF4E9FFF)),
                    buildButton("%",
                        color: const Color(0xFF3A3A3A),
                        textColor: const Color(0xFF4E9FFF)),
                    buildButton("÷", color: const Color(0xFF4E9FFF)),
                  ]),
                  Row(children: [
                    buildButton("7"),
                    buildButton("8"),
                    buildButton("9"),
                    buildButton("×", color: const Color(0xFF4E9FFF)),
                  ]),
                  Row(children: [
                    buildButton("4"),
                    buildButton("5"),
                    buildButton("6"),
                    buildButton("-", color: const Color(0xFF4E9FFF)),
                  ]),
                  Row(children: [
                    buildButton("1"),
                    buildButton("2"),
                    buildButton("3"),
                    buildButton("+", color: const Color(0xFF4E9FFF)),
                  ]),
                  Row(children: [
                    buildButton("0", flex: 2),
                    buildButton("."),
                    buildButton("⌫", color: const Color(0xFFFF9800)),
                  ]),
                  Row(children: [
                    buildButton("=", isEqual: true, flex: 4),
                  ]),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

}
