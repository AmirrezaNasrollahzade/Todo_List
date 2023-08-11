
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/util/constant.dart';

class PriorityChooseBox extends StatelessWidget {
  final String label;
  final Color color;
  final bool isSelected;
  final GestureTapCallback gestureDetectorCallBack;
  const PriorityChooseBox(
      {super.key,
      required this.gestureDetectorCallBack,
      required this.label,
      required this.color,
      required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: gestureDetectorCallBack,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            width: 2,
            color: secondaryTextColor.withOpacity(0.2),
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Text(label),
            ),
            Positioned(
              right: 8,
              bottom: 0,
              top: 0,
              child: Center(
                child: PriorityCheckBoxShape(
                  value: isSelected,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PriorityCheckBoxShape extends StatelessWidget {
  final bool value;
  final Color color;
  const PriorityCheckBoxShape({
    Key? key,
    required this.value,
    required this.color,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: color,
      ),
      child: value
          ? Icon(
              CupertinoIcons.check_mark,
              size: 12,
              color: themeData.colorScheme.onPrimary,
            )
          : null,
    );
  }
}
