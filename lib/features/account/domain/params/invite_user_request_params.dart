import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

class InviteUserRequestParams extends Equatable {
  final String name;
  final String email;

  const InviteUserRequestParams({required this.name, required this.email});

  Map<String, dynamic> toJson() => {'name': name, 'email': email};

  FormData toFormData() {
    return FormData.fromMap({'name': name, 'email': email});
  }

  @override
  List<Object?> get props => [name, email];
}
