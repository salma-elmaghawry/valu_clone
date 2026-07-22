import 'package:equatable/equatable.dart';

class AppUser extends Equatable {
  final String id;
  final String phone;
  final String? nationalId;

  const AppUser({required this.id, required this.phone, this.nationalId});

  @override
  List<Object?> get props => [id, phone, nationalId];
}
