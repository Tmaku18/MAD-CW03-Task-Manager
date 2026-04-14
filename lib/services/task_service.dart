import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task.dart';

class TaskService {
  final CollectionReference _tasksCollection =
      FirebaseFirestore.instance.collection('tasks');

  Stream<List<Task>> streamTasks() {
    return _tasksCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Task.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  Future<void> addTask(String title) async {
    final task = Task(
      id: '',
      title: title.trim(),
      createdAt: DateTime.now(),
    );
    await _tasksCollection.add(task.toMap());
  }

  Future<void> updateTask(String id, Task updatedTask) async {
    await _tasksCollection.doc(id).update(updatedTask.toMap());
  }

  Future<void> deleteTask(String id) async {
    await _tasksCollection.doc(id).delete();
  }
}
