import 'package:flutter/material.dart';
import 'package:taskmanager_new/models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final String? categoryName; // Added this line
  final VoidCallback onTap;

  TaskCard(
      {required this.task,
        this.categoryName,
        required this.onTap}); // Updated constructor

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      color: _getStatusBackgroundColor(task.status), // No opacity here
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
                      "Category: $categoryName", // Display category name
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
                        color: _getStatusColor(task.status),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              // Task status icon on the right
              Icon(
                _getStatusIcon(task.status),
                color: _getStatusColor(task.status),
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function to determine status color with better contrast
  Color _getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return Colors.orange; // Pending - orange
      case TaskStatus.inProgress:
        return Colors.blue; // In progress - blue
      case TaskStatus.completed:
        return Colors.green; // Completed - green
      case TaskStatus.overdue:
        return Colors.red; // Overdue - red
      default:
        return Colors.grey; // Default - grey
    }
  }

  // Helper function to determine status icon
  IconData _getStatusIcon(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return Icons.hourglass_empty; // Pending - hourglass icon
      case TaskStatus.inProgress:
        return Icons.play_arrow; // In progress - play icon
      case TaskStatus.completed:
        return Icons.check_circle_outline; // Completed - check icon
      case TaskStatus.overdue:
        return Icons.warning_amber_outlined; // Overdue - warning icon
      default:
        return Icons.help_outline; // Default - help icon
    }
  }

  // Helper function to determine status background color
  Color _getStatusBackgroundColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return Colors.orange.shade100; // Light orange for pending
      case TaskStatus.inProgress:
        return Colors.blue.shade100; // Light blue for in progress
      case TaskStatus.completed:
        return Colors.green.shade100; // Light green for completed
      case TaskStatus.overdue:
        return Colors.red.shade100; // Light red for overdue
      default:
        return Colors.grey.shade100; // Default background
    }
  }

  // Helper function to determine priority color
  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return Colors.red; // High priority - red
      case TaskPriority.medium:
        return Colors.orange; // Medium priority - orange
      case TaskPriority.low:
        return Colors.blue; // Low priority - blue
      default:
        return Colors.grey; // Default color
    }
  }
}