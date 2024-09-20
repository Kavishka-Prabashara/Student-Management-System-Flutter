import 'package:flutter/material.dart';
import 'package:student_management_system/db/student_db.dart';
import 'package:student_management_system/model/student.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();

  List<Student> _students = [];

  @override
  void initState() {
    super.initState();
    _refreshStudents();
  }

  Future<void> _refreshStudents() async {
    final data = await StudentDatabase.instance.getStudents();
    setState(() {
      _students = data;
    });
  }

  void _addStudent() async {
    final name = _nameController.text;
    final age = int.tryParse(_ageController.text) ?? 0;

    if (name.isNotEmpty && age > 0) {
      final student = Student(name: name, age: age);
      await StudentDatabase.instance.createStudent(student);
      _refreshStudents();
      _nameController.clear();
      _ageController.clear();
    }
  }

  void _updateStudent(Student student) {
    _nameController.text = student.name;
    _ageController.text = student.age.toString();
    _showForm(student: student);
  }

  void _deleteStudent(int id) async {
    await StudentDatabase.instance.deleteStudent(id);
    _refreshStudents();
  }

  void _showForm({Student? student}) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: _ageController,
                  decoration: InputDecoration(labelText: 'Age'),
                  keyboardType: TextInputType.number,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (student == null) {
                      _addStudent();
                    } else {
                      StudentDatabase.instance.updateStudent(Student(
                        id: student.id,
                        name: _nameController.text,
                        age: int.parse(_ageController.text),
                      ));
                      _refreshStudents();
                    }
                    Navigator.pop(context);
                  },
                  child: Text(student == null ? 'Add Student' : 'Update Student'),
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student CRUD'),
      ),
      body: ListView.builder(
        itemCount: _students.length,
        itemBuilder: (context, index) {
          final student = _students[index];
          return ListTile(
            title: Text(student.name),
            subtitle: Text('Age: ${student.age}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _updateStudent(student),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteStudent(student.id!),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _showForm(),
      ),
    );
  }
}
