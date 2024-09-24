import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'create.dart';
import 'model/student.dart';
import 'package:provider/provider.dart';
import 'delete.dart';
import 'edit.dart';
import 'student_notifier.dart';

class ReadScreen extends StatefulWidget {
  const ReadScreen({super.key});

  @override
  State<ReadScreen> createState() => _ReadScreenState();
}

class _ReadScreenState extends State<ReadScreen> {
  late StudentNotifier studentNotifier;

  @override
  void initState() {
    super.initState();
    studentNotifier = StudentNotifier();
    fetchStudents(); // Fetch nya yung mga list sa database
  }

  Future<void> fetchStudents() async {
    final response = await http
        .get(Uri.parse('http://10.0.2.2:8000/api/students')); // GET request

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      // Convert JSON to Student objects and update notifier
      studentNotifier.setStudents(
          jsonResponse.map((data) => Student.fromJson(data)).toList());
    } else {
      throw Exception('Failed to load students');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<StudentNotifier>(
      create: (_) => studentNotifier,
      child: Consumer<StudentNotifier>(
        builder: (context, notifier, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Students'),
            ),
            body: Center(
              child: notifier.students.isEmpty
                  ? const Text('No students available.')
                  : ListView.builder(
                      itemCount: notifier.students.length,
                      itemBuilder: (context, index) {
                        final student = notifier.students[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          child: ListTile(
                            title: Text(
                                '${student.firstName} ${student.lastName}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Course: ${student.course}'),
                                Text('Year: ${student.year}'),
                                Text(
                                    'Enrolled: ${student.enrolled ? "Yes" : "No"}'),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Navigate sa edit
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditStudentScreen(
                                          student: student,
                                          onStudentUpdated: (updatedStudent) {
                                            studentNotifier
                                                .updateStudent(updatedStudent);
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                // Delete the Student
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('Confirm Delete'),
                                          content: const Text(
                                              'Are you sure you want to delete this student?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                if (student.id != null) {
                                                  deleteStudent(
                                                    context,
                                                    student.id!,
                                                    notifier.deleteStudent,
                                                  );
                                                }
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Delete'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateStudentScreen(
                      onStudentCreated: (newStudent) {
                        studentNotifier.addStudent(newStudent);
                      },
                    ),
                  ),
                );
              },
              child: const Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }
}
