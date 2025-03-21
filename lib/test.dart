void main() {
  Person p1 = Person("StackOverFlow");
  Person p2 = Person("StackOverFlow");

  print("Both Classes are same: ${p1 == p2}"); // <- print 'false'
}

class Person {
  String name;
  Person(this.name);

  @override
  bool operator == (Object other) {
    if (identical(this, other)) return true;

    return other is Person && other.name == name;
  }
}
