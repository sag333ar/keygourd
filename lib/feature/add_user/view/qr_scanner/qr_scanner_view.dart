import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:keygourd/feature/add_user/view/qr_scanner/scanner_overlay.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerView extends StatefulWidget {
  const QRScannerView({super.key});

  @override
  State<QRScannerView> createState() => _QRScannerViewState();
}

class _QRScannerViewState extends State<QRScannerView> {
  final MobileScannerController cameraController = MobileScannerController();
  bool isPopped = false;

  @override
  void initState() {
    cameraController.start();
    super.initState();
  }

  @override
  void dispose() {
    cameraController.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Scanner'),
        actions: defaultTargetPlatform == TargetPlatform.android
            ? [
                IconButton(
                  color: Colors.white,
                  icon: ValueListenableBuilder(
                    valueListenable: cameraController.torchState,
                    builder: (context, state, child) {
                      switch (state) {
                        case TorchState.off:
                          return const Icon(Icons.flash_off,
                              color: Colors.grey);
                        case TorchState.on:
                          return const Icon(Icons.flash_on,
                              color: Colors.yellow);
                      }
                    },
                  ),
                  iconSize: 25.0,
                  onPressed: () => cameraController.toggleTorch(),
                ),
                IconButton(
                  color: Colors.white,
                  icon: ValueListenableBuilder(
                    valueListenable: cameraController.cameraFacingState,
                    builder: (context, state, child) {
                      switch (state) {
                        case CameraFacing.front:
                          return const Icon(Icons.camera_front);
                        case CameraFacing.back:
                          return const Icon(Icons.camera_rear);
                      }
                    },
                  ),
                  iconSize: 25.0,
                  onPressed: () => cameraController.switchCamera(),
                ),
              ]
            : null,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            MobileScanner(
              controller: cameraController,
              onDetect: (capture) {
                final List<Barcode> barcodes = capture.barcodes;
                String result = "";

                for (final barcode in barcodes) {
                  debugPrint('Barcode found! ${barcode.rawValue}');
                  result = barcode.rawValue.toString();
                }
                if (result.isNotEmpty && !isPopped) {
                  Navigator.pop(context, [result]);
                  isPopped = true;
                }
              },
            ),
            QRScannerOverlay(overlayColour: Colors.black.withOpacity(0.5))
          ],
        ),
      ),
    );
  }
}
