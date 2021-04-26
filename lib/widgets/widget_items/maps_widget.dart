import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsWidget extends StatefulWidget {
  final String topic;
  final String payload;

  const MapsWidget({
    Key key,
    this.topic,
    this.payload,
  }) : super(key: key);

  @override
  _MapsWidgetState createState() => _MapsWidgetState();
}

class _MapsWidgetState extends State<MapsWidget> with WidgetsBindingObserver {
  final Completer<GoogleMapController> _controller = Completer();

  String _darkMapStyle;
  String _lightMapStyle;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadMapStyles();
  }

  @override
  void didChangePlatformBrightness() {
    setState(() {
      _setMapStyle();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future _loadMapStyles() async {
    _darkMapStyle = await rootBundle.loadString('assets/map_styles/dark.json');
    _lightMapStyle =
        await rootBundle.loadString('assets/map_styles/light.json');
  }

  Future _setMapStyle() async {
    final controller = await _controller.future;
    final theme = WidgetsBinding.instance.window.platformBrightness;
    if (theme == Brightness.dark) {
      await controller.setMapStyle(_darkMapStyle);
    } else {
      await controller.setMapStyle(_lightMapStyle);
    }
  }

  @override
  Widget build(BuildContext context) {
    final initialLocation =
        CameraPosition(zoom: 18, target: LatLng(37.807438, -122.419924));
    return GoogleMap(
      myLocationEnabled: true,
      initialCameraPosition: initialLocation,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
    );
  }
}
