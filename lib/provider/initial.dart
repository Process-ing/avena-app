import 'package:avena/model/initial.dart';
import 'package:avena/provider/auth.dart';
import 'package:avena/provider/profile_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'initial.g.dart';

@riverpod
Future<InitialState> initialState(Ref ref) async {
  final authenticatedUser = await ref.watch(authenticatedUserProvider.future);

  if (authenticatedUser == null) return InitialState.authenticate;

  final userProfile = await ref.watch(userProfileProvider.future);

  return userProfile.finished ? InitialState.home : InitialState.qa;
}
