import 'category.dart';
import 'user.dart';

class Task {
  int _id;
  String _title;
  String _description;
  DateTime _dueDate;
  String _dueTime;
  Duration _remainingTime;
  int _priority;
  String _status;
  bool _isOverdue;
  bool _onNotification;

  Category _category;

  User _user;

  Task(
      this._id,
      this._title,
      this._description,
      this._dueDate,
      this._dueTime,
      this._remainingTime,
      this._priority,
      this._status,
      this._isOverdue,
      this._onNotification,
      this._category,
      this._user);

  int get id => _id;
  String get title => _title;
  String get description => _description;
  DateTime get dueDate => _dueDate;
  String get dueTime => _dueTime;
  Duration get remainingTime => _remainingTime;
  int get priority => _priority;
  String get status => _status;
  bool get isOverdue => _isOverdue;
  bool get onNotification => _onNotification;

  Category get category => _category;
  User get user => _user;

  set title(String title) => _title = title;
  set description(String description) => _description = description;
  set dueDate(DateTime dueDate) => _dueDate = dueDate;
  set dueTime(String dueTime) => _dueTime = dueTime;
  set remainingTime(Duration remainingTime) => _remainingTime = remainingTime;
  set priority(int priority) => _priority = priority;
  set status(String status) => _status = status;
  set isOverdue(bool isOverdue) => _isOverdue = isOverdue;
  set onNotification(bool onNotification) => _onNotification = onNotification;

  set category(Category category) => _category = category;
  set user(User user) => _user = user;

  void createTask() {}
  void readTask() {}
  void updateTask() {}
  void deleteTask() {}
  void markComplete() {}
  void calculateRemainingTime() {}
}
