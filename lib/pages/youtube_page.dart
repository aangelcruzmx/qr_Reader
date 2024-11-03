import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_reader/providers/scan_list_provider.dart';
import 'package:qr_reader/models/scan_model.dart';
import 'package:qr_reader/utils/utils.dart';

class YouTubePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scanListProvider = Provider.of<ScanListProvider>(context);
    final List<ScanModel> scans = scanListProvider.scans;

    return ListView.builder(
      itemCount: scans.length,
      itemBuilder: (_, i) => Dismissible(
        key: UniqueKey(),
        background: Container(
          color: Colors.red,
        ),
        onDismissed: (DismissDirection direction) {
          Provider.of<ScanListProvider>(context, listen: false)
              .deleteScanById(scans[i].id!);
        },
        child: ListTile(
          leading: Icon(
            Icons.video_library_outlined,
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
