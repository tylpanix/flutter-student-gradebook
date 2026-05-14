import 'package:flutter/material.dart';
import '../models/subject.dart';
import '../models/grade.dart';
import '../models/grade_type.dart';

class SubjectDetailsScreen extends StatefulWidget {
  final Subject subject;

  const SubjectDetailsScreen({super.key, required this.subject});

  @override
  State<SubjectDetailsScreen> createState() => _SubjectDetailsScreenState();
}

class _SubjectDetailsScreenState extends State<SubjectDetailsScreen> {
  final _scoreController = TextEditingController();
  final _descriptionController = TextEditingController();
  GradeType _selectedType = GradeType.exam;

  void _showAddGradeDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Add Grade to ${widget.subject.name}'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _scoreController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Grade (0-100)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<GradeType>(
                    value: _selectedType,
                    decoration: const InputDecoration(labelText: 'Type'),
                    items: GradeType.values.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type.name),
                      );
                    }).toList(),
                    onChanged: (value) =>
                        setDialogState(() => _selectedType = value!),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(onPressed: _addGrade, child: const Text('Add')),
              ],
            );
          },
        );
      },
    );
  }

  void _addGrade() {
    final scoreText = _scoreController.text.trim();
    final description = _descriptionController.text.trim();

    if (scoreText.isEmpty || description.isEmpty) return;

    final score = double.tryParse(scoreText);
    if (score == null || score < 0 || score > 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Grade must be between 0 and 100')),
      );
      return;
    }

    setState(() {
      final newGrade = Grade(
        id: DateTime.now().millisecondsSinceEpoch,
        score: score,
        type: _selectedType,
        description: description,
        date: DateTime.now(),
      );
      widget.subject.addGrade(newGrade);
      _scoreController.clear();
      _descriptionController.clear();
    });

    Navigator.pop(context);
  }

  void _deleteGrade(int id) {
    setState(() {
      widget.subject.removeGrade(id);
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Grade deleted')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.subject.name)),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            color: Colors.blue.shade50,
            child: Column(
              children: [
                Text(widget.subject.icon, style: const TextStyle(fontSize: 48)),
                Text(
                  'Average: ${widget.subject.average.toStringAsFixed(1)}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return Icon(
                      index < widget.subject.stars
                          ? Icons.star
                          : Icons.star_border,
                      color: Colors.amber,
                    );
                  }),
                ),
                Text(
                  widget.subject.status,
                  style: const TextStyle(fontSize: 18),
                ),
                Text(
                  '${widget.subject.grades.length} grades',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'All Grades',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.subject.grades.length,
              itemBuilder: (context, index) {
                final grade = widget.subject.grades[index];
                return Dismissible(
                  key: Key(grade.id.toString()),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) => _deleteGrade(grade.id),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    child: ListTile(
                      leading: Icon(grade.type.icon, color: Colors.blue),
                      title: Text(grade.description),
                      subtitle: Text(grade.formattedDate),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            grade.scoreText,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            grade.status,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddGradeDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _scoreController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
