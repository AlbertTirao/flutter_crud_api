import 'package:flutter/foundation.dart';
import 'model/student.dart';

class StudentNotifier extends ChangeNotifier {
  List<Student> _students = []; // List to hold students

  List<Student> get students => _students; // Getter for students

  // Method to set the list of students
  void setStudents(List<Student> students) {
    _students = students; // Update the list
    notifyListeners(); // Notify listeners to update UI
  }

  // Method to add a new student
  void addStudent(Student student) {
    _students.add(student); // Add student to the list
    notifyListeners(); // Notify listeners to update UI
  }

  // Method to update an existing student
  void updateStudent(Student updatedStudent) {
    final index =
        _students.indexWhere((student) => student.id == updatedStudent.id);
    if (index != -1) {
      _students[index] = updatedStudent; // Update student in the list
      notifyListeners(); // Notify listeners to update UI
    }
  }

  // Method to delete a student
  void deleteStudent(int studentId) {
    _students.removeWhere(
        (student) => student.id == studentId); // Remove student from the list
    notifyListeners(); // Notify listeners to update UI
  }
}
