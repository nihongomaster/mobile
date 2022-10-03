// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiUser _$ApiUserFromJson(Map<String, dynamic> json) => ApiUser(
      json['id'] as int,
      json['username'] as String,
      json['email'] as String,
      json['profile_picture_url'] as String,
      json['points'] as int,
      json['level'] as int,
      json['drills_due'] as int,
      DateTime.parse(json['updated_at'] as String),
      DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$ApiUserToJson(ApiUser instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'profile_picture_url': instance.profilePictureUrl,
      'points': instance.points,
      'level': instance.level,
      'drills_due': instance.drillsDue,
      'updated_at': instance.updatedAt.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
    };
