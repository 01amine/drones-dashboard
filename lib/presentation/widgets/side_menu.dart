import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/constant/images.dart';

class SidebarMenu extends StatelessWidget {
  final String currentRoute;
  final Function(String) onRouteSelected;

  const SidebarMenu({
    Key? key,
    required this.currentRoute,
    required this.onRouteSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 76,
      color: const Color(0xFF222222),
      child: Column(
        children: [
          // App Logo
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF2A2A2A),
            child: SvgPicture.asset(
              Images.xctrl,
              height: 28,
            ),
          ),

          // User Profile
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            color: currentRoute == '/profile'
                ? const Color(0xFF1E6F9F)
                : Colors.transparent,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF333333),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white70,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'unknown 34',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'PROGRAMMING TEAM',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 8,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Example usage of _buildNavItem (you can add more as needed)
          _buildNavItem(
            icon: Images.home,
            label: 'Home',
            route: '/home',
            isActive: currentRoute == '/home',
          ),
          _buildNavItem(
            icon: Images.error,
            label: 'Settings',
            route: '/settings',
            isActive: currentRoute == '/settings',
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required String icon,
    required String label,
    required String route,
    required bool isActive,
  }) {
    return InkWell(
      onTap: () => onRouteSelected(route),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        color: isActive ? const Color(0xFF1E6F9F) : Colors.transparent,
        child: Column(
          children: [
            SvgPicture.asset(
              icon,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                isActive ? Colors.white : Colors.white70,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.white70,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
