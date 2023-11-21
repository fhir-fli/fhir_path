class Dimension {
  List<int>? dimVec;

  Dimension(dynamic dimSetting) {
    if (UC.dimLen == 0) {
      throw Exception(
          'Dimension.setDimensionLen must be called before Dimension constructor');
    }
    if (dimSetting == null) {
      assignZero();
    } else if (dimSetting is List<int>) {
      if (dimSetting.length != UC.dimLen) {
        throw Exception(
            'Parameter error, incorrect length of vector passed to Dimension constructor, vector = ${dimSetting.toString()}');
      }
      dimVec = List<int>.from(dimSetting);
    } else if (isInteger(dimSetting)) {
      if (dimSetting < 0 || dimSetting >= UC.dimLen) {
        throw Exception(
            'Parameter error, invalid element number specified for Dimension constructor');
      }
      assignZero();
      dimVec![dimSetting] = 1;
    }
  }

  void setElementAt(int indexPos, [int? value]) {
    if (!isInteger(indexPos) || indexPos < 0 || indexPos >= UC.dimLen) {
      throw Exception(
          'Dimension.setElementAt called with an invalid index position ($indexPos)');
    }

    if (dimVec == null) {
      assignZero();
    }
    value ??= 1;
    dimVec![indexPos] = value;
  }

  int? getElementAt(int indexPos) {
    if (!isInteger(indexPos) || indexPos < 0 || indexPos >= UC.dimLen) {
      throw Exception(
          'Dimension.getElementAt called with an invalid index position ($indexPos)');
    }
    return dimVec?[indexPos];
  }

  dynamic getProperty(String propertyName) {
    final uProp =
        propertyName.endsWith('_') ? propertyName : propertyName + '_';
    return this[uProp];
  }

  String? toString() {
    return dimVec != null ? '[${dimVec!.join(', ')}]' : null;
  }

  Dimension add(Dimension dim2) {
    if (dim2 is! Dimension) {
      throw Exception(
          'Dimension.add called with an invalid parameter - ${dim2.runtimeType} instead of a Dimension object');
    }
    if (dimVec != null && dim2.dimVec != null) {
      for (var i = 0; i < UC.dimLen; i++) {
        dimVec![i] += dim2.dimVec![i];
      }
    }
    return this;
  }

  Dimension sub(Dimension dim2) {
    if (dim2 is! Dimension) {
      throw Exception(
          'Dimension.sub called with an invalid parameter - ${dim2.runtimeType} instead of a Dimension object');
    }
    if (dimVec != null && dim2.dimVec != null) {
      for (var i = 0; i < UC.dimLen; i++) {
        dimVec![i] -= dim2.dimVec![i];
      }
    }
    return this;
  }

  Dimension minus() {
    if (dimVec != null) {
      for (var i = 0; i < UC.dimLen; i++) {
        dimVec![i] = -dimVec![i];
      }
    }
    return this;
  }

  Dimension mul(int s) {
    if (!isInteger(s)) {
      throw Exception(
          'Dimension.sub called with an invalid parameter - ${s.runtimeType} instead of a number');
    }
    if (dimVec != null) {
      for (var i = 0; i < UC.dimLen; i++) {
        dimVec![i] *= s;
      }
    }
    return this;
  }

  bool equals(Dimension dim2) {
    if (dim2 is! Dimension) {
      throw Exception(
          'Dimension.equals called with an invalid parameter - ${dim2.runtimeType} instead of a Dimension object');
    }
    var isEqual = true;
    var dimVec2 = dim2.dimVec;
    if (dimVec != null && dimVec2 != null) {
      for (var i = 0; isEqual && i < UC.dimLen; i++) {
        isEqual = (dimVec![i] == dimVec2[i]);
      }
    } else {
      isEqual = (dimVec == null && dimVec2 == null);
    }
    return isEqual;
  }

  Dimension assignDim(Dimension dim2) {
    if (dim2 is! Dimension) {
      throw Exception(
          'Dimension.assignDim called with an invalid parameter - ${dim2.runtimeType} instead of a Dimension object');
    }
    if (dim2.dimVec == null) {
      dimVec = null;
    } else {
      if (dimVec == null) {
        dimVec = List<int>.filled(UC.dimLen, 0);
      }
      for (var i = 0; i < UC.dimLen; i++) {
        dimVec![i] = dim2.dimVec![i];
      }
    }
    return this;
  }

  Dimension assignZero() {
    if (dimVec == null || dimVec == undefined) {
      dimVec = List<int>.filled(UC.dimLen, 0);
    }

    for (var i = 0; i < UC.dimLen; i++) {
      dimVec!.add(0);
    }
    return this;
  }

  bool isZero() {
    var allZero = dimVec != null;
    if (dimVec != null) {
      for (var i = 0; allZero && i < UC.dimLen; i++) {
        allZero = dimVec![i] == 0;
      }
    }
    return allZero;
  }

  bool isNull() {
    return (dimVec == null);
  }

  Dimension clone() {
    final that = Dimension(null);
    that.assignDim(this);
    return that;
  }
}
