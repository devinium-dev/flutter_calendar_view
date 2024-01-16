// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../calendar_event_data.dart';
import '../constants.dart';
import '../extensions.dart';
import '../style/header_style.dart';
import '../typedefs.dart';
import 'common_components.dart';

/// This class defines default tile to display in day view.
class RoundedEventTile extends StatelessWidget {
  /// Title of the tile.
  final String title;

  final String? timeDurationText;

  /// Description of the tile.
  final String? description;

  /// Background color of tile.
  /// Default color is [Colors.blue]
  final Color backgroundColor;

  /// If same tile can have multiple events.
  /// In most cases this value will be 1 less than total events.
  final int totalEvents;

  /// Padding of the tile. Default padding is [EdgeInsets.zero]
  final EdgeInsets padding;

  /// Margin of the tile. Default margin is [EdgeInsets.zero]
  final EdgeInsets margin;

  /// Border radius of tile.
  final BorderRadius borderRadius;

  /// Style for title
  final TextStyle? titleStyle;

  /// Style for description
  final TextStyle? descriptionStyle;

  /// This is default tile to display in day view.
  const RoundedEventTile({
    Key? key,
    required this.title,
    this.timeDurationText,
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
    this.description,
    this.borderRadius = BorderRadius.zero,
    this.totalEvents = 1,
    this.backgroundColor = Colors.blue,
    this.titleStyle,
    this.descriptionStyle,
  }) : super(key: key);

  bool get hasTitle => title.isNotEmpty;
  bool get hasTimeDurationText =>
      timeDurationText != null && timeDurationText!.trim().isNotEmpty;
  bool get hasDescription =>
      description != null && description!.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
      ),
      child: LayoutBuilder(
        builder: (_, constraints) {
          double remainingHeight = constraints.maxHeight;

          final titleTextStyle = titleStyle ??
              TextStyle(
                fontSize: calculateFontSize(
                  constraints.maxWidth,
                  14.0,
                  16.0,
                ),
                color: backgroundColor.accent,
                height: 1.5,
              );

          final timeDurationTextStyle = TextStyle(
            fontSize: calculateFontSize(
              constraints.maxWidth,
              12.0,
              14.0,
            ),
            color: backgroundColor.accent,
            height: 1.5,
          );

          final descriptionTextStyle = descriptionStyle ??
              TextStyle(
                fontSize: calculateFontSize(
                  constraints.maxWidth,
                  12.0,
                  14.0,
                ),
                color: backgroundColor.accent.withAlpha(200),
              );

          List<Widget> renderedTexts = [];

          void addTextWidget(Widget textWidget, double textHeight) {
            remainingHeight -= textHeight;
            if (remainingHeight >= 0) {
              renderedTexts.add(textWidget);
            }
          }

          if (hasTitle) {
            final titleHeight = calculateTextHeight(
                title, titleTextStyle, constraints.maxWidth);
            addTextWidget(
              Text(
                title,
                style: titleTextStyle,
                softWrap: true,
                overflow: TextOverflow.fade,
              ),
              titleHeight,
            );
          }

          if (hasTimeDurationText) {
            final timeDurationHeight = calculateTextHeight(
                timeDurationText!, timeDurationTextStyle, constraints.maxWidth);
            addTextWidget(
              Text(
                timeDurationText!,
                style: timeDurationTextStyle,
                softWrap: true,
                overflow: TextOverflow.fade,
              ),
              timeDurationHeight,
            );
          }

          if (hasDescription) {
            final descriptionHeight = calculateTextHeight(
                description!, descriptionTextStyle, constraints.maxWidth);
            addTextWidget(
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Text(
                  description!,
                  style: descriptionTextStyle,
                  softWrap: true,
                  overflow: TextOverflow.fade,
                ),
              ),
              descriptionHeight,
            );
          }

          if (totalEvents > 1) {
            final moreHeight = calculateTextHeight("+${totalEvents - 1} more",
                descriptionTextStyle, constraints.maxWidth);
            addTextWidget(
              Text(
                "+${totalEvents - 1} more",
                style: descriptionTextStyle,
                softWrap: true,
                overflow: TextOverflow.fade,
              ),
              moreHeight,
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: renderedTexts,
          );
        },
      ),
    );
  }

  double calculateTextHeight(String text, TextStyle? style, double maxWidth) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxWidth);
    return textPainter.size.height;
  }

  double calculateFontSize(
    double maxWidth,
    double fontSize,
    double maxFontSize,
  ) {
    const double minFactor = 0.85;
    // const double maxFactor = 1.2;

    double scaledFontSize = fontSize * (maxWidth / 375.0);

    // Ensure the font size doesn't go below the minimum factor
    scaledFontSize = scaledFontSize < fontSize * minFactor
        ? fontSize * minFactor
        : scaledFontSize;

    // Ensure the font size doesn't exceed the maximum factor
    return scaledFontSize > maxFontSize ? maxFontSize : scaledFontSize;
  }
}

