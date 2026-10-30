import 'package:six_cash/features/notification/controllers/notification_controller.dart';
import 'package:six_cash/features/notification/widgets/notification_card_widget.dart';
import 'package:six_cash/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_cash/common/widgets/custom_app_bar_widget.dart';
import 'package:six_cash/common/widgets/no_data_widget.dart';
import 'package:six_cash/common/widgets/paginated_list_widget.dart';
import 'package:six_cash/features/notification/widgets/notification_shimmer_widget.dart';
class NotificationScreen extends StatefulWidget {
  const NotificationScreen({ super.key }) ;

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}


class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    return Scaffold(
      appBar: CustomAppbarWidget(title: 'notification'.tr, onlyTitle: true),
      body: RefreshIndicator(
        onRefresh: () async{
          await Get.find<NotificationController>().getNotificationList(true);
        },
        child: GetBuilder<NotificationController>(
          builder: (notification) {
            return notification.notificationModel == null ? const NotificationShimmerWidget() :  notification.notificationList.isNotEmpty ?
            PaginatedListWidget(
              scrollController: scrollController,
              totalSize: notification.notificationModel?.totalSize,
              onPaginate: (int? offset) async => await notification.getNotificationList(false, offset: offset ?? 1),
              offset: notification.notificationModel?.offset,

              itemView: Expanded(
                child: ListView.builder(
                  controller : scrollController,
                  itemCount: notification.notificationList.length,
                  padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                  itemBuilder: (context, index) {
                    return NotificationCardWidget(notification: notification.notificationList[index], index: index);
                  },
                ),
              ),
            ) : const NoDataWidget();
          },
        ),
      ),
    );
  }
}

