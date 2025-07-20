import 'package:flutter/material.dart';

class DialogConfirmWidget extends StatefulWidget {
  final String title;
  final String content;
  final VoidCallback onConfirm;
  final Color color; // ✅ Đúng kiểu và phải là final

  const DialogConfirmWidget({
    super.key,
    required this.title,
    required this.content,
    required this.onConfirm,
    this.color = Colors.blue, // ✅ Giá trị mặc định
  });

  @override
  State<DialogConfirmWidget> createState() => _DialogConfirmWidgetState();
}

class _DialogConfirmWidgetState extends State<DialogConfirmWidget> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Tiêu đề có nền
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: BoxDecoration(
              color:  widget.color,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Text(
              widget.title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Nội dung
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Column(
              children: [
                Text(
                  widget.content,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          side: BorderSide(color: widget.color),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: widget.color),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          widget.onConfirm();
                          // Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.color,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(
                          'Confirm',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
