import 'package:flutter/material.dart';

class TodoStatistics extends StatelessWidget {
  final int totalTodos;
  final int completedTodos;
  final int incompleteTodos;

  const TodoStatistics({
    super.key,
    required this.totalTodos,
    required this.completedTodos,
    required this.incompleteTodos,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    double completedPercentage = (completedTodos / totalTodos) * 100;
    double incompletePercentage = (incompleteTodos / totalTodos) * 100;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.1),
            blurRadius: 4,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
        borderRadius: BorderRadius.circular(20),
        color: theme.cardColor,
      ),
      child: Row(
        children: [
          _StatisticTile(
            label: 'Completed',
            percentage: completedPercentage,
            color: Colors.green,
          ),
          const SizedBox(width: 10),
          _StatisticTile(
            label: 'Incomplete',
            percentage: incompletePercentage,
            color: Colors.redAccent,
          ),
        ],
      ),
    );
  }
}

class _StatisticTile extends StatelessWidget {
  final String label;
  final double percentage;
  final Color color;

  const _StatisticTile({
    required this.label,
    required this.percentage,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: color.withOpacity(0.8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '${percentage.toStringAsFixed(2)}%',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
