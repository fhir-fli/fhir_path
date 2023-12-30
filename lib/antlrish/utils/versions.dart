enum FhirVersionNew {
  dstu2,
  stu3,
  r4,
  r5,
}

extension FhirPathVersionExtensionNew on Map<String, dynamic> {
  static const versionKey = '_version';

  bool isVersion(FhirVersionNew version) => this[versionKey] == version;
  set version(FhirVersionNew version) => this[versionKey] = version;
}
