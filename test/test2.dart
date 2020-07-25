import '../lib/models/lesson.dart';

void main() {
  Lesson l = Lesson(title: 'Test');

  print(l.toJson());
}
