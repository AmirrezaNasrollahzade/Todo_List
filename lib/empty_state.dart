import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

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
