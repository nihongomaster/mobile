import 'package:json_annotation/json_annotation.dart';

part 'api_user.g.dart';

@JsonSerializable()
class ApiUser {
  int id;
  String username;
  String email;
  @JsonKey(name: 'profile_picture_url')
  String profilePictureUrl;
  int points;
  int level;
  @JsonKey(name: 'drills_due')
  int drillsDue;

  @JsonKey(name: 'updated_at')
  DateTime updatedAt;
  @JsonKey(name: 'created_at')
  DateTime createdAt;

  ApiUser(this.id, this.username, this.email, this.profilePictureUrl, this.points, this.level, this.drillsDue, this.updatedAt, this.createdAt);

  factory ApiUser.fromJson(Map<String, dynamic> json) => _$ApiUserFromJson(json);

  Map<String, dynamic> toJson() => _$ApiUserToJson(this);
}
