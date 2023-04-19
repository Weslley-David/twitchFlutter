
class User {
  final int id;
  final String name;
  final int password;

  const User({
    required this.id,
    required this.name,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': password,
    };
  }

  @override
  String toString() {
    return 'User{id: $id, name: $name, age: $password}';
  }
}
