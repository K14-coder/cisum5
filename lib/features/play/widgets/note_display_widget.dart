import 'package:flutter/material.dart';

class NoteDisplayWidget extends StatelessWidget {
  final List<Map<String, String>> notes; // List of notes with pitch and duration

  const NoteDisplayWidget({required this.notes, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, // Allow horizontal scrolling for the staff
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: notes.map((note) {
          return Container(
            margin: EdgeInsets.all(8),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3), // Shadow position
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Pitch: ${note['pitch']}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  'Duration: ${note['duration']}',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}