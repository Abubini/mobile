import 'dart:async';

import 'package:cinema_app/cinema_features/qr_code/data/qr_ticket_data.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vibration/vibration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
// import '../models/qr_ticket_data.dart';

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
  String _cinemaName = '';
  StreamSubscription<DocumentSnapshot>? _cinemaSubscription;
  QRTicketData? _ticketData;
  DateTime _scanTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _loadCinemaData();
  }

  Future<void> _loadCinemaData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _cinemaSubscription = FirebaseFirestore.instance
          .collection('cinemas')
          .doc(user.uid)
          .snapshots()
          .listen((snapshot) {
        if (snapshot.exists && mounted) {
          setState(() {
            _cinemaName = snapshot.data()?['name'] ?? 'CINEMA_ADMIN';
          });
        }
      });
    }
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
        _ticketData = QRTicketData.fromRawData(scannedData!);
        _scanTime = DateTime.now();
        _showCamera = false;
        _isScanning = false;
      });
    } else {
      setState(() => _isScanning = false);
    }
  }

  Future<void> _restartScan() async {
    cameraController.dispose();
    setState(() {
      scannedData = null;
      _ticketData = null;
      _showCamera = true;
      _isScanning = false;
      _initializeCamera();
    });
  }

  bool _isDateValid() {
    if (_ticketData?.parsedDate == null) return false;
    final ticketDate = _ticketData!.parsedDate!;
    final scanDate = DateTime(_scanTime.year, _scanTime.month, _scanTime.day);
    return ticketDate.isAtSameMomentAs(scanDate);
  }

  bool _isDateTooEarly() {
    if (_ticketData?.parsedDate == null) return false;
    final ticketDate = _ticketData!.parsedDate!;
    final scanDate = DateTime(_scanTime.year, _scanTime.month, _scanTime.day);
    return ticketDate.isAfter(scanDate);
  }

  bool _isDatePassed() {
    if (_ticketData?.parsedDate == null) return false;
    final ticketDate = _ticketData!.parsedDate!;
    final scanDate = DateTime(_scanTime.year, _scanTime.month, _scanTime.day);
    return ticketDate.isBefore(scanDate);
  }

  bool _isTimeValid() {
    if (_ticketData?.parsedTime == null) return false;
    final ticketTime = _ticketData!.parsedTime!;
    final oneHourBefore = ticketTime.subtract(const Duration(hours: 1));
    final oneHourAfter = ticketTime.add(const Duration(hours: 1));
    
    return _scanTime.isAfter(oneHourBefore) && _scanTime.isBefore(oneHourAfter);
  }

  bool _isTooEarly() {
    if (_ticketData?.parsedTime == null) return false;
    final ticketTime = _ticketData!.parsedTime!;
    final oneHourBefore = ticketTime.subtract(const Duration(hours: 1));
    return _scanTime.isBefore(oneHourBefore);
  }

  bool _isTooLate() {
    if (_ticketData?.parsedTime == null) return false;
    final ticketTime = _ticketData!.parsedTime!;
    return _scanTime.isAfter(ticketTime.add(const Duration(hours: 1)));
  }

  bool _isCinemaValid() {
    return _ticketData != null && 
           _cinemaName.isNotEmpty && 
           _ticketData!.theater.toLowerCase() == _cinemaName.toLowerCase();
  }

  bool _isTicketValid() {
    return _isCinemaValid() && _isDateValid() && _isTimeValid();
  }

  String _getDayName(DateTime date) {
    const days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    return days[date.weekday % 7];
  }

  String _formatTimeRemaining(Duration duration) {
    return '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
  }

  String _getInvalidReason() {
    if (!_isCinemaValid()) return 'Ticket is for another cinema';
    if (_isDatePassed()) return 'Expired ticket';
    if (_isDateTooEarly()) {
      final ticketDate = _ticketData!.parsedDate!;
      return 'Come back on ${_getDayName(ticketDate)}(${ticketDate.day})';
    }
    if (_isTooLate()) return 'Expired ticket';
    if (_isTooEarly()) {
      final ticketTime = _ticketData!.parsedTime!;
      final oneHourBefore = ticketTime.subtract(const Duration(hours: 1));
      final timeLeft = oneHourBefore.difference(_scanTime);
      return 'Come back in ${_formatTimeRemaining(timeLeft)}';
    }
    return 'Invalid ticket';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        backgroundColor: const Color(0xFF121212),
        foregroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/cinema/home'),
        ),
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
    final isCinemaValid = _isCinemaValid();
    final isDateValid = _isDateValid();
    final isTimeValid = _isTimeValid();
    final isTicketValid = _isTicketValid();
    final isDateTooEarly = _isDateTooEarly();
    final isDatePassed = _isDatePassed();
    final isTooEarly = _isTooEarly();
    final isTooLate = _isTooLate();

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isTicketValid ? Icons.check_circle : Icons.error,
              size: 80,
              color: isTicketValid ? AppColors.primary : Colors.red,
            ),
            const SizedBox(height: 20),
            Text(
              isTicketValid ? 'Valid Ticket' : 'Invalid Ticket',
              style: AppStyles.heading2.copyWith(
                color: isTicketValid ? AppColors.primary : Colors.red,
              ),
            ),
            if (!isTicketValid) ...[
              const SizedBox(height: 8),
              Text(
                _getInvalidReason(),
                style: AppStyles.bodyText.copyWith(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  _buildTicketInfoRow('🎬 Movie', _ticketData?.movieName ?? 'Unknown'),
                  _buildTicketInfoRow('🎭 Genre', _ticketData?.genre ?? 'Unknown'),
                  _buildDateTimeInfoRow(isDateValid, isTimeValid, isDateTooEarly, isDatePassed),
                  _buildTheaterInfoRow(isCinemaValid),
                  _buildTicketInfoRow('💺 Seats', _ticketData?.seats.join(', ') ?? 'Unknown'),
                  _buildTicketInfoRow('💰 Total', _ticketData?.cost ?? 'Unknown'),
                  _buildTicketInfoRow('Status', _ticketData?.status ?? 'Unknown'),
                  // _buildTicketInfoRow('Scanned At', _scanTime.toString()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text('$label: ', style: AppStyles.bodyText.copyWith(fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(value, style: AppStyles.bodyText),
          ),
        ],
      ),
    );
  }

  Widget _buildTheaterInfoRow(bool isValid) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text('📍 Cinema: ', style: AppStyles.bodyText.copyWith(fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(_ticketData?.theater ?? 'Unknown', 
              style: AppStyles.bodyText.copyWith(
                color: isValid ? Colors.green : Colors.red,
              ),
            ),
          ),
          Icon(
            isValid ? Icons.check : Icons.close,
            color: isValid ? Colors.green : Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildDateTimeInfoRow(bool isDateValid, bool isTimeValid, bool isDateTooEarly, bool isDatePassed) {
    final dateColor = isDateTooEarly || isDatePassed ? Colors.red : (isDateValid ? Colors.green : Colors.white);
    final timeColor = isTimeValid ? Colors.green : Colors.red;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Text('📅 Date: ', style: AppStyles.bodyText.copyWith(fontWeight: FontWeight.bold)),
              Expanded(
                child: Text(_ticketData?.date ?? 'Unknown', 
                  style: AppStyles.bodyText.copyWith(
                    color: dateColor,
                  ),
                ),
              ),
              Icon(
                isDateValid ? Icons.check : Icons.close,
                color: dateColor,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Text('🕒 Time: ', style: AppStyles.bodyText.copyWith(fontWeight: FontWeight.bold)),
              Expanded(
                child: Text(_ticketData?.time ?? 'Unknown', 
                  style: AppStyles.bodyText.copyWith(
                    color: timeColor,
                  ),
                ),
              ),
              Icon(
                isTimeValid ? Icons.check : Icons.close,
                color: timeColor,
              ),
            ],
          ),
        ),
      ],
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
    _cinemaSubscription?.cancel();
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