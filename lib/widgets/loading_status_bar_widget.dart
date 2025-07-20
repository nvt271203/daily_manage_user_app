import 'package:flutter/material.dart';

class LoadingStatusBarWidget extends StatefulWidget {
  const LoadingStatusBarWidget({super.key});

  @override
  State<LoadingStatusBarWidget> createState() => _LoadingStatusBarWidgetState();
}

class _LoadingStatusBarWidgetState extends State<LoadingStatusBarWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(); // Lặp vô hạn

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return LinearProgressIndicator(
                value: _animation.value,
                minHeight: 10,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(
                  // Tạo gradient giả bằng cách thay đổi theo animation
                  Color.lerp(Colors.orange, Colors.deepPurple, _animation.value)!,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "Loading...",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.deepOrangeAccent,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
