import 'package:avena/provider/auth.dart';
import 'package:flutter_riverpod/experimental/mutation.dart';

final signInMutation = Mutation();

Future<void> signIn(
  MutationTarget ref, {
  required String email,
  required String password,
}) async {
  await signInMutation.run(ref, (transaction) async {
    final auth = transaction.get(authenticatedUserProvider.notifier);

    await auth.signIn(email: email, password: password);
  });
}

final signUpMutation = Mutation();

Future<void> signUp(
  MutationTarget ref, {
  required String name,
  required String email,
  required String password,
}) async {
  await signUpMutation.run(ref, (transaction) async {
    final auth = transaction.get(authenticatedUserProvider.notifier);

    await auth.signUp(name: name, email: email, password: password);
  });
}

final signOutMutation = Mutation();

Future<void> signOut(MutationTarget ref) async {
  await signOutMutation.run(ref, (transaction) async {
    final auth = transaction.get(authenticatedUserProvider.notifier);

    await auth.signOut();
  });
}
