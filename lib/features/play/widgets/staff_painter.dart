import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StaffPainter extends StatelessWidget {
  final List<Map<String, String>> notes; // List of notes with pitch and duration
  final double noteSpacing;
  final bool animate;

  StaffPainter({
    required this.notes,
    this.noteSpacing = 50,
    this.animate = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Staff Lines
        CustomPaint(
          size: Size(1000, 200),
          painter: _StaffLinesPainter(),
        ),
        // Clef and Time Signature
        Positioned(
          left: 10,
          top: 20,
          child: SvgPicture.asset(
            'assets/clef.svg', // Replace with an SVG file for the treble clef
            height: 80,
          ),
        ),
        Positioned(
          left: 60,
          top: 30,
          child: Text(
            '4/4',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        // Notes
        Positioned.fill(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: notes.map((note) {
                final position = _calculateNotePosition(note['pitch'] ?? 'C4');
                return Container(
                  width: noteSpacing,
                  child: Stack(
                    children: [
                      Positioned(
                        top: position,
                        child: SvgPicture.asset(
                          'assets/note.svg', // Replace with a notehead SVG
                          height: 30,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  double _calculateNotePosition(String pitch) {
    // Map pitch to staff position
    const midiMapping = {
      'C4': 100.0, // Example positions for each pitch
      'D4': 90.0,
      'E4': 80.0,
      'F4': 70.0,
      'G4': 60.0,
      'A4': 50.0,
      'B4': 40.0,
    };
    return midiMapping[pitch] ?? 100.0;
  }
}

class _StaffLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1.5;

    // Draw the staff lines (5 lines)
    const double lineHeight = 20;
    const double topMargin = 50;
    for (int i = 0; i < 5; i++) {
      final y = topMargin + (i * lineHeight);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}