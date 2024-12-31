import 'package:flutter/material.dart';

class StaffPainter extends CustomPainter {
  final List<Map<String, String>> notes; // List of notes with pitch and duration
  final double noteSpacing; // Spacing between notes

  StaffPainter({required this.notes, this.noteSpacing = 50});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1.5;

    // Draw the staff lines (5 lines for treble clef)
    const double lineHeight = 20;
    const double topMargin = 50;
    final double staffHeight = 4 * lineHeight; // Height of the staff
    for (int i = 0; i < 5; i++) {
      double y = topMargin + (i * lineHeight);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Draw the clef symbol (treble clef for now, as a placeholder)
    _drawTrebleClef(canvas, topMargin, lineHeight);

    // Draw the time signature (4/4)
    _drawTimeSignature(canvas, topMargin, lineHeight);

    // Draw notes grouped into measures
    double xOffset = 80; // Leave space for clef and time signature
    for (int i = 0; i < notes.length; i++) {
      final pitch = notes[i]['pitch'] ?? 'C4';
      final duration = notes[i]['duration'] ?? '1';

      // Map pitch to vertical position
      double yOffset = _getNoteYOffset(pitch, topMargin, staffHeight, lineHeight);

      // Draw the note
      canvas.drawCircle(Offset(xOffset, yOffset), 8, paint);

      // Increment xOffset for the next note
      xOffset += noteSpacing;

      // Draw a barline after every 4 notes (measure)
      if ((i + 1) % 4 == 0 && i != notes.length - 1) {
        _drawBarline(canvas, xOffset - (noteSpacing / 2), topMargin, staffHeight);
      }
    }
  }

  void _drawTrebleClef(Canvas canvas, double topMargin, double lineHeight) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Draw a placeholder treble clef symbol
    canvas.drawOval(Rect.fromLTWH(20, topMargin + lineHeight, 30, lineHeight * 2), paint);
  }

  void _drawTimeSignature(Canvas canvas, double topMargin, double lineHeight) {
    final textStyle = TextStyle(color: Colors.black, fontSize: 18);
    final textPainter = TextPainter(
      text: TextSpan(text: '4/4', style: textStyle),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(60, topMargin + lineHeight));
  }

  void _drawBarline(Canvas canvas, double x, double topMargin, double staffHeight) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1.5;

    // Draw the barline from the top to the bottom of the staff
    canvas.drawLine(Offset(x, topMargin), Offset(x, topMargin + staffHeight), paint);
  }

  double _getNoteYOffset(
      String pitch, double topMargin, double staffHeight, double lineHeight) {
    // Map MIDI pitches to vertical positions on the staff
    const midiBase = 21; // MIDI value for A0
    const midiTop = 108; // MIDI value for C8
    const noteRange = midiTop - midiBase; // Total number of notes covered

    // Map pitch (e.g., C4, D4) to MIDI value
    final midiValue = _pitchToMidi(pitch);
    if (midiValue == null) return topMargin + staffHeight; // Default position if unknown

    // Calculate position based on MIDI value
    final positionRatio = (midiValue - midiBase) / noteRange;
    return topMargin + staffHeight - (positionRatio * staffHeight);
  }

  int? _pitchToMidi(String pitch) {
    // Parse pitch and map it to a MIDI value
    final regex = RegExp(r'([A-G])(#|b)?(\d)');
    final match = regex.firstMatch(pitch);
    if (match == null) return null;

    final note = match.group(1)!;
    final accidental = match.group(2) ?? '';
    final octave = int.tryParse(match.group(3) ?? '') ?? 4;

    // MIDI mapping for natural notes
    const midiMapping = {
      'C': 0,
      'D': 2,
      'E': 4,
      'F': 5,
      'G': 7,
      'A': 9,
      'B': 11,
    };

    // Calculate MIDI value
    int baseMidi = midiMapping[note]! + (octave + 1) * 12;
    if (accidental == '#') baseMidi += 1; // Sharp
    if (accidental == 'b') baseMidi -= 1; // Flat
    return baseMidi;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}