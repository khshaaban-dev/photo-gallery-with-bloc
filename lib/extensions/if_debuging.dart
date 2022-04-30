import 'package:flutter/foundation.dart' show kDebugMode;

extension IfDebuging on String {
  String? get ifDebuging => kDebugMode ? this : null;
}
