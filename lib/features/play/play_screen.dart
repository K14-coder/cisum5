import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:xml/xml.dart';

class PlayScreen extends StatefulWidget {
  @override
  _PlayScreenState createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  String? filePath;
  XmlDocument? musicXmlData;

  Future<void> pickFile() async {
    // Open File Picker to select a MusicXML file
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xml'],
    );

    if (result != null) {
      setState(() {
        filePath = result.files.single.path;
      });

      // Parse the MusicXML file
      if (filePath != null) {
        String fileContent = await FilePicker.platform.readFile(result.files.single.path!);
        parseMusicXml(fileContent);
      }
    }
  }

  void parseMusicXml(String xmlContent) {
    try {
      final document = XmlDocument.parse(xmlContent);
      setState(() {
        musicXmlData = document;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("MusicXML Parsed Successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error parsing MusicXML: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload and Play'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: pickFile,
              child: Text('Select MusicXML File'),
            ),
            SizedBox(height: 16),
            filePath != null
                ? Text('Selected File: $filePath')
                : Text('No file selected'),
            SizedBox(height: 16),
            Expanded(
              child: musicXmlData != null
                  ? ListView(
                children: musicXmlData!
                    .findAllElements('note')
                    .map((note) => ListTile(
                  title: Text(
                      'Pitch: ${note.findElements('pitch').single.text}'),
                  subtitle: Text(
                      'Duration: ${note.findElements('duration').single.text}'),
                ))
                    .toList(),
              )
                  : Center(child: Text('MusicXML data will appear here')),
            ),
          ],
        ),
      ),
    );
  }
}