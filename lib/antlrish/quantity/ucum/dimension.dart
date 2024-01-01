import 'ucum_pkg.dart';

class Dimension {
  List<int>? dimVec_;

  Dimension([this.dimVec_]);

  factory Dimension.fromJson(Map<String, dynamic> json) {
    return Dimension(json['dimVec_'] as List<int>);
  }

  Dimension.fromDimSetting([dynamic dimSetting]) {
    if (UcumConfig.dimLen == 0) {
      throw Exception(
          'Dimension.setDimensionLen must be called before Dimension constructor');
    }

    if (dimSetting == null) {
      assignZero();
    } else if (dimSetting is List<int>) {
      if (dimSetting.length != UcumConfig.dimLen) {
        throw Exception(
            'Parameter error, incorrect length of vector passed to Dimension constructor');
      }
      dimVec_ = List<int>.from(dimSetting);
    } else if (int.tryParse(dimSetting) != null) {
      if (dimSetting < 0 || dimSetting >= UcumConfig.dimLen) {
        throw Exception(
            'Parameter error, invalid element number specified for Dimension constructor');
      }
      assignZero();
      dimVec_![dimSetting] = 1;
    } else {
      throw Exception('Invalid parameter type for Dimension constructor');
    }
  }

  void setElementAt(int indexPos, [int value = 1]) {
    if (indexPos < 0 || indexPos >= UcumConfig.dimLen) {
      throw Exception('Invalid index position for Dimension.setElementAt');
    }
    dimVec_ ??= List<int>.filled(UcumConfig.dimLen, 0);
    dimVec_![indexPos] = value;
  }

  int? getElementAt(int indexPos) {
    if (indexPos < 0 || indexPos >= UcumConfig.dimLen) {
      throw Exception('Invalid index position for Dimension.getElementAt');
    }
    return dimVec_?[indexPos];
  }

  void add(Dimension dim2) {
    if (dimVec_ == null || dim2.dimVec_ == null) return;

    for (int i = 0; i < UcumConfig.dimLen; i++) {
      dimVec_![i] += dim2.dimVec_![i];
    }
  }

  void sub(Dimension dim2) {
    if (dimVec_ == null || dim2.dimVec_ == null) return;

    for (int i = 0; i < UcumConfig.dimLen; i++) {
      dimVec_![i] -= dim2.dimVec_![i];
    }
  }

  void minus() {
    if (dimVec_ == null) return;

    for (int i = 0; i < UcumConfig.dimLen; i++) {
      dimVec_![i] = -dimVec_![i];
    }
  }

  void mul(int scalar) {
    if (dimVec_ == null) return;

    for (int i = 0; i < UcumConfig.dimLen; i++) {
      dimVec_![i] *= scalar;
    }
  }

  bool equals(Dimension dim2) {
    if (dimVec_ == null && dim2.dimVec_ == null) return true;
    if (dimVec_ == null || dim2.dimVec_ == null) return false;

    for (int i = 0; i < UcumConfig.dimLen; i++) {
      if (dimVec_![i] != dim2.dimVec_![i]) {
        return false;
      }
    }
    return true;
  }

  void assignDim(Dimension dim2) {
    if (dim2.dimVec_ == null) {
      dimVec_ = null;
    } else {
      dimVec_ = List<int>.from(dim2.dimVec_!);
    }
  }

  void assignZero() {
    dimVec_ = List<int>.filled(UcumConfig.dimLen, 0);
  }

  bool isZero() {
    if (dimVec_ == null) return false;

    for (int element in dimVec_!) {
      if (element != 0) {
        return false;
      }
    }
    return true;
  }

  bool isNull() {
    return dimVec_ == null;
  }

  Dimension clone() {
    Dimension clone = Dimension();
    clone.assignDim(this);
    return clone;
  }

  @override
  String toString() {
    if (dimVec_ == null) return 'null';
    return '[${dimVec_!.join(', ')}]';
  }
}
