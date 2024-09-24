import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'model/student.dart';

class EditStudentScreen extends StatefulWidget {
  final Student student;
  final Function(Student) onStudentUpdated; // Callback for updated student

  const EditStudentScreen(
      {super.key, required this.student, required this.onStudentUpdated});

  @override
  State<EditStudentScreen> createState() => _EditStudentScreenState();
}

class _EditStudentScreenState extends State<EditStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _courseController;
  String? _year;
  late bool _enrolled;

  @override
  void initState() {
    super.initState();
    _firstNameController =
        TextEditingController(text: widget.student.firstName);
    _lastNameController = TextEditingController(text: widget.student.lastName);
    _courseController = TextEditingController(text: widget.student.course);
    _year = widget.student.year;
    _enrolled = widget.student.enrolled;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _courseController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final Student updatedStudent = Student(
        id: widget.student.id,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        course: _courseController.text,
        year: _year!,
        enrolled: _enrolled,
      );

      try {
        // Send Put request para i update and student
        final response = await http.put(
          Uri.parse('http://127.0.0.1:8000/api/students/${widget.student.id}'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(updatedStudent.toJson()),
        );

        if (!mounted) return;

        if (response.statusCode == 200) {
          //Success sa pag update ng studentss
          widget.onStudentUpdated(updatedStudent);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('panu nangyari yun?')),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Failed to update student. Error: ${response.statusCode}'),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('bkt kasi ayaw mag update ******')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Student'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'First Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter first name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Last Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter last name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _courseController,
                decoration: const InputDecoration(labelText: 'Course'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter course';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Year'),
                value: _year,
                items: const [
                  DropdownMenuItem(
                      value: 'First Year', child: Text('First Year')),
                  DropdownMenuItem(
                      value: 'Second Year', child: Text('Second Year')),
                  DropdownMenuItem(
                      value: 'Third Year', child: Text('Third Year')),
                  DropdownMenuItem(
                      value: 'Fourth Year', child: Text('Fourth Year')),
                  DropdownMenuItem(
                      value: 'Fifth Year', child: Text('Fifth Year')),
                ],
                onChanged: (value) {
                  setState(() {
                    _year = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a year';
                  }
                  return null;
                },
              ),
              CheckboxListTile(
                title: const Text('Enrolled'),
                value: _enrolled,
                onChanged: (value) {
                  setState(() {
                    _enrolled = value ?? false;
                  });
                },
              ),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Update Student'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
