class Student {
  final int? id;
  final String name;
  final int age;

  Student({this.id, required this.name, required this.age});

  // Convert Student object to map to insert into database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
    };
  }

  // Convert map to Student object to retrieve from database
  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'],
      name: map['name'],
      age: map['age'],
    );
  }
}
