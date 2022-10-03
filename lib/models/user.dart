import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  int id;
  String username;
  @JsonKey(name: 'profile_picture_url')
  String profilePictureUrl;
  int points;
  int level;

  @JsonKey(name: 'updated_at')
  DateTime updatedAt;
  @JsonKey(name: 'created_at')
  DateTime createdAt;

  User(this.id, this.username, this.profilePictureUrl, this.points, this.level,
      this.updatedAt, this.createdAt);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
