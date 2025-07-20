import 'package:daily_manage_user_app/providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/leave_controller.dart';
import '../models/leave.dart';
class LeaveProvider extends StateNotifier<AsyncValue<List<Leave>>>{
  final Ref ref;
  LeaveProvider(this.ref) : super(const AsyncValue.loading());

  Future<void> loadLeaves() async {
    final user = ref.read(userProvider);
    if(user != null){
      try{
        final leaves = await LeaveController().loadLeavesByUser(userId: user.id);
        state = AsyncValue.data(leaves);
      } catch (e, st) {
        state = AsyncValue.error(e, st);
      }
    }
  }

  /// Thêm một leave mới (ví dụ sau khi check-in hoặc thêm thủ công)
  void addLeave(Leave newLeave) {
    if (state is AsyncData) {
      final updated = [newLeave,...state.value!];
      state = AsyncValue.data(updated);
    }
  }
  Map<String, List<Leave>> get groupedByMonthYear {
    if (state is! AsyncData) return {};
    final leaves = state.value!;
    final Map<String, List<Leave>> grouped = {};
    for (var leave in leaves) {
      final key = '${leave.dateCreated.month.toString().padLeft(2, '0')}-${leave.dateCreated.year}';
      grouped.putIfAbsent(key, () => []);
      grouped[key]!.add(leave);
    }
    return grouped;
  }
}
// final leaveProvider = StateNotifierProvider<LeaveProvider, List<Leave>>((ref) => LeaveProvider(ref),);
final leaveProvider = StateNotifierProvider<LeaveProvider, AsyncValue<List<Leave>>>(
      (ref) => LeaveProvider(ref),
);
