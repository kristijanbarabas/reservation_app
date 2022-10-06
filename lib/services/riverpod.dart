import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reservation_app/services/profile_data.dart';

final userData = FutureProvider<String>((ref) {
  return ref.read(profileDatabase).getUserData();
});

final currentUserProvider = FutureProvider((ref) {
  return ref.read(profileDatabase).getCurrentUser();
});

final profileDataProvider = FutureProvider<String>((ref) async {
  return ref.read(profileDatabase).test();
});
