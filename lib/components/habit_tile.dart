import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MyHabitTile extends StatelessWidget {
  final void Function(bool?)? onChanged;
  final void Function(BuildContext)? editHabit;
  final void Function(BuildContext)? deleteHabit;
  final String text;
  final bool isCompleted;
  final int streak;

  const MyHabitTile({
    super.key,
    required this.isCompleted,
    required this.text,
    required this.streak,
    this.onChanged,
    this.editHabit,
    this.deleteHabit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: editHabit,
              backgroundColor: Colors.blue.withOpacity(0.8),
              foregroundColor: Colors.white,
              icon: Icons.edit,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
            ),
            SlidableAction(
              onPressed: deleteHabit,
              backgroundColor: Colors.red.withOpacity(0.8),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
          ],
        ),
        child: GestureDetector(
          onTap: () {
            if (onChanged != null) {
              onChanged!(!isCompleted);
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isCompleted
                  ? Theme.of(context).colorScheme.primary.withOpacity(0.8)
                  : Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                // Checkbox
                Transform.scale(
                  scale: 1.2,
                  child: Checkbox(
                    value: isCompleted,
                    onChanged: onChanged,
                    activeColor: Colors.white,
                    checkColor: Theme.of(context).colorScheme.primary,
                    side: BorderSide(
                      color: isCompleted ? Colors.white : Colors.grey.shade400,
                      width: 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Habit name and streak
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        text,
                        style: TextStyle(
                          color: isCompleted
                              ? Colors.white
                              : Theme.of(context).colorScheme.inversePrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          decoration: isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          decorationColor: Colors.white,
                        ),
                      ),
                      if (streak > 0)
                        Row(
                          children: [
                            Icon(
                              Icons.local_fire_department,
                              size: 14,
                              color: isCompleted ? Colors.orange.shade200 : Colors.orange,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "$streak day streak",
                              style: TextStyle(
                                fontSize: 12,
                                color: isCompleted
                                    ? Colors.white.withOpacity(0.8)
                                    : Colors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),

                // Options menu
                PopupMenuButton(
                  icon: Icon(
                    Icons.more_vert,
                    color: isCompleted
                        ? Colors.white
                        : Theme.of(context).colorScheme.inversePrimary.withOpacity(0.6),
                  ),
                  itemBuilder: (context) => [
                    // edit option
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 18),
                          SizedBox(width: 10),
                          Text("Edit"),
                        ],
                      ),
                    ),

                    // delete option
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 18, color: Colors.red),
                          SizedBox(width: 10),
                          Text("Delete", style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    if (value == 'edit' && editHabit != null) {
                      editHabit!(context);
                    } else if (value == 'delete' && deleteHabit != null) {
                      deleteHabit!(context);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
