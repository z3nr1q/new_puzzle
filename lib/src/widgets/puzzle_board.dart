import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/puzzle_provider.dart';
import '../models/puzzle_piece.dart';
import 'puzzle_piece_widget.dart';

class PuzzleBoard extends StatelessWidget {
  const PuzzleBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PuzzleProvider>(
      builder: (context, puzzleProvider, child) {
        final gridSize = puzzleProvider.gridSize;
        final pieces = puzzleProvider.pieces;
        
        // Organizar as peças por posição atual
        final orderedPieces = List<PuzzlePiece>.filled(pieces.length, pieces[0]);
        for (var piece in pieces) {
          orderedPieces[piece.currentPosition] = piece;
        }

        return AspectRatio(
          aspectRatio: 1,
          child: Container(
            margin: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Theme.of(context).colorScheme.primaryContainer,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: gridSize,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
              ),
              itemCount: orderedPieces.length,
              itemBuilder: (context, index) {
                final piece = orderedPieces[index];
                return PuzzlePieceWidget(piece: piece);
              },
            ),
          ),
        );
      },
    );
  }
}
