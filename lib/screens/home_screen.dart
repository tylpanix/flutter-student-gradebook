import 'package:flutter/material.dart';
import '../models/subject.dart';
import '../models/grade.dart';
import '../models/grade_type.dart';
import '../models/widgets/subject_card.dart';
import 'subject_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Subject> _subjects = [];

  @override
  void initState() {
    super.initState();
    _subjects.addAll([
      Subject(
        id: 1,
        name: 'Mathematics',
        icon: '📘',
        grades: [
          Grade(
            id: 1,
            score: 95,
            type: GradeType.exam,
            description: 'Midterm',
            date: DateTime.now(),
          ),
          Grade(
            id: 2,
            score: 90,
            type: GradeType.quiz,
            description: 'Quiz 5',
            date: DateTime.now(),
          ),
          Grade(
            id: 3,
            score: 88,
            type: GradeType.homework,
            description: 'Algebra',
            date: DateTime.now(),
          ),
        ],
      ),
      Subject(
        id: 2,
        name: 'Programming',
        icon: '💻',
        grades: [
          Grade(
            id: 4,
            score: 100,
            type: GradeType.project,
            description: 'Flutter App',
            date: DateTime.now(),
          ),
          Grade(
            id: 5,
            score: 92,
            type: GradeType.homework,
            description: 'Dart Basics',
            date: DateTime.now(),
          ),
        ],
      ),
      Subject(
        id: 3,
        name: 'Physics',
        icon: '📗',
        grades: [
          Grade(
            id: 6,
            score: 72,
            type: GradeType.exam,
            description: 'Mechanics',
            date: DateTime.now(),
          ),
          Grade(
            id: 7,
            score: 65,
            type: GradeType.quiz,
            description: 'Optics',
            date: DateTime.now(),
          ),
        ],
      ),
    ]);
  }

  double get _overallAverage {
    if (_subjects.isEmpty) return 0.0;
    final sum = _subjects.fold(0.0, (sum, s) => sum + s.average);
    return sum / _subjects.length;
  }

  Map<String, int> get _statistics {
    final stats = {'Excellent': 0, 'Good': 0, 'Satisfactory': 0, 'Poor': 0};
    for (final subject in _subjects) {
      for (final grade in subject.grades) {
        final status = grade.status;
        stats[status] = (stats[status] ?? 0) + 1;
      }
    }
    return stats;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Grades',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: Colors.blue.shade50,
            child: Column(
              children: [
                const Text('Overall Average', style: TextStyle(fontSize: 16)),
                Text(
                  _overallAverage.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return Icon(
                      index < (_overallAverage / 20).floor()
                          ? Icons.star
                          : Icons.star_border,
                      color: Colors.amber,
                    );
                  }),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  'Excellent',
                  _statistics['Excellent'] ?? 0,
                  Icons.sentiment_very_satisfied,
                  Colors.green,
                ),
                _buildStatItem(
                  'Good',
                  _statistics['Good'] ?? 0,
                  Icons.sentiment_satisfied,
                  Colors.blue,
                ),
                _buildStatItem(
                  'Satisfactory',
                  _statistics['Satisfactory'] ?? 0,
                  Icons.sentiment_neutral,
                  Colors.orange,
                ),
                _buildStatItem(
                  'Poor',
                  _statistics['Poor'] ?? 0,
                  Icons.sentiment_very_dissatisfied,
                  Colors.red,
                ),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Subjects',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: _subjects.length,
              itemBuilder: (context, index) {
                return SubjectCard(
                  subject: _subjects[index],
                  onTap: () => _navigateToSubjectDetails(_subjects[index]),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddSubjectDialog,
        backgroundColor: Colors.blue.shade700,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildStatItem(String label, int count, IconData icon, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        Text(
          '$count',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Icon(icon, color: color, size: 20),
      ],
    );
  }

  void _showAddSubjectDialog() {
    // Буде реалізовано пізніше
  }

  void _navigateToSubjectDetails(Subject subject) {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => SubjectDetailsScreen(subject: subject),
          ),
        )
        .then((_) {
          setState(() {});
        });
  }
}
