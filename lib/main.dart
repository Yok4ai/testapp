// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'dart:math';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),

    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Color _backgroundColor = Color.fromARGB(255, 201, 143, 240);


  String _input = "";
  double _currentNumber = 0.0;
  String _selectedOperator = "";

  void _handleButtonPress(String buttonText) {
    if (buttonText == "C") {
      _input = "";
      _currentNumber = 0.0;
      _selectedOperator = "";
    } else if (buttonText == "=") {
      _calculateResult();
    } else if (buttonText == "+" ||
        buttonText == "-" ||
        buttonText == "*" ||
        buttonText == "/") {
      _selectedOperator = buttonText;
      _input += buttonText;
    } else {
      _input += buttonText;
      // Parse only when necessary (before operators and final result)
      if (_selectedOperator.isEmpty || buttonText == "=") {
        _currentNumber =
            double.parse(_input.trim()); // Trim leading/trailing whitespace
      }
    }
    setState(() {});
  }

void _calculateResult() {
  // Check if no operator is selected
  if (_selectedOperator.isEmpty) {
    // If no operator is selected, there's nothing to calculate
    return;
  }

  try {
    // Find the index of the operator in _input
    int operatorIndex = _input.indexOf(_selectedOperator);

    // Extract the second number from _input
    String secondNumberString = _input.substring(operatorIndex + _selectedOperator.length).trim();
    double secondNumber = double.parse(secondNumberString);

    // Perform the calculation based on the selected operator
    double result;
    if (_selectedOperator == "+") {
      result = _currentNumber + secondNumber;
    } else if (_selectedOperator == "-") {
      result = _currentNumber - secondNumber;
    } else if (_selectedOperator == "*") {
      result = _currentNumber * secondNumber;
    } else if (_selectedOperator == "/") {
      // Check for division by zero
      if (secondNumber == 0) {
        _input = "Error: Division by zero";
        return;
      }
      result = _currentNumber / secondNumber;
    } else {
      // Handle unknown operators
      _input = "Error: Unknown operator";
      return;
    }

    // Update _input with the result
    _input = result.toString();
    _currentNumber = result; // Update _currentNumber for potential further calculations
  } catch (e) {
    // If there's an error during the calculation or parsing, display an error message
    _input = "Error: Invalid input";
  } finally {
    // Reset the operator, as the calculation is complete
    _selectedOperator = "";
  }
}

void _changeBackgroundColor() {
  setState(() {
    // Generate a random even lighter color
    Color randomColor = Color.fromRGBO(
      Random().nextInt(200) + 50, // R value between 100 and 255
      Random().nextInt(200) + 50, // G value between 100 and 255
      Random().nextInt(200) + 50, // B value between 100 and 255
      1.0,
    );

    // Update the background color
    _backgroundColor = randomColor;
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _backgroundColor,
        title: Text("Calculator"),
      ),
      body: Container(
      color: _backgroundColor, // Set the background color to black
      child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(50),
                child: Text(
                  _input,
                  style: TextStyle(fontSize: 50.0),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildButton("7"),
                  _buildButton("8"),
                  _buildButton("9"),
                  _buildButton("*"),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildButton("4"),
                  _buildButton("5"),
                  _buildButton("6"),
                  _buildButton("/"),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildButton("1"),
                  _buildButton("2"),
                  _buildButton("3"),
                  _buildButton("-"),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildButton("."),
                  _buildButton("0"),
                  _buildButton("C"),
                  _buildButton("+"),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildButton("="),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildButton("Change Color", colorChange: true),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

Widget _buildButton(String buttonText, {bool colorChange = false}) {
  return Expanded(
    child: TextButton(
      onPressed: () {
        if (colorChange) {
          _changeBackgroundColor();
        } else {
          _handleButtonPress(buttonText);
        }
      },
      style: ElevatedButton.styleFrom(
        primary: Colors.grey[200],
        onPrimary: Colors.black,
      ),
      child: Text(buttonText),
    ),
  );
}
}
