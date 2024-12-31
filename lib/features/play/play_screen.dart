import 'package:flutter/material.dart';
import 'widgets/staff_painter.dart';

class PlayScreen extends StatefulWidget {
  @override
  _PlayScreenState createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  List<Map<String, String>> parsedNotes = [];
  double playbackProgress = 0.0;

  void startPlayback() {
    setState(() {
      playbackProgress = 1.0; // Move notes fully to the left
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Learn Notes')),
      body: Column(
        children: [
          StaffPainter(
            notes: parsedNotes,
            animate: true,
            noteSpacing: 50,
          ),
          ElevatedButton(
            onPressed: startPlayback,
            child: Text('Start Playback'),
          ),
        ],
      ),
    );
  }
}