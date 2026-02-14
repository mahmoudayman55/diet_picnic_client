import 'package:flutter/material.dart';

class InformationRow extends StatelessWidget {
  final String leftText;
  final String rightText;

  const InformationRow({
    super.key,
    required this.leftText,
    required this.rightText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            leftText,
            style: Theme.of(context).textTheme.displayMedium!.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 20,),
          Flexible(
            child: Text(
              rightText,
              style: Theme.of(context)
                  .textTheme
                  .displayMedium
                  ?.copyWith(fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }
}
