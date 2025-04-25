import 'user_model.dart';

class LoginResponseModel {
  final bool success;
  final String message;
  final UserModel? user;

  LoginResponseModel({
    required this.success,
    required this.message,
    this.user,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      success: json['success'],
      message: json['message'],
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'user': user?.toJson(),
    };
  }
}
