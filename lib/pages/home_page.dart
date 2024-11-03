import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_reader/pages/instagram_page.dart';
import 'package:qr_reader/pages/maps_pages.dart';
import 'package:qr_reader/pages/youtube_page.dart';
import 'package:qr_reader/providers/scan_list_provider.dart';
import 'package:qr_reader/providers/ui_provider.dart';
import 'package:qr_reader/pages/addresses_page.dart';
import 'package:qr_reader/widgets/custom_navigatorbar.dart';
import 'package:qr_reader/widgets/scan_button.dart';



class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    
    // Crear un ScanModel temporal y almacenarlo en la base de datos
    //final tempScan = ScanModel(valor: 'http://google.com');
    //DBProvider.db.nuevoScan(tempScan);

    //DBProvider.db.getScanById(3).then((scan) => print(scan!.valor));

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Historial'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: () {
              // Llamar al método deleteAll del ScanListProvider
              final scanListProvider = Provider.of<ScanListProvider>(context, listen: false);
              scanListProvider.deleteAll();
            },
          )
        ],
      ),
      body: _HomePageBody(),
      bottomNavigationBar: CustomNavigatorBar(),
      floatingActionButton: ScanButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class _HomePageBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final uiProvider = Provider.of<UiProvider>(context);
    final currentIndex = uiProvider.selectedMenuOpt;

    final scanListProvider = Provider.of<ScanListProvider>(context, listen: false);

    switch (currentIndex) {
      case 0:
        scanListProvider.loadScanByType('geo');
        return MapsPage();
      case 1:
        scanListProvider.loadScanByType('http');
        return AddressesPage();
      case 2:
        scanListProvider.loadScanByType('youtube');
        return YouTubePage();
      case 3:
        scanListProvider.loadScanByType('instagram');
        return InstagramPage();
      default:
        return MapsPage();
    }
  }
}
