// 确认订单

import 'package:cxhighversion2/machine/machine_order_util.dart';
import 'package:flutter/material.dart';

import 'package:cxhighversion2/util/app_default.dart';
import 'package:cxhighversion2/component/custom_input.dart';
import 'package:cxhighversion2/component/custom_button.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

class MallOrderConfirmPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<MallOrderConfirmPageController>(MallOrderConfirmPageController());
  }
}

class MallOrderConfirmPageController extends GetxController {}

class MallOrderConfirmPage extends GetView<MallOrderConfirmPageController> {
  const MallOrderConfirmPage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: getDefaultAppBar(context, '确认订单'),
      body: Stack(
        children: [
          Positioned(
              top: 0,
              bottom: 0,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    addressDefaultBox(),
                    shopInfoBox(),
                    orderPayMethods(),
                    orderTotalBox(),
                  ],
                ),
              )),
          Positioned(
            bottom: 18.w,
            child: orderConfirmButton(),
          )
        ],
      ),
      // body: SingleChildScrollView(
      //   child: Column(
      //     children: [
      //       addressDefaultBox(),
      //       shopInfoBox(),
      //       orderPayMethods(),
      //       orderTotalBox(),
      //     ],
      //   ),
      // ),
    );
  }

  // 默认地址
  Widget addressDefaultBox() {
    return Column(
      children: [
        Container(
          width: 375.w - 15.w * 2,
          height: 120.w,
          margin: EdgeInsets.fromLTRB(15.w, 15.w, 15.w, 0),
          padding: EdgeInsets.only(left: 18.5.w, top: 24.w, right: 18.5.w),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.0.w),
                topRight: Radius.circular(8.0.w),
              )),
          child: SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
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
                Image.asset(
                  assetsName("mine/icon_right_arrow"),
                  width: 18.w,
                  fit: BoxFit.fitWidth,
                ),
              ],
            ),
          ),
        ),
        Image.asset(
          assetsName("business/address_line"),
          width: 345.w,
          height: 3.w,
          fit: BoxFit.fitWidth,
        )
      ],
    );
  }

  Widget shopInfoBox() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Container(
        width: 345.w,
        padding: EdgeInsets.all(15.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.w),
        ),
        margin: EdgeInsets.only(top: 15.w, bottom: 15.5.w),
        child: Column(
          children: [
            shopItem(),
            ghb(25.w),
            SizedBox(
              height: 52.w,
              child: Row(
                children: [
                  nSimpleText('数量', 14, textHeight: 1.5),
                ],
              ),
            ),
            gline(345 - 15 * 2, 1),
            SizedBox(
              height: 52.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  nSimpleText('配送方式', 14, textHeight: 1.5),
                  nSimpleText('普通快递', 14, textHeight: 1.5),
                ],
              ),
            ),
            gline(345 - 15 * 2, 1),
            ghb(20),
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
            ghb(25),
          ],
        ),
      ),
    );
  }

  // 商品信息
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

  // 支付方式
  Widget orderPayMethods() {
    return Container(
        width: 345.w,
        padding: EdgeInsets.all(15.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.w),
        ),
        margin: EdgeInsets.only(bottom: 15.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getSimpleText("支付方式", 15, const Color(0xFF333333)),
            ghb(16),
            Row(
              children: [
                CustomButton(
                  onPressed: () {},
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFFFEFEA),
                      border: Border.all(color: Color(0xFFFF6231)),
                      borderRadius: BorderRadius.circular(12.w),
                    ),
                    padding: EdgeInsets.fromLTRB(11.5.w, 2.5.w, 11.5.w, 2.5.w),
                    child: getSimpleText("6380积分", 12, const Color(0xFFFF6231)),
                  ),
                ),
                gwb(15),
                CustomButton(
                  onPressed: () {},
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFFFFFFF),
                      border: Border.all(color: Color(0xFFCCCCCC)),
                      borderRadius: BorderRadius.circular(12.w),
                    ),
                    padding: EdgeInsets.fromLTRB(11.5.w, 2.5.w, 11.5.w, 2.5.w),
                    child: getSimpleText("73积分+21.63元", 12, const Color(0xFF333333)),
                  ),
                )
              ],
            )
          ],
        ));
  }

  // 商品合计Box

  Widget orderTotalBox() {
    return Container(
      width: 345.w,
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.w),
      ),
      margin: EdgeInsets.only(bottom: 79.w),
      child: Column(
        children: [
          SizedBox(
            height: 30.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                nSimpleText('商品单价', 14, color: const Color(0xFF999999)),
                gwb(14.5),
                nSimpleText('6380积分', 14, color: const Color(0xFF333333)),
              ],
            ),
          ),
          //  6380积分 1 6380积分
          SizedBox(
            height: 30.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                nSimpleText('商品数量', 14, color: const Color(0xFF999999)),
                gwb(14.5),
                nSimpleText('1', 14, color: const Color(0xFF333333)),
              ],
            ),
          ),
          SizedBox(
            height: 30.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                nSimpleText('合计', 14, color: const Color(0xFF999999)),
                gwb(14.5),
                nSimpleText('6380积分', 15, color: const Color(0xFFFF6231)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget orderConfirmButton() {
    return CustomButton(
      onPressed: () {},
      child: Container(
        width: 345,
        height: 45,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Color(0xFFFF6231),
          borderRadius: BorderRadius.circular(22.5.w),
        ),
        margin: EdgeInsets.only(left: 15.w, right: 15.w),
        child: nSimpleText('确认兑换', 15, color: Colors.white),
      ),
    );
  }
}
