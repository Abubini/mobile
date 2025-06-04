import 'package:flutter/material.dart';
import 'package:cinema_app/features/tickets/data/models/ticket_model.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../core/constants/app_colors.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:share_plus/share_plus.dart';

class TicketMenuWidget extends StatelessWidget {
  final Ticket ticket;
  final VoidCallback onDelete;
  final VoidCallback onReschedule;
  final GlobalKey qrKey;

  const TicketMenuWidget({
    super.key,
    required this.ticket,
    required this.onDelete,
    required this.onReschedule,
    required this.qrKey,
  });


  Future<void> _shareQR(BuildContext context) async {
  try {
    final qrData = '''
🎬 Movie: ${ticket.movieName}
📅 Date: ${ticket.formattedDate}
🕒 Time: ${ticket.formattedTime}
📍 Theater: ${ticket.theater}
💺 Seats: ${ticket.seats.join(', ')}
✅ Valid Ticket
''';

    final painter = QrPainter(
      data: qrData,
      version: QrVersions.auto,
      gapless: true,
      color: const Color(0xFF000000),
      emptyColor: const Color(0xFFFFFFFF),
    );

    final uiImage = await painter.toImage(512);
    final byteData = await uiImage.toByteData(format: ui.ImageByteFormat.png);
    final pngBytes = byteData!.buffer.asUint8List();

    final tempDir = await getTemporaryDirectory();
    final file = await File('${tempDir.path}/ticket_qr.png').create();
    await file.writeAsBytes(pngBytes);

    await Share.shareXFiles(
      [XFile(file.path)],
      text: 'Cinema Ticket QR Code 🎟️\n🎬 Movie: ${ticket.movieName}\n📅 Date: ${ticket.formattedDate} | 🕒: ${ticket.formattedTime}\n📍 Theater: ${ticket.theater}\n💺 Seats: ${ticket.seats.join(', ')} ',
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to share QR: ${e.toString()}')),
    );
  }
}



  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, color: AppColors.textMuted),
      onSelected: (value) async {
        switch (value) {
          case 'share':
            _shareQR(context);
            break;
            
          case 'reschedule':
            onReschedule();
            break;
          case 'delete':
            onDelete();
            break;
        }
      },
      itemBuilder: (BuildContext context) => [
        const PopupMenuItem<String>(
          value: 'share',
          child: Row(
            children: [
              Icon(Icons.share, size: 18, color: Colors.white),
              SizedBox(width: 8),
              Text('Share Ticket'),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: 'reschedule',
          child: Row(
            children: [
              Icon(Icons.calendar_today, size: 18, color: AppColors.accentBlue),
              SizedBox(width: 8),
              Text('Reschedule'),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete, size: 18, color: AppColors.secondary),
              SizedBox(width: 8),
              Text('Cancel Ticket'),
            ],
          ),
        ),
      ],
    );
  }
}