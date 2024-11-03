import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:qr_reader/models/scan_model.dart';

Future<void> launchURL(BuildContext context, ScanModel scan) async {
  final String valor = scan.valor;
  final Uri url = Uri.parse(valor);

  // Verificar el tipo de scan y abrir según corresponda
  if (scan.tipo == 'http' || scan.tipo == 'youtube' || scan.tipo == 'instagram') {
    try {
      // Intentar lanzar la URL
      if (await canLaunchUrl(url)) {
        bool launched = await launchUrl(
          url,
          mode: LaunchMode.externalApplication, // Abrir en el navegador predeterminado o aplicación
        );
        if (!launched) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('No se pudo abrir la URL: $url'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No se pudo abrir la URL: $url'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al abrir la URL: $e'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  } else if (scan.tipo == 'geo') {
    // Si es de tipo 'geo', llevar al mapa
    Navigator.pushNamed(context, 'map', arguments: scan);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tipo de scan no soportado: ${scan.tipo}'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
