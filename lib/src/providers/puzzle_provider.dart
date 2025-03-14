import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/puzzle_piece.dart';

class PuzzleProvider extends ChangeNotifier {
  late List<PuzzlePiece> _pieces;
  int _moves = 0;
  int _gridSize = 3; // 3x3 grid by default
  bool _isComplete = false;
  Duration _time = Duration.zero;

  List<PuzzlePiece> get pieces => _pieces;
  int get moves => _moves;
  int get gridSize => _gridSize;
  bool get isComplete => _isComplete;
  Duration get time => _time;

  void initializePuzzle([int size = 3]) {
    _gridSize = size;
    _moves = 0;
    _time = Duration.zero;
    _isComplete = false;
    
    // Create pieces
    _pieces = List.generate(
      size * size,
      (index) => PuzzlePiece(
        id: index,
        correctPosition: index,
        currentPosition: index,
        isBlank: index == (size * size - 1),
      ),
    );

    // Shuffle pieces
    shufflePieces();
    notifyListeners();
  }

  void shufflePieces() {
    final random = Random();
    for (int i = _pieces.length - 1; i > 0; i--) {
      int j = random.nextInt(i + 1);
      // Swap current positions
      int temp = _pieces[i].currentPosition;
      _pieces[i].currentPosition = _pieces[j].currentPosition;
      _pieces[j].currentPosition = temp;
      // Swap pieces in list
      var tempPiece = _pieces[i];
      _pieces[i] = _pieces[j];
      _pieces[j] = tempPiece;
    }
  }

  bool canMovePiece(int position) {
    int blankIndex = _pieces.indexWhere((piece) => piece.isBlank);
    int blankRow = blankIndex ~/ _gridSize;
    int blankCol = blankIndex % _gridSize;
    int pieceRow = position ~/ _gridSize;
    int pieceCol = position % _gridSize;

    return (blankRow == pieceRow && (blankCol - pieceCol).abs() == 1) ||
           (blankCol == pieceCol && (blankRow - pieceRow).abs() == 1);
  }

  void movePiece(int position) {
    if (!canMovePiece(position)) return;

    int blankIndex = _pieces.indexWhere((piece) => piece.isBlank);
    int pieceIndex = _pieces.indexWhere((piece) => piece.currentPosition == position);

    // Swap positions
    int tempPosition = _pieces[blankIndex].currentPosition;
    _pieces[blankIndex].currentPosition = _pieces[pieceIndex].currentPosition;
    _pieces[pieceIndex].currentPosition = tempPosition;

    // Increment moves
    _moves++;

    // Check if puzzle is complete
    _isComplete = _pieces.every((piece) => piece.isInCorrectPosition);

    notifyListeners();
  }

  void updateTime(Duration newTime) {
    _time = newTime;
    notifyListeners();
  }
}
