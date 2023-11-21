bool isObject(dynamic value) {
  return value is Map<String, dynamic>;
}

List<List<String>> createConfig(Map<String, dynamic> refObj) {
  List<List<String>> config = [];
  refObj.forEach((key, value) {
    if (isObject(value)) {
      createConfig(value).forEach((keyTail) {
        config.add([key, ...keyTail]);
      });
    } else {
      config.add([key]);
    }
  });
  return config;
}

List<List<String>> prepareConfig(List<dynamic> config) {
  return config.map((key) => key is List<String> ? key : [key]).toList()
      as List<List<String>>;
}

List<dynamic> packItem(List<List<String>> config, Map<String, dynamic> item) {
  if (config.join() != prepareConfig(createConfig(item)).join()) {
    throw Exception('Object of unusual structure');
  }

  return config.map((keyArr) {
    var place = item;
    keyArr.forEach((key) {
      place = place[key];
    });
    return place;
  }).toList();
}

Map<String, dynamic> unpackItem(List<List<String>> config, List<dynamic> item) {
  var result = <String, dynamic>{};

  config.asMap().forEach((i, keyArr) {
    var place = result;
    for (var j = 0; j < keyArr.length - 1; j++) {
      place[keyArr[j]] = place[keyArr[j]] ?? <String, dynamic>{};
      place = place[keyArr[j]];
    }
    place[keyArr.last] = item[i];
  });

  return result;
}

Map<String, dynamic> packArray(List<dynamic> arr) {
  if (arr.isNotEmpty) {
    var config = createConfig(arr[0]);
    var _config = prepareConfig(config);

    if (config.isNotEmpty) {
      return {
        'config': config,
        'data': arr.map((item) => packItem(_config, item)).toList(),
      };
    }
  }

  return {
    'config': [],
    'data': arr,
  };
}

List<dynamic> unpackArray(Map<String, dynamic> obj) {
  var config = obj['config'] as List<dynamic>;

  if (config.isNotEmpty && obj['data'] != null) {
    var _config = prepareConfig(config);
    return obj['data'].map((item) => unpackItem(_config, item)).toList();
  } else {
    return obj['data'];
  }
}
