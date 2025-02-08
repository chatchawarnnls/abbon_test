class ContactResultModel {
  List<UsersResultModel>? users;
  int? total;
  int? skip;
  int? limit;

  ContactResultModel({this.users, this.total, this.skip, this.limit});

  ContactResultModel.fromJson(Map<String, dynamic> json) {
    if (json['users'] != null) {
      users = <UsersResultModel>[];
      json['users'].forEach((v) {
        users!.add(UsersResultModel.fromJson(v));
      });
    }
    total = json['total'];
    skip = json['skip'];
    limit = json['limit'];
  }

  ContactResultModel copyWith({List<UsersResultModel>? users}) {
    return ContactResultModel(
      users: users ?? this.users,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (users != null) {
      data['users'] = users!.map((v) => v.toJson()).toList();
    }
    data['total'] = total;
    data['skip'] = skip;
    data['limit'] = limit;
    return data;
  }
}

class UsersResultModel {
  int? id;
  String? firstName;
  String? lastName;
  int? age;

  UsersResultModel({
    this.id,
    this.firstName,
    this.lastName,
    this.age,
  });

  UsersResultModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    age = json['age'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['age'] = age;
    return data;
  }
}
