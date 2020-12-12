import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);
  static const String title = 'Tic-Tac-Toe';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(title: title),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<int, Color> gameState;
  bool isGreenPlayer;

  /// 0 1 2
  /// 3 4 5
  /// 6 7 8
  List<List<int>> winningCombinations = <List<int>>[
    <int>[0, 1, 2],
    <int>[3, 4, 5],
    <int>[6, 7, 8],
    <int>[0, 3, 6],
    <int>[1, 4, 7],
    <int>[2, 5, 8],
    <int>[0, 4, 8],
    <int>[2, 4, 6]
  ];

  void setStateGame() {
    setState(() {
      gameState = <int, Color>{
        0: Colors.transparent,
        1: Colors.transparent,
        2: Colors.transparent,
        3: Colors.transparent,
        4: Colors.transparent,
        5: Colors.transparent,
        6: Colors.transparent,
        7: Colors.transparent,
        8: Colors.transparent
      };
    });
  }

  void initGame() {
    isGreenPlayer = true;
  }

  void resetGame() {
    setStateGame();
    initGame();
  }

  void playGame(int index) {
    if (gameState[index] == Colors.transparent) {
      setState(() {
        if (isGreenPlayer) {
          gameState[index] = Colors.green;
        } else {
          gameState[index] = Colors.yellow;
        }
        isGreenPlayer = !isGreenPlayer;
        checkWin();
      });
    }
  }

  void setWinningState(Color player, List<int> winningCombination) {
    setState(() {
      if (player == Colors.green) {
        gameState.forEach((int key, Color value) {
          if (value == Colors.yellow) {
            gameState[key] = Colors.transparent;
          }
          if (value == Colors.green && !winningCombination.contains(key)) {
            gameState[key] = Colors.transparent;
          }
        });
      } else {
        gameState.forEach((int key, Color value) {
          if (value == Colors.green) {
            gameState[key] = Colors.transparent;
          }
          if (value == Colors.yellow && !winningCombination.contains(key)) {
            gameState[key] = Colors.transparent;
          }
        });
      }
    });
  }

  void checkWin() {
    const Color green = Colors.green;
    const Color yellow = Colors.yellow;
    for (int i = 0; i < winningCombinations.length; i++) {
      final List<int> list = winningCombinations[i];
      if (gameState[list[0]] == green &&
          gameState[list[1]] == green &&
          gameState[list[2]] == green) {
        setWinningState(green, list);
      } else if (gameState[list[0]] == yellow &&
          gameState[list[1]] == yellow &&
          gameState[list[2]] == yellow) {
        setWinningState(yellow, list);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    setStateGame();
    initGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: 9,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
              ),
              itemBuilder: (BuildContext context, int index) {
                return Material(
                  child: Ink(
                    decoration: BoxDecoration(
                        color: gameState[index],
                        border: const Border.symmetric(
                          vertical: BorderSide(color: Colors.grey, width: 4.0),
                          horizontal:
                              BorderSide(color: Colors.grey, width: 4.0),
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8.0))),
                    child: InkWell(
                      splashColor: Colors.white,
                      onTap: () {
                        playGame(index);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          RaisedButton(
            onPressed: () {
              setState(() {
                resetGame();
              });
            },
            child: const Text('Play Again'),
          )
        ],
      ),
    );
  }
}
