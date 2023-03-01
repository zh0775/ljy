import 'package:cxhighversion2/component/custom_button.dart';
import 'package:cxhighversion2/component/custom_empty_view.dart';
import 'package:cxhighversion2/home/redpacket/redpacket_detail_list.dart';
import 'package:cxhighversion2/home/redpacket/redpacket_history_order.dart';
import 'package:cxhighversion2/service/urls.dart';
import 'package:cxhighversion2/util/app_default.dart';
import 'package:cxhighversion2/util/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RedPacketHistoryBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<RedPacketHistoryController>(RedPacketHistoryController());
  }
}

class RedPacketHistoryController extends GetxController {
  RefreshController pullCtrl = RefreshController();

  final _isLoading = true.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(v) => _isLoading.value = v;
  List historyDatas = [];

  onRefresh() {
    loadHistoryData();
  }

  loadHistoryData() {
    simpleRequest(
      url: Urls.userInvestReceived,
      params: {},
      success: (success, json) {
        if (success) {
          List data = json["data"] ?? [];
          historyDatas = data;
          update();
          pullCtrl.refreshCompleted();
        } else {
          pullCtrl.refreshFailed();
        }
      },
      after: () {
        isLoading = false;
      },
    );
  }

  @override
  void onInit() {
    loadHistoryData();
    super.onInit();
  }

  @override
  void onClose() {
    pullCtrl.dispose();
    super.onClose();
  }
}

class RedPacketHistory extends GetView<RedPacketHistoryController> {
  const RedPacketHistory({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getDefaultAppBar(context, "我的领取记录", action: [
        CustomButton(
            onPressed: () {
              if (controller.isLoading) {
                ShowToast.normal("正在获取数据，请稍等");
                return;
              }
              push(
                  RedPacketHistoryOrder(
                    orderDatas: controller.historyDatas,
                  ),
                  context,
                  binding: RedPacketHistoryOrderBinding());
            },
            child: SizedBox(
              width: 70.w,
              height: kToolbarHeight,
              child: Align(
                alignment: Alignment.centerLeft,
                child: getSimpleText(
                  "红包订单",
                  14,
                  AppColor.textBlack,
                ),
              ),
            ))
      ]),
      body: GetBuilder<RedPacketHistoryController>(
        builder: (_) {
          return SmartRefresher(
              controller: controller.pullCtrl,
              onRefresh: controller.onRefresh,
              child: controller.historyDatas.isEmpty
                  ? GetX<RedPacketHistoryController>(
                      builder: (_) {
                        return CustomEmptyView(
                          isLoading: controller.isLoading,
                          type: CustomEmptyType.noContent,
                          contentText: "暂无领取记录",
                        );
                      },
                    )
                  : ListView.builder(
                      padding: EdgeInsets.only(bottom: 15.w),
                      itemCount: controller.historyDatas != null &&
                              controller.historyDatas.isNotEmpty
                          ? controller.historyDatas.length
                          : 0,
                      itemBuilder: (context, index) {
                        return historyCell(
                            controller.historyDatas[index], index);
                      },
                    ));
        },
      ),
    );
  }

  Widget historyCell(Map data, int index) {
    double rowWidth = 375 - 20 * 2;
    return Container(
      margin: EdgeInsets.only(top: 15.w),
      width: 375.w,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          sbhRow([
            getRichText("奖励金订单金额：￥", priceFormat(data["investAmount"] ?? 0), 14,
                AppColor.textBlack, 23, AppColor.textBlack,
                isBold2: true)
          ], width: rowWidth, height: 70),
          gline(rowWidth, 0.5),
          singleRow("领取明细", "查看明细", onPressed: () {
            push(
                RedPacketDetaiList(
                  detailData: data,
                ),
                null,
                binding: RedPacketDetaiListBinding());
          }, type: 1),
          gline(rowWidth, 0.5),
          singleRow("已领取红包金额", priceFormat(data["receivedAmount"] ?? 0)),
          gline(rowWidth, 0.5),
          singleRow("兑换订单时间", data["addTime"] ?? ""),
          gline(rowWidth, 0.5),
          singleRow("订单号", data["order_NO"] ?? ""),
          gline(rowWidth, 0.5),
          singleRow("红包领取次数", "${data["receivedCount"] ?? ""}"),
          gline(rowWidth, 0.5),
          singleRow("剩余领取次数", "${data["noReceivedCount"] ?? ""}"),
        ],
      ),
    );
  }

  Widget singleRow(String t1, String t2,
      {int type = 0, Function()? onPressed}) {
    double height = 50;
    return sbhRow([
      getSimpleText(t1, 14, AppColor.textBlack),
      type == 0
          ? getSimpleText(t2, 14, AppColor.textBlack, isBold: true)
          : CustomButton(
              onPressed: onPressed,
              child: SizedBox(
                  width: 80.w,
                  height: height.w,
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: getSimpleText(t2, 14, AppColor.buttonTextBlue))),
            ),
    ], width: 375 - 20 * 2, height: height);
  }
}