/// A header widget to display on day view.
class DayPageHeader extends CalendarPageHeader {
  /// A header widget to display on day view.
  const DayPageHeader({
    Key? key,
    VoidCallback? onNextDay,
    AsyncCallback? onTitleTapped,
    VoidCallback? onPreviousDay,
    Color iconColor = Constants.black,
    Color backgroundColor = Constants.headerBackground,
    StringProvider? dateStringBuilder,
    required DateTime date,
    HeaderStyle headerStyle = const HeaderStyle(),
  }) : super(
          key: key,
          date: date,
          // ignore_for_file: deprecated_member_use_from_same_package
          backgroundColor: backgroundColor,
          iconColor: iconColor,
          onNextDay: onNextDay,
          onPreviousDay: onPreviousDay,
          onTitleTapped: onTitleTapped,
          dateStringBuilder:
              dateStringBuilder ?? DayPageHeader._dayStringBuilder,
          headerStyle: headerStyle,
        );

  static String _dayStringBuilder(DateTime date, {DateTime? secondaryDate}) =>
      "${date.day} - ${date.month} - ${date.year}";
}

class DefaultTimeLineMark extends StatelessWidget {
  /// Defines time to display
  final DateTime date;

  /// StringProvider for time string
  final StringProvider? timeStringBuilder;

  /// Text style for time string.
  final TextStyle? markingStyle;

  /// Time marker for timeline used in week and day view.
  const DefaultTimeLineMark({
    Key? key,
    required this.date,
    this.markingStyle,
    this.timeStringBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hour = ((date.hour - 1) % 12) + 1;
    final timeString = (timeStringBuilder != null)
        ? timeStringBuilder!(date)
        : date.minute != 0
            ? "$hour:${date.minute}"
            : "$hour ${date.hour ~/ 12 == 0 ? "am" : "pm"}";
    return Transform.translate(
      offset: Offset(0, -7.5),
      child: Padding(
        padding: const EdgeInsets.only(right: 7.0),
        child: Text(
          timeString,
          textAlign: TextAlign.right,
          style: markingStyle ??
              TextStyle(
                fontSize: 15.0,
              ),
        ),
      ),
    );
  }
}

/// This class is defined default view of full day event
class FullDayEventView<T> extends StatelessWidget {
  const FullDayEventView({
    Key? key,
    this.boxConstraints = const BoxConstraints(maxHeight: 100),
    required this.events,
    this.padding,
    this.itemView,
    this.titleStyle,
    this.onEventTap,
    required this.date,
  }) : super(key: key);

  /// Constraints for view
  final BoxConstraints boxConstraints;

  /// Define List of Event to display
  final List<CalendarEventData<T>> events;

  /// Define Padding of view
  final EdgeInsets? padding;

  /// Define custom Item view of Event.
  final Widget Function(CalendarEventData<T>? event)? itemView;

  /// Style for title
  final TextStyle? titleStyle;

  /// Called when user taps on event tile.
  final TileTapCallback<T>? onEventTap;

  /// Defines date for which events will be displayed.
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: boxConstraints,
      child: ListView.builder(
        itemCount: events.length,
        padding: padding ?? EdgeInsets.zero,
        shrinkWrap: true,
        itemBuilder: (context, index) => InkWell(
          onTap: () => onEventTap?.call(events[index], date),
          child: itemView?.call(events[index]) ??
              Container(
                margin: const EdgeInsets.all(5.0),
                padding: const EdgeInsets.all(1.0),
                height: 24,
                child: Text(
                  events[index].title,
                  style: titleStyle ??
                      TextStyle(
                        fontSize: 16,
                        color: events[index].color.accent,
                      ),
                  maxLines: 1,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: events[index].color,
                ),
                alignment: Alignment.centerLeft,
              ),
        ),
      ),
    );
  }
}
