import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lab1/currencyconvert.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'My Converter App',
        theme: ThemeData(primarySwatch: Colors.blueGrey),
        home: const SplashPage());
  }
}

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (content) => const HomePage())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  [
            const Text("Currency Convert App",
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
            Image.asset('assets/images/money.jpg', scale: 1.5),
            const Text("Version 1.0")
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectcountry = "MYR", selectcountry2 = "JPY";
  List<String> countryList = ["MYR", "JPY", "KRW", "CNY", "SGD"];
  var value = 0.0, number = 0.0, total = 0.0, desc = "";
  CurrencyConvert curconvert = CurrencyConvert(0.0);
  TextEditingController numberEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Currency Converter App", style: TextStyle(fontSize: 25))
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.money, size: 150, color: Colors.blue),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    DropdownButton(
                      itemHeight: 60,
                      value: selectcountry,
                      onChanged: (newValue) {
                        setState(() {
                          selectcountry = newValue.toString();
                        });
                      },
                      items: countryList.map((selectcountry) {
                        return DropdownMenuItem(
                          child: Text(selectcountry),
                          value: selectcountry,
                        );
                      }).toList(),
                    ),
                    DropdownButton(
                      itemHeight: 60,
                      value: selectcountry2,
                      onChanged: (newValue) {
                        setState(() {
                          selectcountry2 = newValue.toString();
                        });
                      },
                      items: countryList.map((selectcountry2) {
                        return DropdownMenuItem(
                          child: Text(selectcountry2),
                          value: selectcountry2,
                        );
                      }).toList(),
                    ),
                  ],
                ),
                TextField(
                  controller: numberEditingController,
                  decoration: InputDecoration(
                    hintText: 'Input amount of $selectcountry',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0)),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: _loadCurrency,
                    child: const Text("Show Currency")),
                const SizedBox(height: 20),
                const SizedBox(height: 20),
                Text(desc, style: const TextStyle(fontSize: 30)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _loadCurrency() async {
    var apiid = "78cb5070-3e0a-11ec-9e72-9d853cb6d466";
    var url = Uri.parse(
        'https://freecurrencyapi.net/api/v2/latest?apikey=$apiid&base_currency=$selectcountry');
    var response = await http.get(url);
    var rescode = response.statusCode;
    if (selectcountry == selectcountry2) {
    } else if (rescode == 200) {
      var jsonData = response.body;
      var data = json.decode(jsonData);
      // ignore: unnecessary_string_interpolations
      value = data['data']['$selectcountry2'];
      curconvert = CurrencyConvert(value);
    }
    setState(() {
      number = double.parse(numberEditingController.text);
      total = number * value;
      if (selectcountry == selectcountry2) {
        desc = "The " +
            selectcountry +
            " " +
            number.toStringAsFixed(2) +
            " is equals to " +
            selectcountry +
            " " +
            number.toStringAsFixed(2);
        return;
      } else {
        desc = "The " +
            selectcountry +
            " " +
            number.toStringAsFixed(2) +
            " is equals to " +
            selectcountry2 +
            " " +
            total.toStringAsFixed(2);
        return;
      }
    });
  }
}
