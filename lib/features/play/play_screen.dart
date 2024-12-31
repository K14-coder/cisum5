import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io'; // For file operations
import 'package:xml/xml.dart'; // For parsing MusicXML files
import 'package:archive/archive_io.dart'; // For handling .mxl files
import 'widgets/staff_painter.dart';

class PlayScreen extends StatefulWidget {
  @override
  _PlayScreenState createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  String? filePath; // To store the selected file path
  List<Map<String, String>> parsedNotes = []; // To store parsed notes

  // Function to pick and parse a MusicXML or MXL file
  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mxl', 'xml'], // Allow both .mxl and .xml files
    );

    if (result != null) {
      setState(() {
        filePath = result.files.single.path;
      });

      if (filePath != null) {
        try {
          if (filePath!.endsWith('.mxl')) {
            // Handle MXL file extraction
            String xmlContent = await extractMxlFile(filePath!);
            parseMusicXml(xmlContent);
          } else if (filePath!.endsWith('.xml')) {
            // Handle direct XML file
            String fileContent = await File(filePath!).readAsString();
            parseMusicXml(fileContent);
          } else {
            throw Exception('Unsupported file type');
          }
        } catch (e) {
          // Show error messages
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error reading file: $e")),
          );
        }
      }
    }
  }

  // Function to extract .mxl file and return its MusicXML content
  Future<String> extractMxlFile(String filePath) async {
    try {
      final file = File(filePath);
      final bytes = await file.readAsBytes();
      final archive = ZipDecoder().decodeBytes(bytes);

      // Look for the score.xml file inside the .mxl archive
      for (var file in archive) {
        if (file.name == 'score.xml') {
          final extractedContent = String.fromCharCodes(file.content as List<int>);
          debugPrint('Extracted score.xml Content:\n$extractedContent'); // Log the XML content
          return extractedContent;
        }
      }
      throw Exception('No score.xml file found inside .mxl');
    } catch (e) {
      throw Exception('Failed to extract .mxl file: $e');
    }
  }

  // Function to parse MusicXML content
  void parseMusicXml(String xmlContent) {
    try {
      debugPrint('Parsing XML Content:\n$xmlContent'); // Log the XML content being parsed
      final document = XmlDocument.parse(xmlContent); // Parse the XML
      final notes = document.findAllElements('note'); // Find all <note> elements

      // Extract pitch and duration from notes
      setState(() {
        parsedNotes = notes.map((note) {
          final pitchElement = note.findElements('pitch').isNotEmpty
              ? note.findElements('pitch').first
              : null;
          final durationElement = note.findElements('duration').isNotEmpty
              ? note.findElements('duration').first
              : null;

          final pitch = pitchElement != null ? pitchElement.text : 'C4';
          final duration =
          durationElement != null ? durationElement.text : '1';

          return {'pitch': pitch, 'duration': duration};
        }).toList();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("MusicXML Parsed Successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error parsing MusicXML: $e")),
      );
      debugPrint('Parsing Error: $e'); // Log parsing errors
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload and Play'), // AppBar title
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Add padding around the content
        child: Column(
          children: [
            // Button to select a file
            ElevatedButton(
              onPressed: pickFile,
              child: Text('Select MusicXML or MXL File'),
            ),
            SizedBox(height: 16), // Add some spacing
            // Display the selected file path
            filePath != null
                ? Text('Selected File: $filePath')
                : Text('No file selected'),
            SizedBox(height: 16), // Add some spacing
            // Display parsed MusicXML data
            Expanded(
              child: parsedNotes.isNotEmpty
                  ? CustomPaint(
                size: Size(1000, 200), // Define the size of the staff
                painter: StaffPainter(notes: parsedNotes),
              )
                  : Center(child: Text('MusicXML data will appear here')),
            ),
          ],
        ),
      ),
    );
  }
}