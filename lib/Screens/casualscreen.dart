import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geocoder/geocoder.dart';

class CasualScreen extends StatefulWidget {
  static const id = "casual_screen";
  CasualScreen({this.latitude, this.longitude});
  final double latitude;
  final double longitude;
  @override
  _CasualScreenState createState() => _CasualScreenState();
}

class _CasualScreenState extends State<CasualScreen> {
  final myController = TextEditingController();
  final dbRef = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  User loggedinuser;
  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  var address;
  var first;
  int complaints;
  @override
  void initState() {
    getCurrentUser();
    getNumberofComplaints();
    getMarkers();
    getAddress();
    super.initState();
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedinuser = user;
        print(loggedinuser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  void getNumberofComplaints() async {
    try {
      await dbRef
          .collection('Users')
          .doc(loggedinuser.email)
          .get()
          .then((value) {
        complaints = value.data()['no_of_complaints'];
        print("Complaints -----------$complaints");
      });
    } catch (e) {
      print(e);
    }
  }

  getMarkers() {
    dbRef.collection("Markers").get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((location) => initMarker(location.data));
    });
  }

  void getAddress() async {
    final coordinates = new Coordinates(widget.latitude, widget.longitude);
    address = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    first = address.first;
    print("${first.featureName} : ${first.addressLine}");
  }

  void initMarker(data) {
    var markerIdVal = data()['MarkerId'].toString();
    final MarkerId markerId = MarkerId(markerIdVal);
    double distanceInMeters = distanceBetween(widget.latitude, widget.longitude,
            data()['Coordinates'].latitude, data()['Coordinates'].longitude) /
        1000;
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(
          data()['Coordinates'].latitude, data()['Coordinates'].longitude),
      infoWindow: InfoWindow(
        title: data()['Markername'],
        snippet: '${double.parse(distanceInMeters.toStringAsFixed(2))} KMS',
        onTap: () {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: Color.fromRGBO(240, 243, 246, 1),
              contentPadding: EdgeInsets.symmetric(horizontal: 60.0),
              titlePadding:
                  EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0)),
              title: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.phone),
                    title: Text('Make Phone Call'),
                    onTap: () async {
                      await dbRef
                          .collection('Users')
                          .doc(loggedinuser.email)
                          .update({'no_of_complaints': complaints + 1});
                      await dbRef
                          .collection('Users')
                          .doc(loggedinuser.email)
                          .collection('Complaints')
                          .doc('complaint ${complaints + 1}')
                          .set({
                        'station': data()['Markername'],
                        'time': DateTime.now()
                      });
                      final phoneCall = launch("tel:${data()['phone']}");
                    },
                  ),
                  Divider(
                    thickness: 3.0,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    'SMS',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  ListTile(
                    //    leading: Icon(Icons.message),
                    title: TextField(
                      keyboardType: TextInputType.text,
                      controller: myController,
                      decoration: InputDecoration(
                        labelText: 'LandMark',
                        labelStyle: TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                    trailing: Icon(Icons.send),
                    onTap: () async {
                      var uri =
                          'sms:${data()['phone']}?body=I am under danger please help me my location is ${first.addressLine} and my coordinates are ${widget.latitude} , ${widget.longitude} LandMark:${myController.text}';
                      await dbRef
                          .collection('Users')
                          .doc(loggedinuser.email)
                          .update({'no_of_complaints': complaints + 1});

                      await dbRef
                          .collection('Users')
                          .doc(loggedinuser.email)
                          .collection('Complaints')
                          .doc('complaint ${complaints + 1}')
                          .set({
                        'complaint${complaints + 1}': uri,
                        'station': data()['Markername'],
                        'time': DateTime.now()
                      });
                      if (await canLaunch(uri)) {
                        await launch(uri);
                      } else {
                        throw 'Could not launch $uri';
                      }
                      myController.clear();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              actions: <Widget>[
                new FlatButton(
                  onPressed: () {
                    myController.clear();
                    Navigator.of(context).pop();
                  },
                  child: new Text(
                    'Cancel',
                  ),
                ),
              ],
            ),
          );
        },
      ),
      icon: BitmapDescriptor.defaultMarker,
    );
    setState(() {
      markers[markerId] = marker;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: GoogleMap(
                // mapType: MapType.hybrid,
                initialCameraPosition: CameraPosition(
                    target: LatLng(widget.latitude, widget.longitude),
                    zoom: 12),
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                markers: Set<Marker>.of(markers.values),
                compassEnabled: true,
                //  myLocationButtonEnabled: true,
                myLocationEnabled: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
