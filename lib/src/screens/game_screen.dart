import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/puzzle_provider.dart';
import '../widgets/puzzle_board.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  Timer? _timer;
  int _seconds = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PuzzleProvider>().initializePuzzle();
      _startTimer();
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
        context.read<PuzzleProvider>().updateTime(Duration(seconds: _seconds));
      });
    });
  }

  void _resetGame() {
    setState(() {
      _seconds = 0;
      context.read<PuzzleProvider>().initializePuzzle();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Puzzle Game'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Consumer<PuzzleProvider>(
        builder: (context, puzzleProvider, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildInfoCard(
                      'Moves',
                      puzzleProvider.moves.toString(),
                      Icons.touch_app,
                    ),
                    _buildInfoCard(
                      'Time',
                      '${puzzleProvider.time.inMinutes}:${(puzzleProvider.time.inSeconds % 60).toString().padLeft(2, '0')}',
                      Icons.timer,
                    ),
                  ],
                ),
              ),
              const Expanded(
                child: Center(
                  child: PuzzleBoard(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton.icon(
                  onPressed: _resetGame,
                  icon: const Icon(Icons.refresh),
                  label: const Text('New Game'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Column(
          children: [
            Icon(icon),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
      ),
    );
  }
}
