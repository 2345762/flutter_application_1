import 'dart:async';
import 'package:flutter/material.dart';
import 'math_markdown_text.dart';

class TypewriterText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration speed;
  final VoidCallback? onComplete;
  final bool? isDarkMode;

  const TypewriterText({
    super.key,
    required this.text,
    this.style,
    this.speed = const Duration(milliseconds: 14),
    this.onComplete,
    this.isDarkMode,
  });

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText> {
  int _characterCount = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  @override
  void didUpdateWidget(TypewriterText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _startTyping();
    }
  }

  void _startTyping() {
    _timer?.cancel();
    _characterCount = 0;
    if (widget.text.isEmpty) return;

    _timer = Timer.periodic(widget.speed, (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_characterCount < widget.text.length) {
        setState(() {
          // Adjust character step size for longer texts so the animation stays engaging
          final step = widget.text.length > 500 ? 3 : (widget.text.length > 200 ? 2 : 1);
          _characterCount = (_characterCount + step).clamp(0, widget.text.length);
        });
      } else {
        timer.cancel();
        widget.onComplete?.call();
      }
    });
  }

  void _completeImmediately() {
    if (_characterCount < widget.text.length) {
      _timer?.cancel();
      setState(() {
        _characterCount = widget.text.length;
      });
      widget.onComplete?.call();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final displayedText = widget.text.substring(0, _characterCount);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _completeImmediately,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
        child: MathMarkdownText(
          text: displayedText,
          style: widget.style,
          isDarkMode: widget.isDarkMode,
          selectable: false,
        ),
      ),
    );
  }
}
