import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/util/constant.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset('assets/empty_state.svg', width: 150),
        const SizedBox(height: 16),
        const Text("Your List is Empty"),
      ],
    );
  }
}

class MyCheckBox extends StatelessWidget {
  final bool value;
  final VoidCallback checkBox;
  const MyCheckBox({super.key, required this.value, required this.checkBox});
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return InkWell(
      onTap: checkBox,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border:
              !value ? Border.all(color: secondaryTextColor, width: 2) : null,
          color: value ? primaryColor : null,
        ),
        child: value
            ? Icon(CupertinoIcons.check_mark,
                size: 16, color: themeData.colorScheme.onPrimary)
            : null,
      ),
    );
  }
}
