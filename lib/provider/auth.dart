import 'package:avena/provider/api.dart';
import 'package:flutter_better_auth/core/api/better_auth_client.dart';
import 'package:flutter_better_auth/flutter_better_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth.g.dart';

@riverpod
Future<BetterAuthClient> betterAuthClient(Ref ref) async {
  await FlutterBetterAuth.initialize(
    url: "https://avena.henriquesf.me/api/auth",
    dio: ref.watch(dioProvider),
  );

  return FlutterBetterAuth.client;
}

@riverpod
class AuthenticatedUserNotifier extends _$AuthenticatedUserNotifier {
  @override
  Future<User?> build() async {
    final client = await ref.watch(betterAuthClientProvider.future);

    final result = await client.getSession();

    if (result.data != null) {
      return result.data?.user;
    } else {
      return null;
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    final client = await ref.watch(betterAuthClientProvider.future);

    final result = await client.signIn.email(email: email, password: password);

    if (result.data != null) {
      state = AsyncValue.data(result.data!.user);
    } else {
      throw Exception(result.error?.message ?? 'Sign in failed');
    }
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final client = await ref.watch(betterAuthClientProvider.future);

    final result = await client.signUp.email(
      name: name,
      email: email,
      password: password,
    );

    if (result.data != null) {
      state = AsyncValue.data(result.data!.user);
    } else {
      throw Exception(result.error?.message ?? 'Sign up failed');
    }
  }

  Future<void> signOut() async {
    final client = await ref.watch(betterAuthClientProvider.future);

    final result = await client.signOut();

    if (result.data != null) {
      state = AsyncValue.data(null);
    } else {
      throw Exception(result.error?.message ?? 'Sign out failed');
    }
  }
}
