import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_service.dart';
import '../widgets/task_tile.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TaskService _taskService = TaskService();
  final TextEditingController _taskController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  void _addTask() {
    final title = _taskController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task title cannot be empty')),
      );
      return;
    }
    _taskService.addTask(title);
    _taskController.clear();
  }

  void _toggleComplete(Task task) {
    final updated = task.copyWith(isCompleted: !task.isCompleted);
    _taskService.updateTask(task.id, updated);
  }

  void _deleteTask(Task task) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Task'),
        content: Text('Are you sure you want to delete "${task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _taskService.deleteTask(task.id);
              Navigator.of(ctx).pop();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _addSubtask(Task task) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Subtask'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Subtask title'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final subtaskTitle = controller.text.trim();
              if (subtaskTitle.isNotEmpty) {
                final newSubtasks = List<Map<String, dynamic>>.from(task.subtasks)
                  ..add({'title': subtaskTitle, 'isCompleted': false});
                final updated = task.copyWith(subtasks: newSubtasks);
                _taskService.updateTask(task.id, updated);
              }
              Navigator.of(ctx).pop();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _toggleSubtask(Task task, int index) {
    final newSubtasks = List<Map<String, dynamic>>.from(
      task.subtasks.map((s) => Map<String, dynamic>.from(s)),
    );
    newSubtasks[index]['isCompleted'] = !(newSubtasks[index]['isCompleted'] ?? false);
    final updated = task.copyWith(subtasks: newSubtasks);
    _taskService.updateTask(task.id, updated);
  }

  void _removeSubtask(Task task, int index) {
    final newSubtasks = List<Map<String, dynamic>>.from(task.subtasks)
      ..removeAt(index);
    final updated = task.copyWith(subtasks: newSubtasks);
    _taskService.updateTask(task.id, updated);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    decoration: const InputDecoration(
                      hintText: 'Enter task title...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _addTask(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addTask,
                  child: const Text('Add'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search tasks...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.trim().toLowerCase();
                });
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: StreamBuilder<List<Task>>(
              stream: _taskService.streamTasks(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                final tasks = snapshot.data ?? [];
                final filteredTasks = _searchQuery.isEmpty
                    ? tasks
                    : tasks.where((t) =>
                        t.title.toLowerCase().contains(_searchQuery)).toList();

                if (filteredTasks.isEmpty) {
                  return const Center(
                    child: Text(
                      'No tasks yet — add one above!',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: filteredTasks.length,
                  itemBuilder: (context, index) {
                    final task = filteredTasks[index];
                    return TaskTile(
                      task: task,
                      onToggleComplete: () => _toggleComplete(task),
                      onDelete: () => _deleteTask(task),
                      onAddSubtask: () => _addSubtask(task),
                      onToggleSubtask: (i) => _toggleSubtask(task, i),
                      onRemoveSubtask: (i) => _removeSubtask(task, i),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
