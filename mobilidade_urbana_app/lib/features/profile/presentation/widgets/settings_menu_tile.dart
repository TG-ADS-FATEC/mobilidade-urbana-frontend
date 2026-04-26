import 'package:flutter/material.dart';
import 'package:mobilidade_urbana_app/utils/constants/colors.dart';
import 'package:mobilidade_urbana_app/utils/helpers/helper_functions.dart';
import 'package:mobilidade_urbana_app/utils/constants/sizes.dart';

class TSettingsMenuTile extends StatefulWidget {
  final IconData icon;
  final String title, subtitle;
  final Widget? trailing;
  final void Function() onTap;

  const TSettingsMenuTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    required this.onTap,
  });

  @override
  State<TSettingsMenuTile> createState() => _TSettingsMenuTileState();
}

class _TSettingsMenuTileState extends State<TSettingsMenuTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) => _controller.forward();

  void _onTapUp(TapUpDetails _) {
    _controller.reverse();
    widget.onTap();
  }

  void _onTapCancel() => _controller.reverse();

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                color: isDark
                    ? Color.lerp(TColors.darkSurface, Colors.white, _controller.value * 0.05)
                    : Color.lerp(TColors.surface, Colors.black, _controller.value * 0.04),
                borderRadius: BorderRadius.circular(12),
              ),
              child: child,
            );
          },
          child: ListTile(
            leading: Icon(
              widget.icon,
              size: TSizes.md,
              color: isDark ? TColors.grey : TColors.darkGrey,
            ),
            title: Text(widget.title, style: Theme.of(context).textTheme.titleSmall),
            subtitle: Text(widget.subtitle, style: Theme.of(context).textTheme.bodySmall),
            trailing: widget.trailing,
          ),
        ),
      ),
    );
  }
}