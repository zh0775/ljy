import 'package:cxhighversion2/business/mallOrder/mall_order_page.dart';
import 'package:cxhighversion2/component/custom_button.dart';
import 'package:cxhighversion2/component/custom_network_image.dart';
import 'package:cxhighversion2/home/businessSchool/business_school_collect.dart';
import 'package:cxhighversion2/home/integralRepurchase/integral_repurchase_order.dart';
import 'package:cxhighversion2/information/information_detail.dart';
import 'package:cxhighversion2/machine/machine_order_list.dart';
import 'package:cxhighversion2/mine/cycle_mission.dart';
import 'package:cxhighversion2/mine/integral/integral_cash_order_list.dart';
import 'package:cxhighversion2/mine/integral/my_integral.dart';
import 'package:cxhighversion2/mine/mineStoreOrder/mine_store_order_list.dart';
import 'package:cxhighversion2/mine/mine_help_center.dart';
import 'package:cxhighversion2/mine/mine_setting_list.dart';
import 'package:cxhighversion2/mine/myWallet/my_wallet.dart';
import 'package:cxhighversion2/mine/myWallet/my_wallet_draw.dart';
import 'package:cxhighversion2/mine/personal_information.dart';
import 'package:cxhighversion2/service/http_config.dart';
import 'package:cxhighversion2/service/urls.dart';
import 'package:cxhighversion2/util/EventBus.dart';
import 'package:cxhighversion2/util/app_default.dart';
import 'package:cxhighversion2/util/notify_default.dart';
import 'package:cxhighversion2/util/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MineBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MinePageController>(() => MinePageController());
  }
}

class MinePageController extends GetxController {
  String aboutMeInfoContent = "";
  String serverInfo = "";

  loadAgreement() {
    simpleRequest(
      url: Urls.agreementListByID(1),
      params: {},
      success: (success, json) {
        if (success) {
          serverInfo = (json["data"] ?? {})["content"] ?? "";
        }
      },
      after: () {},
    );
  }

  final _cClient = true.obs;
  bool get cClient => _cClient.value;
  set cClient(v) => _cClient.value = v;

  final _haveVip = false.obs;
  bool get haveVip => _haveVip.value;
  set haveVip(v) => _haveVip.value = v;

  final _isLogin = false.obs;
  set isLogin(value) {
    _isLogin.value = value;
    update();
  }

  get isLogin => _isLogin.value;

  Map homeData = {};
  Map publicHomeData = {};
  String imageUrl = "";

  String topUserCellBuildId = "MinePage_topUserCellBuildId";

  @override
  void onReady() {
    needUpdate();

    super.onReady();
  }

  @override
  void onInit() {
    loadAgreement();

    bus.on(USER_LOGIN_NOTIFY, getNotify);
    bus.on(HOME_DATA_UPDATE_NOTIFY, getNotify);
    bus.on(HOME_PUBLIC_DATA_UPDATE_NOTIFY, getNotify);
    super.onInit();
  }

  getNotify(arg) {
    needUpdate();
  }

  needUpdate() {
    // dataFormat();
    getUserData().then((value) {
      homeData = AppDefault().homeData;
      publicHomeData = AppDefault().publicHomeData;
      dataFormat();
    });
  }

  // @override
  // void onReady() {
  //   homeRequest({}, (success) {});
  //   super.onReady();
  // }

  double moneyNum = 0.0;
  double jfNum = 0.0;

  bool isAuth = false;

  int level = 1;

  dataFormat() {
    imageUrl = AppDefault().imageUrl;
    isLogin = AppDefault().loginStatus;
    // publicHomeData = AppDefault().publicHomeData;
    cClient = false;
    moneyNum = 0.0;
    jfNum = 0.0;
    List accounts = homeData["u_Account"] ?? [];
    for (var e in accounts) {
      if (e["a_No"] >= 4) {
        jfNum += (e["amout"] ?? 0);
      } else if (e["a_No"] <= 3) {
        moneyNum += (e["amout"] ?? 0);
      }
    }
    Map info = (publicHomeData["webSiteInfo"] ?? {})["app"] ?? {};
    // cClient = (AppDefault().homeData["u_Role"] ?? 0) == 0;
    aboutMeInfoContent = info["apP_Introduction"] ?? "";
    isAuth = (homeData["authentication"] ?? {})["isCertified"] ?? false;
    level = homeData["uL_Level"] ?? 1;
    if (level > 9) {
      level = 9;
    }
    update([topUserCellBuildId]);
    update();
  }

