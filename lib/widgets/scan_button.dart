import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_reader/providers/scan_list_provider.dart';

class ScanButton extends StatefulWidget {
  @override
  _ScanButtonState createState() => _ScanButtonState();
}

class _ScanButtonState extends State<ScanButton> with WidgetsBindingObserver {
  final MobileScannerController controller = MobileScannerController();
  bool isOverlayVisible = false; // Control de visibilidad de la superposición
  bool isProcessing = false; // Evita el procesamiento doble del escaneo

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    controller.start();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused) {
      controller.stop();
    } else if (state == AppLifecycleState.resumed) {
      controller.start();
    }
  }

  void _toggleOverlay(bool visible) {
    setState(() {
      isOverlayVisible = visible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FloatingActionButton(
          child: Icon(Icons.filter_center_focus),
          onPressed: () async {
            final scanListProvider = Provider.of<ScanListProvider>(context, listen: false);
            _toggleOverlay(true);

            try {
              controller.start();
              await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) {
                  return AlertDialog(
                    title: Text('Escaneo de Código QR'),
                    content: AspectRatio(
                      aspectRatio: 1,
                      child: MobileScanner(
                        controller: controller,
                        fit: BoxFit.cover,
                        errorBuilder: (
                          BuildContext context,
                          MobileScannerException error,
                          Widget? child,
                        ) {
                          // Manejo de errores con mensajes claros
                          String errorMessage;
                          switch (error.errorCode) {
                            case MobileScannerErrorCode.controllerUninitialized:
                              errorMessage = 'El controlador no está listo.';
                              break;
                            case MobileScannerErrorCode.permissionDenied:
                              errorMessage = 'Permiso denegado';
                              break;
                            default:
                              errorMessage = 'Error de escáner';
                              break;
                          }
                          return Center(
                            child: Text(errorMessage, style: TextStyle(color: Colors.white)),
                          );
                        },
                        onDetect: (BarcodeCapture capture) {
                          // Verificar si ya estamos procesando un escaneo
                          if (!isProcessing) {
                            isProcessing = true;
                            final List<Barcode> barcodes = capture.barcodes;
                            for (final barcode in barcodes) {
                              String? code = barcode.rawValue;
                              if (code != null && code.isNotEmpty) {
                                debugPrint('Código escaneado: $code');
                                controller.stop(); // Detiene el escáner

                                Future.delayed(Duration(milliseconds: 300), () {
                                  if (mounted) {
                                    Navigator.of(context, rootNavigator: true).pop();
                                    scanListProvider.nuevoScan(code);
                                    _toggleOverlay(false);
                                  }
                                  isProcessing = false; // Restablece el bloqueo después del procesamiento
                                });
                                break;
                              }
                            }
                          }
                        },
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          controller.stop();
                          _toggleOverlay(false); 
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
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error al abrir el escáner QR: $e'),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          },
        ),
        if (isOverlayVisible)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Container(
                  width: 200,
                  height: 100,
                  color: Colors.white,
                  child: Center(child: Text('Escaneando...', style: TextStyle(fontSize: 18))),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
