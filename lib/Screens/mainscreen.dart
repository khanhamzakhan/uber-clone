import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './login_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../widgets/dividerWidget.dart';
import '../widgets/MainDrawer.dart';
import 'package:geolocator/geolocator.dart';

class MainScreen extends StatefulWidget {
  static const routeName = '/mainscreen';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  GlobalKey<ScaffoldState> _globalKey = new GlobalKey<ScaffoldState>();
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController newgoogleMapController;

  Position currentPostition;
  var geolocator = Geolocator();

  double bottomMapingofMap = 0;

  void locatePostion() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    currentPostition = position;

    LatLng latlngPosition = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition =
        new CameraPosition(target: latlngPosition, zoom: 14);

    newgoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  Widget buttonStyle(IconData icon, String text, String text2) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.grey,
        ),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Add $text address'),
            SizedBox(
              height: 4,
            ),
            Text(
              'Your $text2 address',
              style: TextStyle(color: Colors.black54, fontSize: 12),
            )
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: Text('Main Screen'),
        actions: [
          DropdownButton(
            items: [
              DropdownMenuItem(
                child: Row(
                  children: [
                    Icon(Icons.exit_to_app),
                    SizedBox(
                      width: 5,
                    ),
                    Text('Sign Out')
                  ],
                ),
                value: 'SignOut',
              )
            ],
            onChanged: (val) {
              if (val == 'SignOut') {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pushNamed(LogInScreen.routeName);
              }
            },
            icon: Icon(Icons.more_vert),
          )
        ],
      ),
      drawer: MainDrawer(),
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: bottomMapingofMap),
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              newgoogleMapController = controller;
              setState(() {
                bottomMapingofMap = 320;
              });
              locatePostion();
            },
          ),
          Positioned(
            top: 45,
            left: 22,
            child: GestureDetector(
              onTap: () {
                _globalKey.currentState.openDrawer();
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 6,
                          color: Colors.black,
                          offset: Offset(0.7, 0.7),
                          spreadRadius: 0.5)
                    ]),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.menu,
                    color: Colors.black,
                  ),
                  radius: 20.0,
                ),
              ),
            ),
          ),
          Positioned(
              left: 0.0,
              right: 0.0,
              bottom: 0.0,
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(18),
                        topRight: Radius.circular(18)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black,
                          blurRadius: 16,
                          offset: Offset(0.7, 0.7),
                          spreadRadius: 0.5)
                    ]),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 6),
                      Text(
                        'Hello there, ',
                        style: TextStyle(fontSize: 12),
                      ),
                      Text(
                        'Where to? ',
                        style:
                            TextStyle(fontSize: 20, fontFamily: 'Brand-Bold'),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 6,
                                  color: Colors.black54,
                                  offset: Offset(0.7, 0.7),
                                  spreadRadius: 0.5)
                            ]),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.search,
                                color: Colors.blueAccent,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text('Search Drop Off')
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      buttonStyle(Icons.home, 'Home', 'Living Home'),
                      SizedBox(
                        height: 10,
                      ),
                      DividerWidget(),
                      SizedBox(
                        height: 10,
                      ),
                      buttonStyle(Icons.work, 'Work', 'Office')
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
