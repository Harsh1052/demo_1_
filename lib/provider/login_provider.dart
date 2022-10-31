
import 'package:flutter/widgets.dart';

import '../modals/user_modal.dart';
import '../sqlight_database/db_helper.dart';

class LoginNotifier extends ChangeNotifier{

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<bool> doLogin( Map<String,dynamic> data) async{

isLoading =true;
    try {
      if (data.runtimeType != Null) {
        final user = User.fromJson(data);
        DatabaseHelper dbHelper = DatabaseHelper();
        await dbHelper.saveUser(user);
        isLoading = false;
        return true;
      }
    } catch (e) {
      isLoading = false;
      debugPrint(e.toString());
    }
    isLoading = false;
    return false;


  }
}