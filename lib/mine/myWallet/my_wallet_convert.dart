import 'package:cxhighversion2/app_binding.dart';
import 'package:cxhighversion2/component/app_success_page.dart';
import 'package:cxhighversion2/component/bottom_paypassword.dart';
import 'package:cxhighversion2/component/custom_html_view.dart';
import 'package:cxhighversion2/component/custom_input.dart';
import 'package:cxhighversion2/home/home.dart';
import 'package:cxhighversion2/main.dart';
import 'package:cxhighversion2/mine/myWallet/my_wallet.dart';
import 'package:cxhighversion2/service/urls.dart';
import 'package:cxhighversion2/util/app_default.dart';
import 'package:cxhighversion2/util/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MyWalletConvertBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<MyWalletConvertController>(MyWalletConvertController());
  }
}

class MyWalletConvertController extends GetxController {
  TextEditingController inputCtrl = TextEditingController();
  final _submitBtnEnable = true.obs;
  bool get submitBtnEnable => _submitBtnEnable.value;
  set submitBtnEnable(v) => _submitBtnEnable.value = v;

  bool isFirst = true;
  Map walletData = {};
  late BottomPayPassword bottomPayPassword;

  // loadData() {
  //   simpleRequest(
  //     url: Urls.getInvestList,
  //     params: {},
  //     success: (success, json) {
  //       if (success) {
  //       } else {
  //         // Future.delayed(const Duration(milliseconds: 500), () {
  //         //   Get.back();
  //         // });
  //       }
  //     },
  //     after: () {},
  //   );
  // }

  convertRequest(String pwd) {
    submitBtnEnable = false;
    simpleRequest(
      url: Urls.investOrder,
      params: {
        "investConfigId": AppDefault().homeData["investConfigId"],
        "customAmount": double.tryParse(inputCtrl.text),
        "u_3nd_Pad": pwd,
      },
      success: (success, json) {
        if (success) {
          Get.find<HomeController>().refreshHomeData();
          Get.to(
              AppSuccessPage(
                title: "????????????",
                subContentText: "????????????????????????",
                buttons: [
                  getSubmitBtn("??????????????????", () {
                    Get.until((route) {
                      if (route is GetPageRoute) {
                        if (fromEarn) {
                          return (route.binding is MainPageBinding)
                              ? true
                              : false;
                        } else {
                          return (route.binding is MyWalletBinding)
                              ? true
                              : false;
                        }
                      } else {
                        return false;
                      }
                    });
                  })
                ],
              ),
              binding: AppSuccessPageBinding());
        } else {}
      },
      after: () {
        submitBtnEnable = true;
      },
    );
  }

  convertAction() {
    if (double.tryParse(inputCtrl.text) == null) {
      ShowToast.normal("????????????????????????");
      return;
    }
    if (AppDefault().homeData["investConfigId"] == null) {
      ShowToast.normal("????????????????????????");
      return;
    }
    if (AppDefault().homeData["u_3rd_password"] == null ||
        AppDefault().homeData["u_3rd_password"].isEmpty) {
      showPayPwdWarn(
        haveClose: true,
        popToRoot: false,
        untilToRoot: false,
        setSuccess: () {},
      );
      return;
    }
    bottomPayPassword.show();
  }

  bool fromEarn = false;
  dataInit(Map wallet, bool from) {
    if (!isFirst) return;
    isFirst = false;
    walletData = wallet;
    fromEarn = from;
  }

  @override
  void onInit() {
    // loadData();
    bottomPayPassword = BottomPayPassword.init(
      confirmClick: (payPwd) {
        convertRequest(payPwd);
      },
    );
    super.onInit();
  }

  @override
  void dispose() {
    bottomPayPassword.dispos();
    inputCtrl.dispose();
    super.dispose();
  }
}

class MyWalletConvert extends GetView<MyWalletConvertController> {
  final Map walletData;
  final bool fromEarn;
  const MyWalletConvert(
      {super.key, this.walletData = const {}, this.fromEarn = false});

  @override
  Widget build(BuildContext context) {
    controller.dataInit(walletData, fromEarn);
    return GestureDetector(
      onTap: () => takeBackKeyboard(context),
      child: Scaffold(
        appBar: getDefaultAppBar(context, "????????????"),
        body: getInputBodyNoBtn(
          context,
          buttonHeight: 80.w + paddingSizeBottom(context),
          submitBtn: GetX<MyWalletConvertController>(
            builder: (_) {
              return getBottomBlueSubmitBtn(context, "????????????", onPressed: () {
                if (controller.inputCtrl.text.isEmpty) {
                  ShowToast.normal("?????????????????????${walletData["name"] ?? ""}??????");
                  return;
                }
                controller.convertAction();
              }, enalble: controller.submitBtnEnable);
            },
          ),
          build: (boxHeight, context) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  ghb(15),
                  Container(
                    width: 345.w,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5.w)),
                    child: Column(
                      children: [
                        ghb(
                          20,
                        ),
                        sbRow([
                          getSimpleText(
                              "??????${walletData["name"] ?? ""}???${integralFormat(walletData["amout"] ?? 0)}",
                              14,
                              AppColor.textBlack),
                        ], width: 345 - 20 * 2),
                        ghb(40),
                        sbRow([
                          getSimpleText("??????${walletData["name"] ?? ""}??????", 14,
                              AppColor.textGrey),
                        ], width: 345 - 20 * 2),
                        ghb(20),
                        sbRow([
                          // getSimpleText("${walletData["name"] ?? ""}", 18,
                          //     AppColor.textBlack,
                          //     isBold: true),
                          Image.asset(
                            assetsName("home/icon_coin"),
                            width: 30.w,
                            height: 30.w,
                            fit: BoxFit.fill,
                          ),
                          CustomInput(
                            textEditCtrl: controller.inputCtrl,
                            width: 305.w - 30.w - 15.w,
                            heigth: 50.w,
                            style: TextStyle(
                                fontSize: 18.sp, color: AppColor.textBlack),
                            placeholderStyle: TextStyle(
                                fontSize: 18.sp, color: AppColor.textGrey),
                            placeholder: "?????????",
                            keyboardType: TextInputType.number,
                          ),
                        ], width: 345 - 20 * 2),
                        ghb(20),
                      ],
                    ),
                  ),
                  ghb(20),
                  sbRow([
                    getSimpleText("????????????", 18, AppColor.textBlack, isBold: true)
                  ], width: 345),
                  ghb(10),
                  SizedBox(
                    width: 345.w,
                    child: CustomHtmlView(
                      src: AppDefault().homeData["investConfigDesc"] ?? "",
                      // loadingWidget: Center(
                      //     child:
                      //         getSimpleText("?????????????????????", 15, AppColor.textGrey)),
                    ),
                  ),
                  // getWidthText(
                  //     "?????????????????????\n1.???????????????????????????500?????????????????????\n1??????=1??????????????????????????????????????????",
                  //     14,
                  //     AppColor.textBlack,
                  //     345,
                  //     100),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
