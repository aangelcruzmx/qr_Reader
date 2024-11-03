import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:qr_reader/providers/scan_list_provider.dart';

/*
class ScanButton extends StatelessWidget {
  final MobileScannerController controller = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.filter_center_focus),
      onPressed: () async {
        final scanListProvider = Provider.of<ScanListProvider>(context, listen: false);

        try {
          // Iniciar el escáner al presionar el botón
          controller.start();
          await showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text('Escaneo de Código QR'),
                content: AspectRatio(
                  aspectRatio: 1,
                  child: MobileScanner(
                    controller: controller,
                    fit: BoxFit.cover,
                    onDetect: (capture) {
                      final List<Barcode> barcodes = capture.barcodes;
                      for (final barcode in barcodes) {
                        // Procesar el valor escaneado
                        String? code = barcode.rawValue;
                        if (code == '-1') {
                          // Código -1 indica que se canceló el escaneo
                          debugPrint('Escaneo cancelado por el usuario.');
                        } else if (code != null && code.isNotEmpty) {
                          // Código válido detectado, cerrar el escáner y agregar a la BD
                          debugPrint('Código escaneado: $code');

                          // Detener el escáner antes de cerrar el diálogo
                          controller.stop(); 

                          // Cerrar el escáner después de un pequeño retraso para permitir que los recursos de la cámara se liberen correctamente
                          Future.delayed(Duration(milliseconds: 200), () {
                            Navigator.of(context, rootNavigator: true).pop(); // Cerrar el escáner
                            scanListProvider.nuevoScan(code);
                          });

                          break; // Romper el ciclo para evitar múltiples lecturas
                        }
                      }
                    },
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      // Detener el escáner antes de cerrar el diálogo
                      controller.stop(); 
                      Future.delayed(Duration(milliseconds: 200), () {
                        Navigator.of(context, rootNavigator: true).pop(); // Cerrar el diálogo al presionar "Cancelar"
                      });
                    },
                    child: Text('Cancelar', style: TextStyle(color: Colors.red)),
                  ),
                ],
              );
            },
          );
        } catch (e) {
          // Mostrar un mensaje de error si ocurre algún problema
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al abrir el escáner QR: $e'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      },
    );
  }
}
*/

class ScanButton extends StatefulWidget {
  @override
  _ScanButtonState createState() => _ScanButtonState();
}

class _ScanButtonState extends State<ScanButton> with WidgetsBindingObserver {
  final MobileScannerController controller = MobileScannerController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    controller.dispose(); // Liberar el controlador adecuadamente
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused) {
      controller.stop(); // Detener el escáner si la app pasa a segundo plano
    } else if (state == AppLifecycleState.resumed) {
      controller.start(); // Reiniciar el escáner si la app vuelve a primer plano
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.filter_center_focus),
      onPressed: () async {
        final scanListProvider = Provider.of<ScanListProvider>(context, listen: false);

        try {
          controller.start(); // Iniciar el escáner
          await showDialog(
            context: context,
            barrierDismissible: false, // Evitar que se cierre accidentalmente
            builder: (_) {
              return AlertDialog(
                title: Text('Escaneo de Código QR'),
                content: AspectRatio(
                  aspectRatio: 1,
                  child: MobileScanner(
                    controller: controller,
                    fit: BoxFit.cover,
                    onDetect: (capture) {
                      final List<Barcode> barcodes = capture.barcodes;
                      for (final barcode in barcodes) {
                        String? code = barcode.rawValue;
                        if (code != null && code.isNotEmpty) {
                          debugPrint('Código escaneado: $code');

                          // Detener el escáner y cerrar el diálogo después de un pequeño retraso
                          controller.stop();
                          Future.delayed(Duration(milliseconds: 300), () {
                            if (mounted) {
                              Navigator.of(context, rootNavigator: true).pop(); // Cerrar el diálogo
                              scanListProvider.nuevoScan(code); // Agregar el nuevo scan

                              // Retornar a la pantalla principal después de un breve retraso
                              Future.delayed(Duration(milliseconds: 300), () {
                                if (mounted) {
                                  Navigator.of(context).pop();
                                }
                              });
                            }
                          });

                          break; // Detener el ciclo para evitar múltiples lecturas
                        }
                      }
                    },
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      // Detener el escáner y cerrar el diálogo
                      controller.stop();
                      Future.delayed(Duration(milliseconds: 300), () {
                        if (mounted) {
                          Navigator.of(context, rootNavigator: true).pop();
                        }
                      });
                    },
                    child: Text('Cancelar', style: TextStyle(color: Colors.red)),
                  ),
                ],
              );
            },
          );
        } catch (e) {
          // Mostrar un mensaje de error si ocurre algún problema
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al abrir el escáner QR: $e'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      },
    );
  }
}