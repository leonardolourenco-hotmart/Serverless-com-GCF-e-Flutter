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
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'PUC SPOT MINAS'),
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
  final cont = 0;

  @override
  void initState() {
    super.initState();
    _getUserCurrentLocation();
    _listenUserLocation();
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  void _showAlert(BuildContext context, String campus) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Você chegou!"),
          content: Text("Bem vindo(a) à PUC Minas unidade " + campus),
          actions: [
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("FECHAR"))
          ],
        );
      },
    );
  } // end _showAlert()

  _getUserCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });
  } // end _getUserCurrentLocation()

  _listenUserLocation() {
    Geolocator.getPositionStream(
            desiredAccuracy: LocationAccuracy.best,
            timeInterval: 1000,
            distanceFilter: 50)
        .listen((Position position) {
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });
      // _tryCheckInCampus();
    });
  } // end _listenUserLocation()

  _tryCheckInCampus() async {
    await searchCampus(_currentPosition);
  } // _tryCheckInCampus()

  searchCampus(LatLng currentPosition) async {
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
  } // end searchCampus()

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('PUC SPOT MINAS'),
          backgroundColor: Colors.green[700],
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
