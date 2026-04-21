import 'package:flutter/material.dart';

class TSectionHeading extends StatelessWidget{
  const TSectionHeading({
    super.key,
    this.onPressed,
    this.textColor,
    this.buttonTitle = "Ver tudo",
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
          TextButton(onPressed: onPressed, child: Text(buttonTitle, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: textColor)))
      ],
    );
  }

}