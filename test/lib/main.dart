// Flutter imports:
import 'package:flutter/material.dart';

import 'fhir_path_test/fhir_path_test.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MaterialApp(
        theme: ThemeData.light(),
        home: const SafeArea(
          child: Scaffold(
            body: SizedBox(
              height: 200,
              width: 200,
              child: Center(
                  child: Column(
                children: <Widget>[
                  SizedBox(height: 8),
                  RunTests('FHIRPath Tests', fhirPathTest),
                  SizedBox(height: 8),
                ],
              )),
            ),
          ),
        ),
      );
}

class RunTests extends StatefulWidget {
  const RunTests(this.testName, this.test, {super.key});

  final String testName;
  final void Function() test;

  @override
  State<RunTests> createState() => _RunTestsState();
}

class _RunTestsState extends State<RunTests> {
  @override
  Widget build(BuildContext context) {
    String buttonText = 'Perform ${widget.testName}';
    return TextButton(
      child: Container(
          height: 100,
          width: 100,
          color: Colors.blue,
          child: Center(
            child: Text(
              buttonText,
              style: const TextStyle(color: Colors.white),
            ),
          )),
      onPressed: () {
        try {
          widget.test();
          setState(() {
            buttonText = 'running ${widget.testName}';
          });
        } catch (e) {
          setState(() {
            buttonText = '$e';
          });
        }
      },
    );
  }
}
