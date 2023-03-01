/**
 * 积分商城收藏
 */

import 'package:flutter/material.dart';
import 'package:cxhighversion2/component/custom_button.dart';
import 'package:cxhighversion2/util/app_default.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

class MallCollectPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MallCollectPageController>(() => MallCollectPageController());
  }
}

class MallCollectPageController extends GetxController {
  List collectList = [
    {
      "id": 1,
      "title": "酒店枕芯五星级宾馆枕 头仿羽布羽丝棉仿鹅...",
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
      "title": "天堂伞2件套 天堂伞天堂伞",
      "integral": 1592,
      "exchange": 9456,
      "tag": "积分+现金",
      "status": 1,
      "favoriteStatus": false,
      "img": "${AppDefault().imageUrl}D0031/2023/1/202301311856422204X.png",
    },
    {
      "id": 4,
      "title": "苏泊尔电磁炉 苏泊尔 电磁炉",
      "integral": 1592,
      "exchange": 9456,
      "tag": "",
      "status": 0,
      "favoriteStatus": false,
      "img": "${AppDefault().imageUrl}D0031/2023/1/202301311856422204X.png",
    },
  ];

  @override
  void onInit() {
    super.onInit();
  }
}

class MallCollectPage extends GetView<MallCollectPageController> {
  const MallCollectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getDefaultAppBar(
        context,
        "我的收藏",
        action: [],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [CollectList()],
        ),
      ),
    );
  }

  // 收藏列表
  Widget CollectList() {
    return Container(
      padding: EdgeInsets.only(top: 15.w),
      child: Column(
        children: List.generate(controller.collectList.length, (index) {
          Map data = controller.collectList[index];
          return CollectItem(data);
        }),
      ),
    );
  }

  // 收藏item
  Widget CollectItem(item) {
    return Center(
      child: Container(
        width: 345.w,
        color: Colors.white,
        margin: EdgeInsets.only(bottom: 15.w),
        child: Row(
          children: [
            SizedBox(
              child: Image.network(
                width: 120.w,
                height: 120.w,
                '${AppDefault().imageUrl}D0031/2023/1/202301311856422204X.png',
                fit: BoxFit.cover,
              ),
            ),
            Container(
              width: 225.w,
              padding: EdgeInsets.fromLTRB(8.w, 11.5.w, 8.w, 11.5.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getWidthText(item['title'], 15, AppColor.textBlack, 209.w, 2,
                      textAlign: TextAlign.left, alignment: Alignment.topLeft),
                  ghb(15.w),
                  getSimpleText(
                      "${item['integral'] ?? "0"}积分", 18, AppColor.theme3,
                      isBold: true, textAlign: TextAlign.left),
                  sbhRow([
                    getSimpleText("已兑${item['exchange'] ?? "已兑0"}个", 12,
                        AppColor.textGrey5,
                        textAlign: TextAlign.left),
                    centRow([
                      GetBuilder<MallCollectPageController>(
                        builder: (_) {
                          return CustomButton(
                            onPressed: () {
                              item["favoriteStatus"] = !item["favoriteStatus"];
                              //
                              controller.update();
                            },
                            child: Image.asset(
                              assetsName(item["favoriteStatus"]
                                  ? 'business/mall/btn_iscollect'
                                  : 'business/mall/btn_collect'),
                              width: 32.w,
                              height: 28.w,
                            ),
                          );
                        },
                      )
                    ])
                  ], width: 245.w - 10 * 2, height: 12.w),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
