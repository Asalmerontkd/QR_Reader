import 'package:flutter/material.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class MapaPage extends StatelessWidget {
  final MapController map = MapController();

  @override
  Widget build(BuildContext context) {
    final ScanModel scan = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Coordenadas QR'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.my_location), 
            onPressed: () {
              map.move(
                scan.getLatLng(),
                15
              );
            }
          )
        ],
      ),
      body: _crearFlutterMap( scan )
    );
  }

  Widget _crearFlutterMap( ScanModel scan ) {
    return FlutterMap(
      mapController: map,
      options: MapOptions(
        center: scan.getLatLng(),
        zoom: 15
      ),
      layers: [
        _crearMapa(),
        _crearMarcadores( scan ),
      ],
    );
  }

  _crearMapa() {
    return TileLayerOptions(
      urlTemplate: 'https://api.mapbox.com/v4/{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}',
      additionalOptions: {
        'accessToken' : 'pk.eyJ1IjoiYXNhbG1lcm9udGtkIiwiYSI6ImNrZXRmZmEzNDIzcG4yenNheThrdzI0MHoifQ.5ZMdAvyl2Sw_rQRs_mL_VA',
        'id' : 'mapbox.satellite' 
        // mapbox-streets-v8, satellite, mapbox.mapbox-terrain-v2, mapbox.mapbox-traffic-v1
      }
    );
  }

  _crearMarcadores( ScanModel scan ){
    return MarkerLayerOptions(
      markers: <Marker>[
        Marker(
          width: 100.0,
          height: 100.0,
          point: scan.getLatLng(),
          builder: ( context ) => Container(
            child: Icon(
              Icons.location_on, 
              size: 45.0,
              color: Theme.of(context).primaryColor,
            ),
          )
        )
      ]
    );
  }
}