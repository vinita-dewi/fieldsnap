import 'package:fieldsnap/core/theme/app_colors.dart';
import 'package:fieldsnap/core/theme/app_text_styles.dart';
import 'package:fieldsnap/features/users/domain/entities/user_profile.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/gap.dart';

class UserCard extends StatelessWidget {
  const UserCard({super.key, required this.user});

  final UserProfile user;

  Widget _buildWidgetIcon(UserGender gender) {
    IconData? icGender;
    Color? icColor;

    switch (gender) {
      case UserGender.female:
        icGender = Icons.female;
        icColor = Colors.pinkAccent;
        break;
      case UserGender.male:
        icGender = Icons.male;
        icColor = Colors.blueAccent;
        break;
      case UserGender.other:
        icGender = Icons.transgender;
        icColor = AppColors.primary;
        break;
      default:
        break;
    }
    if (gender == UserGender.unknown) {
      return SizedBox();
    } else {
      return Icon(icGender, color: icColor, size: 14.px);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.px),
      padding: EdgeInsets.all(12.px),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.px),
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: AppColors.textSecondary.withAlpha(70),
            blurRadius: 5,
            spreadRadius: 2,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.px),
            child: Image.network(user.image, width: 40.px),
          ),
          Gap.w(20.px),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    RichText(
                      softWrap: true,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: user.completeName,
                            style: AppTextStyles.textTheme.bodyLarge!,
                          ),

                          TextSpan(
                            text: ' • ${user.age} y.o',
                            style: AppTextStyles.textTheme.labelMedium,
                          ),
                        ],
                      ),
                    ),
                    Gap.w(4.px),
                    _buildWidgetIcon(user.gender),
                  ],
                ),
                if (user.maidenName.isNotEmpty) ...[
                  Text(
                    ' nee ${user.maidenName}',
                    style: AppTextStyles.textTheme.labelSmall!,
                  ),
                ],
                Text(
                  user.company.title,
                  style: AppTextStyles.textTheme.bodySmall,
                ),
                Text(
                  '${user.company.department} , ${user.company.name}',
                  style: AppTextStyles.textTheme.bodySmall,
                ),
                Divider(color: AppColors.textSecondary),
                Text(user.phone, style: AppTextStyles.textTheme.bodySmall),
                Text(user.email, style: AppTextStyles.textTheme.bodySmall),
                Text(
                  user.completeAddress,
                  style: AppTextStyles.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
