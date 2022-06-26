/// Class defining features for app user, including name, username and branch.


class AppUser {
  AppUser._internal();

  static final AppUser _user = AppUser._internal();
  String? name;
  String? username;
  String? branch;

  factory AppUser() {
    return _user;
  }

  setFields(String name, String username, String branch) {
    _user.name = name;
    _user.username = username;
    _user.branch = branch;
  }
}
