import 'dart:math';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  const TicTacToeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TicTacToeScreen(),
    );
  }
}

class TicTacToeScreen extends StatefulWidget {
  const TicTacToeScreen({super.key});

  get userModel => null;

  @override
  _TicTacToeScreenState createState() => _TicTacToeScreenState();
}

class _TicTacToeScreenState extends State<TicTacToeScreen> {
  List<String> board = List.filled(9, '');
  bool isPlayerTurn = true; // true for player, false for computer
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleTextStyle: const TextStyle(
          color: Color(0xFFFF9000),
          fontFamily: 'Poppins',
          fontStyle: FontStyle.italic,
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
        title: const Text('Tic Tac Toe'),
        backgroundColor: const Color(0xFF000000),
      ),
      body: _selectedIndex == 0 ? buildGameBody() : aboutPageBuild(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.gamepad),
            label: 'Game',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'About Pratyush',
          ),
        ],
      ),
    );
  }

  Widget buildGameBody() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF000000), Color(0xFF091e4f), Color(0xFF58a5e0), Color(0xFFffffff)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: SizedBox(
          width: 300,
          height: 300,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            itemCount: 9,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  if (board[index] == '' && isPlayerTurn) {
                    setState(() {
                      board[index] = 'X';
                      isPlayerTurn = false;
                      if (!checkGameOver()) {
                        computerMove();
                      }
                    });
                  }
                },
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      board[index],
                      style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget aboutPageBuild() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Hey Bugsmirror Team, \n'
                'As you can see, this is a minimalistic TicTacToe app wherein we can compete with the Computer.',
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          const Text(
            'Computer\'s moves are random as specified.',
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 100),

          const Text(
            'Made By Pratyush Chowdhury',
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),

          TextButton(
            onPressed: _sendEmail,
            child: const Text(
              'Personal Email: pratyushchowdhury27@gmail.com',
              style: TextStyle(fontSize: 18, color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }
  void _sendEmail(){
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'pratyushchowdhury27@gmail.com',
    );
    launchUrl(emailLaunchUri);
  }

  bool checkGameOver() {
    // Check rows
    for (int i = 0; i < 9; i += 3) {
      if (board[i] != '' && board[i] == board[i + 1] && board[i] == board[i + 2]) {
        showGameOverDialog(board[i]);
        return true;
      }
    }
    // Check columns
    for (int i = 0; i < 3; i++) {
      if (board[i] != '' && board[i] == board[i + 3] && board[i] == board[i + 6]) {
        showGameOverDialog(board[i]);
        return true;
      }
    }
    // Check diagonals
    if (board[0] != '' && board[0] == board[4] && board[0] == board[8]) {
      showGameOverDialog(board[0]);
      return true;
    }
    if (board[2] != '' && board[2] == board[4] && board[2] == board[6]) {
      showGameOverDialog(board[2]);
      return true;
    }
    // Check for draw
    if (!board.contains('')) {
      showGameOverDialog('Draw');
      return true;
    }
    return false;
  }

  void showGameOverDialog(String winner) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Game Over'),
          content: Text(winner == 'Draw' ? 'It\'s a draw!' : 'Winner: $winner'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                resetBoard();
                Navigator.of(context).pop();
              },
              child: const Text('Play Again'),
            ),
          ],
        );
      },
    );
  }

  void resetBoard() {
    setState(() {
      board = List.filled(9, '');
      isPlayerTurn = true;
    });
  }

  void computerMove() {
    // Simple random move for computer
    var emptyCells = [];
    for (int i = 0; i < board.length; i++) {
      if (board[i] == '') {
        emptyCells.add(i);
      }
    }
    var random = Random();
    var index = emptyCells[random.nextInt(emptyCells.length)];
    board[index] = 'O';
    isPlayerTurn = true;
    checkGameOver();
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
