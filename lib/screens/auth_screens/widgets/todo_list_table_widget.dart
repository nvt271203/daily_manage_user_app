import 'package:daily_manage_user_app/helpers/format_helper.dart';
import 'package:daily_manage_user_app/helpers/tools_colors.dart';
import 'package:daily_manage_user_app/providers/user_provider.dart';
import 'package:daily_manage_user_app/providers/work_provider.dart';
import 'package:daily_manage_user_app/screens/auth_screens/nav_screens/home/screens/detail_work_screen.dart';
import 'package:daily_manage_user_app/widgets/loading_status_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TodoListTableWidget extends ConsumerStatefulWidget {
  TodoListTableWidget({super.key});

  @override
  _TodoListTableWidgetState createState() => _TodoListTableWidgetState();
}

class _TodoListTableWidgetState extends ConsumerState<TodoListTableWidget> {
  int _currentPage = 0;
  final _pageSize = 10;

  @override
  void initState() {
    super.initState();
    // Load dữ liệu khi màn hình được khởi tạo
    Future.microtask(() => ref.read(workProvider.notifier).fetchWorks());
  }

  @override
  Widget build(BuildContext context) {
    final workAsync = ref.watch(workProvider);

    return Column(
      children: [
        // Padding(
        //   padding: EdgeInsets.symmetric(horizontal: 100),
        //   child: Container(height: 2,color: Colors.blueGrey.withOpacity(0.5),),
        // ),
        // Row(children: [
        //   Icon(Icons.filter_alt_rounded,color: HelpersColors.primaryColor,),
        //   Text('Today'),
        //   Icon(Icons.keyboard_arrow_down)
        // ],),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: workAsync.when(
            loading: () => const Center(child: LoadingStatusBarWidget()),
            error: (err, _) => Center(child: Text('Lỗi khi tải dữ liệu: $err')),
            data: (workList) {
              // Nếu rỗng
              if (workList.isEmpty)
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.event_busy, size: 80, color: Colors.grey[400]),
                      SizedBox(height: 20),
                      Text(
                        "No Work Yet",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Text(
                          "You have not joined any job yet. Click the 'Check in' button above to start your first job.",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                );
              else{
                // Tính phân trang
                final startIndex = _currentPage * _pageSize;
                final endIndex = (_currentPage + 1) * _pageSize;
                final totalPages = (workList.length / _pageSize).ceil();
                final pagedWorkList = workList.sublist(
                  startIndex,
                  endIndex > workList.length ? workList.length : endIndex,
                );
        
                return Column(
                  children: [
                    // Header
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            HelpersColors.primaryColor,
                            HelpersColors.secondaryColor,
                          ],
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      child: Row(
                        children: const [
                          Expanded(
                            flex: 1,
                            child: Center(child: Text("No.", style: _headerStyle)),
                          ),
                          Expanded(
                            flex: 2,
                            child: Center(child: Text("Date", style: _headerStyle)),
                          ),
                          Expanded(
                            flex: 4,
                            child: Center(
                              child: Text("Working Time", style: _headerStyle),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Center(child: Text("Hours", style: _headerStyle)),
                          ),
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: Text("Details", style: _headerStyle),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 0),
        
                    ...pagedWorkList.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;
        
                      final checkIn = item.checkInTime.toLocal();
                      final checkOut = item.checkOutTime.toLocal();
                      final duration = item.workTime;
        
                      String formatDate(DateTime date) =>
                          "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}";
                      String formatTimeRange(DateTime start, DateTime end) {
                        String f(DateTime d) =>
                            "${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}";
                        return "${f(start)} – ${f(end)}";
                      }

                      String formatDuration(Duration d) {
                        String twoDigits(int n) => n.toString().padLeft(2, '0');
                        return "${twoDigits(d.inHours)}:${twoDigits(d.inMinutes % 60)}:${twoDigits(d.inSeconds % 60)}";
                      }
        
                      return Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 12,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Center(
                                    child: Text(
                                      "${index + 1 + _currentPage * _pageSize}.",style: TextStyle(fontSize: 12)
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Center(child: Text(formatDate(checkIn),style: TextStyle(fontSize: 12))),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Center(
                                    child: Text(formatTimeRange(checkIn, checkOut,),style: TextStyle(fontSize: 12),),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Center(
                                    child: Text(
                                      formatDuration(duration),
                                      // FormatHelper.formatDurationHH_MM(duration),
                                      style: TextStyle(
                                        color: HelpersColors.itemSelected,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Center(
                                    child: InkWell(
                                      onTap: () {
                                        // showDialog(
                                        //   context: context,
                                        //   builder: (context) =>
                                        //       DialogDetailWorkWidget(
                                        //         onConfirm: () {},
                                        //         work: item,
                                        //       ),
                                        // );
                                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                                          return DetailWorkScreen(onConfirm: () {
        
                                          }, work: item);
                                        },));
                                      },
                                      child: Text(
                                        "View",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: HelpersColors.itemPrimary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(height: 0),
                        ],
                      );
                    }).toList(),
        
                    // Phân trang
                    if (totalPages > 1) ...[
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: _currentPage > 0
                                ? () => setState(() => _currentPage--)
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _currentPage > 0
                                  ? Colors.blueAccent
                                  : Colors.black.withOpacity(0.4),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.arrow_back, size: 18, color: Colors.white),
                                SizedBox(width: 6),
                                Text(
                                  'Previous',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'Page ${_currentPage + 1} of $totalPages',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: _currentPage < totalPages - 1
                                ? () => setState(() => _currentPage++)
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _currentPage < totalPages - 1
                                  ? Colors.blueAccent
                                  : Colors.black.withOpacity(0.4),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Row(
                              children: [
                                Text('Next', style: TextStyle(color: Colors.white)),
                                SizedBox(width: 6),
                                Icon(
                                  Icons.arrow_forward,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                    SizedBox(height: 30,),


                  ],
                );
              }
            },
          ),
        ),
      ],
    );
  }
}

const TextStyle _headerStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
);
