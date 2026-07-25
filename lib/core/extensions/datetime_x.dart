/// Extension methods on [DateTime] for surveillance timestamp formatting.
extension DateTimeX on DateTime {
  /// Formats time as HH:mm:ss.
  String get toTimeString {
    final h = hour.toString().padLeft(2, '0');
    final m = minute.toString().padLeft(2, '0');
    final s = second.toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  /// Formats date into Arabic formatted string e.g. 13 يوليو 2026.
  String get toArabicDateString {
    const months = [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر'
    ];
    final monthName = months[month - 1];
    return '$day $monthName $year';
  }
}
