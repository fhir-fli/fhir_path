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

bool deepEquals(List<dynamic> list1, List<dynamic> list2) {
  if (list1.length != list2.length) {
    return false;
  } else {
    for (int i = 0; i < list1.length; i++) {
      if (!list2.remove(list1[i])) {
        return false;
      }
    }
  }
  return true;
}
