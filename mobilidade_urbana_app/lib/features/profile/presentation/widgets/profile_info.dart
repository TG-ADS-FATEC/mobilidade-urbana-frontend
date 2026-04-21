import 'package:flutter/material.dart';
import 'package:mobilidade_urbana_app/utils/constants/image_strings.dart';
import 'package:mobilidade_urbana_app/utils/shared/widgets/circular_Image.dart';
import 'package:mobilidade_urbana_app/utils/constants/text_sizes.dart';

class ProfileInfo extends StatelessWidget {
  const ProfileInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ListTile(
        leading: TCircularImage(
          image: TImages.userAvatar,
          size: 60.0,
        ),
        title: Text('Gustavo', style: TextStyle(fontSize: TTextSizes.titleMedium)),
        subtitle: Text('Por aqui desde de janeiro de 2026', style: TextStyle(fontSize: TTextSizes.bodySmall)),
        // trailing: IconButton(onPressed: (){}, icon: Icon(Icons.manage_accounts_rounded, color: isDark ? TColors.white : TColors.black, )),
      ),
    );
  }
}