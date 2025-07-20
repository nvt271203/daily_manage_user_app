import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controller/work_controller.dart';
import '../models/work.dart';
import 'user_provider.dart';

class WorkProvider extends StateNotifier<AsyncValue<List<Work>>> {
  final Ref ref;

  // WorkProvider(this.ref) : super([]);
  WorkProvider(this.ref) : super(const AsyncValue.loading());

  /// Load danh sách Work từ backend theo user
  Future<void> fetchWorks() async {
    final user = ref.read(userProvider);
    if (user != null) {
      try {
        final works = await WorkController().loadWorkByUser(userId: user.id);
        // state = works.reversed.toList();
        // state = AsyncValue.data(works.reversed.toList());
        works.sort((a, b) => b.checkInTime.compareTo(a.checkInTime));
        // Sắp xếp giảm dần
        state = AsyncValue.data(works);

      } catch (e) {
        print("Error loading work list: $e");
        // Optionally: state = [];
      }
    }
  }

  /// Thêm một work mới (ví dụ sau khi check-in hoặc thêm thủ công)
  void addWork(Work work) {
    // state = [...state, work];
    if (state is AsyncData) {
      final updated = [work,...state.value!];
      state = AsyncValue.data(updated);
    }
  }

  // /// Xoá một work (nếu bạn cần)
  // void removeWork(String workId) {
  //   state = state.where((w) => w.id != workId).toList();
  // }
  //
  // /// Cập nhật một work (nếu có edit)
  // void updateWork(Work updatedWork) {
  //   state = [
  //     for (final w in state)
  //       if (w.id == updatedWork.id) updatedWork else w
  //   ];
  // }
}
final workProvider = StateNotifierProvider<WorkProvider, AsyncValue<List<Work>>>((ref) => WorkProvider(ref),);
