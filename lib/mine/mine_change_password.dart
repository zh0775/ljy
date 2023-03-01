import 'package:flutter/material.dart';
import 'package:cxhighversion2/component/custom_button.dart';
import 'package:cxhighversion2/component/custom_input.dart';
import 'package:cxhighversion2/service/http.dart';
import 'package:cxhighversion2/service/urls.dart';
import 'package:cxhighversion2/util/app_default.dart';
import 'package:cxhighversion2/util/toast.dart';
import 'package:flutter_screenutil/src/size_extension.dart';
import 'package:get/get.dart';
import 'package:platform_device_id/platform_device_id.dart';

import 'mine_setting_list.dart';

class MineChangePasswordBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<MineChangePasswordController>(MineChangePasswordController());
  }
}

class MineChangePasswordController extends GetxController {
  bool isFirst = true;
  int authCode = 0;
  final pwdInputCtrl = TextEditingController();
  final confirmPwdInputCtrl = TextEditingController();

  final _submitBtnEnable = true.obs;
  set submitBtnEnable(value) => _submitBtnEnable.value = value;
  get submitBtnEnable => _submitBtnEnable.value;

  final _showPwd = false.obs;
  set showPwd(value) => _showPwd.value = value;
  get showPwd => _showPwd.value;

  final _showConfirmPwd = false.obs;
  set showConfirmPwd(value) => _showConfirmPwd.value = value;
  get showConfirmPwd => _showConfirmPwd.value;

  userSetPayPwdRequest(Map<String, dynamic> params,
      Function(bool success, dynamic json) success) {
    Http().doPost(
      Urls.userChangePwd,
      params,
      success: (json) {
        if (success != null) {
          success(true, json);
        } else {
          success(false, json);
        }
      },
      fail: (reason, code, json) {
        if (success != null) {
          success(false, json);
        }
      },
    );
  }

  dataInit(int code) {
    if (!isFirst) {
      return;
    }
    isFirst = false;
    authCode = code;
  }

  submitAction() async {
    if (pwdInputCtrl.text.isEmpty) {
      ShowToast.normal("请输入新密码");
      return;
    }

    if (pwdInputCtrl.text.length < 4 || pwdInputCtrl.text.length > 20) {
      ShowToast.normal("密码长度需为4到20位");
      return;
    }

    if (confirmPwdInputCtrl.text.isEmpty) {
      ShowToast.normal("请输入确认密码");
      return;
    }

    if (pwdInputCtrl.text != confirmPwdInputCtrl.text) {
      ShowToast.normal("两次密码不一致，请重新输入");
      return;
    }

    submitBtnEnable = false;
    String? deviceId = await PlatformDeviceId.getDeviceId;
    userSetPayPwdRequest({
      "code": authCode,
      "new1st_Pad": pwdInputCtrl.text,
      "phoneKey": deviceId ?? ""
    }, (success, json) {
      submitBtnEnable = true;
      if (success) {
        ShowToast.normal("设置成功");
        Future.delayed(const Duration(seconds: 1), () {
          Get.until((route) {
            if (route is GetPageRoute) {
              if (route.binding is MineSettingListBinding) {
                return true;
              } else {
                return false;
              }
            } else {
              return false;
            }
          });
        });
      } else {
        if (json != null &&
            json["messages"] != null &&
            json["messages"].isNotEmpty) {
          ShowToast.normal(json["messages"]);
        }
      }
    });

    // userSetPayPwdRequest({"old3nd_Pad":""}, (success, json) => null)
  }
}

class MineChangePassword extends GetView<MineChangePasswordController> {
  final int authCode;
  const MineChangePassword({Key? key, required this.authCode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.dataInit(authCode);
    return GestureDetector(
      onTap: () => takeBackKeyboard(context),
      child: Scaffold(
        backgroundColor: AppColor.pageBackgroundColor,
        appBar: getDefaultAppBar(context, "修改登陆密码"),
        body: getInputBodyNoBtn(context,
            contentColor: Colors.white,
            marginTop: 10,
            submitBtn: GetX<MineChangePasswordController>(
              init: controller,
              builder: (_) {
                return getBottomBlueSubmitBtn(context, "确认修改", onPressed: () {
                  controller.submitAction();
                }, enalble: controller.submitBtnEnable);
              },
            ),
            children: [
              ghb(60),
              sbRow([
                getSimpleText("设置新登陆密码", 26, AppColor.textBlack, isBold: true),
              ], width: 375 - 25 * 2),
              ghb(8),
              sbRow([
                getSimpleText(
                  "你已通过身份认证，请输入新密码来修改",
                  14,
                  AppColor.textGrey,
                ),
              ], width: 375 - 25 * 2),
              ghb(55),
              sbhRow([
                GetX<MineChangePasswordController>(
                  init: controller,
                  builder: (_) {
                    return CustomInput(
                      textEditCtrl: controller.pwdInputCtrl,
                      width: (375 - 35 * 2 - 40).w,
                      heigth: 45.w,
                      keyboardType: TextInputType.text,
                      showValue: controller.showConfirmPwd,
                      placeholder: "请输入新密码(由英文或数字组成8位数)",
                      onSubmitted: (p0) {
                        takeBackKeyboard(context);
                      },
                    );
                  },
                ),
                GetX<MineChangePasswordController>(
                  init: controller,
                  builder: (_) {
                    return CustomButton(
                      onPressed: () => controller.showConfirmPwd =
                          !controller.showConfirmPwd,
                      child: SizedBox(
                        width: 40.w,
                        height: 45.w,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Image.asset(
                              "assets/images/login/icon_${controller.showConfirmPwd ? "hide" : "show"}pwd.png",
                              width: 17.w,
                              fit: BoxFit.fitWidth),
                        ),
                      ),
                    );
                  },
                ),
              ], width: 375 - 35 * 2, height: 45),
              gline(375 - 25 * 2, 0.5),
              ghb(22),
              sbhRow([
                GetX<MineChangePasswordController>(
                  init: controller,
                  builder: (_) {
                    return CustomInput(
                      textEditCtrl: controller.confirmPwdInputCtrl,
                      width: (375 - 35 * 2 - 40).w,
                      heigth: 45.w,
                      keyboardType: TextInputType.text,
                      showValue: controller.showPwd,
                      placeholder: "请再次输入新密码",
                      onSubmitted: (p0) {
                        takeBackKeyboard(context);
                      },
                    );
                  },
                ),
                GetX<MineChangePasswordController>(
                  init: controller,
                  builder: (_) {
                    return CustomButton(
                      onPressed: () => controller.showPwd = !controller.showPwd,
                      child: SizedBox(
                        width: 40.w,
                        height: 45.w,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Image.asset(
                              "assets/images/login/icon_${controller.showPwd ? "hide" : "show"}pwd.png",
                              width: 17.w,
                              fit: BoxFit.fitWidth),
                        ),
                      ),
                    );
                  },
                ),
              ], width: 375 - 35 * 2, height: 45),
              gline(375 - 25 * 2, 0.5),
            ]),
      ),
    );
  }
}
