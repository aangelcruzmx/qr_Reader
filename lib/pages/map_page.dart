import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:qr_reader/models/scan_model.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Completer<GoogleMapController> _controller = Completer();
  
  // Propiedad para manejar el tipo de mapa
  MapType mapType = MapType.normal;

  @override
  Widget build(BuildContext context) {
    // Obtener el scan que se ha pasado como argumento
    final ScanModel scan = ModalRoute.of(context)!.settings.arguments as ScanModel;

    // Configurar la posicin inicial del mapa segun las coordenadas del scan
    final CameraPosition initialPoint = CameraPosition(
      target: scan.getLatLng(), // Usando el nuevo metodo getLatLng()
      zoom: 17, // Ajustar el zoom a 17
    );

    // Crear el set de marcadores y añadir un marcador en la ubicación del scan
    Set<Marker> markers = Set<Marker>();
    markers.add(
      Marker(
        markerId: MarkerId('geo-location'),
        position: scan.getLatLng(),
      ),
    );

return Scaffold(
  appBar: AppBar(
    title: Text('Mapa'),
    actions: [
      IconButton(
        icon: Icon(Icons.location_on),
        onPressed: () async {
          // Volver a centrar la camara en el punto inicial
          final GoogleMapController controller = await _controller.future;
          controller.animateCamera(
            CameraUpdate.newCameraPosition(initialPoint),
          );
        },
      )
    ],
  ),
  body: Stack(
    children: [
      GoogleMap(
        mapType: mapType, // Utilizar el tipo de mapa actual
        initialCameraPosition: initialPoint,
        markers: markers, // Añadir los marcadores al mapa
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        myLocationButtonEnabled: false, // Deshabilitar boton de ubicación
      ),
      Positioned(
        bottom: 100,
        right: 5,
        child: FloatingActionButton(
          child: Icon(Icons.layers),
          onPressed: () {
            // Cambiar entre tipo de mapa normal y satelite eb un solo toque
            if (mapType == MapType.normal) {
              mapType = MapType.satellite;
            } else {
              mapType = MapType.normal;
            }
            setState(() {});
          },
        ),
      ),
    ],
  ),
);

  }
}
