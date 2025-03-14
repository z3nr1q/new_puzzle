import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/puzzle_piece.dart';
import '../providers/puzzle_provider.dart';

class PuzzlePieceWidget extends StatelessWidget {
  final PuzzlePiece piece;

  const PuzzlePieceWidget({
    super.key,
    required this.piece,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<PuzzleProvider>(
      builder: (context, puzzleProvider, child) {
        if (piece.isBlank) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
          );
        }

        return GestureDetector(
          onTap: () {
            puzzleProvider.movePiece(piece.currentPosition);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: piece.isInCorrectPosition
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                '${piece.id + 1}',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
              ),
            ),
          ),
        );
      },
    );
  }
}
