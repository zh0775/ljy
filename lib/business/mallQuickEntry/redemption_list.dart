// 兑换榜单

import 'package:flutter/material.dart';
import 'package:cxhighversion2/util/app_default.dart';
import 'package:cxhighversion2/component/custom_input.dart';
import 'package:cxhighversion2/component/custom_button.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

class RedemptionListPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<RedemptionListPageController>(RedemptionListPageController());
  }
}

class RedemptionListPageController extends GetxController {
  List collectList = [
    {
      "id": 1,
      "title": "酒店枕芯五星级宾馆枕...",
      "integral": 1592,
      "exchange": 9456,
      "tag": "积分+现金",
      "status": 0,
      "favoriteStatus": false,
      "img": "${AppDefault().imageUrl}D0031/2023/1/202301311856422204X.png",
    },
    {
      "id": 2,
      "title": "臻棉超柔4件套200*23 0cm 丝丝深情",
      "integral": 6380,
      "exchange": 9456,
      "tag": "",
      "status": 1,
      "favoriteStatus": false,
      "img": "${AppDefault().imageUrl}D0031/2023/1/202301311856422204X.png",
    },
    {
      "id": 3,
      "title": "臻棉超柔4件套200*23 0cm 丝丝深情",
      "integral": 6380,
      "exchange": 9456,
      "tag": "",
      "status": 1,
      "favoriteStatus": false,
      "img": "${AppDefault().imageUrl}D0031/2023/1/202301311856422204X.png",
    },
    {
      "id": 4,
      "title": "臻棉超柔4件套200*23 0cm 丝丝深情",
      "integral": 6380,
      "exchange": 9456,
      "tag": "",
      "status": 1,
      "favoriteStatus": false,
      "img": "${AppDefault().imageUrl}D0031/2023/1/202301311856422204X.png",
    },
    {
      "id": 5,
      "title": "臻棉超柔4件套200*23 0cm 丝丝深情",
      "integral": 6380,
      "exchange": 9456,
      "tag": "",
      "status": 1,
      "favoriteStatus": false,
      "img": "${AppDefault().imageUrl}D0031/2023/1/202301311856422204X.png",
    }
  ];

  @override
  void onInit() {
    super.onInit();
  }
}

class RedemptionListPage extends GetView<RedemptionListPageController> {
  const RedemptionListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFD4649),
      appBar: getDefaultAppBar(context, '兑换榜单'),
      body: Stack(
        children: [
          Positioned(top: 0, child: redemptionTopBg()),
          Positioned(
            top: 171.w,
            left: 0.w,
            bottom: 0,
            child: redemptionList(),
          )
        ],
      ),
    );
  }

  Widget redemptionTopBg() {
    return Container(
      child: Image.asset(
        assetsName('business/redemption/bg'),
        width: 365.w,
        height: 260.w,
        fit: BoxFit.fitHeight,
      ),
    );
  }

  Widget redemptionList() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Container(
        width: 375.w - 15.w * 2,
        margin: EdgeInsets.fromLTRB(15.w, 0, 15.w, 15.w),
        child: Column(
          children: List.generate(controller.collectList.length, (index) {
            Map data = controller.collectList[index];
            return redemptionItem(data);
          }),
        ),
      ),
    );
  }

  Widget redemptionItem(item) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(bottom: 15.w),
      child: Row(
        children: [
          SizedBox(
            child: Image.network(
              width: 120.w,
              height: 120.w,
              'https://cdn.pixabay.com/photo/2016/09/18/20/15/frachtschiff-1678895_1280.jpg',
              fit: BoxFit.fitHeight,
            ),
          ),
          gwb(8),
          SizedBox(
            width: 345.w - 120.w - 8.w,
            height: 120.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    getWidthText(item['title'], 15, AppColor.textBlack, 209.w, 2, textAlign: TextAlign.left, alignment: Alignment.topLeft),
                  ],
                ),
                getSimpleText("${item['integral'] ?? "0"}积分", 18, AppColor.theme3, isBold: true, textAlign: TextAlign.left),
                sbhRow([
                  getSimpleText("已兑${item['exchange'] ?? "已兑0"}个", 12, AppColor.textGrey5, textAlign: TextAlign.left),
                  centRow([
                    GetBuilder<RedemptionListPageController>(
                      builder: (_) {
                        return CustomButton(
                          onPressed: () {
                            item["favoriteStatus"] = !item["favoriteStatus"];
                            //
                            controller.update();
                          },
                          child: Image.asset(
                            assetsName(item["favoriteStatus"] ? 'business/mall/btn_iscollect' : 'business/mall/btn_collect'),
                            width: 32.w,
                            height: 28.w,
                          ),
                        );
                      },
                    )
                  ])
                ]),
              ],
            ),
          )
        ],
      ),
    );
  }
}
