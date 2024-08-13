// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import '../constants/text_font_style.dart';
// import '../gen/colors.gen.dart';

// class CustomTextFormField extends StatelessWidget {
//   final String? labelText;
//   final String? hintText;
//   final Widget? prefixIcon;
//   final IconData? suffixIcon;
//   final bool obscureText;
//   final TextEditingController? controller;
//   final TextInputType keyboardType;
//   final Function(String)? onChanged;
//   final String? Function(String?)? validator;
//   final bool isPrefixIcon;
//   final double borderRadius;
//   final VoidCallback? onSuffixIconTap;
//   final String? iconpath;

//   const CustomTextFormField({
//     super.key,
//     this.labelText,
//     this.hintText,
//     this.prefixIcon,
//     this.suffixIcon,
//     this.obscureText = false,
//     this.controller,
//     this.keyboardType = TextInputType.text,
//     this.onChanged,
//     this.validator,
//     this.borderRadius = 15.0,
//     required this.isPrefixIcon,
//     this.iconpath,
//     this.onSuffixIconTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: AppColors.allPrimaryColor,
//         borderRadius: BorderRadius.circular(borderRadius),
//       ),
//       child: TextFormField(
//         controller: controller,
//         keyboardType: keyboardType,
//         obscureText: obscureText,
//         onChanged: onChanged,
//         validator: validator,
//         decoration: InputDecoration(

// ignore_for_file: library_private_types_in_public_api

//           filled: true,
//           fillColor: AppColors.cF4F5F7,
//           labelText: labelText,
//           hintText: hintText,
//           hintStyle: TextFontStyle.headline16w400C848484StyleInter,
//           prefixIcon: isPrefixIcon && iconpath != null
//               ? Padding(
//                   padding: EdgeInsets.only(left: 5.w, right: 11.w),
//                   child: Container(
//                     width: 51.w,
//                     height: 46.h,
//                     padding:
//                         EdgeInsets.symmetric(vertical: 11.h, horizontal: 14.w),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(12.r),
//                       color: AppColors.allPrimaryColor,
//                     ),
//                     child: Image.asset(
//                       iconpath!,
//                       width: 24.w,
//                     ),
//                   ),
//                 )
//               : null,
//           suffixIcon: suffixIcon != null
//               ? GestureDetector(
//                   onTap: onSuffixIconTap,
//                   child: Icon(
//                     suffixIcon,
//                     color: AppColors.c848484,
//                   ),
//                 )
//               : null,
//           border: InputBorder.none,
//           enabledBorder: InputBorder.none,
//           focusedBorder: InputBorder.none,
//           errorBorder: InputBorder.none,
//           disabledBorder: InputBorder.none,
//           contentPadding:
//               EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/text_font_style.dart';
import '../gen/colors.gen.dart';

class CustomTextFormField extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final Widget? prefixIcon;
  final IconData? suffixIcon;
  final bool obscureText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final bool isPrefixIcon;
  final double borderRadius;
  final VoidCallback? onSuffixIconTap;
  final String? iconpath;

  const CustomTextFormField({
    super.key,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.validator,
    this.borderRadius = 10.0, // Set to 10 pixels
    required this.isPrefixIcon,
    this.iconpath,
    this.onSuffixIconTap,
  });

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      child: TextFormField(
        focusNode: _focusNode,
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        obscureText: widget.obscureText,
        onChanged: widget.onChanged,
        validator: widget.validator,
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.cF4F5F7,
          labelText: widget.labelText,
          hintText: widget.hintText,
          hintStyle: TextFontStyle.headline16w400C848484StyleInter,
          prefixIcon: widget.isPrefixIcon && widget.iconpath != null
              ? Padding(
                  padding: EdgeInsets.only(left: 20.w, right: 12.w),
                  child: Image.asset(
                    widget.iconpath!,
                    width: 24.w,
                    color: _isFocused
                        ? AppColors.allPrimaryColor
                        : AppColors.cB3BAC5,
                  ),
                )
              : null,
          suffixIcon: widget.suffixIcon != null
              ? GestureDetector(
                  onTap: widget.onSuffixIconTap,
                  child: Padding(
                    padding: EdgeInsets.only(right: 16.w),
                    child: Icon(
                      widget.suffixIcon,
                      color: _isFocused
                          ? AppColors.allPrimaryColor
                          : AppColors.cB3BAC5,
                    ),
                  ),
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: const BorderSide(
              color: AppColors
                  .allPrimaryColor, // Adjust the border width if needed
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: const BorderSide(color: Colors.red),
          ),
          disabledBorder: InputBorder.none,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
        ),
      ),
    );
  }
}
