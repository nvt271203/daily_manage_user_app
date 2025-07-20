import 'package:flutter/material.dart';
import '../../../../../../models/work.dart';

class WorkGantChart extends StatelessWidget {
  final List<Work> works;
  final DateTime startOfWeek;

  const WorkGantChart({super.key, required this.works, required this.startOfWeek});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double chartWidth = constraints.maxWidth;
        final double hourWidth = chartWidth / 24;

        // ✅ Gom công việc theo ngày (có cả năm để tránh trùng)
        Map<String, List<Work>> worksByDay = {};
        for (var work in works) {
          final checkIn = work.checkInTime;
          final dayKey =
              "${checkIn.day.toString().padLeft(2, '0')}/${checkIn.month.toString().padLeft(2, '0')}/${checkIn.year}";
          worksByDay.putIfAbsent(dayKey, () => []).add(work);
        }

        final days = worksByDay.keys.toList();

        return ListView.builder(
          itemCount: days.length,
          itemBuilder: (context, index) {
            final day = days[index];
            final worksInDay = worksByDay[day]!;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Text(
                      day,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                  Container(
                    height: 32,
                    width: chartWidth,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      color: Colors.grey.shade100,
                    ),
                    child: Stack(
                      children: worksInDay.map((work) {
                        final checkIn = work.checkInTime;
                        final checkOut = work.checkOutTime;
                        final startHour = checkIn.hour + checkIn.minute / 60.0;
                        final endHour = checkOut.hour + checkOut.minute / 60.0;
                        final left = startHour * hourWidth;
                        final width = (endHour - startHour) * hourWidth;

                        return width <= 0 // Nếu chiều rộng âm -> ẩn Box đó đi
                            ? const SizedBox.shrink()
                            : Positioned(
                          left: left,
                          top: 2,
                          bottom: 2,
                          child: Container(
                            width: width,
                            decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Center(
                              child: Text(
                                "${checkIn.hour}:${checkIn.minute.toString().padLeft(2, '0')} - "
                                    "${checkOut.hour}:${checkOut.minute.toString().padLeft(2, '0')}",
                                style: const TextStyle(color: Colors.white, fontSize: 10),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
