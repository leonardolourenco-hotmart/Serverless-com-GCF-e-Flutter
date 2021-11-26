import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'MAPS'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GoogleMapController mapController;

  static LatLng _currentPosition;
  bool checkin = false;
  Timer timer;

  @override
  void initState() {
    super.initState();
    _getUserCurrentLocation();
    _listenUserLocation();
    timer =
        Timer.periodic(Duration(seconds: 30), (Timer t) => _checkInCampus());
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  void _showAlert(BuildContext context, String campus) {
    checkin = true;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text("Bem vindo à PUC Minas unidade " + campus),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            )
          ],
        );
      },
    );
  }

  void _getUserCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });
  }

  void _listenUserLocation() {
    Geolocator.getPositionStream(
            desiredAccuracy: LocationAccuracy.best,
            intervalDuration: Duration(seconds: 1),
            distanceFilter: 50)
        .listen((Position position) {
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });
      if (checkin) {
        timer.cancel();
      }
    });
  }

  _checkInCampus() async {
    await findCampus(_currentPosition);
  }

  findCampus(LatLng currentPosition) async {
    var lat, long;

    lat = currentPosition.latitude;
    long = currentPosition.longitude;
    String url =
        "https://us-central1-mediar-painel.cloudfunctions.net/micro-api?lat=$lat&lng=$long";

    var httpClient = new HttpClient();

    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == 200) {
        var json =
            await response.transform(utf8.decoder).asBroadcastStream().join();
        var data = jsonDecode(json);
        if (data['response'] == true) {
          _showAlert(context, data['campus']);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('MAPS'),
          backgroundColor: Colors.blue[600],
        ),
        body: _currentPosition == null
            ? Container(
                child: Center(child: CircularProgressIndicator()),
              )
            : GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _currentPosition,
                  zoom: 15,
                ),
                zoomGesturesEnabled: true,
                myLocationEnabled: true,
                compassEnabled: true,
                zoomControlsEnabled: false,
              ),
      ),
    );
  }
}
