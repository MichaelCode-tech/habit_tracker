import 'package:flutter/material.dart';
import 'package:habit_tracker/models/appSettings.dart';
import 'package:habit_tracker/models/habit.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class HabitDB extends ChangeNotifier {
  static late Isar isar;

  /*
  
  I N I T I A L I Z E
  
  */

  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [HabitSchema, AppSettingsSchema],
      directory: dir.path,
    );
  }

  // Save first date of app startup (for heatmap)
  Future<void> saveFirstLaunchDate() async {
    final existingSettings = await isar.appSettings.where().findFirst();
    if (existingSettings == null) {
      final settings = AppSettings()
        ..firstLaunchData = DateTime.now()
        ..isDarkMode = false;
      await isar.writeTxn(() => isar.appSettings.put(settings));
    }
  }

  // Get first date of startup (for heatmap)
  Future<DateTime?> getFirstLaunchDate() async {
    final settings = await isar.appSettings.where().findFirst();
    return settings?.firstLaunchData;
  }

  // Get is dark mode
  Future<bool> getIsDarkMode() async {
    final settings = await isar.appSettings.where().findFirst();
    return settings?.isDarkMode ?? false;
  }

  // Update is dark mode
  Future<void> updateIsDarkMode(bool isDarkMode) async {
    final settings = await isar.appSettings.where().findFirst();
    if (settings != null) {
      settings.isDarkMode = isDarkMode;
      await isar.writeTxn(() => isar.appSettings.put(settings));
    }
  }

  /*
  
  C R U D  O P E R A T I O N S
  
  */

  // List of habits
  final List<Habit> currentHabits = [];

  // CREATE - add a new habit
  Future<void> addHabit(String habitName) async {
    // create a new habit
    final newHabit = Habit()..name = habitName;

    // save to db
    await isar.writeTxn(() => isar.habits.put(newHabit));

    // re-read from db
    readHabits();
  }

  // READ - read saved habits from db
  Future<void> readHabits() async {
    // fetch all habits from db
    List<Habit> fetchedHabits = await isar.habits.where().findAll();

    // give to current habits
    currentHabits.clear();
    currentHabits.addAll(fetchedHabits);

    // update UI
    notifyListeners();
  }

  // UPDATE - check habit on and off
  Future<void> updateHabitCompletion(int id, bool isCompleted) async {
    // find the specific habit
    final habit = await isar.habits.get(id);

    // update completion status
    if (habit != null) {
      await isar.writeTxn(() async {
        final today = DateTime.now();
        final todayDate = DateTime(today.year, today.month, today.day);

        // if habit is completed -> add the current date to the list
        if (isCompleted) {
          // add the current date if it's not already in the list
          if (!habit.completedDays.any((date) =>
              date.year == todayDate.year &&
              date.month == todayDate.month &&
              date.day == todayDate.day)) {
            habit.completedDays.add(todayDate);
          }
        }
        // if habit is NOT completed -> remove the current date from the list
        else {
          habit.completedDays.removeWhere((date) =>
              date.year == todayDate.year &&
              date.month == todayDate.month &&
              date.day == todayDate.day);
        }
        // save the updated habits back to the db
        await isar.habits.put(habit);
      });
    }

    // re-read from db
    readHabits();
  }

  // UPDATE - edit habit name
  Future<void> updateHabitName(int id, String newName) async {
    // find the specific habit
    final habit = await isar.habits.get(id);

    // update habit name
    if (habit != null) {
      // update name
      await isar.writeTxn(() async {
        habit.name = newName;
        // save back to db
        await isar.habits.put(habit);
      });
    }

    // re-read from db
    readHabits();
  }

  // DELETE - delete habit
  Future<void> deleteHabit(int id) async {
    // perform the delete
    await isar.writeTxn(() async {
      await isar.habits.delete(id);
    });

    // re-read from db
    readHabits();
  }
}
