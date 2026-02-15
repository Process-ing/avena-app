import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'category.g.dart';

@riverpod
List<String> categories(Ref _) => ['Breakfast', 'Lunch', 'Snack', 'Dinner'];
