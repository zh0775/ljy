import 'package:cxhighversion2/business/finance/finance_space.dart';
import 'package:cxhighversion2/component/custom_button.dart';
import 'package:cxhighversion2/util/app_default.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:cxhighversion2/business/pointsMall/points_mall_page.dart';
import 'package:get/get.dart';

class BusinessController extends GetxController {
  List cardList = [
    {
      "id": 0,
      "name": "招商银行全球支付信用卡",
      "subTitle": "初审+首刷+M4补贴",
      "reward": 58.0,
      "img": "business/tmp_card",
    },
    {
      "id": 0,
      "name": "建行龙卡尊享白金信用卡",
      "subTitle": "初审+首刷+M4补贴",
      "reward": 68.0,
      "img": "business/tmp_card",
    },
    {
      "id": 0,
      "name": "农业银行金穗信用卡",
      "subTitle": "初审+首刷+M4补贴",
      "reward": 78.0,
      "img": "business/tmp_card",
    },
    {
      "id": 0,
      "name": "建行龙卡尊享白金信用卡",
      "subTitle": "初审+首刷+M4补贴",
      "reward": 88.0,
      "img": "business/tmp_card",
    }
  ];
}

class Business extends GetView<BusinessController> {
  const Business({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getDefaultAppBar(
        context,
        "商业圈",
        centerTitle: false,
        color: Colors.transparent,
        needBack: false,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            ghb(20),
            gwb(375),
            sbRow(
                List.generate(5, (index) {
                  String title = "";
                  String img = "business/icon_";
                  switch (index) {
                    case 0:
                      title = "金融区";
                      img += "jrq";
                      break;
                    case 1:
                      title = "生活区";
                      img += "shq";
                      break;
                    case 2:
                      title = "商家区";
                      img += "sjq";
                      break;
                    case 3:
                      title = "娱乐区";
                      img += "ylq";
                      break;
                    case 4:
                      title = "相关资讯";
                      img += "xgzx";
                      break;
                    default:
                  }

                  return CustomButton(
                    onPressed: () {
                      if (index == 0) {
                        push(const FinanceSpace(), context,
                            binding: FinanceSpaceBinding());
                      }
                    },
                    child: centClm([
                      Image.asset(
                        assetsName(img),
                        width: 45.w,
                      ),
                      ghb(4),
                      getSimpleText(title, 12, AppColor.text2)
                    ]),
                  );
                }),
                width: 375 - 21 * 2),
            ghb(20),
            sbRow([
              secondBlock(0),
              secondBlock(1),
            ], width: 345),
            ghb(15),
            CustomButton(
              onPressed: () {},
              child: Image.asset(
                assetsName("business/bg_apply_card"),
                width: 345.w,
                fit: BoxFit.fitWidth,
              ),
            ),
            ghb(15),
            cardList(),
            ghb(20)
          ],
        ),
      ),
    );
  }

  Widget secondBlock(int index) {
    return CustomButton(
      onPressed: () {
        if (index == 0) {
          push(const PointsMallPage(), null, binding: PointsMallPageBinding());
        }
      },
      child: Container(
        width: 165.w,
        height: 150.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.w),
        ),
        child: centClm([
          getSimpleText(index == 0 ? "积分商城" : "特惠复购", 15, AppColor.text,
              isBold: true),
          ghb(2),
          getSimpleText(
              index == 0 ? "超值积分换好礼" : "限时积分低至7.5折", 12, AppColor.text3),
          ghb(8),
          Image.asset(
            assetsName("business/icon_${index == 0 ? "jfsc" : "thfg"}"),
            width: 65.w,
            fit: BoxFit.fitWidth,
          )
        ]),
      ),
    );
  }

  Widget cardList() {
    return Container(
      width: 345.w,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8.w)),
      child: Column(
        children: [
          sbhRow([
            nSimpleText("热门信用卡", 16, isBold: true),
            centRow([
              nSimpleText("查看更多", 12, color: AppColor.text3, textHeight: 1.2),
              Image.asset(
                assetsName("mine/icon_right_arrow"),
                width: 12.w,
                fit: BoxFit.fitWidth,
              )
            ])
          ], width: 345 - 15.5 * 2, height: 45.5),
          ...List.generate(controller.cardList.length, (index) {
            Map data = controller.cardList[index];
            return SizedBox(
              width: (345 - 15 * 2).w,
              child: Column(
                children: [
                  ghb(index == 0 ? 8 : 17),
                  sbRow([
                    centRow([
                      Image.asset(
                        assetsName(data["img"] ?? ""),
                        width: 40.w,
                        fit: BoxFit.fitWidth,
                      ),
                      gwb(12),
                      centClm([
                        nSimpleText(data["name"] ?? "", 15, isBold: true),
                        ghb(5),
                        getSimpleText(
                            data["subTitle"] ?? "", 12, AppColor.text2),
                      ], crossAxisAlignment: CrossAxisAlignment.start)
                    ]),
                    Container(
                      width: 60.w,
                      height: 30.w,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.w),
                          border:
                              Border.all(width: 0.5.w, color: AppColor.theme)),
                      child: Center(
                        child: getSimpleText("申请", 12, AppColor.theme),
                      ),
                    )
                  ], width: 345 - 15 * 2),
                  ghb(10),
                  sbRow([
                    Container(
                      height: 18.w,
                      padding: EdgeInsets.symmetric(horizontal: 6.w),
                      decoration: BoxDecoration(
                          color: AppColor.theme.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(2.w)),
                      child: Center(
                        child: getSimpleText(
                            "奖励￥${priceFormat(data["reward"] ?? 0, savePoint: 0)}",
                            10,
                            AppColor.theme),
                      ),
                    )
                  ], width: 345 - (15 + 40 + 12) * 2),
                  ghb(16),
                  index != controller.cardList.length - 1
                      ? gline(315, 1)
                      : ghb(0)
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