  @override
  void onClose() {
    bus.off(USER_LOGIN_NOTIFY, getNotify);
    bus.off(HOME_DATA_UPDATE_NOTIFY, getNotify);
    bus.off(HOME_PUBLIC_DATA_UPDATE_NOTIFY, getNotify);
    super.onClose();
  }
}

class MinePage extends StatefulWidget {
  const MinePage({Key? key}) : super(key: key);
  @override
  State<MinePage> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage>
    with AutomaticKeepAliveClientMixin {
  final controller = Get.find<MinePageController>();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        appBar: getDefaultAppBar(context, "",
            needBack: false,
            color: Colors.transparent,
            action: [
              CustomButton(
                onPressed: () {
                  push(const MineSettingList(), context,
                      binding: MineSettingListBinding());
                },
                child: Container(
                  padding: EdgeInsets.only(left: 8.w),
                  height: kToolbarHeight,
                  width: (22 + 15 * 2).w,
                  child: Center(
                    child: Image.asset(
                      assetsName("mine/btn_sz"),
                      width: 21.w,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ),
              CustomButton(
                onPressed: () {
                  ShowToast.normal("????????????!");
                },
                child: Container(
                  padding: EdgeInsets.only(right: 5.w),
                  height: kToolbarHeight,
                  width: (22 + 15 * 2).w,
                  child: Center(
                    child: Image.asset(
                      assetsName("mine/btn_tz"),
                      width: 21.w,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              )
            ]),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              ghb(10),
              //????????????
              toLoginButton(context),
              ghb(10),
              // vip
              vipView(),
              ghb(15),
              // ????????????
              GetBuilder<MinePageController>(
                builder: (_) {
                  return sbRow([
                    walletView(
                      "????????????",
                      "?????? ${priceFormat(controller.moneyNum, savePoint: 2, tenThousand: true, tenThousandUnit: false)} ${controller.moneyNum > 10000.0 ? "???" : ""}???",
                      onPressed: () {
                        push(const MyWallet(), context,
                            binding: MyWalletBinding());
                      },
                    ),
                    walletView(
                      "????????????",
                      "?????? ${priceFormat(
                        controller.jfNum,
                        savePoint: 0,
                        tenThousand: true,
                        tenThousandUnit: false,
                      )} ${controller.jfNum > 10000.0 ? "???" : ""}???",
                      onPressed: () {
                        push(const MyIntegral(), context,
                            binding: MyIntegralBinding());
                      },
                    ),
                  ], width: 345);
                },
              ),
              ghb(15),
              // ????????????
              orderView(),
              ghb(15),
              weekMission(),
              ghb(15),
              GetBuilder<MinePageController>(
                builder: (_) {
                  return GetX<MinePageController>(
                    builder: (_) {
                      return controller.haveVip ? rewardCell() : ghb(0);
                    },
                  );
                },
              ),
              GetBuilder<MinePageController>(
                builder: (_) {
                  return Container(
                      width: 345.w,
                      padding: EdgeInsets.symmetric(vertical: 4.25.w),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.w),
                          boxShadow: [
                            BoxShadow(
                                color: const Color(0xFFE9EDF5),
                                offset: Offset(0, 8.5.w),
                                blurRadius: 25.5.w,
                                spreadRadius: 15.5.w)
                          ]),
                      child: Column(
                        children: List.generate(5, (index) {
                          String image = "";
                          String title = "";
                          int last = 5 - 1;
                          switch (index) {
                            case 0:
                              image = "mine/icon_jyjl";
                              title = "????????????";
                              break;
                            // case 1:
                            //   image = "mine/icon_syjl";
                            //   title = "????????????";
                            //   break;
                            case 1:
                              image = "mine/icon_bzzx";
                              title = "????????????";
                              break;
                            case 2:
                              image = "mine/icon_wdsc";
                              title = "????????????";
                              break;
                            case 3:
                              image = "mine/icon_gywm";
                              title = "????????????";
                              break;
                            case 4:
                              image = "mine/icon_fwly";
                              title = "????????????";
                              break;
                            default:
                          }

                          return CustomButton(
                            onPressed: () {
                              if (index == 0) {
                                // push(const MyWallet(), context,
                                //     binding: MyWalletBinding());
                                push(const InformationDetail(), context,
                                    binding: InformationDetailBinding());
                              } else if (index == 1) {
                                // ShowToast.normal("????????????!");
                                push(const MineHelpCenter(), context,
                                    binding: MineHelpCenterBinding());
                              } else if (index == 2) {
                                // controller.cClient
                                //     ? push(
                                //         const IdentityAuthentication(), context,
                                //         binding:
                                //             IdentityAuthenticationBinding())
                                //     : push(const MineAddressManager(), context,
                                //         binding: MineAddressManagerBinding());
                                push(const BusinessSchoolCollect(), context,
                                    binding: BusinessSchoolCollectBinding());
                              } else if (index == 3) {
                                // controller.cClient
                                //     ? push(const MineCustomerService(), context,
                                //         binding: MineCustomerServiceBinding())
                                //     : push(const MineCertificateAuthorization(),
                                //         context,
                                //         binding:
                                //             MineCertificateAuthorizationBinding());
                                pushInfoContent(
                                  title: "????????????",
                                  content: controller.aboutMeInfoContent,
                                  isText: true,
                                );
                              } else if (index == 4) {
                                // push(const IdentityAuthentication(), context,
                                //     binding: IdentityAuthenticationBinding());
                                // push(const MachinePayPage(), context,
                                //     binding: MachinePayPageBinding());
                                pushInfoContent(
                                  title: "????????????",
                                  content: controller.serverInfo,
                                );
                              } else if (index == 5) {
                                // push(const MineCustomerService(), context,
                                //     binding: MineCustomerServiceBinding());
                                // push(const MachinePayPage(), context,
                                //     binding: MachinePayPageBinding());
                              } else if (index == 6) {
                                // push(const MineTransactionFormat(), context,
                                //     binding: MineTransactionFormatBinding());
                              }
                            },
                            child: sbRow([
                              Image.asset(
                                assetsName(image),
                                height: 30.w,
                                fit: BoxFit.fitHeight,
                              ),
                              SizedBox(
                                height: 54.5.w,
                                child: Center(
                                  child: sbRow([
                                    getSimpleText(
                                        title, 14, const Color(0xFF565B66),
                                        textHeight: 1.1),
                                    Image.asset(
                                      assetsName("mine/icon_right_arrow"),
                                      width: 11.w,
                                      fit: BoxFit.fitWidth,
                                    )
                                  ], width: 345 - 16 * 2 - 40 - 0.1),
                                ),
                              )
                            ], width: 345 - 16 * 2),
                          );
                        }),
                      ));
                },
              ),
              ghb(16),
            ],
          ),
        ),
      ),
    );
  }

  Widget walletView(String title, String amout, {Function()? onPressed}) {
    return CustomButton(
      onPressed: onPressed,
      child: Container(
          width: 165.w,
          height: 65.w,
          padding: EdgeInsets.only(right: 15.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.w),
          ),
          child: centRow([
            centRow([
              Image.asset(
                assetsName(
                    "mine/${title == "????????????" ? "icon_qbye" : "icon_jfye"}"),
                height: 26.w,
                fit: BoxFit.fitHeight,
              ),
              gwb(17.5),
              centClm([
                getSimpleText(title, 15, AppColor.text, isBold: true),
                getSimpleText(amout, 12, AppColor.text2),
              ], crossAxisAlignment: CrossAxisAlignment.start),
            ])
          ])),
    );
  }

  Widget orderView() {
    return GetBuilder<MinePageController>(
      id: controller.topUserCellBuildId,
      builder: (_) {
        // String levelStr = controller.homeData["uLevel"] ?? "";
        return Container(
          width: 345.w,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(8.w)),
          child: Column(
            children: [
              ghb(15),
              sbRow([getSimpleText("????????????", 16, AppColor.text, isBold: true)],
                  width: 345 - 15.5 * 2),
              ghb(15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(4, (index) {
                  String image = "mine/icon_jfhg";
                  String text = "????????????";

                  switch (index) {
                    case 0:
                      image = "mine/icon_jfhg";
                      text = "????????????";
                      break;
                    case 1:
                      image = "mine/icon_jfdx";
                      text = "????????????";
                      break;
                    case 2:
                      image = "mine/icon_jffg";
                      text = "????????????";
                      break;
                    case 3:
                      image = "mine/icon_sbdd";
                      text = "????????????";
                      break;
                    // case 4:
                    //   image = "mine/btn_ywc";
                    //   text = "?????????";
                    //   break;
                    // default:
                  }

                  return CustomButton(
                    onPressed: () {
                      // if (index == 0) {

                      // } else if (index == 1) {
                      // } else if (index == 2) {
                      // } else if (index == 3) {}
                      if (index == 0) {
                        push(const MallOrderPage(), null,
                            binding: MallOrderPageBinding(),
                            arguments: {"index": 0});
                      } else if (index == 1) {
                        push(const IntegralCashOrderList(), context,
                            binding: IntegralCashOrderListBinding());
                      } else if (index == 2) {
                        push(const IntegralRepurchaseOrder(), context,
                            binding: IntegralRepurchaseOrderBinding());
                      } else if (index == 3) {
                        push(const MachineOrderList(), context,
                            binding: MachineOrderListBinding());
                      } else {
                        push(
                            MineStoreOrderList(
                              orderType: StoreOrderType.storeOrderTypePackage,
                              index: index,
                            ),
                            context,
                            binding: MineStoreOrderListBinding());
                      }
                    },
                    child: SizedBox(
                      width: (345 / 4 - 0.1).w,
                      child: centClm([
                        Image.asset(
                          assetsName(image),
                          height: 45.w,
                          fit: BoxFit.fitHeight,
                        ),
                        ghb(8),
                        getSimpleText(text, 14, AppColor.text2)
                      ]),
                    ),
                  );
                }),
              ),
              ghb(12)
            ],
          ),
        );
      },
    );
  }

  Widget vipView() {
    return GetBuilder<MinePageController>(
      builder: (_) {
        return Container(
          width: 345.w,
          // height: 80.w,
          decoration: BoxDecoration(
            color: Colors.transparent,
            image: DecorationImage(
                fit: BoxFit.fill, image: AssetImage(assetsName("mine/bg_vip"))),
          ),
          child: Column(
            children: [
              ghb(9),
              sbRow([
                centRow([
                  getSimpleText(controller.homeData["uLevel"] ?? "", 15,
                      const Color(0xFFBB5D10),
                      isBold: true),
                  gwb(2),
                  Image.asset(
                    assetsName("mine/vip/level${controller.level}"),
                    width: 31.5.w,
                    fit: BoxFit.fitWidth,
                  )
                ]),
                getSimpleText(
                    "????????? ${(controller.homeData["teamTotalNum"] ?? 0)}/${(controller.homeData["upTerminalNum"] ?? 0)}",
                    10,
                    const Color(0xFF5A2F0F))
              ], width: 345 - 15 * 2),
              ghb(6),
              Container(
                width: 315.w,
                height: 3.w,
                decoration: BoxDecoration(
                    color: const Color(0xFFFF860B).withOpacity(0.5),
                    borderRadius: BorderRadius.circular(1.5.w)),
                child: Stack(children: [
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    width: (controller.homeData["teamTotalNum"] ?? 0) /
                        (controller.homeData["upTerminalNum"] ?? 1) *
                        315.w,
                    left: 0,
                    bottom: 0,
                    top: 0,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(1.5.w)),
                    ),
                  )
                ]),
              ),
              ghb(6),
              sbRow([
                Text.rich(
                  TextSpan(
                      text: "???????????????",
                      style: TextStyle(
                          fontSize: 10.w,
                          color: const Color(0xFF5A2F0F).withOpacity(0.7)),
                      children: [
                        TextSpan(
                            text: "${controller.homeData["teamTotalNum"] ?? 0}",
                            style: const TextStyle(
                                color: Color(0xFF5A2F0F),
                                fontWeight: AppDefault.fontBold)),
                        const TextSpan(text: "???"),
                        WidgetSpan(child: gwb(10)),
                        const TextSpan(text: "???????????????"),
                        TextSpan(
                            text:
                                "${controller.homeData["teamTotalFailureNum"] ?? 0}",
                            style: const TextStyle(
                                color: Color(0xFF5A2F0F),
                                fontWeight: AppDefault.fontBold)),
                        const TextSpan(text: "???"),
                        WidgetSpan(child: gwb(10)),
                        const TextSpan(text: "??????????????????"),
                        TextSpan(
                            text:
                                "${(controller.homeData["upTerminalNum"] ?? 0) - (controller.homeData["teamTotalNum"] ?? 0)}",
                            style: const TextStyle(
                                color: Color(0xFF5A2F0F),
                                fontWeight: AppDefault.fontBold)),
                        const TextSpan(text: "???"),
                      ]),
                ),
              ], width: 345 - 15 * 2),
              ghb(9)
            ],
          ),
        );
      },
    );
  }

  // ?????????
  Widget weekMission() {
    return CustomButton(
      onPressed: () {
        push(const CycleMission(), context, binding: CycleMissionBinding());
      },
      child: GetBuilder<MinePageController>(
        builder: (_) {
          return Container(
            width: 345.w,
            height: 45.w,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(8.w)),
            child: Center(
              child: sbRow([
                centRow([
                  Image.asset(
                    assetsName("mine/icon_zqrw"),
                    width: 19.w,
                    fit: BoxFit.fitWidth,
                  ),
                  gwb(15),
                  getWidthText(
                      "?????????????????????", 14, AppColor.text, 305 - 19 - 15 - 51, 1,
                      textHeight: 1.2),
                  // getSimpleText(title, 14, AppColor.text, isBold: true),
                ]),
                getSimpleText("????????????", 12, AppColor.theme)
              ], width: 345 - 20 * 2),
            ),
          );
        },
      ),
    );
  }

  Widget rewardCell() {
    Map publicHomeData = AppDefault().publicHomeData;
    Map drawInfo = publicHomeData["drawInfo"] ?? {};
    List tmpWallet = [];

    if (!HttpConfig.baseUrl.contains("woliankeji")) {
      tmpWallet = ((controller.homeData["u_Account"] ?? []) as List).map((e) {
        e["show"] = true;
        Map walletDrawInfo = {};
        if (drawInfo["draw_Account${e["a_No"] ?? -1}"] != null) {
          walletDrawInfo = drawInfo["draw_Account${e["a_No"] ?? -1}"];
        }
        e["haveDraw"] = walletDrawInfo.isNotEmpty;
        if (walletDrawInfo.isNotEmpty) {
          e["minCharge"] =
              "${walletDrawInfo["draw_Account_SingleAmountMin"] ?? 0}";
          e["charge"] = "${walletDrawInfo["draw_Account_ServiceCharges"] ?? 0}";
          e["fee"] = "${walletDrawInfo["draw_Account_SingleFee"] ?? 0}";
        }
        return e;
      }).toList();
    } else if (HttpConfig.baseUrl.contains("woliankeji")) {
      List drawWallets =
          ((drawInfo["System_AllowDrawAccount"] ?? "") as String).split(",");
      List drawCharges =
          ((drawInfo["System_TiHandlingCharge"] ?? "") as String).split(",");
      List drawFees = ((drawInfo["System_DrawFee"] ?? "") as String).split(",");

      tmpWallet = ((controller.homeData["u_Account"] ?? []) as List).map((e) {
        e["show"] = true;

        int walletIdx = -1;
        for (var i = 0; i < drawWallets.length; i++) {
          if (e["a_No"] == int.parse(drawWallets[i])) {
            walletIdx = i;
            break;
          }
        }
        e["haveDraw"] = walletIdx != -1 ? true : false;

        if (walletIdx != -1) {
          e["minCharge"] = drawInfo["System_MinHandingCharge"];
          e["charge"] = drawCharges[walletIdx];
          e["fee"] = drawFees[walletIdx];
        }
        return e;
      }).toList();
    }

    Map walletData = {};
    for (var e in tmpWallet) {
      if (e["haveDraw"] != null && e["haveDraw"]) {
        walletData = e;
        break;
      }
    }

    return CustomButton(
      onPressed: () {
        if (walletData.isEmpty) {
          toLogin();
          return;
        }
        push(MyWalletDraw(walletData: walletData), context,
            binding: MyWalletDrawBinding());
      },
      child: Container(
        width: 345.w,
        height: 80.w,
        decoration: BoxDecoration(
            color: AppDefault().getThemeColor() ?? AppColor.blue,
            borderRadius: BorderRadius.circular(12.w),
            image: DecorationImage(
                image: AssetImage(assetsName("mine/bg_reward_cell")),
                fit: BoxFit.fill),
            boxShadow: [
              BoxShadow(
                  color: const Color(0x322368F2),
                  offset: Offset(0, 8.5.w),
                  blurRadius: 5.5.w)
            ]),
        child: Column(
          children: [
            ghb(20),
            Row(
              children: [
                gwb(25),
                getRichText("???", priceFormat(walletData["amout"] ?? 0), 12,
                    Colors.white, 24, Colors.white,
                    fw2: AppDefault.fontBold),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget toLoginButton(BuildContext context) {
    return CustomButton(
      onPressed: () {
        if (controller.isLogin) {
          push(
            const PersonalInformation(),
            context,
            binding: PersonalInformationBinding(),
          );
        } else {
          toLogin();
        }
      },
      child: GetBuilder<MinePageController>(
        init: controller,
        id: controller.topUserCellBuildId,
        initState: (_) {},
        builder: (_) {
          double maxNameWidth = 345 - (64 + 16 + 3 + 5 + 50) - 0.1;

          String name = controller.isLogin
              ? (controller.homeData["nickName"] != null &&
                      controller.homeData["nickName"].isNotEmpty
                  ? controller.homeData["nickName"]
                  : "???????????????")
              : "????????????";
          double nameWidth = maxNameWidth.w;

          return SizedBox(
            width: 375.w,
            child: Align(
              child: sbRow([
                GetX<MinePageController>(
                  builder: (_) {
                    return centRow([
                      Container(
                        width: 60.w,
                        height: 60.w,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(31.w),
                            color: Colors.white),
                        child: Center(
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(32.w),
                                child: controller.isLogin
                                    ? CustomButton(
                                        onPressed: () {
                                          if (controller
                                                      .homeData["userAvatar"] !=
                                                  null &&
                                              controller.homeData["userAvatar"]
                                                  .isNotEmpty) {
                                            toCheckImg(
                                                image:
                                                    "${controller.imageUrl}${controller.homeData["userAvatar"]}",
                                                needSave: true);
                                          }
                                        },
                                        child: CustomNetworkImage(
                                          src:
                                              "${controller.imageUrl}${controller.homeData["userAvatar"]}",
                                          width: 60.w,
                                          height: 60.w,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Image.asset(
                                        assetsName(
                                            "home/machinetransfer/icon_machine_transfer_defaultpeople"),
                                        width: 60.w,
                                        height: 60.w,
                                        fit: BoxFit.fill,
                                      ))),
                      ),
                      gwb(15),
                      centClm([
                        SizedBox(
                          width: (375 - 21 * 2 - 60 - 15 - 1).w,
                          child: Text.rich(
                            TextSpan(
                                text: name,
                                style: TextStyle(
                                    fontSize: 18.sp,
                                    color: (controller.homeData["nickName"] !=
                                                    null &&
                                                controller.homeData["nickName"]
                                                    .isNotEmpty) ||
                                            !controller.isLogin
                                        ? AppColor.text
                                        : AppColor.textGrey,
                                    fontWeight: AppDefault.fontBold,
                                    height: 1.1),
                                children: [
                                  WidgetSpan(
                                      child: Padding(
                                    padding: EdgeInsets.only(left: 5.w),
                                    child: Image.asset(
                                      assetsName(
                                          "mine/vip/level${controller.level}"),
                                      width: 31.5.w,
                                      height: 20.w,
                                      fit: BoxFit.fitWidth,
                                    ),
                                  )),
                                  WidgetSpan(
                                      child: !controller.isAuth
                                          ? gwb(0)
                                          : Padding(
                                              padding:
                                                  EdgeInsets.only(left: 4.w),
                                              child: Image.asset(
                                                assetsName("mine/icon_isauth"),
                                                width: 54.5.w,
                                                height: 20.w,
                                                fit: BoxFit.fitWidth,
                                              ),
                                            )),
                                ]),
                            maxLines: 10,
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        ghb(5),
                        getSimpleText(
                            controller.isLogin
                                ? "????????????${controller.homeData["u_Mobile"] ?? ""}"
                                : "????????????????????????????????????",
                            12,
                            AppColor.text2),
                      ], crossAxisAlignment: CrossAxisAlignment.start)
                    ]);
                  },
                ),
              ],
                  width: 375 - 21 * 2,
                  crossAxisAlignment: CrossAxisAlignment.start),
            ),
          );
        },
      ),
    );
  }

  Widget orderButtons(String title, String assets,
      {Function()? onPressed, int type = 0}) {
    return CustomButton(
      onPressed: onPressed,
      child: SizedBox(
        width: 375.w / 4 - 0.1.w,
        height: 67.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              assetsName(assets.isNotEmpty ? assets : "pay/icon_business"),
              height: type == 1 ? 30.w : 20.w,
              fit: BoxFit.fitHeight,
            ),
            ghb(15),
            getSimpleText(title, 14, AppColor.textBlack),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
