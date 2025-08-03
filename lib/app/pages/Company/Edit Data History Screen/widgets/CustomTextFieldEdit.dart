import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class CustomTextFieldEdit extends StatefulWidget {
  final String? label;
  final String? hintText;
  final String? initialValue;
  final TextEditingController? controller;
  final bool isPassword;
  final bool isNumber;
  final TextInputType? keyboardType;
  final RxString? errorMessage;
  final String? svgIcon;
  final bool? isPasswordHidden;
  final VoidCallback? onSuffixTap;
  final Function(String)? onChanged;

  const CustomTextFieldEdit({
    super.key,
    this.label,
    this.hintText,
    this.initialValue,
    this.controller,
    this.isPassword = false,
    this.isNumber = false,
    this.keyboardType,
    this.errorMessage,
    this.svgIcon,
    this.isPasswordHidden,
    this.onSuffixTap,
    this.onChanged,
  });

  @override
  State<CustomTextFieldEdit> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextFieldEdit> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();

    // Set initial value if provided and controller doesn't have text
    if (widget.initialValue != null && _controller.text.isEmpty) {
      _controller.text = widget.initialValue!;
    }
  }

  @override
  void dispose() {
    // Only dispose if we created the controller internally
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Perbaikan: Cek null terlebih dahulu sebelum mengakses value
    final borderColor = widget.errorMessage?.value.isEmpty ?? true
        ? const Color(0xFF275637)
        : Colors.red;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * 0.008),
            child: Text(
              widget.label!,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.035,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.06,
          child: TextField(
            controller: _controller,
            obscureText: widget.isPassword ? (widget.isPasswordHidden ?? true) : false,
            keyboardType: widget.keyboardType ??
                (widget.isNumber ? TextInputType.number : TextInputType.text),
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.037,
                color: Colors.black),
            onChanged: widget.onChanged,
            decoration: InputDecoration(
              hintText: widget.hintText ?? '',
              hintStyle: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.037,
                  color: Colors.grey),
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.02,
                  horizontal: MediaQuery.of(context).size.width * 0.03),
              prefixIcon: widget.svgIcon != null
                  ? Padding(
                padding: EdgeInsets.all(
                    MediaQuery.of(context).size.width * 0.03),
                child: SvgPicture.asset(
                  widget.svgIcon!,
                  width: MediaQuery.of(context).size.width * 0.06,
                  height: MediaQuery.of(context).size.width * 0.06,
                ),
              )
                  : null,
              suffixIcon: widget.isPassword
                  ? Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: widget.onSuffixTap,
                  child: Container(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.03),
                    child: SvgPicture.asset(
                      (widget.isPasswordHidden ?? true)
                          ? 'assets/icons/eye_closed.svg'
                          : 'assets/icons/eye_open.svg',
                      width: MediaQuery.of(context).size.width * 0.05,
                      height: MediaQuery.of(context).size.width * 0.05,
                      colorFilter: ColorFilter.mode(
                        Colors.grey.shade600,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.width * 0.02),
                borderSide: BorderSide(color: borderColor, width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.width * 0.02),
                borderSide: BorderSide(color: borderColor, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.width * 0.02),
                borderSide: BorderSide(color: borderColor, width: 1),
              ),
            ),
          ),
        ),
        // Perbaikan: Hanya gunakan Obx jika errorMessage tidak null
        widget.errorMessage != null
            ? Obx(() => widget.errorMessage!.value.isNotEmpty
            ? Padding(
          padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.02,
              top: MediaQuery.of(context).size.height * 0.008),
          child: Text(
            widget.errorMessage!.value,
            style: TextStyle(
              color: Colors.red,
              fontSize: MediaQuery.of(context).size.width * 0.03,
              fontWeight: FontWeight.w500,
            ),
          ),
        )
            : const SizedBox.shrink())
            : const SizedBox.shrink(),
      ],
    );
  }
}