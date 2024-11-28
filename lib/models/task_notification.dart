import 'task.dart';
import '../services/NotificationHelper.dart';

class TaskNotification {
  int _id;
  DateTime _notificationDate;
  String _message;

  Task _task;

  TaskNotification(this._id, this._notificationDate, this._message, this._task);

  int get id => _id;
  DateTime get notificationDate => _notificationDate;
  String get message => _message;
  Task get task => _task;

  set id(int id) => _id = id;
  set notificationDate(DateTime notificationDate) =>
      _notificationDate = notificationDate;
  set message(String message) => _message = message;
  set task(Task task) => _task = task;

  void sendNotification() {
    NotificationHelper.scheduleNotification(
      id: _id,
      title: _task.title,
      body: _message,
      scheduledDate: _notificationDate,
    );
  }

  void cancelNotification() {
    NotificationHelper.cancelNotification(_id);
  }
}
