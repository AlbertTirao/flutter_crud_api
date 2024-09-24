import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'model/student.dart';

class CreateStudentScreen extends StatefulWidget {
  final Function(Student) onStudentCreated; // Callback for created student

  const CreateStudentScreen({super.key, required this.onStudentCreated});

  @override
  State<CreateStudentScreen> createState() => _CreateStudentScreenState();
}

class _CreateStudentScreenState extends State<CreateStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _courseController = TextEditingController();
  String? _year;
  bool _enrolled = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _courseController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final Student newStudent = Student(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        course: _courseController.text,
        year: _year!,
        enrolled: _enrolled,
      );

      try {
        // Send Post Request para mag create ng data
        final response = await http.post(
          Uri.parse('http://127.0.0.1:8000/api/students'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(newStudent.toJson()),
        );

        if (!mounted) return;

        if (response.statusCode == 201) {
          //Success sa pag create
          final createdStudent = Student.fromJson(json.decode(response.body));
          widget.onStudentCreated(createdStudent);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('yay success')),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Failed to create student. Error: ${response.statusCode}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bkt ayaw mag create ahhhh')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Student')),
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
                child: const Text('Create Student'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
