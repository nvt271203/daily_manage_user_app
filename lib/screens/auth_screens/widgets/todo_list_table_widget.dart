  import 'package:daily_manage_user_app/helpers/format_helper.dart';
  import 'package:daily_manage_user_app/helpers/tools_colors.dart';
  import 'package:daily_manage_user_app/providers/user_provider.dart';
  import 'package:daily_manage_user_app/providers/work_provider.dart';
  import 'package:daily_manage_user_app/screens/auth_screens/nav_screens/home/screens/detail_work_screen.dart';
  import 'package:daily_manage_user_app/widgets/loading_status_bar_widget.dart';
  import 'package:flutter/material.dart';
  import 'package:flutter_riverpod/flutter_riverpod.dart';
  
  class TodoListTableWidget extends ConsumerStatefulWidget {
    TodoListTableWidget({super.key, required this.selectedDate, this.showFilterDropdown = true});
    final DateTime selectedDate;
    final bool showFilterDropdown;
    @override
    _TodoListTableWidgetState createState() => _TodoListTableWidgetState();
  }
  
  class _TodoListTableWidgetState extends ConsumerState<TodoListTableWidget> {
    int _currentPage = 0;
    final _pageSize = 10;
    String _filterValue = ''; // khởi tạo sau khi biết selectedDate


    @override
    void initState() {
      super.initState();
      // Mặc định nếu ko phân trang thì sẽ sử dụng đoạn code này.
      // _filterValue = FormatHelper.formatDate_DD_MM_YYYY(widget.selectedDate);

      _filterValue = widget.showFilterDropdown
          ? FormatHelper.formatDate_DD_MM_YYYY(widget.selectedDate)
          : 'All';

      // Load dữ liệu khi màn hình được khởi tạo
      Future.microtask(() => ref.read(workProvider.notifier).fetchWorks());
    }
    @override
    void didUpdateWidget(covariant TodoListTableWidget oldWidget) {
      super.didUpdateWidget(oldWidget);
      if (oldWidget.selectedDate != widget.selectedDate) {
        setState(() {
          _filterValue =
              FormatHelper.formatDate_DD_MM_YYYY(widget.selectedDate);
        });
      }
    }

  
    @override
    Widget build(BuildContext context) {
      final workAsync = ref.watch(workProvider);
  
      return Container(
        child: Column(
          children: [
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 100),
            //   child: Container(height: 2,color: Colors.blueGrey.withOpacity(0.5),),
            // ),
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
          
                    // final totalPages = (workList.length / _pageSize).ceil();
          
          
                    // final pagedWorkList = workList.sublist(
                    //   startIndex,
                    //   endIndex > workList.length ? workList.length : endIndex,
                    // );
          
                    // lọc nếu là ngày hôm nay. thì trả về danh sách ngày hôm nay
                    final filteredWorkList = _filterValue != 'All'
                        ? workList.where((work) =>
                    work.checkInTime.toLocal().year == widget.selectedDate.year &&
                        work.checkInTime.toLocal().month == widget.selectedDate.month &&
                        work.checkInTime.toLocal().day == widget.selectedDate.day,
                    ).toList()
                        : workList;
          
                    // Tính phân trang
                    final startIndex = _currentPage * _pageSize;
                    final endIndex = (_currentPage + 1) * _pageSize;
                    final totalPages = (filteredWorkList.length / _pageSize).ceil();
          
                    final pagedWorkList = filteredWorkList.sublist(
                      startIndex,
                      endIndex > filteredWorkList.length ? filteredWorkList.length : endIndex,
                    );
          
          
          
          
                    return Column(
                      children: [
                        Padding(
                          padding: EdgeInsetsGeometry.symmetric(horizontal: 60),
                          child: Container(
                            height: 1,color: HelpersColors.itemPrimary.withOpacity(0.4),),
                        ),
                        SizedBox(height: 10,),
                        Row(
                          children: [
                            SizedBox(width: 20,),
                            Text('Work Time Board',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: HelpersColors.primaryColor),),
                            Spacer(),
                            if (widget.showFilterDropdown)
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {}, // Không làm gì khi nhấn icon, để dropdown hoạt động
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: HelpersColors.primaryColor.withOpacity(0.6)),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.filter_alt_rounded, color: HelpersColors.primaryColor, size: 20),
                                        const SizedBox(width: 14),
                                        DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            value: _filterValue,
                                            icon: const Icon(Icons.arrow_drop_down),
                                            iconEnabledColor: HelpersColors.primaryColor,
                                            dropdownColor: Colors.white,
                                            style: const TextStyle(fontSize: 14, color: Colors.black),
                                            onChanged: (value) {
                                              if (value != null) {
                                                setState(() {
                                                  _filterValue = value;
                                                });
                                              }
                                            },
                                            items: [
                                              DropdownMenuItem(
                                                value: FormatHelper.formatDate_DD_MM_YYYY(widget.selectedDate),
                                                child: Text("${FormatHelper.formatDate_DD_MM_YYYY(widget.selectedDate)}"),
                                              ),
                                              const DropdownMenuItem(
                                                value: 'All',
                                                child: Text('All Days'),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                  else
                  const SizedBox() // ẩn hoàn toàn nếu không show dropdown
        
                          ],
                        ),
                        SizedBox(height: 10,),
        
                        // Nếu như dữ liệu không rỗng thì ms cho phép hiện header - ngược lại hiển thị error.
                       if (filteredWorkList.isNotEmpty) ...[
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
                       ]else ...[
                         const SizedBox(height: 20),
                         Center(
                           child: Column(
                             children: [
                               Icon(Icons.event_busy, size: 80, color: Colors.grey[400]),
                               const SizedBox(height: 20),
                               Text(
                                 "No Work Yet",
                                 style: TextStyle(
                                   fontSize: 20,
                                   fontWeight: FontWeight.bold,
                                   color: Colors.grey[700],
                                 ),
                               ),
                               const SizedBox(height: 10),
                               Padding(
                                 padding: const EdgeInsets.symmetric(horizontal: 30),
                                 child: Text(
                                   _filterValue == 'All'
                                       ? "You have no work record for this day."
                                       : "You have not joined any job yet.",
                                   style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                                   textAlign: TextAlign.center,
                                 ),
                               ),
                             ],
                           ),
                         ),
        ]
        
                        ,
                        // Header
        
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
        ),
      );
    }
  }
  
  const TextStyle _headerStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );
