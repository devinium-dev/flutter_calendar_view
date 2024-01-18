import 'package:flutter/material.dart';

import '../extensions.dart';

class OverlayTooltip extends StatefulWidget {
  final bool showOverlay;
  final String message;
  final Widget child;
  final double tooltipMaxWidth;
  final TextStyle tooltipTextStyle;
  final EdgeInsets toolTipTextPadding;

  OverlayTooltip({
    required this.message,
    required this.child,
    this.tooltipMaxWidth = 300.0,
    this.showOverlay = true,
    this.tooltipTextStyle = const TextStyle(fontSize: 12.0),
    this.toolTipTextPadding = const EdgeInsets.all(10.0),
  });

  @override
  _OverlayTooltipState createState() => _OverlayTooltipState();
}

class _OverlayTooltipState extends State<OverlayTooltip> {
  OverlayEntry? overlayEntry;
  bool isShowingOverlay = false;

  @override
  Widget build(BuildContext context) {
    // if (widget.message.isEmpty) {
    //   return const SizedBox();
    // }

    return Stack(
      children: [
        if (widget.showOverlay && overlayEntry != null)
          Container(
            color: Colors.grey.withOpacity(0.5),
          ),
        MouseRegion(
          onEnter: (e) {
            if (widget.showOverlay) {
              setState(() {
                // print('onEnter triggered');
                _createOverlayEntry(e.position);
              });
            } else {
              _createOverlayEntry(e.position);
            }
          },
          onExit: (_) {
            if (widget.showOverlay) {
              setState(() {
                _removeOverlayEntry();
              });
            } else {
              _removeOverlayEntry();
            }
          },
          child: widget.child,
        ),
      ],
    );
  }

  void _createOverlayEntry(Offset cursorPosition) {
    if (overlayEntry == null) {
      overlayEntry = OverlayEntry(
        builder: (context) => _buildTooltip(cursorPosition),
      );
      Overlay.of(context).insert(overlayEntry!);
    } else {
      overlayEntry!.markNeedsBuild();
    }
  }

  Widget _buildTooltip(Offset cursorPosition) {
    final size = MediaQuery.of(context).size;
    final screenHeight = size.height;
    final screenWidth = size.width;

    final textHeight = widget.message.calculateTextHeight(
      context: context,
      maxWidth: widget.tooltipMaxWidth,
      textStyle: widget.tooltipTextStyle,
      padding: widget.toolTipTextPadding,
    );

    double verticalOffset = cursorPosition.dy - 300.0;
    double horizontalOffset = cursorPosition.dx;

    if (verticalOffset < 0) {
      verticalOffset = 0;
    } else if (verticalOffset > screenHeight - textHeight) {
      verticalOffset = screenHeight - textHeight;
    }

    if (horizontalOffset + widget.tooltipMaxWidth + 50.0 > screenWidth) {
      horizontalOffset = cursorPosition.dx - (widget.tooltipMaxWidth + 50.0);
    }

    return Positioned(
      top: verticalOffset,
      left: horizontalOffset,
      child: Card(
        elevation: 4,
        child: Container(
          width: widget.tooltipMaxWidth,
          padding: widget.toolTipTextPadding,
          child: Text(
            widget.message,
            style: widget.tooltipTextStyle,
          ),
        ),
      ),
    );
  }

  // double calculateTextHeight({
  //   required String text,
  //   required double maxWidth,
  //   required TextStyle style,
  //   TextDirection textDirection = TextDirection.ltr,
  //   EdgeInsets? padding,
  // }) {
  //   final ts = TextSpan(
  //     text: text,
  //     style: style.copyWith(
  //       fontSize: MediaQuery.textScalerOf(context)
  //           .scale(widget.tooltipTextStyle.fontSize!),
  //     ),
  //   );

  //   final strutStyle = StrutStyle(
  //     fontSize: style.fontSize,
  //     height: 1.2, // Adjust as needed
  //   );

  //   final tp = TextPainter(
  //     text: ts,
  //     textDirection: textDirection,
  //     strutStyle: strutStyle,
  //   );
  //   tp.layout(maxWidth: maxWidth);

  //   final numLines = tp.computeLineMetrics().length;
  //   final textHeight = (numLines * tp.size.height);

  //   return textHeight;
  // }

  void _removeOverlayEntry() {
    overlayEntry?.remove();
    overlayEntry = null;
  }

  @override
  void dispose() {
    _removeOverlayEntry();
    super.dispose();
  }
}
