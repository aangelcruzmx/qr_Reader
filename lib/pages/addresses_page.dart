import 'package:flutter/material.dart';
import 'package:qr_reader/widgets/scan_tiles.dart';

class AddressesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScanTiles(tipo: 'http');
  }
}

