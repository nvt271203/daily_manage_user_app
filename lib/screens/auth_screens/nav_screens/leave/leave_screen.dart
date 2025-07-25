import 'package:daily_manage_user_app/helpers/format_helper.dart';
import 'package:daily_manage_user_app/helpers/tools_colors.dart';
import 'package:daily_manage_user_app/widgets/loading_status_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../models/leave.dart';
import '../../../../providers/leave_provider.dart';
import 'screens/leave_request_screen.dart';
import 'screens/detail_leave_request.dart';

class LeaveScreen extends ConsumerStatefulWidget {
  const LeaveScreen({super.key});

  @override
  _LeaveScreenState createState() => _LeaveScreenState();
}

class _LeaveScreenState extends ConsumerState<LeaveScreen> with TickerProviderStateMixin  {
  int selectedYear = DateTime.now().year;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Gọi loadLeaves từ LeaveProvider
    Future.microtask(() => ref.read(leaveProvider.notifier).loadLeaves());
    _tabController = TabController(length: 3, vsync: this);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging == false) {
        setState(() {}); // Cập nhật UI khi đổi tab
      }
    });
  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }


  // mỗi nhóm theo tháng-năm sẽ được sắp xếp mới nhất lên đầu:
  Map<String, List<Leave>> groupWorksByMonthYear(List<Leave> leaves) {
    final Map<String, List<Leave>> grouped = {};
    for (var leave in leaves) {
      final createdDate = leave.dateCreated;
      final key =
          '${createdDate.month.toString().padLeft(2, '0')}-${createdDate.year}';
      grouped.putIfAbsent(key, () => []);
      grouped[key]!.add(leave);
    }

    // ✅ Sắp xếp từng nhóm theo dateCreated giảm dần
    for (var key in grouped.keys) {
      grouped[key]!.sort((a, b) => b.dateCreated.compareTo(a.dateCreated));
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final leaveState = ref.watch(leaveProvider);

    return DefaultTabController(
      length: 3,
      child: Container(
        color: Colors.white,
        child: SafeArea(
            child: Scaffold(
              // backgroundColor: Colors.transparent,
              backgroundColor: Colors.white,
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                     TabBar(
                       controller: _tabController, // 👈 thêm dòng này - Để lắng nghe sự kiện nhấn.
                      labelColor: HelpersColors.itemPrimary, // Màu chữ khi chọn
                      unselectedLabelColor: Colors.black.withOpacity(0.5), // màu chữ khi chưa chọn
                      // indicatorColor: Colors.deepOrange,
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                       indicatorSize: TabBarIndicatorSize.tab, // 👈 Cần dòng này để mở rộng nền

                       indicator: BoxDecoration(
                         color: HelpersColors.bgFillTextField, // nền của tab đang được chọn
                         // borderRadius: BorderRadius.all(Radius.circular(10)),
                       ),
                      tabs: [
                        Tab(text: 'Pending'),
                        Tab(text: 'Approved'),
                        // Tab(
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: [
                        //       const Text('Approved'),
                        //       const SizedBox(width: 6),
                        //       Container(
                        //         padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        //         decoration: BoxDecoration(
                        //           color: Colors.red,
                        //           borderRadius: BorderRadius.circular(12),
                        //         ),
                        //         child: const Text(
                        //           '1',
                        //           style: TextStyle(
                        //             color: Colors.white,
                        //             fontSize: 12,
                        //             fontWeight: FontWeight.bold,
                        //           ),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),

                        Tab(text: 'Rejected'),
                      ],
                    ),
                    SizedBox(height: 10),
      
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Recent leave history',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // Container(
                        //   padding: const EdgeInsets.symmetric(horizontal: 10),
                        //   decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.circular(20),
                        //     border: Border.all(color: HelpersColors.secondaryColor, width: 1),
                        //   ),
                        //   child: Row(
                        //     children: [
                        //       Text(selectedYear.toString(), style: TextStyle(fontWeight: FontWeight.bold)),
                        //
                        //       Icon(Icons.keyboard_arrow_down),
                        //     ],
                        //   ),
                        //
                        DropdownButton<int>(
                          value: selectedYear,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          underline: const SizedBox(),
                          // Ẩn gạch dưới
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          onChanged: (int? newValue) {
                            if (newValue != null) {
                              setState(() {
                                selectedYear = newValue;
                                // Gọi hàm lọc lại danh sách nếu cần
                              });
                            }
                          },
                          items: List.generate(10, (index) {
                            final year = DateTime.now().year - index;
                            return DropdownMenuItem(
                              value: year,
                              child: Text('$year'),
                            );
                          }),
                        ),
                      ],
                    ),
                    Container(
                      height: 2,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            HelpersColors.primaryColor,
                            HelpersColors.secondaryColor,
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
      
                    // Leave history
                    Expanded(
                      child: leaveState.when(
                        // loading: () => const Center(child: CircularProgressIndicator()),
                        loading: () =>
                            const Center(child: LoadingStatusBarWidget()),
                        error: (e, _) => Center(child: Text('Lỗi: $e')),
                          data: (leaves) {
                          if (leaves.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.event_busy,
                                    size: 80,
                                    color: Colors.grey[400],
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    "No Leave Requests Yet",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 30,
                                    ),
                                    child: Text(
                                      "You haven't submitted any leave requests. Tap the 'Leave Request' button below to request time off.",
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
                          }
      

                          // Lọc theo năm
                          // ✅ BƯỚC THÊM: Lọc dữ liệu theo selectedYear
                          // final filteredLeaves = leaves.where((leave) =>
                          // leave.dateCreated.year == selectedYear).toList();

                         return AnimatedBuilder(
                            animation: _tabController,
                            builder: (context, _) {
                              // Lọc theo tab trạng thái
                              final tabIndex = _tabController.index;
                              String selectedStatus;
                              if (tabIndex == 0) {
                                selectedStatus = 'Pending';
                              } else if (tabIndex == 1) {
                                selectedStatus = 'Approved';
                              } else {
                                selectedStatus = 'Rejected';
                              }

                              // Lọc theo năm và trạng thái
                              final filteredLeaves = leaves.where((leave) =>
                              leave.dateCreated.year == selectedYear &&
                                  leave.status == selectedStatus
                              ).toList();
                              // ✅ Nếu không có dữ liệu của năm được chọn
                              if (filteredLeaves.isEmpty) {
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.event_busy, size: 80, color: Colors.grey[400]),
                                      SizedBox(height: 20),
                                      Text(
                                        "No Leave Requests in $selectedYear",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        "You have no leave data for this year.",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[600],
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                );
                              }

                              final entries =
                              groupWorksByMonthYear(filteredLeaves).entries.toList()..sort((
                                  a,
                                  b,
                                  ) {
                                // final aDate = DateTime.parse(
                                //   '01-${a.key.split('-')[0]}-${a.key.split('-')[1]}',
                                // );
                                // final bDate = DateTime.parse(
                                //   '01-${b.key.split('-')[0]}-${b.key.split('-')[1]}',
                                // );
                                final aDate = DateTime.parse('${a.key.split('-')[1]}-${a.key.split('-')[0]}-01');
                                final bDate = DateTime.parse('${b.key.split('-')[1]}-${b.key.split('-')[0]}-01');
                                return bDate.compareTo(aDate);
                              });

                              return ListView.builder(
                                itemCount: entries.length,
                                itemBuilder: (context, index) {
                                  final entry = entries[index];
                                  final monthYear = entry.key;
                                  final items = entry.value;

                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.symmetric(vertical: 8),
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(

                                          color: Colors.orange.shade50,
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                            width: 2,
                                            color: Colors.black.withOpacity(0.3),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.calendar_month,
                                              color: Colors.deepOrange,
                                            ),
                                            const SizedBox(width: 12),
                                            Text(
                                              '$monthYear (${items.length} leave requests)',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.deepOrange.shade700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      ...items.map(
                                            (leave) => InkWell(
                                          onTap: () async{
                                            final result = await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return DetailLeaveRequest(
                                                    leave: leave,
                                                  );
                                                },
                                              ),
                                            );

                                            if (result == true) {
                                              ref.read(leaveProvider.notifier).loadLeaves(); // reload
                                            }

                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 20.0),
                                            child: LeaveHistoryItem(leave: leave),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 30),
                                    ],
                                  );
                                },
                              );

                            },
                          );





      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      

                        },
                      ),
                    ),
                  ],
                ),
              ),
      
              // Floating Button
              floatingActionButton: Container(
                padding: const EdgeInsets.all(10),
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.white.withOpacity(0.1), Colors.white],
                  ),
                ),
                child: Row(
                  children: [
                    const Spacer(),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            HelpersColors.primaryColor.withOpacity(0.3),
                            HelpersColors.secondaryColor.withOpacity(0.3),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: HelpersColors.secondaryColor.withOpacity(0.5),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: RawMaterialButton(
                        onPressed: () {
                          // Navigator.push(context, MaterialPageRoute(builder: (_) => const LeaveRequestScreen()));
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LeaveRequestScreen(),
                            ),
                          ).then((result) {
                            // ✅ Nếu result là true (nghĩa là vừa request thành công), thì load lại
                            if (result == true) {
                              ref.read(leaveProvider.notifier).loadLeaves();
                            }
                          });
                        },
                        shape: const CircleBorder(),
                        constraints: const BoxConstraints.tightFor(
                          width: 60,
                          height: 60,
                        ), // 👈 Đảm bảo nút là hình tròn
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.add, color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            ),
      
        ),
      ),
    );
  }
}

