import 'package:flutter/material.dart';

class ReadMoreTextWidget extends StatefulWidget {
  final String text;
  final int trimLines;
  final TextStyle? style;
  final String readMoreText;
  final String readLessText;
  final Color linkColor;

  const ReadMoreTextWidget({
    Key? key,
    required this.text,
    this.trimLines = 3,
    this.style,
    this.readMoreText = "اقرأ المزيد",
    this.readLessText = "اقرأ أقل",
    this.linkColor = Colors.blue,
  }) : super(key: key);

  @override
  _ReadMoreTextWidgetState createState() => _ReadMoreTextWidgetState();
}

class _ReadMoreTextWidgetState extends State<ReadMoreTextWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final textStyle = widget.style ?? Theme.of(context).textTheme.displayMedium;

    return LayoutBuilder(
      builder: (context, constraints) {
        final span = TextSpan(text: widget.text, style: textStyle);
        final tp = TextPainter(
          text: span,
          maxLines: widget.trimLines,
          textDirection: TextDirection.rtl, // للغة العربية
        );
        tp.layout(maxWidth: constraints.maxWidth);

        final isOverflow = tp.didExceedMaxLines;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.text,
              style: textStyle,
              maxLines: _isExpanded ? null : widget.trimLines,
              overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
              textAlign: TextAlign.start,
            ),
            if (isOverflow)
              GestureDetector(
                onTap: () => setState(() => _isExpanded = !_isExpanded),
                child: Text(
                  _isExpanded ? widget.readLessText : widget.readMoreText,
                  style: textStyle?.copyWith(
                    color: widget.linkColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
