// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';

import 'enumerations.dart';

/// Settings for hour lines
class HourIndicatorSettings {
  final double height;
  final Color color;
  final double offset;
  final LineStyle lineStyle;
  final double dashWidth;
  final double dashSpaceWidth;
  final double? widthEnds;

  /// Settings for hour lines
  const HourIndicatorSettings({
    this.height = 1.0,
    this.offset = 0.0,
    this.color = Colors.grey,
    this.lineStyle = LineStyle.solid,
    this.dashWidth = 4,
    this.dashSpaceWidth = 4,
    this.widthEnds,
  }) : assert(height >= 0, "Height must be greater than or equal to 0.");

  factory HourIndicatorSettings.none() => HourIndicatorSettings(
        color: Colors.transparent,
        height: 0.0,
      );
}
