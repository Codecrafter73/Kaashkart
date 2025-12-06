class CustomerLoginModelResponse {
  bool? success;
  String? message;
  User? user;

  CustomerLoginModelResponse({this.success, this.message, this.user});

  CustomerLoginModelResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  int? userId;
  String? userName;
  String? email;
  String? mobileNumber;
  String? address;

  User(
      {this.userId,
        this.userName,
        this.email,
        this.mobileNumber,
        this.address});

  User.fromJson(Map<String, dynamic> json) {
    userId = json['UserId'];
    userName = json['UserName'];
    email = json['Email'];
    mobileNumber = json['MobileNumber'];
    address = json['Address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UserId'] = this.userId;
    data['UserName'] = this.userName;
    data['Email'] = this.email;
    data['MobileNumber'] = this.mobileNumber;
    data['Address'] = this.address;
    return data;
  }
}
