import 'package:flutter/material.dart';

class EditableTextField extends StatefulWidget {
  final String hintText;
  final IconData prefixIcon;
  final String initialValue;
  final void Function(String)? onChanged;

  const EditableTextField({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    this.initialValue = '',
    this.onChanged,
  });

  @override
  State<EditableTextField> createState() => _EditableTextFieldState();
}

class _EditableTextFieldState extends State<EditableTextField> {
  bool _isEditing = false;
  late TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(text: widget.initialValue);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      readOnly: !_isEditing,
      onChanged: widget.onChanged,
      style: const TextStyle(color: Colors.blue),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFE0F0FF),
        hintText: widget.hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.blue),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        prefixIcon: Icon(widget.prefixIcon, color: Colors.grey),
        suffixIcon: IconButton(
          icon: Icon(
            _isEditing ? Icons.check_circle : Icons.edit,
            color: _isEditing ? Colors.green : Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _isEditing = !_isEditing;
            });
            if (_isEditing) {
              Future.delayed(const Duration(milliseconds: 100), () {
                FocusScope.of(context).requestFocus(FocusNode());
              });
            }
          },
        ),
      ),
    );
  }
}
