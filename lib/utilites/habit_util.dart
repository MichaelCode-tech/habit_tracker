bool isHabitCompletedToday(List<DateTime> completedDays) {
  final today = DateTime.now();
  return completedDays.any(
    (date) =>
        date.year == today.year &&
        date.month == today.month &&
        date.day == today.day,
  );
}

// prepare heat map dataset
Map<DateTime, int> prepareHeatMapDataset(List<dynamic> habits) {
  Map<DateTime, int> dataset = {};

  for (var habit in habits) {
    for (var date in habit.completedDays) {
      // normalize date to remove time
      final normalizedDate = DateTime(date.year, date.month, date.day);

      // if date already exists in dataset, increment count
      if (dataset.containsKey(normalizedDate)) {
        dataset[normalizedDate] = dataset[normalizedDate]! + 1;
      } else {
        // else initialize it with 1
        dataset[normalizedDate] = 1;
      }
    }
  }

  return dataset;
}

// calculate current streak
int calculateCurrentStreak(List<DateTime> completedDays) {
  if (completedDays.isEmpty) return 0;

  // sort dates from newest to oldest
  List<DateTime> sortedDates = List.from(completedDays)
    ..sort((a, b) => b.compareTo(a));

  int streak = 0;
  DateTime today = DateTime.now();
  DateTime currentDate = DateTime(today.year, today.month, today.day);

  // check if completed today or yesterday to continue streak
  bool completedToday = sortedDates.any((date) =>
      date.year == currentDate.year &&
      date.month == currentDate.month &&
      date.day == currentDate.day);

  DateTime yesterday = currentDate.subtract(const Duration(days: 1));
  bool completedYesterday = sortedDates.any((date) =>
      date.year == yesterday.year &&
      date.month == yesterday.month &&
      date.day == yesterday.day);

  if (!completedToday && !completedYesterday) {
    return 0;
  }

  // start counting from the most recent completion
  DateTime checkDate = completedToday ? currentDate : yesterday;

  while (true) {
    bool found = sortedDates.any((date) =>
        date.year == checkDate.year &&
        date.month == checkDate.month &&
        date.day == checkDate.day);

    if (found) {
      streak++;
      checkDate = checkDate.subtract(const Duration(days: 1));
    } else {
      break;
    }
  }

  return streak;
}

// Completion stats
int getMonthlyCompletionCount(List<DateTime> completedDays) {
  final now = DateTime.now();
  return completedDays
      .where((date) => date.year == now.year && date.month == now.month)
      .length;
}

int getYearlyCompletionCount(List<DateTime> completedDays) {
  final now = DateTime.now();
  return completedDays.where((date) => date.year == now.year).length;
}
