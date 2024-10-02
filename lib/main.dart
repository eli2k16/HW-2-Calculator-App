import 'package:flutter/material.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator App',
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String display = '0';
  String operator = '';
  double firstOperand = 0;
  double secondOperand = 0;
  bool isResultDisplayed = false;

  void buttonPressed(String value) {
  setState(() {
    if (value == 'C') {
      // Reset everything
      display = '0';
      operator = '';
      firstOperand = 0;
      secondOperand = 0;
      isResultDisplayed = false;
    } else if (value == '+' || value == '-' || value == '*' || value == '/') {
      // If an operator is pressed
      if (operator.isEmpty && display != '0') {
        // Save the first operand and keep it on the display
        operator = value;
        firstOperand = double.parse(display);
        // Don't reset the display yet, just keep showing the first operand
      } else if (isResultDisplayed) {
        // If a result is displayed and an operator is pressed, continue using the result
        operator = value;
        firstOperand = double.parse(display); // Use result as first operand
        // No need to change the display here
      }
    } else if (value == '=') {
      // Perform calculation
      secondOperand = double.parse(display);
      double result;
      switch (operator) {
        case '+':
          result = firstOperand + secondOperand;
          break;
        case '-':
          result = firstOperand - secondOperand;
          break;
        case '*':
          result = firstOperand * secondOperand;
          break;
        case '/':
          result = secondOperand != 0 ? firstOperand / secondOperand : double.infinity;
          break;
        default:
          result = 0;
      }
      display = result.toString();
      operator = '';
      firstOperand = 0;
      isResultDisplayed = true; // Indicate that a result has been displayed
    } else {
      // Handling number and decimal inputs
      if (isResultDisplayed) {
        // If a result was displayed, clear the display when typing a new number
        display = value == '.' ? '0.' : value;
        isResultDisplayed = false; // Reset flag after entering new input
      } else if (operator.isNotEmpty) {
        // When entering the second operand after the operator is pressed
        display = value == '.' ? '0.' : value; // Replace with the new operand
      } else {
        // Normal input handling (appending numbers/decimal)
        if (display == '0' && value != '.') {
          display = value; // Replace display if it's 0
        } else {
          display += value; // Append the new digit or decimal
        }
      }
    }
  });
}


  Widget _buildButtonRow(List<String> buttons) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttons.map((String button) {
        return ElevatedButton(
          onPressed: () => buttonPressed(button),
          child: Text(
            button,
            style: TextStyle(fontSize: 24),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF758BA2), // Background color
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            alignment: Alignment.centerRight,
            child: Text(
              display,
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
          ),
          Column(
            children: [
              _buildButtonRow(['7', '8', '9', '/']),
              _buildButtonRow(['4', '5', '6', '*']),
              _buildButtonRow(['1', '2', '3', '-']),
              _buildButtonRow(['0', '.', '=', '+']),
              _buildButtonRow(['C']), // Adding the decimal button
            ],
          ),
        ],
      ),
    );
  }
}
