/// Extension for filtering lists by time ranges
/// 
/// Usage examples:
/// ```dart
/// // For objects with DateTime createdAt field:
/// final filtered = logs.filterByTimeRange('this week', (log) => log.createdAt);
/// 
/// // For objects with String createdAt field:
/// final filtered = items.filterByTimeRange('this month', (item) => DateTime.parse(item.createdAt));
/// 
/// // Supported filters: 'all time', 'this week', 'this month', 'this year'
/// ```
extension ListFilterExtension<T> on List<T> {
  /// Filters a list based on time period and item's createdAt field
  List<T> filterByTimeRange(String filter, DateTime Function(T) getCreatedAt) {
    if (filter.toLowerCase() == 'all time') {
      return this;
    }

    final now = DateTime.now();
    
    return where((item) {
      final itemDate = getCreatedAt(item);
      
      return switch (filter.toLowerCase()) {
        'this week' => itemDate.isInCurrentWeek(now),
        'this month' => itemDate.year == now.year && itemDate.month == now.month,
        'this year' => itemDate.year == now.year,
        _ => itemDate.toString().trim() == filter.trim(),
      };
    }).toList();
  }
}

extension DateTimeFilterExtension on DateTime {
  /// Checks if this DateTime is in the current week (Monday to Sunday)
  bool isInCurrentWeek(DateTime now) {
    // Get the start of the current week (Monday)
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    // Compare only the date part (ignore time)
    final itemDateOnly = DateTime(year, month, day);
    final startOfWeekOnly = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
    final endOfWeekOnly = DateTime(endOfWeek.year, endOfWeek.month, endOfWeek.day);

    return itemDateOnly.isAtSameMomentAs(startOfWeekOnly) ||
           itemDateOnly.isAtSameMomentAs(endOfWeekOnly) ||
           (itemDateOnly.isAfter(startOfWeekOnly) && itemDateOnly.isBefore(endOfWeekOnly));
  }
}

