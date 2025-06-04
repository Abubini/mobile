import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class SeatInfoWidget extends StatelessWidget {
  const SeatInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildInfoItem(AppColors.elementBg, 'Available'),
        const SizedBox(width: 15),
        _buildInfoItem(AppColors.primary, 'Selected'),
        const SizedBox(width: 15),
        _buildInfoItem(AppColors.secondary, 'Taken'),
      ],
    );
  }

  Widget _buildInfoItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 5),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}