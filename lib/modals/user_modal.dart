class User {
   String? name;
   String? email;

  User({this.email,this.name,});

  // here because of user object is too long Im storing it as string
  // and that is actually not a good way to do this because of when you want to
  // fetch user and handle information it will be very hard to do those and also when testing
  // please map other properties in your json to model and that's the best way.
  User.fromJson(Map<dynamic,dynamic> obj)
      : name = obj['name'].toString(),
        email = obj['email'];

  String get getUserName => name??'No Name Found';
  String get getEmail => email??'No Email Found';

  Map<String, dynamic> toMap() => {'name': name, 'email': email,};
}



class Appointment {
  String? name;
  String? email;
  String? createdBy;
  String? time;

  Appointment({this.email,this.name,this.createdBy,this.time});

  // here because of user object is too long Im storing it as string
  // and that is actually not a good way to do this because of when you want to
  // fetch user and handle information it will be very hard to do those and also when testing
  // please map other properties in your json to model and that's the best way.
  Appointment.fromJson(Map<dynamic,dynamic> obj)
      : name = obj['name'].toString(),
        email = obj['email'],createdBy = obj['created_by'],time = obj['time'];

  String get getUserName => name??'No Name Found';
  String get getEmail => email??'No Email Found';
  String get getCreatedBy => createdBy??'No createdBY Found';
  String get getTime => time??'No Time Found';

  Map<String, dynamic> toMap() => {'name': name, 'email': email,'time':time,'created_by':createdBy};
}