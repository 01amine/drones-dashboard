
import 'package:drones_dashboard/domain/entities/drone.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constant/images.dart';

class DroneCard extends StatelessWidget {
  final Drone drone;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback? onViewLivestream;

  const DroneCard({
    Key? key,
    required this.drone,
    required this.isSelected,
    required this.onTap,
    this.onViewLivestream,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    switch (drone.status) {
      case 'armed':
        statusColor = const Color(0xFF2BFFC6);
        break;
      case 'error':
        statusColor = Colors.red;
        break;
      case 'offline':
        statusColor = Colors.grey;
        break;
      default:
        statusColor = Colors.amber;
    }

    return InkWell(
      onTap: onTap,
      child: Container(
        width: 270,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF222222),
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: const Color(0xFF2BFFC6), width: 2)
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  drone.status == 'offline'
                      ? Images.drone_off
                      : drone.batteryLevel < 20
                          ? Images.low_battery_drone
                          : Images.drone_on,
                  width: 24,
                  height: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  drone.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  drone.status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              label: 'Battery Level:',
              value: '${drone.batteryLevel}%',
              icon: Icons.battery_std,
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              label: 'Localisation:',
              value: '${drone.latitude.toStringAsFixed(6)}, ${drone.longitude.toStringAsFixed(6)}',
              icon: Icons.location_on_outlined,
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              label: 'State:',
              value: drone.status,
              icon: Icons.info_outline,
            ),
            if (onViewLivestream != null) ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: drone.status != 'offline' ? onViewLivestream : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E6F9F),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 36),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.videocam, size: 16),
                    const SizedBox(width: 8),
                    const Text('View Livestream'),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.white70,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}