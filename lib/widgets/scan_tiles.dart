import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_reader/providers/scan_list_provider.dart';
import 'package:qr_reader/models/scan_model.dart';
import 'package:qr_reader/utils/utils.dart';

class ScanTiles extends StatelessWidget {
  final String tipo;

  const ScanTiles({required this.tipo});

  @override
  Widget build(BuildContext context) {
    final scanListProvider = Provider.of<ScanListProvider>(context);
    final List<ScanModel> scans = scanListProvider.scans;

    return ListView.builder(
      itemCount: scans.length,
      itemBuilder: (_, i) => Dismissible(
        key: UniqueKey(),
        background: Container(
          color: Colors.red,//Color del swipe de eliminación
        ),
        onDismissed: (DismissDirection direction) {
          Provider.of<ScanListProvider>(context, listen: false)
              .deleteScanById(scans[i].id!);
        },
        child: ListTile(
          leading: Icon(
            this.tipo == 'http' ? Icons.home_outlined : Icons.map_outlined,
            color: Theme.of(context).primaryColor,
          ),
          title: Text(scans[i].valor),
          subtitle: Text('ID: ${scans[i].id}'),
          trailing: Icon(Icons.keyboard_arrow_right, color: Colors.grey),
          onTap: () => launchURL(context, scans[i]),
        ),
      ),
    );
  }
}

IconData _getLeadingIcon(String tipo) {
    switch (tipo) {
      case 'geo':
        return Icons.map_outlined;
      case 'http':
        return Icons.home_outlined;
      case 'youtube':
        return Icons.video_library;
      case 'instagram':
        return Icons.camera_alt_outlined;
      default:
        return Icons.help_outline; // Para otros tipos desconocidos
    }
  }
