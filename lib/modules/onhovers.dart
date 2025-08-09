import 'package:flutter/material.dart';

class HoverText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final TextStyle? hoverStyle;

  const HoverText({super.key, required this.text, this.style, this.hoverStyle});

  @override
  _HoverTextState createState() => _HoverTextState();
}

class _HoverTextState extends State<HoverText> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click, // Change cursor on hover optionally
      child: Text(
        widget.text,
        style: _isHovered ? widget.hoverStyle ?? widget.style : widget.style,
      ),
    );
  }
}
