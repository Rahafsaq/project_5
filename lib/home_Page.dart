import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class CityWeather {
  final String temp;
  final String humidity;
  final String error;
  final String img;
  final String feel;
  final String mytext;

  const CityWeather({
    this.temp = '',
    this.humidity = '',
    this.error = '',
    this.img = '',
    this.feel = '',
    this.mytext = '',
  });
}

class ForWeather {
  final String f_temp;
  final String date;
  final String error;

  const ForWeather({
    this.f_temp = '',
    this.date = '',
    this.error = '',
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final cityNameController = TextEditingController();
  String cityName = '';
  //String cityWeather = '12';

  CityWeather cityWeather = const CityWeather(temp: '', humidity: '', img: '', feel: '', mytext: '');
  ForWeather forWeather = const ForWeather(f_temp: '', date: '');

  Map<String, String> allWeather = {'hi': '12'};
  @override
  void dispose() {
    cityNameController.dispose();
    super.dispose();
  }

  Future<CityWeather> getWeather(String cityName) async {
    final url = Uri.https(
      'api.weatherapi.com',
      '/v1/current.json',
      {
        'key': '2b9bab6b6528479189a111917232602',
        'q': cityName,
        'aqi': 'no',
      },
    );

    final response = await http.get(url);
    final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    final error = jsonResponse['error'];
    if (error != null) {
      final message = (error['message'] ?? '') as String;
      return CityWeather(error: message);
    }

    final currentObject = jsonResponse['current'];
    final temp = currentObject['temp_c'];
    final hum = currentObject['humidity'];
    final imageUrl = currentObject['icon'];
    final feelLike = currentObject['feelslike_c'];
    final text = currentObject['text'];
    return CityWeather(temp: '$temp', humidity: '$hum', img: '$imageUrl', feel: '$feelLike', mytext: '$text');
  }

  Future<ForWeather> forecastWeather(String cityName) async {
    final url = Uri.https(
      'api.weatherapi.com',
      '/v1/forecast.json',
      {
        'key': 'a2b1d98e47594b3385d154456232602',
        'q': cityName,
        'aqi': 'no',
      },
    );
    //http: //api.weatherapi.com/v1/forecast.json?key=a2b1d98e47594b3385d154456232602&q=riyadh&days=1&aqi=no&alerts=no

    final response = await http.get(url);
    final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    final error = jsonResponse['error'];
    if (error != null) {
      final message = (error['message'] ?? '') as String;
      return ForWeather(error: message);
    }

    final forecastObject = jsonResponse['forecast'];
    final date = forecastObject['date'];
    final temp = forecastObject['temp_c'];
    return ForWeather(date: '$date', f_temp: '$date');
  }

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    // print(formattedDate);
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.topRight,
              colors: [Color(0xffe5dcae), Color(0xffd7f2f1), Color(0xfff5d8e9)]),
          shape: BoxShape.rectangle,
        ),
        child: Column(
          children: [
            Container(
              height: 350,
              width: 510,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
                image: DecorationImage(
                    image: NetworkImage(
                        'https://images.unsplash.com/photo-1656751609190-e0168efca2da?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxjb2xsZWN0aW9uLXBhZ2V8NXwxNDA4MDM3fHxlbnwwfHx8fA%3D%3D&auto=format&fit=crop&w=600&q=60'),
                    fit: BoxFit.cover),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 30, top: 20),
                    child: Row(
                      children: [
                        Text(formattedDate),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(30),
                    child: TextField(
                      decoration: const InputDecoration(label: Text('City name')),
                      controller: cityNameController,
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          cityName = cityNameController.text;
                        });
                        cityWeather = await getWeather(cityName);
                        setState(() {});
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffbfafab),
                      ),
                      child: const Text('Enter')),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    cityName,
                    style: const TextStyle(
                      fontSize: 30,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    //'{cityWeather.temp}$°C',
                    '${cityWeather.temp}°C',
                    style: const TextStyle(
                      fontSize: 25,
                    ),
                  ),
                  // Text(
                  //   //'{cityWeather.temp}$°C',
                  //   cityWeather.mytext,
                  //   style: const TextStyle(
                  //     fontSize: 25,
                  //   ),
                  // ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32),
              child: Row(
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: const BoxDecoration(
                        color: Color(0xffbfafab), borderRadius: BorderRadius.all(Radius.circular(18))),
                    child: Center(
                        child: Image.network(
                      '//cdn.weatherapi.com/weather/64x64/night/116.png',
                      height: 80,
                      width: 80,
                    )

                        //Image.network(cityWeather.img)),
                        ),
                  ),
                  const SizedBox(
                    width: 70,
                  ),
                  Container(
                    height: 100,
                    width: 100,
                    decoration: const BoxDecoration(
                        color: Color(0xffbfafab), borderRadius: BorderRadius.all(Radius.circular(18))),
                    child: Center(
                        child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10, left: 5),
                          child: Row(
                            children: [
                              Image.network(
                                'https://cdn-icons-png.flaticon.com/512/219/219816.png',
                                height: 25,
                                width: 25,
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              const Text('Humidity')
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          '${cityWeather.humidity}%',
                          // style: const TextStyle(fontSize: 20),
                        ),
                      ],
                    )),
                  ),
                  const SizedBox(
                    width: 70,
                  ),
                  Container(
                    height: 100,
                    width: 100,
                    decoration: const BoxDecoration(
                        color: Color(0xffbfafab), borderRadius: BorderRadius.all(Radius.circular(18))),
                    child: Center(
                        child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10, left: 2),
                          child: Row(
                            children: [
                              Image.network(
                                'https://cdn-icons-png.flaticon.com/512/4064/4064413.png',
                                height: 25,
                                width: 25,
                              ),
                              // const SizedBox(
                              //   width: 4,
                              // ),
                              const Text('Feels Like')
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          '${cityWeather.feel}°C',
                          //style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    )),
                  ),
                ],
              ),
            ),
            // Row(
            //   children: [
            //     // for (final temp in cityWeather)
            //     Container(
            //       height: 60,
            //       width: 120,
            //       decoration: const BoxDecoration(
            //           color: Color(0xffbfafab), borderRadius: BorderRadius.all(Radius.circular(18))),
            //       child: Column(
            //         children: [
            //           Text(forWeather.date),
            //           // Text(forWeather.f_temp),
            //         ],
            //       ),
            //     )
            //   ],
            // )
          ],
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}
