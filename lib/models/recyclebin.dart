import 'task.dart';

class RecycleBin {
  int _id;
  DateTime _deleteDate;

  Task _task;

  RecycleBin(this._id, this._deleteDate, this._task);

  int get id => _id;
  DateTime get deleteDate => _deleteDate;
  Task get task => _task;

  set id(int id) => _id = id;
  set deleteDate(DateTime deleteDate) => _deleteDate = deleteDate;
  set task(Task task) => _task = task;

  void restoreTask() {}
  void permenantDeleteTask() {}
}
