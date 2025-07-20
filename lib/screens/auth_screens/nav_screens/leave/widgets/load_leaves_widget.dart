// import 'package:daily_manage_user_app/controller/leave_controller.dart';
// import 'package:daily_manage_user_app/providers/user_provider.dart';
// import 'package:flutter/material.dart';
//
// import '../../../../../models/leave.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// class LoadLeavesWidget extends ConsumerStatefulWidget {
//   const LoadLeavesWidget({super.key});
//   @override
//   _LoadLeavesWidgetState createState() => _LoadLeavesWidgetState();
// }
//
// class _LoadLeavesWidgetState extends ConsumerState<LoadLeavesWidget> {
//   late Future<List<Leave>> leavesFuture;
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     final user = ref.read(userProvider);
//     leavesFuture = LeaveController().loadLeavesByUser(userId: user!.id);
//   }
//   @override
//   Widget build(BuildContext context) {
//     return
//
//       FutureBuilder(
//       future: leavesFuture,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         } else if (snapshot.hasError) {
//           return Center(
//             child: Text('Error: ${snapshot.error}'),
//           );
//         } else {
//           final leaves = snapshot.data!;
//           return Text(leaves.length.toString());
//         }
//       },
//     );
//   }
// }
