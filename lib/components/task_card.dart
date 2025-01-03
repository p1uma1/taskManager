import 'package:flutter/material.dart';
import 'package:taskmanager_new/models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final String? categoryName;  // Added this line
  final VoidCallback onTap;

  TaskCard({required this.task, this.categoryName, required this.onTap}); // Updated constructor

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      color: task.status == TaskStatus.pending
          ? Colors.orange.shade50
          : Colors.green.shade50,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Icon indicating priority level
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _getPriorityColor(task.priority).withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.label,
                  color: _getPriorityColor(task.priority),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              // Task Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Category: $categoryName",  // Display category name
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    Text(
                      "Time: ${task.dueTime}",
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    Text(
                      "Priority: ${task.priority.name}",
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    Text(
                      "Status: ${task.status.name}",
                      style: TextStyle(
                        fontSize: 14,
                        color: task.status == TaskStatus.pending
                            ? Colors.orange
                            : Colors.green,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              // Task status icon on the right
              Icon(
                task.status == TaskStatus.pending
                    ? Icons.hourglass_empty
                    : Icons.check_circle_outline,
                color: task.status == TaskStatus.pending
                    ? Colors.orange
                    : Colors.green,
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function to determine priority color
  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return Colors.red;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.low:
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}

