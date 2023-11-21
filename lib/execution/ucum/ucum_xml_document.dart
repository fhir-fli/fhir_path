import 'dart:io';

import 'package:xml/xml.dart';

import 'ucum.dart'; // Use the appropriate XML package for parsing XML files

class UcumXmlDocument {
  final essenceFile_ = '../data/ucum-essence.xml';
  XmlDocument? xmlInput_;
  late List<String> moleCodes_;

  UcumXmlDocument() {
    var data = File(essenceFile_).readAsStringSync();
    xmlInput_ = XmlDocument.parse(data);

    moleCodes_ = ['mol', 'eq', 'osm', 'kat', 'U'];
  }

  void parseXml() {
    parsePrefixes(xmlInput_!.findAllElements('prefix').toList());
    parseBaseUnits(xmlInput_!.findAllElements('base-unit').toList());
    parseUnitStrings(xmlInput_!.findAllElements('unit').toList());

    writeJsonFile();
    writeVersionText();
  }

  void parsePrefixes(List<XmlElement> prefixes) {
    for (var curPfx in prefixes) {
      var attrs = {
        'code_': curPfx.getAttribute('Code'),
        'ciCode_': curPfx.getAttribute('CODE'),
        'name_': curPfx.findElements('name').single.value,
        'printSymbol_': curPfx.findElements('printSymbol').single.value,
      };

      var pValNode = curPfx.findElements('value').single;
      if (pValNode.findElements('sup').isNotEmpty) {
        attrs['exp_'] = pValNode.findElements('sup').single.value;
        attrs['value_'] = 10.0 ^ int.parse(attrs['exp_']!);
      } else {
        attrs['value_'] = pValNode.value;
        attrs['exp_'] = null;
      }

      var ptab =
          PrefixTables.getInstance(); // Assuming PrefixTables is a singleton
      if (ptab.isDefined(attrs['code_']!)) {
        throw (Exception(
            'Prefix constructor called for prefix already defined; code = ${attrs["code_"]}'));
      } else {
        var newPref = Prefix(
            attrs); // Assuming Prefix is a class that takes attributes in its constructor
        ptab.add(newPref);
      }
    }
  }

  void parseBaseUnits(List<XmlElement> unitNodes) {
    // Logic for parsing base units
    // ...

    // Example implementation of parsing base units:
    for (var curBUnit in unitNodes) {
      // Logic for parsing each base unit
      // ...
    }
  }

  void parseUnitStrings(List<XmlElement> unitStrings) {
    // Logic for parsing unit strings
    // ...

    // Example implementation of parsing unit strings:
    for (var curUA in unitStrings) {
      // Logic for parsing each unit string
      // ...
    }
  }

  void writeJsonFile() {
    // Logic for writing JSON file
    // ...
  }

  void writeVersionText() {
    // Logic for writing version text
    // ...
  }
}
