// 积分商城 下单成功后到订单状态页面

import 'package:flutter/material.dart';
import 'package:cxhighversion2/util/app_default.dart';
import 'package:cxhighversion2/component/custom_input.dart';
import 'package:cxhighversion2/component/custom_button.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MallOrderStatusPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<MallOrderStatusPageController>(MallOrderStatusPageController(id: Get.arguments));
  }
}

class MallOrderStatusPageController extends GetxController {
  final dynamic id;
  MallOrderStatusPageController({this.id});
}

class MallOrderStatusPage extends GetView<MallOrderStatusPageController> {
  const MallOrderStatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => takeBackKeyboard(context),
      child: Scaffold(
        appBar: getDefaultAppBar(context, '订单详情'),
        body: Stack(
          children: [
            Positioned(
              top: 0,
              child: orderStatusTopBox(),
            ),
            Positioned(
              top: 100.w - 15.w, // 下面的margin引起的
              bottom: 50.w,
              child: addressDefaultBox(),
            ),

            Positioned(
              left: 15.w,
              top: 220.w, // 下面的margin引起的
              bottom: 50.w,
              child: shopOrderBox(),
            ),

            Positioned(bottom: 0, child: orderStatusBottom())
            // Positioned(child: shopOrderBox())
          ],
        ),
      ),
    );
  }

  // 订单发货状态类型
  Widget orderStatusTopBox() {
    return Container(
      width: 375.w,
      height: 120.w,
      color: const Color(0xFFFF6231),
      padding: EdgeInsets.only(left: 30.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          getSimpleText("待发货", 18, Colors.white),
          getSimpleText("卖家正在发货，请耐心等待", 12, Colors.white),
        ],
      ),
    );
  }

  Widget addressDefaultBox() {
    return Container(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 375.w - 15.w * 2,
                height: 120.w,
                margin: EdgeInsets.all(15.w),
                padding: EdgeInsets.only(left: 18.5.w, top: 24.w),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.0.w),
                      topRight: Radius.circular(8.0.w),
                    )),
                child: SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 5.w, right: 5.w),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF6231),
                              borderRadius: BorderRadius.circular(2.w),
                            ),
                            child: getSimpleText("默认", 12, Colors.white),
                          ),
                          gwb(10.5),
                          getSimpleText("李志明", 15, const Color(0xFF000000)),
                          gwb(14.5),
                          getSimpleText("13246870069", 15, const Color(0xFF000000)),
                        ],
                      ),
                      ghb(15.w),
                      SizedBox(
                        width: 242.w,
                        child: Text(
                          '武汉市共东西湖区金银滩大道18号碧桂园天然 公寓2栋1812',
                          style: TextStyle(color: const Color(0xFF999999), fontSize: 12.w, height: 1.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 133.w,
                left: 15.w,
                width: 345.w,
                height: 3.w,
                child: Image.asset(
                  assetsName("business/address_line"),
                  width: 345.w,
                  height: 3.w,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ],
          ),
          // SingleChildScrollView(
          //   child: shopOrderBox(),
          // ),
        ],
      ),
    );
  }

  Widget shopOrderBox() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Container(
        width: 345.w,
        padding: EdgeInsets.all(15.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.w),
        ),
        margin: EdgeInsets.only(top: 15.w, bottom: 38.w),
        child: Column(
          children: [
            shopItem(),
            ghb(25.w),
            SizedBox(
              height: 40.w,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  nSimpleText('选填', 14, textHeight: 1.5),
                  CustomInput(
                    placeholder: '留言50字以内）',
                    width: 345 - 15 * 2 - 30,
                    heigth: 40,
                    maxLines: 2,
                    maxLength: 50,
                    placeholderStyle: TextStyle(fontSize: 14.sp, color: AppColor.assisText, height: 1.3),
                    style: TextStyle(fontSize: 14.sp, color: AppColor.text2, height: 1.3),
                  )
                ],
              ),
            ),
            gline(345 - 15 * 2, 1),
            ghb(11),
            Column(
              children: [
                SizedBox(
                  height: 30.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      nSimpleText('商品单价', 14, color: const Color(0xFF999999)),
                      nSimpleText('6380积分', 14, color: const Color(0xFF999999)),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      nSimpleText('运费', 14, color: const Color(0xFF999999)),
                      nSimpleText('包邮', 14, color: const Color(0xFF999999)),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      nSimpleText('总计', 14, color: const Color(0xFF999999)),
                      nSimpleText('6380积分', 15, color: const Color(0xFF333333)),
                    ],
                  ),
                ),
              ],
            ),
            gline(345 - 15 * 2, 1),
            ghb(11),
            Column(
              children: [
                SizedBox(
                  height: 30.w,
                  child: Row(
                    children: [
                      nSimpleText('订单编号', 14, color: const Color(0xFF999999)),
                      gwb(14.5),
                      nSimpleText('201545130123056460', 14, color: const Color(0xFF333333)),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30.w,
                  child: Row(
                    children: [
                      nSimpleText('兑换时间', 14, color: const Color(0xFF999999)),
                      gwb(14.5),
                      nSimpleText('13:26:09', 14, color: const Color(0xFF333333)),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30.w,
                  child: Row(
                    children: [
                      nSimpleText('订单状态', 14, color: const Color(0xFF999999)),
                      gwb(14.5),
                      nSimpleText('待发货', 15, color: const Color(0xFF333333)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget shopItem() {
    return SizedBox(
      width: 345.w,
      height: 105.w,
      // padding: EdgeInsets.fromLTRB(10.w, 7.5.w, 10.w, 7.5.w),
      child: sbRow([
        Image.network(
          "https://cdn.pixabay.com/photo/2017/10/12/22/23/bazaar-2846247_1280.jpg",
          width: 105.w,
          height: 105.w,
          fit: BoxFit.fitHeight,
        ),
        gwb(15),
        SizedBox(
          width: 345.w - 105.w - 15.w * 2 - 15.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '无痕发夹欧阳娜娜同款流沙 鸭嘴夹刘海 夹简约头饰透...',
                style: TextStyle(fontSize: 15.w, color: Color(0xFF333333)),
              ),
              getSimpleText("已选：经典蓝；", 12, const Color(0xFF999999)),
              sbRow([
                getSimpleText("6380积分", 15, const Color(0xFF333333)),
                getSimpleText("X1", 12, const Color(0xFF999999)),
              ])
            ],
          ),
        ),
      ]),
    );
  }

  Widget orderStatusBottom() {
    return Container(
      width: 375.w,
      height: 50.w + paddingSizeBottom(Global.navigatorKey.currentContext!),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
            top: BorderSide(
          width: 1.0.w,
          color: Colors.white,
        )),
        boxShadow: [BoxShadow(color: Colors.white, offset: Offset.zero, blurRadius: 2.w, spreadRadius: 2.w, blurStyle: BlurStyle.solid)],
      ),
      padding: EdgeInsets.only(top: 6.w, left: 8.w, bottom: 6.w, right: 8.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CustomButton(
            onPressed: () {},
            child: Container(
              padding: EdgeInsets.fromLTRB(8.5.w, 7.w, 8.5.w, 7.w),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.w),
                  border: Border.all(
                    color: Color(0xFF999999),
                  ),
                  boxShadow: [BoxShadow(color: Colors.white, offset: Offset.zero, blurRadius: 2.w, spreadRadius: 2.w, blurStyle: BlurStyle.solid)]),
              child: getSimpleText("申请售后 ", 12.w, const Color(0xFF333333), textHeight: 1.1),
            ),
          )
        ],
      ),
    );
  }
}
