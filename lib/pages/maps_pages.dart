import 'package:flutter/material.dart';
import 'package:qr_reader/widgets/scan_tiles.dart';

class MapsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScanTiles(tipo: 'geo');
  }
}
