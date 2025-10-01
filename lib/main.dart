import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TemperatureWidget(),
    );
  }
}

class TemperatureWidget extends StatefulWidget {
  @override
  _TemperatureWidgetState createState() => _TemperatureWidgetState();
}

class _TemperatureWidgetState extends State<TemperatureWidget> {
  String temperature = "Loading...";
  Timer? timer;

  Future<void> fetchData() async {
    try {
      // Replace with your PC IP
      final url = Uri.parse("http://172.25.235.167:5000/data");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          temperature = "${data['temperature']} ${data['unit']}";
        });
      } else {
        setState(() {
          temperature = "Error: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        temperature = "Error: $e";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData(); // fetch once on startup

    // Auto-refresh every 500 ms
    timer = Timer.periodic(Duration(milliseconds: 500), (Timer t) {
      fetchData();
    });
  }

  @override
  void dispose() {
    timer?.cancel(); // stop timer when app closes
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Temperature Widget")),
      body: Center(
        child: Text(
          temperature,
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
