<?php

namespace App\Http\Controllers;

use App\Models\Student;
use Illuminate\Http\Request;

class StudentController extends Controller
{
    // Display a listing of the students.
    public function index()
    {
        // Fetch all students from the database
        $students = Student::all();
        return response()->json($students); // Send students directly
    }

    // Store a newly created student in the database.
    public function store(Request $request)
    {
        // Validate the request data
        $request->validate([
            'firstName' => 'required|string|max:255',
            'lastName' => 'required|string|max:255',
            'course' => 'required|string|max:255',
            'year' => 'required|string|in:First Year,Second Year,Third Year,Fourth Year,Fifth Year',
            'enrolled' => 'required|boolean',
        ]);

        // Create a new student
        $student = Student::create($request->all());

        return response()->json($student, 201); // Return created student with status 201
    }

    // Display the specified student.
    public function show(Student $student)
    {
        return response()->json($student); // Return specific student
    }

    // Update the specified student in the database.
    public function update(Request $request, Student $student)
    {
        // Validate the request data
        $request->validate([
            'firstName' => 'required|string|max:255',
            'lastName' => 'required|string|max:255',
            'course' => 'required|string|max:255',
            'year' => 'required|string|in:First Year,Second Year,Third Year,Fourth Year,Fifth Year',
            'enrolled' => 'required|boolean',
        ]);

        // Update the student
        $student->update($request->all());

        return response()->json($student); // Return updated student
    }

    // Remove the specified student from the database.
    public function destroy($id)
    {
        $student = Student::find($id);
        $student->delete();
        return response()->json(null, 204); // Return 204 status code
    }
}
