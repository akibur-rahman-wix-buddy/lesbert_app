import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../common_widgets/custom_checkbox.dart';
import '../../../../constants/text_font_style.dart';
import '../../../../helpers/ui_helpers.dart';

class Step4Content extends StatelessWidget {
  final List<String> title;
  final List<bool> isCheckedList;
  final ValueChanged<String?>? onChanged;

  const Step4Content({
    super.key,
    required this.title,
    required this.isCheckedList,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UIHelper.verticalSpace(34.h),
        Text(
          "Are you proficient in using online software and comfortable uploading/downloading and communicating through our Trade Pros Portal?",
          style: TextFontStyle.headline20w400C141414StyleInter,
        ),
        UIHelper.verticalSpace(37.h),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: title.length,
          itemBuilder: (context, index) {
            return CheckboxListItem(
              value: isCheckedList[index],
              onChanged: (bool? value) {
                onChanged?.call(title[index]);
              },
              label: title[index],
            );
          },
        ),
      ],
    );
  }
}
