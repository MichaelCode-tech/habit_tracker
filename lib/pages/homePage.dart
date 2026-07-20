import 'package:flutter/material.dart';
import 'package:habit_tracker/DB/DB.dart';
import 'package:habit_tracker/components/drawer.dart';
import 'package:habit_tracker/components/habit_tile.dart';
import 'package:habit_tracker/components/heat_map.dart';
import 'package:habit_tracker/models/habit.dart';
import 'package:habit_tracker/utilites/habit_util.dart';
import 'package:provider/provider.dart';

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  final TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<HabitDB>(context, listen: false).readHabits();
  }

  void checkHabitOnOff(bool? value, Habit habit) {
    if (value != null) {
      context.read<HabitDB>().updateHabitCompletion(habit.id, value);
    }
  }

  void createNewHabit() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("New Habit"),
        content: TextField(
          controller: textEditingController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: "What's the habit?",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              textEditingController.clear();
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              String newHabitName = textEditingController.text;
              if (newHabitName.isNotEmpty) {
                context.read<HabitDB>().addHabit(newHabitName);
                Navigator.pop(context);
                textEditingController.clear();
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void editHabitBox(Habit habit) {
    textEditingController.text = habit.name;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Edit Habit"),
        content: TextField(
          controller: textEditingController,
          autofocus: true,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              textEditingController.clear();
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              String newHabitName = textEditingController.text;
              if (newHabitName.isNotEmpty) {
                context.read<HabitDB>().updateHabitName(habit.id, newHabitName);
                Navigator.pop(context);
                textEditingController.clear();
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void deleteHabitBox(Habit habit) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Delete Habit?"),
        content: const Text("This action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade400,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              context.read<HabitDB>().deleteHabit(habit.id);
              Navigator.pop(context);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Habit Tracker",
          style: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewHabit,
        elevation: 4,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            // GREETING
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hello there!",
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.6),
                        ),
                      ),
                      Text(
                        "Track your progress",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
                    ],
                  ),
                  // App Icon Placeholder
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Image.asset(
                      'assets/icons/logo.png',
                      height: 30,
                      width: 30,
                    ),
                  ),
                ],
              ),
            ),

            // MOTIVATION QUOTE
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 5),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary.withOpacity(0.8),
                      Theme.of(context).colorScheme.primary,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "\"Success is the sum of small efforts, repeated day in and day out.\"",
                      style: TextStyle(
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "- Robert Collier",
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // SUMMARY STATS
            _buildSummaryStats(),

            // HEAT MAP
            _buildHeatMap(),

            const SizedBox(height: 10),

            // HABIT LIST TITLE
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
              child: Text(
                "My Habits",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
            ),

            // HABIT LIST
            _buildHabitList(),
            
            const SizedBox(height: 100), // Space for FAB
          ],
        ),
      ),
    );
  }

  Widget _buildHabitList() {
    final habitDB = context.watch<HabitDB>();
    List<Habit> currentHabits = habitDB.currentHabits;

    if (currentHabits.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            children: [
              Icon(Icons.spa_outlined, size: 60, color: Colors.grey.withOpacity(0.5)),
              const SizedBox(height: 10),
              Text(
                "No habits yet. Start small!",
                style: TextStyle(color: Colors.grey.shade500),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: currentHabits.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final habit = currentHabits[index];
        bool isCompletedToday = isHabitCompletedToday(habit.completedDays);
        int streak = calculateCurrentStreak(habit.completedDays);

        return MyHabitTile(
          text: habit.name,
          isCompleted: isCompletedToday,
          streak: streak,
          onChanged: (value) => checkHabitOnOff(value, habit),
          editHabit: (context) => editHabitBox(habit),
          deleteHabit: (context) => deleteHabitBox(habit),
        );
      },
    );
  }

  Widget _buildSummaryStats() {
    final habitDB = context.watch<HabitDB>();
    List<Habit> currentHabits = habitDB.currentHabits;

    int totalMonthly = 0;
    int totalYearly = 0;

    for (var habit in currentHabits) {
      totalMonthly += getMonthlyCompletionCount(habit.completedDays);
      totalYearly += getYearlyCompletionCount(habit.completedDays);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
      child: Row(
        children: [
          _buildStatCard("Monthly", totalMonthly.toString(), Icons.calendar_month),
          const SizedBox(width: 15),
          _buildStatCard("Yearly", totalYearly.toString(), Icons.history),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 5),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeatMap() {
    final habitDB = context.watch<HabitDB>();
    List<Habit> currentHabits = habitDB.currentHabits;

    return FutureBuilder<DateTime?>(
      future: habitDB.getFirstLaunchDate(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: MyHeatMap(
                startDate: snapshot.data!,
                datasets: prepareHeatMapDataset(currentHabits),
              ),
            ),
          );
        } else {
          return const SizedBox(height: 150);
        }
      },
    );
  }
}
