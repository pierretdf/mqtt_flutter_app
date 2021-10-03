import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class GaugeWidget extends StatelessWidget {
  final String topic;
  final String payload;
  const GaugeWidget({
    Key key,
    this.topic,
    this.payload,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(
      axes: <RadialAxis>[
        RadialAxis(
          maximum: 150,
          ranges: <GaugeRange>[
            GaugeRange(startValue: 0, endValue: 50, color: Colors.green),
            GaugeRange(startValue: 50, endValue: 100, color: Colors.orange),
            GaugeRange(startValue: 100, endValue: 150, color: Colors.red)
          ],
          pointers: <GaugePointer>[const NeedlePointer(value: 90)],
          annotations: <GaugeAnnotation>[
            const GaugeAnnotation(
                widget:
                    // 90 is the value from the payload --> Decoding JSON payload
                    // must be "dynamic" because each MQTT broker send different JSON message structure
                    // Must implement a quick tuto of which variable useful for which widget
                    // Problem: if JSON attributes is nested ???
                    // Solution: add a forEach loop on Map if value key isn't find ! --> value in nested position
                    // e.g. value, lat, lon, etc.
                    // json = jsonDecode(payload)
                    // json['value']; json['lat']; json['lon']
                    // https://flutter.dev/docs/development/data-and-backend/json#serializing-json-inline

                    Text('90.0',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                angle: 90,
                positionFactor: 0.5)
          ],
        )
      ],
    );
  }
}
