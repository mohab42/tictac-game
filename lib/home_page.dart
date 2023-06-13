import 'package:flutter/material.dart';
import 'package:tic_tac_game/game_logic.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String activePlayer = 'X';
  int turns = 0;
  String res = '';
  Game game = Game();
  bool isSwitched = false;
  bool gameOver = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Center(
          child: MediaQuery.of(context).orientation == Orientation.portrait
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ...firstBlock(),
                    expanded(context),
                    ...lastBlock(),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ...firstBlock(),
                          ...lastBlock(),
                        ],
                      ),
                    ),
                    expanded(context)
                  ],
                ),
        ),
      ),
    );
  }

  Expanded expanded(BuildContext context) {
    return Expanded(
      child: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 3,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        childAspectRatio: 1.0,
        children: List.generate(
            9,
            (index) => InkWell(
                  onTap: gameOver ? null : () => _ontap(index),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).shadowColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Text(
                        Player.playerX.contains(index)
                            ? 'X'
                            : Player.playerO.contains(index)
                                ? 'O'
                                : '',
                        style: TextStyle(
                            color: Player.playerX.contains(index)
                                ? Colors.blue
                                : Colors.pink,
                            fontSize: 52),
                      ),
                    ),
                  ),
                )),
      ),
    );
  }

  lastBlock() {
    return [
      Text(
        res,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 40,
        ),
      ),
      ElevatedButton.icon(
        onPressed: () {
          setState(() {
            Player.playerX = [];
            Player.playerO = [];
            activePlayer = 'X';
            turns = 0;
            res = '';
            gameOver = false;
          });
        },
        icon: const Icon(Icons.replay),
        label: const Text('Replay The Game'),
      )
    ];
  }

  firstBlock() {
    return [
      SwitchListTile.adaptive(
        activeColor: Colors.amber,
        title: const Text(
          'Turn On/Off player mode',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
          ),
        ),
        value: isSwitched,
        onChanged: (bool newVal) {
          setState(() {
            isSwitched = newVal;
          });
        },
      ),
      Text(
        'it\'s $activePlayer Turn',
        style: const TextStyle(fontSize: 40, color: Colors.white),
      ),
    ];
  }

  _ontap(int index) async {
    if ((!Player.playerX.contains(index) || Player.playerX.isEmpty) &&
        (!Player.playerO.contains(index) || Player.playerO.isEmpty)) {
      game.playGame(index, activePlayer);
      updateState();

      if (isSwitched == false && gameOver == false && turns != 9) {
        await game.autoPlay(activePlayer);
        updateState();
      }
    }
  }

  void updateState() {
    setState(() {
      activePlayer = activePlayer == 'X' ? 'O' : 'X';
      turns++;
      String winnerPlayer = game.checkWinner();

      if (winnerPlayer != '') {
        gameOver == true;
        res = '$winnerPlayer is the winner';
      } else if (!gameOver && turns == 9) {
        res = 'It\'s Draw';
      }
    });
  }
}
