bool isObject(dynamic value) {
  return value is Map;
}

List<dynamic> createConfig(Map refObj) {
  List<dynamic> config = [];
  refObj.forEach((key, value) {
    if (isObject(value)) {
      createConfig(value as Map).forEach((keyTail) {
        config.add([
          key,
          ...keyTail is List ? keyTail : [keyTail]
        ]);
      });
    } else {
      config.add(key);
    }
  });
  return config;
}

List<List<dynamic>> prepareConfig(List<dynamic> config) {
  return config.map((key) => key is List ? key : [key]).toList();
}

List<dynamic> packItem(List<List<dynamic>> config, Map<String, dynamic> item) {
  if (!ListEquality().equals(config, prepareConfig(createConfig(item)))) {
    throw Exception('Object of unusual structure');
  }
  print('item: $item');

  return config.map((keyArr) {
    dynamic place = item;
    for (var key in keyArr) {
      print('key: $key');
      place = place[key];
      // TODO(Dokotela): tests had null values, which would automatically throw
      // if (place == null) {
      //   throw Exception('Object of unusual structure');
      // }
    }
    return place;
  }).toList();
}

Map<String, dynamic> unpackItem(
    List<List<dynamic>> config, List<dynamic> item) {
  Map<String, dynamic> result = <String, dynamic>{};
  for (var i = 0; i < config.length; i++) {
    var keyArr = config[i];
    Map<String, dynamic> place = result;

    for (int j = 0; j < keyArr.length - 1; j++) {
      String key = keyArr[j];
      place = place[key] = place[key] ?? <String, dynamic>{};
    }

    place[keyArr.last] = item[i];
  }
  return result;
}

Map<String, dynamic> packArray(List<Map<String, dynamic>> arr) {
  if (arr.isNotEmpty) {
    var config = createConfig(arr[0]), _config = prepareConfig(config);

    if (config.isNotEmpty) {
      return {
        'config': config,
        'data': arr.map((item) => packItem(_config, item)).toList()
      };
    }
  }

  return {'config': [], 'data': arr};
}

List<Map<String, dynamic>> unpackArray(Map<String, dynamic> obj) {
  List? config = obj['config'];

  if (config != null) {
    if (config.isNotEmpty && obj['data'] != null) {
      var _config = prepareConfig(config);
      return (obj['data'] as List)
          .map((item) => unpackItem(_config, item))
          .toList();
    } else {
      return obj['data'];
    }
  }

  return obj as List<Map<String, dynamic>>;
}

// Helper class for comparing lists
class ListEquality {
  bool equals(List list1, List list2) {
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] is List && list2[i] is List) {
        if (!equals(list1[i], list2[i])) return false;
      } else {
        if (list1[i] != list2[i]) return false;
      }
    }
    return true;
  }
}
