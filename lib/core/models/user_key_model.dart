import 'dart:convert';

import 'package:equatable/equatable.dart';

class UserKeyModel extends Equatable {
  final String name;
  final String? posting;
  final String? active;
  final String? memo;

  const UserKeyModel(
      {this.active, this.posting, this.memo, required this.name});

  factory UserKeyModel.fromJson(Map<String, dynamic> json) => UserKeyModel(
        name: json["name"],
        posting: json["posting"],
        active: json["active"],
        memo: json["memo"],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'posting': posting,
        'active': active,
        'memo': memo,
      };

  List<String> toCsv() => [
        name,
        posting ?? "",
        active ?? "",
        memo ?? "",
      ];

  static List<UserKeyModel> fromRawJson(String encodedValue) {
    var result = json.decode(encodedValue) as List<dynamic>;
    return result.map((element) {
      return UserKeyModel.fromJson(element);
    }).toList();
  }

  UserKeyModel copyWith({
    String? posting,
    String? active,
    String? memo,
  }) {
    return UserKeyModel(
      name: name,
      posting: posting ?? this.posting,
      active: active ?? this.active,
      memo: memo ?? this.memo
    );
  }

  @override
  List<Object?> get props => [name, posting, active, memo];
}
