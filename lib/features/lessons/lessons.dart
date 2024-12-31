class Lessons {
  final String title;
  final List<Map<String, String>> notes;

  Lessons({required this.title, required this.notes});

  static List<Lessons> allLessons = [
    Lessons(
      title: 'Lesson 1: Basics',
      notes: [
        {'pitch': 'C4', 'duration': '1'},
        {'pitch': 'D4', 'duration': '1'},
        {'pitch': 'E4', 'duration': '1'},
      ],
    ),
    Lessons(
      title: 'Lesson 2: Scales',
      notes: [
        {'pitch': 'C4', 'duration': '1'},
        {'pitch': 'D4', 'duration': '1'},
        {'pitch': 'E4', 'duration': '1'},
        {'pitch': 'F4', 'duration': '1'},
        {'pitch': 'G4', 'duration': '1'},
      ],
    ),
  ];
}