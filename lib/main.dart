import 'package:flutter/material.dart';
import 'dart:async'; // Add this line to import the dart:async package for Timer
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tic Tac Toe',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Poppins'
      ),
      home: const MyHomePage(title: 'Tic Tac Toe Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> _board = List.filled(9, '');
  bool _isXTurn = true;
  bool _gameOver = false;

  List<int> _getAvailableMoves() {
    List<int> moves = [];
    for (int i = 0; i < _board.length; i++) {
      if (_board[i] == '') {
        moves.add(i);
      }
    }
    return moves;
  }

  bool _checkWin(String player) {
    List<List<int>> winningCombinations = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (List<int> combination in winningCombinations) {
      if (_board[combination[0]] == player &&
          _board[combination[1]] == player &&
          _board[combination[2]] == player) {
        return true;
      }
    }
    return false;
  }

  void _handleTap(int index) {
    if (_gameOver || _board[index] != '') {
      return;
    }

    setState(() {
      _board[index] = _isXTurn ? 'X' : 'O';
      if (_checkWin(_board[index])) {
        _gameOver = true;
      } else if (_getAvailableMoves().isEmpty) {
        _gameOver = true;
      } else {
        _isXTurn = !_isXTurn;
      }

      if (!_gameOver && !_isXTurn) {
        Timer(const Duration(seconds: 1), () {
          _computerMove();
        });
      }
    });
  }

  void _computerMove() {
    List<int> availableMoves = _getAvailableMoves();
    int move = availableMoves[Random().nextInt(availableMoves.length)];
    _handleTap(move);
  }

  void _resetGame() {
    setState(() {
      _board = List.filled(9, '');
      _isXTurn = true;
      _gameOver = false;
    });
  }

  Widget _buildBoard() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
      ),
      itemCount: _board.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => _handleTap(index),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
            ),
            child: Center(
              child: Text(
                _board[index],
                style: const TextStyle(fontSize: 30.0),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildBoard(),
            const SizedBox(height: 20.0),
            if (_gameOver)
              Text(
                _checkWin('X')
                    ? 'Player X wins!'
                    : _checkWin('O')
                    ? 'Player O wins!'
                    : 'It\'s a draw!',
                style: const TextStyle(fontSize: 20.0),
              ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _resetGame,
              child: const Text('Reset Game'),
            ),
          ],
        ),
      ),
    );
  }
}
