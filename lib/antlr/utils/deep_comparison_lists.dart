// Package imports:
import 'package:collection/collection.dart';

bool notFoundInList(List<dynamic> list, dynamic e) =>
    list.indexWhere(
        (dynamic l) => const DeepCollectionEquality().equals(e, l)) ==
    -1;

bool foundInList(List<dynamic> list, dynamic e) =>
    list.indexWhere(
        (dynamic l) => const DeepCollectionEquality().equals(e, l)) !=
    -1;

bool deepEquals(List<dynamic>? list1, List<dynamic>? list2) =>
    const DeepCollectionEquality().equals(list1, list2);
