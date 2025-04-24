// drone_marker.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/constant/images.dart';

class DroneMarker extends StatelessWidget {
  final String droneId;
  final String droneName;
  final double batteryLevel;
  final String status;
  final bool isSelected;
  final Function() onTap;

  const DroneMarker({
    Key? key,
    required this.droneId,
    required this.droneName,
    required this.batteryLevel,
    required this.status,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Select appropriate drone icon based on status
    String droneIcon;
    if (status == 'offline') {
      droneIcon = Images.drone_off;
    } else if (status == 'error') {
      droneIcon = Images.drone_err;
    } else if (batteryLevel < 20) {
      droneIcon = Images.low_battery_drone;
    } else {
      droneIcon = Images.drone_on;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: isSelected
            ? BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF2BFFC6),
                  width: 2,
                ),
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              droneIcon,
              width: 36,
              height: 36,
            ),
            if (isSelected) ...[
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  droneName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}