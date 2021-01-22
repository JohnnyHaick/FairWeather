import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'GetLocation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(weatherApp());

class weatherApp extends StatefulWidget {
  @override
  _weatherAppState createState() => _weatherAppState();
}

class _weatherAppState extends State<weatherApp> {
  String apiKey = '2558757f095acba985450742deeae3ad';
  var description;
  var temp;
  String city;

  @override
  Widget build(BuildContext context) {
    //calling the location method
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: <Widget>[
            Container(
              //calling the displayImages to show the required picture
              child: displayImages(),
            ),
            //SizedBox(height: 50.0,),
            Container(
              margin: EdgeInsets.only(top: 50.0),
              child: Text(
                'You are in:',
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.blue[500],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                children: <Widget>[
                  Container(
                    child: Text(
                      city.toString(),
                      style: TextStyle(
                        fontSize: 35.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[500],
                      ),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Container(
                    child: Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 35.0,
                    ),
                  ),
                ],
              ),
            ),
            Card(
              margin: EdgeInsets.symmetric(vertical: 17.0, horizontal: 25.0),
              color: Colors.white,
              child: ListTile(
                leading: Icon(
                  Icons.wb_sunny,
                  color: Colors.amber,
                ),
                title: Text('Temperature: ${temp.toString()} C'),
                subtitle: Text('Status: ${description.toString()}'),
              ),
            ),
            Container(
              child: Center(
                child: FlatButton(
                  child: Text('Get weather info'),
                  color: Colors.blue[500],
                  textColor: Colors.white,
                  onPressed: (){
                    setState(() {
                      getLocation();

                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //display images based on current time
  displayImages() {
    var now = DateTime.now();
    //setting the current time
    final currentTime = DateFormat.jm().format(now);

    //if the time is morning
    if (currentTime.contains('AM')) {
      //to print the current time
      //print('the current time is: $currentTime');
      //now return the morning pic
      return Image.asset('images/dayTime.jpg');
    } else if (currentTime.contains('PM')) {
      //print('the current time is: $currentTime');
      return Image.asset('images/nightTime.jpg');
    }
  }

  //getLocation from the GetLocation class
  void getLocation() async {
    GetLocation getLocation = GetLocation();
    await getLocation.getCurrentLocation();
    print(getLocation.latitude);
    print(getLocation.longitude);
    print(getLocation.City);
    city = getLocation.City;
    getTemp(getLocation.latitude, getLocation.longitude);
  }

  //get current temp
  Future<void> getTemp(double lat, double lon) async{
    http.Response response = await http.get('https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric');
    print(response.body);

    //decoding the json body
    var dataDecoded = jsonDecode(response.body);
    description = dataDecoded['weather'][0]['description'];
    temp = dataDecoded['main']['temp'];
    print(temp);


  }
}
