// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<void> deleteStudent(
    BuildContext context, int studentId, Function(int) deleteCallback) async {
  try {
    final response = await http.delete(
      Uri.parse(
          'http://127.0.0.1:8000/api/students/$studentId'), // DELETE request
    );

    if (response.statusCode == 200) {
      // If deleted successfully
      deleteCallback(studentId); // Call the delete callback
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('goodbye')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Failed to delete student. Error: ${response.statusCode}'),
        ),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('ok bkt ayaw mo mawala')),
    );
  }
}
