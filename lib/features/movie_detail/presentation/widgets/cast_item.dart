import 'package:flutter/material.dart';
import '../../../home/data/models/movie_model.dart';

class CastItem extends StatelessWidget {
  final Actor actor;

  const CastItem({super.key, required this.actor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(actor.imageUrl),
          ),
          const SizedBox(height: 8),
          Text(
            actor.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            actor.role,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 10,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}