// Widget hiển thị từng đơn nghỉ phép
class LeaveHistoryItem extends StatelessWidget {
  final Leave leave;

  const LeaveHistoryItem({super.key, required this.leave});

  @override
  Widget build(BuildContext context) {
    final totalDaysLeaves =
        leave.endDate.difference(leave.startDate).inDays + 1;

    final color = leave.status == 'Pending'
        ? Colors.orange
        : leave.status == 'Approved'
        ? Color(0xFF00B2BF)
        : Colors.red;

    final icon = leave.status == 'Pending'
        ? Icons.timelapse_rounded
        : leave.status == 'Approved'
        ? Icons.check_circle
        : Icons.close_rounded;

    return IntrinsicHeight(
      child: Row(
        children: [
          Container(width: 2, color: Colors.black.withOpacity(0.3)),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 25, left: 5),
              decoration: BoxDecoration(
                border: Border.all(color: color, width: 2),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10,),
                        Row(
                          children: [
                            const Text('Time off: '),
                            Text(
                              FormatHelper.formatDate_DD_MM_YYYY(
                                leave.startDate,
                              ),
                              style: const TextStyle(fontSize: 13),
                            ),
                            const Text(' - '),
                            Text(
                              FormatHelper.formatDate_DD_MM_YYYY(leave.endDate),
                            ),
                            const Spacer(),
                            const Icon(Icons.chevron_right_outlined),
                          ],
                        ),
                        Text(
                          'Leave Type: ${leave.leaveType}',
                          style: const TextStyle(fontSize: 15),
                        ),
                        Text(
                          'Duration: $totalDaysLeaves day -  ${leave.leaveTimeType}',
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: -15,
                    left: 10,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(7)),
                        border: Border.all(width: 1, color: Colors.grey),
                        color: leave.status == 'Pending' ? Colors.orange.shade50
                            : leave.status == 'Approved' ? Color(0xFFCAE5E8)
                            : Color(0xFFFCDAD5)
                        ,

                      ),
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    child: Row(
                      children: [
                        Text(
                          '${FormatHelper.formatTimeHH_MM_AP(leave.dateCreated)} - ${FormatHelper.formatDate_DD_MM(leave.dateCreated)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 10,
                      ),
                      child: Row(
                        children: [
                          Icon(icon, color: Colors.white),
                          const SizedBox(width: 10),
                          Text(
                            leave.status,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
