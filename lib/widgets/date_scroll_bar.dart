import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

typedef OnDateSelected = void Function(DateTime date);

class DateScrollBar extends StatefulWidget {
  final OnDateSelected onDateSelected;
  const DateScrollBar({Key? key, required this.onDateSelected})
      : super(key: key);

  @override
  State<DateScrollBar> createState() => _DateScrollBarState();
}

class _DateScrollBarState extends State<DateScrollBar> {
  final ScrollController _ctrl = ScrollController();
  List<DateTime> dates = [];
  int selectedIndex = 10;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    // 10 দিন আগে থেকে 10 দিন পর পর্যন্ত লিস্ট
    for (int i = -10; i <= 10; i++) {
      dates.add(now.add(Duration(days: i)));
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _centerTo(selectedIndex, animate: false);
      widget.onDateSelected(dates[selectedIndex]);
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  String _label(DateTime d) {
    final now = DateTime.now();
    final todayStr = DateFormat('yyyyMMdd').format(now);
    final dateStr = DateFormat('yyyyMMdd').format(d);

    if (dateStr == todayStr) return 'Today';
    if (dateStr ==
        DateFormat('yyyyMMdd').format(now.subtract(const Duration(days: 1)))) {
      return 'Yesterday';
    }
    if (dateStr ==
        DateFormat('yyyyMMdd').format(now.add(const Duration(days: 1)))) {
      return 'Tomorrow';
    }

    const weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return weekdays[d.weekday % 7];
  }

  void _centerTo(int index, {bool animate = true}) {
    final itemWidth = 90.0;
    final screenWidth = MediaQuery.of(context).size.width;
    final target = (index * itemWidth) - (screenWidth / 2) + (itemWidth / 2);

    if (_ctrl.hasClients) {
      final clampedTarget = target.clamp(
        _ctrl.position.minScrollExtent,
        _ctrl.position.maxScrollExtent,
      );

      if (animate) {
        _ctrl.animateTo(
          clampedTarget,
          duration: const Duration(milliseconds: 450),
          curve: Curves.easeOutCubic,
        );
      } else {
        _ctrl.jumpTo(clampedTarget);
      }
    }
  }

  Future<void> _openCalendar() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: dates[selectedIndex],
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF0F3460),
              onPrimary: Colors.white,
              surface: Colors.white10, // Color(0xFF16213E)
              onSurface: Colors.white70,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        // নতুন তারিখ লিস্টে না থাকলে যোগ করো
        if (!dates.any((d) =>
            d.year == picked.year &&
            d.month == picked.month &&
            d.day == picked.day)) {
          dates.add(picked);
          dates.sort((a, b) => a.compareTo(b));
          selectedIndex = dates.indexWhere((d) =>
              d.year == picked.year &&
              d.month == picked.month &&
              d.day == picked.day);
        } else {
          selectedIndex = dates.indexWhere((d) =>
              d.year == picked.year &&
              d.month == picked.month &&
              d.day == picked.day);
        }
      });

      _centerTo(selectedIndex);
      widget.onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: const BoxDecoration(
        color: Color(0xFF16213E),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListView.builder(
        controller: _ctrl,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: dates.length + 1, // +1 for calendar icon
        itemBuilder: (context, i) {
          if (i == dates.length) {
            // Calendar Icon
            return GestureDetector(
              onTap: _openCalendar,
              child: Container(
                width: 90,
                margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F3460),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.calendar_month,
                    color: Colors.white, size: 30),
              ),
            );
          }

          final isSelected = i == selectedIndex;
          final date = dates[i];

          return GestureDetector(
            onTap: () {
              setState(() => selectedIndex = i);
              widget.onDateSelected(date);
              _centerTo(i);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              width: 90,
              margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
              decoration: BoxDecoration(
                color:
                    isSelected ? const Color(0xFF0F3460) : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color:
                      isSelected ? const Color(0xFF0F3460) : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _label(date),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? Colors.white : Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('dd').format(date),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    DateFormat('MMM').format(date),
                    style: TextStyle(
                      fontSize: 11,
                      color: isSelected ? Colors.white70 : Colors.white54,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
