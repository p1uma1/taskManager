
import 'task.dart';

class Notification {
  int _id;
  DateTime _notificationDate;
  String _message;

  Task _task;

  Notification(this._id, this._notificationDate, this._message, this._task);

  int get id => _id;
  DateTime get notificationDate => _notificationDate;
  String get message => _message;
  Task get task => _task;

  set id(int id) => _id = id;
  set notificationDate(DateTime notificationDate) =>
      _notificationDate = notificationDate;
  set message(String message) => _message = message;
  set task(Task task) => _task = task;

  void sendNotification() {}
  void cancelNotification() {}
}
