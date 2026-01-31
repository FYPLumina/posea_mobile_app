import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomNavItem {
  final String iconPath;
  final String label;

  BottomNavItem({required this.iconPath, required this.label});
}

class CustomBottomNavigation extends StatefulWidget {
  const CustomBottomNavigation({
    super.key,
    required this.items,
    required this.onItemTapped,
    this.currentIndex = 0,
    this.activeColor = const Color(0xFF8B6F47),
    this.inactiveColor = Colors.grey,
    this.iconSize = 28,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  final List<BottomNavItem> items;
  final Function(int) onItemTapped;
  final int currentIndex;
  final Color activeColor;
  final Color inactiveColor;
  final double iconSize;
  final Duration animationDuration;

  @override
  State<CustomBottomNavigation> createState() => _CustomBottomNavigationState();
}

class _CustomBottomNavigationState extends State<CustomBottomNavigation>
    with TickerProviderStateMixin {
  late int _selectedIndex;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.currentIndex;
    _animationController = AnimationController(duration: widget.animationDuration, vsync: this);
    // Play animation on initial build to show default selected item
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward(from: 0.0);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(widget.items.length, (index) => _buildNavItem(index)),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final isSelected = _selectedIndex == index;
    final item = widget.items[index];

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
        _animationController.forward(from: 0.0);
        widget.onItemTapped(index);
      },
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          // Calculate offset: selected item moves up by 8 pixels
          final offset = isSelected
              ? Tween<double>(
                  begin: 0,
                  end: -8,
                ).evaluate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut))
              : 0.0;

          // Calculate scale: selected item scales up slightly
          final scale = isSelected
              ? Tween<double>(
                  begin: 1,
                  end: 1.1,
                ).evaluate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut))
              : 1.0;

          return Transform.translate(
            offset: Offset(0, offset),
            child: Transform.scale(
              scale: scale,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? widget.activeColor : Colors.transparent,
                    ),
                    child: Center(
                      child: _buildIcon(
                        item.iconPath,
                        isSelected ? Colors.white : widget.inactiveColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.label,
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected ? widget.activeColor : widget.inactiveColor,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildIcon(String iconPath, Color color) {
    if (iconPath.endsWith('.svg')) {
      return SvgPicture.asset(
        iconPath,
        width: widget.iconSize,
        height: widget.iconSize,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      );
    } else {
      return Image.asset(iconPath, width: widget.iconSize, height: widget.iconSize, color: color);
    }
  }
}
