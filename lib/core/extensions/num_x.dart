import 'package:flutter/material.dart';

/// Convenient spacing & dimension extensions on [num].
extension NumX on num {
  Widget get verticalSpace => SizedBox(height: toDouble());
  Widget get horizontalSpace => SizedBox(width: toDouble());
}
