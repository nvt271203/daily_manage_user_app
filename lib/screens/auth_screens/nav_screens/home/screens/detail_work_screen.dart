import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../helpers/tools_colors.dart';
import '../../../../../models/work.dart';

class DetailWorkScreen extends StatelessWidget {
  const DetailWorkScreen({
    super.key,
    required this.onConfirm,
    required this.work,
  });

  final Work work;
  final VoidCallback onConfirm;

  String _formatDate(DateTime dateTime) {
    return DateFormat('HH:mm:ss - dd/MM/yyyy').format(dateTime);
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
    Color? color,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: (color ?? Colors.blue).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(8),
            child: Icon(icon, color: color ?? Colors.blue, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String content,
    Color? color,
  }) {
    final Color mainColor = color ?? HelpersColors.primaryColor.withOpacity(0.8);
    final bool isEmpty = content.trim().isEmpty;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
        // border: Border.all(color: mainColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Header có nền nhẹ
          Container(
            decoration: BoxDecoration(
              color: mainColor.withOpacity(0.05),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: mainColor.withOpacity(0.08),
                    borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                  child: Icon(icon, size: 20, color: mainColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 15.5,
                          fontWeight: FontWeight.w700,
                          color: mainColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: HelpersColors.itemPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Divider mờ phân cách
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Divider(
              height: 1,
              thickness: 1,
              color: Colors.grey.shade200,
            ),
          ),

          // Nội dung
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
            child: Text(
              isEmpty ? '' : content,
              style: const TextStyle(
                fontSize: 14.5,
                height: 1.6,
                color: Color(0xFF333333),
              ),
            ),
          ),
        ],
      ),
    );
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xFFEFF6FF),
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Work Day Details'),
        centerTitle: true,
        backgroundColor: HelpersColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Time Information',
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                ),
              ),
            ),
            const SizedBox(height: 8),

            _buildInfoTile(
              icon: Icons.flag_rounded,
              label: 'Start Time',
              value: _formatDate(work.checkInTime),
              color: Colors.green,
            ),
            _buildInfoTile(
              icon: Icons.flag_rounded,
              label: 'End Time',
              value: _formatDate(work.checkOutTime),
              color: Colors.red,
            ),
            _buildInfoTile(
              icon: Icons.timer_rounded,
              label: 'Work Duration',
              value: _formatDuration(work.workTime),
              color: HelpersColors.itemPrimary,
            ),

            const SizedBox(height: 18),
            const Divider(thickness: 1),
            const SizedBox(height: 8),

            Center(
              child: Text(
                'Work Summary',
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                ),
              ),
            ),

            _buildTextCard(
              icon: Icons.assignment_outlined,
              title: 'Report',
              subtitle: 'Yesterday\'s tasks and results',
              content: work.report,
            ),
            _buildTextCard(
              icon: Icons.event_note,
              title: 'Plan',
              subtitle: 'Today\'s goals and plans',
              content: work.plan,
            ),
            _buildTextCard(
              icon: Icons.fact_check_outlined,
              title: 'Note',
              subtitle: 'Notes and support needs',
              content: work.note,
            ),
          ],
        ),
      ),
    );
  }
}


