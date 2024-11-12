class User {
  int _id;
  String _name;
  String _email;
  String _password;
  String _authenticationMethod;
  DateTime _birthday;
  Map<String, String> _statusByDay;

  User(this._id, this._name, this._email, this._password,
      this._authenticationMethod, this._birthday, this._statusByDay);

  int get id => _id;
  String get name => _name;
  String get email => _email;
  String get password => _password;
  String get authenticationMethod => _authenticationMethod;
  DateTime get birthday => _birthday;
  Map<String, String> get statusByDay => _statusByDay;

  set name(String name) => _name = name;
  set email(String email) => _email = email;
  set password(String password) => _password = password;
  set authenticationMethod(String authenticationMethod) =>
      _authenticationMethod = authenticationMethod;
  set birthday(DateTime birthday) => _birthday = birthday;
  set statusByDay(Map<String, String> statusByDay) =>
      _statusByDay = statusByDay;

  void login() {}
  void logout() {}
  void register() {}
  void authenticate() {}
}
