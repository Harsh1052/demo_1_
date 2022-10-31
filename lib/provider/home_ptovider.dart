import 'package:flutter/foundation.dart';

import '../modals/user_modal.dart';
import '../sqlight_database/appoinment_db.dart';
import '../sqlight_database/db_helper.dart';

class HomeNotifier extends ChangeNotifier {
  bool _isLoading = false;
  List<Appointment?> appointments = [];
  List<User?> users = [];
  final DatabaseHelper1 databaseHelper1 = DatabaseHelper1();
  final DatabaseHelper databaseHelper = DatabaseHelper();

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }


 Future<void> getAllUser() async {
    isLoading = true;
    users = await DatabaseHelper().getUser();

    isLoading = false;
  }

  getAppointment(String userName) async {
    appointments = await DatabaseHelper1().getAppointment(userName);

    isLoading = false;
  }

  addAppointment(User selectedUser,String time) async {

    isLoading = true;


    User? user = await databaseHelper.getCurrentUser();

    await databaseHelper1.addAppointment(Appointment(
        createdBy: user?.name ?? 'current user',
        name: selectedUser.name ?? "seleted userName",
        time: time,
        email: user?.email ?? 'email'));
  }
}
