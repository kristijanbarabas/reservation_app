import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class UserProfile extends Equatable {
  // TODO remove late and add final?
  final String userId;
  late String? username;
  late String? userPhoneNumber;
  late String? firstName;
  late String? lastName;
  final String? userProfilePicture;

  UserProfile({
    required this.userId,
    required this.username,
    required this.userPhoneNumber,
    required this.userProfilePicture,
    required this.firstName,
    required this.lastName,
  });

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
    final firstName = data['firstName'] as String?;
    final lastName = data['lastName'] as String?;
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
        userProfilePicture: userProfilePicture,
        firstName: firstName,
        lastName: lastName);
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'userPhoneNumber': userPhoneNumber,
      'userProfilePicture': userProfilePicture,
      'firstName': firstName,
      'lastName': lastName,
    };
  }
}
