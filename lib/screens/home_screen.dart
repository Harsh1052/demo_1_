import 'package:demo_1/provider/home_ptovider.dart';
import 'package:demo_1/sqlight_database/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../modals/user_modal.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  final User user;
  const HomeScreen({Key? key,required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeNotifier()..getAppointment(user.getUserName),
      child: Scaffold(
        appBar: AppBar(
          title:  Text("${user.getUserName}'s Appointments"),
          actions: [IconButton(onPressed: () async{

            await DatabaseHelper().deleteUser(user.getUserName).then((value){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
            }
            );


          }, icon: const Icon(Icons.logout))],
        ),
        floatingActionButton:
            Consumer<HomeNotifier>(builder: (context, snapshot, child) {
          return FloatingActionButton(
            onPressed: () async {
              String? chooseTime;
              String? selectedTime;
              List<User?> users = [];
              for(int i = 0;i<10;i++){
                users.add(User(name: 'User ${i+1}',email:'user$i@gmail.com'),);
              }
              int? selectedIndex;
              await showDialog(
                  context: context,
                  builder: (_) => ChangeNotifierProvider(
                        create: (_) => HomeNotifier(),
                        child: Consumer<HomeNotifier>(
                            builder: (context, snapshot, child) {
                          HomeNotifier homeNotifier = snapshot;
                          return StatefulBuilder(builder: (context, setState) {
                            return AlertDialog(
                              title: const Text('Book your Appointment'),
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                DropdownButton<int>(
                                  isExpanded: true,
                                  hint:const Text('Select Member'),
                                    value: selectedIndex,
                                    items:
                                    List.generate(users.length, (index) {
                                      return DropdownMenuItem<int>(
                                          value: index,
                                          child: Text(
                                              users[index]?.getUserName ??
                                                  'No Name'));
                                    }),
                                    onChanged: (int? value) {
                                      selectedIndex = value ?? 0;
                                      setState(() {});
                                    }),
                                const SizedBox(
                                  height: 10,
                                ),
                                InkWell(
                                  onTap: () async {
                                    TimeOfDay? selectedDay =
                                    await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now());

                                    if (selectedDay != null) {
                                      var now = DateTime.now();
                                      selectedTime = selectedDay.format(context);
                                      chooseTime = DateTime(
                                          now.year,
                                          now.month,
                                          now.day,
                                          selectedDay.hour,
                                          selectedDay.minute)
                                          .toString();

                                      setState((){});
                                    }
                                  },
                                  child:  TextField(
                                    enabled: false,
                                    decoration: InputDecoration(
                                        hintText: selectedTime ?? 'Choose Appointment Time',hintStyle: TextStyle(
                                      color: selectedTime==null?null:Colors.black
                                    )),
                                  ),
                                ),
                              ],),
                              actions: [
                                TextButton(onPressed: (){
                                  Navigator.pop(context);
                                }, child: const Text('Cancel')),TextButton(
                                    onPressed: homeNotifier.isLoading
                                        ? null
                                        : chooseTime != null && selectedIndex !=null?() async {
                                      if (chooseTime != null && selectedIndex !=null) {
                                        await homeNotifier
                                            .addAppointment(
                                            users[selectedIndex!]!,
                                            chooseTime!);
                                        Navigator.pop(context);
                                      }
                                    }:null,
                                    child: homeNotifier.isLoading
                                        ? const Center(
                                      child:
                                      CircularProgressIndicator(),
                                    )
                                        : const Text('Confirm')),
                              ],
                            );
                          });
                        }),
                      ));
              snapshot.getAppointment(user.getUserName);
            },
            child: const Icon(Icons.add),
          );
        }),

        body: Consumer<HomeNotifier>(builder: (context, snapshot, child) {
          return snapshot.isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : snapshot.appointments.isEmpty
                  ? const Center(
                      child: Text('Add Appointments'),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: List.generate(snapshot.appointments.length,
                            (index) {
                          final Appointment? user =
                              snapshot.appointments[index];
                           return ListTile(
                              title: Text(user?.getUserName??'Not found' ),
                              subtitle: Text(user?.getEmail??'not found' ),
                              trailing: StreamBuilder<String?>(
                                initialData: null,
                                  stream:
                                      setSeconds(DateTime.parse(user?.getTime??DateTime.now().toString())),
                                  builder: (context, snapshot) {
                                  if(!snapshot.hasData && snapshot.connectionState != ConnectionState.done){
                                    return const CircularProgressIndicator();
                                  }
                                    if(snapshot.data != null && snapshot.hasData){

                                      return Text(snapshot.data.toString());
                                    }
                                    return Text(user?.getTime??'not found');
                                  }));
                        }),
                      ),
                    );
        }),
      ),
    );
  }

  Stream<String?>? setSeconds(DateTime? time) async* {
    var now = DateTime.now();
    int seconds = time!.difference(now).inSeconds;


    if((!time.isAfter(now.toUtc()) )){

      yield 'You missed';
      return;
    }

    if ((time.isAfter(now.toUtc())) && seconds< 3600) {

      for (int i = seconds; i >= 0; i--) {

        await Future.delayed(const Duration(seconds: 1));

        yield formatTime(i);
      }
    }else{
      yield time.toString();
      return;
    }
    yield null;
  }

  String formatTime(int seconds) {
    return '${(Duration(seconds: seconds))}'.split('.')[0].padLeft(8, '0');
  }
}
