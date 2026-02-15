import 'package:flutter_better_auth/core/api/better_auth_client.dart';
import 'package:flutter_better_auth/flutter_better_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api.dart';

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
class AuthenticatedUser extends _$AuthenticatedUser {
  @override
  Future<User?> build() async {
    // We use .future here because build() is already async
    final client = await ref.watch(betterAuthClientProvider.future);
    final result = await client.getSession();
    return result.data?.user;
  }

  Future<void> signIn({required String email, required String password}) async {
    state = const AsyncValue.loading();

    try {
      final client = await ref.read(betterAuthClientProvider.future);

      // The Async Gap: This network call takes time
      final result = await client.signIn.email(
        email: email,
        password: password,
      );

      // FIX: Check if the provider is still active before updating state
      if (!ref.mounted) return;

      if (result.data != null) {
        state = AsyncValue.data(result.data!.user);
      } else {
        throw Exception(result.error?.message ?? 'Sign in failed');
      }
    } catch (e, stackTrace) {
      if (!ref.mounted) return;
      state = AsyncValue.error(e, stackTrace);
      rethrow;
    }
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();

    try {
      final client = await ref.read(betterAuthClientProvider.future);

      final result = await client.signUp.email(
        name: name,
        email: email,
        password: password,
      );

      // FIX: Check if the provider is still active
      if (!ref.mounted) return;

      if (result.data != null) {
        state = AsyncValue.data(result.data!.user);
      } else {
        throw Exception(result.error?.message ?? 'Sign up failed');
      }
    } catch (e, stackTrace) {
      if (!ref.mounted) return;
      state = AsyncValue.error(e, stackTrace);
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      final client = await ref.read(betterAuthClientProvider.future);
      final result = await client.signOut();

      // FIX: Check if the provider is still active
      if (!ref.mounted) return;

      if (result.data != null) {
        state = const AsyncValue.data(null);
      } else {
        throw Exception(result.error?.message ?? 'Sign out failed');
      }
    } catch (e, stackTrace) {
      if (!ref.mounted) return;
      state = AsyncValue.error(e, stackTrace);
      rethrow;
    }
  }

  /// Check if user is authenticated
  bool get isAuthenticated {
    return state.value != null;
  }

  /// Get current user or null
  User? get currentUser {
    return state.value;
  }
}
