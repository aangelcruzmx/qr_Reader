import 'package:flutter/material.dart';
import 'package:qr_reader/models/scan_model.dart';
import 'package:qr_reader/providers/db_provider.dart';

class ScanListProvider extends ChangeNotifier {
  List<ScanModel> scans = [];
  String tipoSeleccionado = 'http';

  // Método para agregar un nuevo scan
  Future<ScanModel> nuevoScan(String valor) async {
    final nuevoScan = new ScanModel(valor: valor);
    final id = await DBProvider.db.nuevoScan(nuevoScan);

    // Asignar el ID al nuevo Scan
    nuevoScan.id = id;

    // Solo agregar el scan si coincide con el tipo seleccionado
    if (nuevoScan.tipo == tipoSeleccionado) {
      scans.add(nuevoScan);
      notifyListeners();
    }

    return nuevoScan;
  }

  // Método para cargar todos los scans de la base de datos
  loadScans() async {
    final scans = await DBProvider.db.getAllScans();
    this.scans = [...scans];
    notifyListeners();
  }

// Método para cargar scans por tipo (http, geo, youtube, instagram)
loadScanByType(String tipo) async {
  final scans = await DBProvider.db.getScansByTipo(tipo);
  this.scans = [...scans];
  this.tipoSeleccionado = tipo;
  notifyListeners();
}



  // Método para borrar todos los scans
  deleteAll() async {
    await DBProvider.db.deleteAllScans();
    this.scans = [];
    notifyListeners();
  }

  // Método para borrar un scan por id
  deleteScanById(int id) async {
    await DBProvider.db.deleteScan(id);
    this.scans.removeWhere((scan) => scan.id == id);
    notifyListeners();
  }

  // Método para cargar scans por tipo (http, geo, twitter, instagram)


}
