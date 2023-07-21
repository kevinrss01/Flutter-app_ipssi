class Position {
  double longitude;
  double latitude;

  Position({required this.longitude, required this.latitude});

  factory Position.fromMap(Map<String, dynamic> map) {
    return Position(
      longitude: map['longitude'],
      latitude: map['latitude'],
    );
  }
}

class AllMessagesByUser {
  String id;
  String message;
  String sender;
  String receiver;
  String date;

  AllMessagesByUser(
      {required this.id,
      required this.message,
      required this.sender,
      required this.receiver,
      required this.date});

  factory AllMessagesByUser.fromMap(Map<String, dynamic> map) {
    return AllMessagesByUser(
      id: map['id'],
      message: map['message'],
      sender: map['sender'],
      receiver: map['receiver'],
      date: map['date'],
    );
  }
}

class Messages {
  Map<String, List<AllMessagesByUser>> data;

  Messages({required this.data});

  factory Messages.fromMap(Map<String, dynamic> map) {
    Map<String, List<AllMessagesByUser>> data = {};
    map.forEach((key, value) {
      List<AllMessagesByUser> messages = List<AllMessagesByUser>.from(
          value.map((item) => AllMessagesByUser.fromMap(item)));
      data[key] = messages;
    });
    return Messages(data: data);
  }
}

class UserData {
  final String NOM;
  final String PRENOM;
  final String EMAIL;
  final String GENDER;
  final String PHONE_NUMBER;
  final String AVATAR;
  final String PSEUDO;
  final Position POSITION;
  final Messages MESSAGES;

  UserData(this.NOM, this.PRENOM, this.EMAIL, this.GENDER, this.PHONE_NUMBER,
      this.AVATAR, this.PSEUDO, this.POSITION, this.MESSAGES);

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      map['NOM'],
      map['PRENOM'],
      map['EMAIL'],
      map['GENDER'],
      map['PHONE_NUMBER'],
      map['AVATAR'],
      map['PSEUDO'],
      Position.fromMap(map['POSITION']),
      Messages.fromMap(map['MESSAGES']),
    );
  }
}
