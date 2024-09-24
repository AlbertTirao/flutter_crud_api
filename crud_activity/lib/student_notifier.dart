import 'package:flutter/foundation.dart';
import 'model/student.dart';

class StudentNotifier extends ChangeNotifier {
  List<Student> _students = [];

  List<Student> get students => _students;

  // Method to set the list of students
  void setStudents(List<Student> students) {
    _students = students;
    notifyListeners();
  }

  // Method to add a new student
  void addStudent(Student student) {
    _students.add(student);
    notifyListeners();
  }

  // Method to update an existing student
  void updateStudent(Student updatedStudent) {
    final index =
        _students.indexWhere((student) => student.id == updatedStudent.id);
    if (index != -1) {
      _students[index] = updatedStudent;
      notifyListeners();
    }
  }

  // Method to delete a student
  void deleteStudent(int studentId) {
    _students.removeWhere((student) => student.id == studentId);
    notifyListeners();
  }
}
