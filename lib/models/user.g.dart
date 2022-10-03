// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      json['id'] as int,
      json['username'] as String,
      json['profile_picture_url'] as String,
      json['points'] as int,
      json['level'] as int,
      DateTime.parse(json['updated_at'] as String),
      DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'profile_picture_url': instance.profilePictureUrl,
      'points': instance.points,
      'level': instance.level,
      'updated_at': instance.updatedAt.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
    };
