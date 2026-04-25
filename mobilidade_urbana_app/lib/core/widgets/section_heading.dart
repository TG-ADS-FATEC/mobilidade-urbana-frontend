import 'package:flutter/material.dart';

class TSectionHeading extends StatelessWidget{
  const TSectionHeading({
    super.key,
    this.onPressed,
    this.textColor,
    this.buttonTitle = "Ver mais",
    required this.title,
    this.showActionButton = false,
  });

  final void Function()? onPressed;
  final Color? textColor;
  final String title, buttonTitle;
  final bool showActionButton;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: textColor)),
        if(showActionButton)
          Row(
            children: [
              TextButton(onPressed: onPressed, child: Text(buttonTitle, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: textColor))),
              Icon(Icons.keyboard_arrow_down, size: 16, color: textColor),
            ]
          )

      ],
    );
  }

}