import 'package:fieldsnap/core/enums/fetch_state.dart';
import 'package:fieldsnap/core/theme/app_colors.dart';
import 'package:fieldsnap/features/users/domain/entities/user_profile.dart';
import 'package:fieldsnap/features/users/presentation/controllers/users_controller.dart';
import 'package:fieldsnap/features/users/presentation/widgets/user_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/utils/gap.dart';

class UsersPage extends GetView<UsersController> {
  const UsersPage({super.key});

  Widget _buildList() {
    return Column(
      children: [
        Expanded(
          child: Obx(
            () => ListView.separated(
              shrinkWrap: true,
              controller: controller.scroll,
              itemCount: controller.users.length,
              itemBuilder: (ctx, idx) {
                UserProfile user = controller.users[idx];
                return UserCard(user: user);
              },
              separatorBuilder: (ctx, idx) {
                return Gap.h(12.px);
              },
            ),
          ),
        ),
        Obx(
          () => controller.fetchState == FetchState.fetching
              ? Center(child: CircularProgressIndicator())
              : SizedBox(),
        ),
      ],
    );
  }

  Widget _buildLoad() {
    return Center(child: CircularProgressIndicator());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: Container(
        color: AppColors.surface,
        padding: EdgeInsets.all(20.px),
        child: Obx(
          () => controller.fetchState == FetchState.loading
              ? _buildLoad()
              : _buildList(),
        ),
      ),
    );
  }
}
