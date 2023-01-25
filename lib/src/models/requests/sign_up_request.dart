import 'dart:io';

class SignUpRequest {
  String? name;
  String? fullName;
  File? file;
  String? email;
  String? password;
  String? username;
  String? phone;
  String? role;
  String? specialty;
  String? orcid;

  SignUpRequest({
    this.email,
    this.password,
    this.name,
    this.fullName,
    this.role,
    this.file,
    this.specialty,
    this.phone,
    this.orcid
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'fullName': fullName,
        'file': file,
        'mail': email,
        "password": password,
        'phone': phone,
        'role': role,
        'specialty': specialty,
        'orcid':orcid
      };
}
