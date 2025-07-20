import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../providers/admin/admin_user_provider.dart';
import '../../../../services/socket_service.dart';
class AdminUserScreen extends ConsumerStatefulWidget {
  const AdminUserScreen({super.key});

  @override
  _AdminUserScreenState createState() => _AdminUserScreenState();
}

class _AdminUserScreenState extends ConsumerState<AdminUserScreen> {
  @override
  void initState() {
    super.initState();


    SocketService.initSocketConnection();
    SocketService.listenUserUpdates(() {
      ref.read(adminUserProvider.notifier).fetUsers(); // Gọi lại khi có update
    });
    // Gọi fetchUser khi màn hình load
    Future.microtask(() => ref.read(adminUserProvider.notifier).fetUsers());
  }
  @override
  void dispose() {
    SocketService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(adminUserProvider);

    return userState.when(
      data: (users) {
        if (users.isEmpty) {
          return Center(child: Text('No users found.'));
        }
        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return ListTile(
              title: Text(user.fullName.isNotEmpty ? user.fullName : "No Name"),
              subtitle: Text(user.email),
            );
          },
        );
      },
      loading: () => Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}
