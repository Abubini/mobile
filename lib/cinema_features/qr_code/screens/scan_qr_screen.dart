import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vibration/vibration.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';

class ScanQRScreen extends StatefulWidget {
  const ScanQRScreen({super.key});

  @override
  State<ScanQRScreen> createState() => _ScanQRScreenState();
}

class _ScanQRScreenState extends State<ScanQRScreen> with SingleTickerProviderStateMixin {
  late MobileScannerController cameraController;
  String? scannedData;
  bool _hasPermission = false;
  bool _showCamera = true;
  bool _isScanning = false;
  bool _cameraInitialized = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  void _initializeCamera() {
    cameraController = MobileScannerController(
      torchEnabled: false,
      formats: [BarcodeFormat.qrCode],
      returnImage: false,
    );
    _cameraInitialized = false;
  }

  Future<void> _checkCameraPermission() async {
    final status = await Permission.camera.status;
    if (!status.isGranted) {
      final result = await Permission.camera.request();
      setState(() => _hasPermission = result.isGranted);
    } else {
      setState(() => _hasPermission = true);
    }
  }

  void _handleQRScan(BarcodeCapture capture) async {
    if (_isScanning || !_cameraInitialized) return;
    
    setState(() => _isScanning = true);

    final barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate(duration: 200);
      }

      setState(() {
        scannedData = barcodes.first.rawValue;
        _showCamera = false;
        _isScanning = false;
      });
    } else {
      setState(() => _isScanning = false);
    }
  }

  Future<void> _restartScan() async {
    // Properly dispose and recreate the controller
    cameraController.dispose();
    setState(() {
      scannedData = null;
      _showCamera = true;
      _isScanning = false;
      _initializeCamera();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        title: Text('Scan QR Code', style: AppStyles.heading2),
        backgroundColor: AppColors.cardBg,
      ),
      body: !_hasPermission
          ? _buildPermissionDeniedView()
          : _showCamera 
              ? _buildCameraView() 
              : _buildResultView(),
      floatingActionButton: !_showCamera
          ? FloatingActionButton(
              onPressed: _restartScan,
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.camera_alt, color: Colors.white),
            )
          : null,
    );
  }

  Widget _buildCameraView() {
    return Stack(
      alignment: Alignment.center,
      children: [
        MobileScanner(
          controller: cameraController,
          onDetect: _handleQRScan,
          onScannerStarted: (arguments) {
            if (!mounted) return;
            setState(() => _cameraInitialized = true);
          },
          errorBuilder: (context, error, child) {
            return Center(child: Text('Camera Error: $error', style: AppStyles.bodyText));
          },
        ),
        _buildScanningOverlay(),
      ],
    );
  }

  Widget _buildScanningOverlay() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Container(
          width: 250,
          height: 250,
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.primary.withOpacity(_animationController.value * 0.7),
              width: 4,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: CustomPaint(
            painter: _CornerPainter(color: AppColors.primary),
          ),
        );
      },
    );
  }

  Widget _buildResultView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 80, color: AppColors.primary),
            const SizedBox(height: 20),
            Text('Scan Successful!', style: AppStyles.heading2),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                scannedData ?? 'No data found',
                style: AppStyles.bodyText,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionDeniedView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.camera_alt, size: 50, color: Colors.white),
          const SizedBox(height: 20),
          Text('Camera permission required', style: AppStyles.bodyText),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _checkCameraPermission,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
            child: Text('Grant Permission', style: AppStyles.buttonText),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    cameraController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}

class _CornerPainter extends CustomPainter {
  final Color color;

  _CornerPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    const cornerLength = 30.0;

    // Top-left corner
    canvas.drawLine(Offset.zero, const Offset(cornerLength, 0), paint);
    canvas.drawLine(Offset.zero, const Offset(0, cornerLength), paint);

    // Top-right corner
    canvas.drawLine(Offset(size.width, 0), Offset(size.width - cornerLength, 0), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width, cornerLength), paint);

    // Bottom-left corner
    canvas.drawLine(Offset(0, size.height), Offset(0, size.height - cornerLength), paint);
    canvas.drawLine(Offset(0, size.height), Offset(cornerLength, size.height), paint);

    // Bottom-right corner
    canvas.drawLine(Offset(size.width, size.height), Offset(size.width, size.height - cornerLength), paint);
    canvas.drawLine(Offset(size.width, size.height), Offset(size.width - cornerLength, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}