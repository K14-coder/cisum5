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

    // Draw notes on the staff
    final textStyle = TextStyle(color: Colors.black, fontSize: 16);
    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    double xOffset = 0;

    for (var note in notes) {
      final pitch = note['pitch'] ?? 'C4'; // Default pitch if missing
      final duration = note['duration'] ?? '1';

      // Map pitch to vertical position on the staff
      double yOffset = _getNoteYOffset(pitch, topMargin, staffHeight, lineHeight);

      // Draw the note as a filled circle
      canvas.drawCircle(Offset(xOffset + noteSpacing, yOffset), 8, paint);

      // Draw duration text below the note
      textPainter.text = TextSpan(
        text: duration,
        style: textStyle,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(xOffset + noteSpacing - textPainter.width / 2, yOffset + 20),
      );

      xOffset += noteSpacing; // Increment horizontal spacing for next note
    }
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