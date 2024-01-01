import 'ucum_pkg.dart';

class Dimension {
  List<int>? dimVec_;

  // Dimension([this.dimVec_]);

  Dimension([dynamic dimSetting]) {
    if (UcumConfig.dimLen_ == 0) {
      throw Exception(
          'Dimension.setDimensionLen must be called before Dimension constructor');
    } else if (dimSetting == null) {
      assignZero();
    } else if (dimSetting is List<int>) {
      if (dimSetting.length != UcumConfig.dimLen_) {
        throw Exception(
            'Parameter error, incorrect length of vector passed to Dimension constructor');
      } else {
        /// List<int>
        dimVec_ = List<int>.from(dimSetting);
      }
    } else if (int.tryParse(dimSetting) != null) {
      final int dimSettingInt = int.parse(dimSetting);
      if (dimSettingInt < 0 || dimSettingInt >= UcumConfig.dimLen_) {
        throw Exception(
            'Parameter error, invalid element number specified for Dimension constructor');
      }
      assignZero();
      dimVec_![dimSettingInt] = 1;
    }
  }

  factory Dimension.fromJson(Map<String, dynamic> json) =>
      Dimension(json['dimVec_'] as List<int>?);

  void setElementAt(int indexPos, [int value = 1]) {
    if (indexPos < 0 || indexPos >= UcumConfig.dimLen_) {
      throw Exception('Invalid index position for Dimension.setElementAt');
    }
    if (dimVec_ == null) {
      assignZero();
    }
    dimVec_![indexPos] = value;
  }

  int? getElementAt(int indexPos) {
    if (indexPos < 0 || indexPos >= UcumConfig.dimLen_) {
      throw Exception('Invalid index position for Dimension.getElementAt');
    }
    return dimVec_?[indexPos];
  }

  dynamic getProperty(String propertyName) {
    final uProp =
        propertyName.endsWith('_') ? propertyName : propertyName + '_';
    if (uProp == 'dimVec_') {
      return dimVec_;
    }
  }

  @override
  String toString() => dimVec_ == null ? 'null' : '[${dimVec_!.join(', ')}]';

  void add(Dimension dim2) {
    if (dimVec_ != null && dim2.dimVec_ != null) {
      for (int i = 0; i < UcumConfig.dimLen_; i++) {
        dimVec_![i] += dim2.dimVec_![i];
      }
    }
  }

  void sub(Dimension dim2) {
    if (dimVec_ != null && dim2.dimVec_ != null) {
      for (int i = 0; i < UcumConfig.dimLen_; i++) {
        dimVec_![i] -= dim2.dimVec_![i];
      }
    }
  }

  void minus() {
    if (dimVec_ != null) {
      for (int i = 0; i < UcumConfig.dimLen_; i++) {
        dimVec_![i] = -dimVec_![i];
      }
    }
  }

  void mul(int scalar) {
    if (dimVec_ != null) {
      for (int i = 0; i < UcumConfig.dimLen_; i++) {
        dimVec_![i] *= scalar;
      }
    }
  }

  bool equals(Dimension dim2) {
    if (dimVec_ == null) {
      return dim2.dimVec_ == null;
    } else if (dim2.dimVec_ == null) {
      return false;
    } else {
      for (int i = 0; i < UcumConfig.dimLen_; i++) {
        if (dimVec_![i] != dim2.dimVec_![i]) {
          return false;
        }
      }
      return true;
    }
  }

  void assignDim(Dimension dim2) {
    if (dim2.dimVec_ == null) {
      dimVec_ = null;
    } else {
      dimVec_ = List<int>.from(dim2.dimVec_!);
    }
  }

  void assignZero() {
    dimVec_ = List<int>.filled(UcumConfig.dimLen_, 0);
  }

  bool isZero() {
    if (dimVec_ == null) {
      return false;
    } else {
      for (int element in dimVec_!) {
        if (element != 0) {
          return false;
        }
      }
      return true;
    }
  }

  bool isNull() => dimVec_ == null;

  Dimension clone() => Dimension(dimVec_);
}
