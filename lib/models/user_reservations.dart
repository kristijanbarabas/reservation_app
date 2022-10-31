import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class UserProfile extends Equatable {
  const UserProfile({
    required this.userId,
    required this.username,
    required this.userPhoneNumber,
    required this.userProfilePicture,
  });

  final String userId;
  final String? username;
  final String? userPhoneNumber;
  final String? userProfilePicture;

  @override
  List<Object> get props => [userId];

  @override
  bool get stringify => true;

  factory UserProfile.fromMap(Map<String, dynamic>? data, String documentId) {
    if (data == null) {
      throw StateError('missing data for userId:$documentId');
    }
    final username = data['username'] as String?;
    final userPhoneNumber = data['userPhoneNumber'] as String?;
    final userProfilePicture = data['userProfilePicture'] as String?;
    /* if (username == null) {
      throw StateError('missing username for userId: $documentId');
    }
    if (userPhoneNumber == null) {
      throw StateError('missing username for userId: $documentId');
    }
    if (userProfilePicture == null) {
      throw StateError('missing username for userId: $documentId');
    } */
    return UserProfile(
        userId: documentId,
        username: username,
        userPhoneNumber: userPhoneNumber,
        userProfilePicture: userProfilePicture);
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'userPhoneNumber': userPhoneNumber,
      'userProfilePicture': userProfilePicture
    };
  }
}
