import 'package:flutter/material.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';
import 'package:flutter_map/flutter_map.dart';

class MapaPage extends StatefulWidget {
  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  MapController map = MapController();

  String tipoMapa = 'satellite';

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
      body: _crearFlutterMap( scan ),
      floatingActionButton: _crearBotonFlotante( context, scan),
    );
  }

  Widget _crearBotonFlotante( BuildContext context, ScanModel scan ){
    return FloatingActionButton(
      onPressed: () {
        setState(() {
          // mapbox-streets-v8, satellite, mapbox.mapbox-terrain-v2, mapbox.mapbox-traffic-v1
          if ( tipoMapa == 'mapbox-streets-v8' ){
            tipoMapa = 'satellite';
          } else if( tipoMapa == 'satellite'){
            tipoMapa = 'mapbox-terrain-v2';
          } else if( tipoMapa == 'mapbox-terrain-v2'){
            tipoMapa = 'mapbox-traffic-v1';
          } else{
            tipoMapa = 'mapbox-streets-v8';
          }
        });
        print(tipoMapa);
        map.move(scan.getLatLng(), 30);
        //Regreso al Zoom Deseado después de unos Milisegundos
        Future.delayed(Duration(milliseconds: 50),(){
        map.move(scan.getLatLng(), 15);
        });
      },
      child: Icon( Icons.repeat ),
      backgroundColor: Theme.of(context).primaryColor,
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
        'id' : 'mapbox.$tipoMapa' 
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