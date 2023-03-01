import 'package:cxhighversion2/component/custom_button.dart';
import 'package:cxhighversion2/component/custom_empty_view.dart';
import 'package:cxhighversion2/home/redpacket/redpacket.dart';
import 'package:cxhighversion2/home/redpacket/redpacket_history.dart';
import 'package:cxhighversion2/service/urls.dart';
import 'package:cxhighversion2/util/app_default.dart';
import 'package:cxhighversion2/util/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RedPacketHistoryOrderBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<RedPacketHistoryOrderController>(RedPacketHistoryOrderController());
  }
}

class RedPacketHistoryOrderController extends GetxController {
  final _isLoading = true.obs;
  set isLoading(value) => _isLoading.value = value;
  bool get isLoading => _isLoading.value;
  RefreshController pullCtrl = RefreshController();
  List orderDatas = [];
  List orders = [];
  bool isFirst = true;

  int pageNo = 1;
  int pageSize = 10;
  int count = 0;

  onRefresh() {
    loadDatas();
  }

  revocationAction(int id) {
    simpleRequest(
      url: Urls.userInvestOrderCancel(id),
      params: {},
      success: (success, json) {
        if (success) {
          if (json["messages"] != null) {
            ShowToast.normal(json["messages"] ?? "");
          }
          loadDatas();
          // Get.find<RedPacketHistoryController>().loadHistoryData();
          // Future.delayed(const Duration(seconds: 1), () {
          //   Get.back();
          // });
        }
      },
      after: () {},
    );
  }

  onLoad() {
    loadDatas(isLoad: true);
  }

  loadDatas({bool isLoad = false}) {
    isLoad ? pageNo++ : pageNo = 1;
    simpleRequest(
      url: Urls.userInvestReceivedList,
      params: {
        "pageNo": pageNo,
        "pageSize": pageSize,
      },
      success: (success, json) {
        if (success) {
          Map data = json["data"] ?? {};
          count = data["count"] ?? 0;
          // orders = data["data"] ?? [];
          isLoad
              ? orders = [...orders, ...(data["data"] ?? [])]
              : orders = (data["data"] ?? []);
          isLoad ? pullCtrl.loadComplete() : pullCtrl.refreshCompleted();
          update();
        } else {
          isLoad ? pullCtrl.loadFailed() : pullCtrl.refreshFailed();
        }
      },
      after: () {
        isLoading = false;
      },
    );

    // simpleRequest(url: Urls.userHongbaoQueueList, params: params, success: success, after: after)
  }

  // dataInit(List orders) {
  //   if (!isFirst) return;
  //   isFirst = false;
  //   orderDatas = orders;
  // }

  @override
  void onInit() {
    loadDatas();
    super.onInit();
  }

  @override
  void onClose() {
    pullCtrl.dispose();
    super.onClose();
  }
}

class RedPacketHistoryOrder extends GetView<RedPacketHistoryOrderController> {
  final List orderDatas;
  const RedPacketHistoryOrder({super.key, this.orderDatas = const []});

  @override
  Widget build(BuildContext context) {
    // controller.dataInit(orderDatas);
    return Scaffold(
        appBar: getDefaultAppBar(context, "红包订单"),
        body: GetBuilder<RedPacketHistoryOrderController>(
          builder: (_) {
            return SmartRefresher(
                controller: controller.pullCtrl,
                onRefresh: controller.onRefresh,
                onLoading: controller.onLoad,
                enablePullUp: controller.count > controller.orders.length,
                child: controller.orders.isEmpty
                    ? GetX<RedPacketHistoryOrderController>(
                        builder: (_) {
                          return CustomEmptyView(
                            isLoading: controller.isLoading,
                          );
                        },
                      )
                    : ListView.builder(
                        padding: EdgeInsets.only(bottom: 15.w),
                        itemCount: controller.orders != null &&
                                controller.orders.isNotEmpty
                            ? controller.orders.length
                            : 0,
                        itemBuilder: (context, index) {
                          return cell(controller.orders[index], index, context);
                        },
                      ));
          },
        ));
  }

  Widget cell(Map data, int index, BuildContext context) {
    double rowHeight = 50;
    double rowWidth = 345 - 20 * 2;
    return Container(
      margin: EdgeInsets.only(top: 15.w),
      width: 345.w,
      decoration: getDefaultWhiteDec(),
      child: Column(
        children: [
          sbhRow([
            //1.进行中 2.已完成，3已撤单
            getSimpleText(
                data["receivedFlag"] == 1
                    ? "进行中"
                    : data["receivedFlag"] == 2
                        ? "已完成"
                        : "已撤单",
                18,
                AppColor.textRed),
          ], width: rowWidth, height: rowHeight),
          gline(rowWidth, 0.5),
          singleRow("订单号", data["order_NO"] ?? "", rowWidth, rowHeight),
          gline(rowWidth, 0.5),
          singleRow("兑换红包金额", "${priceFormat(data["investAmount"] ?? 0)}元",
              rowWidth, rowHeight),
          gline(rowWidth, 0.5),
          singleRow("已领取红包", "${priceFormat(data["receivedAmount"] ?? 0)}元",
              rowWidth, rowHeight),
          gline(rowWidth, 0.5),
          singleRow("兑换时间", data["addTime"] ?? "", rowWidth, rowHeight),
          data["receivedFlag"] != 1 ? ghb(0) : gline(rowWidth, 0.5),
          data["receivedFlag"] != 1
              ? ghb(0)
              : sbhRow([
                  gwb(0),
                  CustomButton(
                      onPressed: () {
                        showAlert(
                          context,
                          "确定要撤单吗？",
                          confirmOnPressed: () {
                            controller.revocationAction(data["id"]);
                            Navigator.pop(context);
                          },
                        );
                      },
                      child: Container(
                          width: 70.w,
                          height: 26.w,
                          decoration: BoxDecoration(
                              color: AppColor.textRed,
                              borderRadius: BorderRadius.circular(20.w)),
                          child: Center(
                              child: getSimpleText("撤单", 16, Colors.white)))),
                ], width: rowWidth, height: rowHeight),
        ],
      ),
    );
  }

  Widget singleRow(String t1, String t2, double rowWidth, double rowHeight) {
    return sbhRow(
      [
        getSimpleText(t1, 14, AppColor.textGrey),
        getSimpleText(t2, 15, AppColor.textBlack)
      ],
      width: rowWidth,
      height: rowHeight,
    );
  }
}
