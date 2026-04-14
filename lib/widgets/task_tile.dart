import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback onToggleComplete;
  final VoidCallback onDelete;
  final VoidCallback onAddSubtask;
  final void Function(int) onToggleSubtask;
  final void Function(int) onRemoveSubtask;

  const TaskTile({
    super.key,
    required this.task,
    required this.onToggleComplete,
    required this.onDelete,
    required this.onAddSubtask,
    required this.onToggleSubtask,
    required this.onRemoveSubtask,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ExpansionTile(
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (_) => onToggleComplete(),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isCompleted
                ? TextDecoration.lineThrough
                : TextDecoration.none,
            color: task.isCompleted ? Colors.grey : null,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.add_circle_outline, size: 20),
              onPressed: onAddSubtask,
              tooltip: 'Add subtask',
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red, size: 20),
              onPressed: onDelete,
              tooltip: 'Delete task',
            ),
          ],
        ),
        children: [
          if (task.subtasks.isEmpty)
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                'No subtasks yet',
                style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
              ),
            )
          else
            ...List.generate(task.subtasks.length, (index) {
              final subtask = task.subtasks[index];
              final isCompleted = subtask['isCompleted'] ?? false;
              return ListTile(
                contentPadding: const EdgeInsets.only(left: 32, right: 16),
                leading: Checkbox(
                  value: isCompleted,
                  onChanged: (_) => onToggleSubtask(index),
                ),
                title: Text(
                  subtask['title'] ?? '',
                  style: TextStyle(
                    fontSize: 14,
                    decoration: isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    color: isCompleted ? Colors.grey : null,
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.remove_circle_outline,
                      size: 18, color: Colors.red),
                  onPressed: () => onRemoveSubtask(index),
                  tooltip: 'Remove subtask',
                ),
              );
            }),
        ],
      ),
    );
  }
}
