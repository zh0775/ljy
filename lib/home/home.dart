import 'dart:convert' as convert;

import 'package:cxhighversion2/bounspool/bonuspool.dart';
import 'package:cxhighversion2/component/app_banner.dart';
import 'package:cxhighversion2/component/app_bottom_tips.dart';
import 'package:cxhighversion2/component/app_lottery_webview.dart';
import 'package:cxhighversion2/component/custom_button.dart';
import 'package:cxhighversion2/component/custom_network_image.dart';
import 'package:cxhighversion2/component/custom_webview.dart';
import 'package:cxhighversion2/home/businessSchool/business_school_detail.dart';
import 'package:cxhighversion2/home/component/custom_message.dart';
import 'package:cxhighversion2/home/contactCustomerService/contact_customer_service.dart';
import 'package:cxhighversion2/home/fodderlib/fodder_lib.dart';
import 'package:cxhighversion2/home/integralRepurchase/integral_repurchase.dart';
import 'package:cxhighversion2/home/machine_manage.dart';
import 'package:cxhighversion2/home/machinetransfer/machine_transfer.dart';
import 'package:cxhighversion2/home/machinetransfer/machine_transfer_userlist.dart';
import 'package:cxhighversion2/home/member_charge.dart';
import 'package:cxhighversion2/home/merchantAccessNetwork/merchant_access_network.dart';
import 'package:cxhighversion2/home/myTeam/my_team.dart';
import 'package:cxhighversion2/home/mybusiness/mybusiness.dart';
import 'package:cxhighversion2/home/news/news_detail.dart';
import 'package:cxhighversion2/home/news/news_list.dart';
import 'package:cxhighversion2/home/redpacket/redpacket.dart';
import 'package:cxhighversion2/home/store/vip_store.dart';
import 'package:cxhighversion2/home/terminal_binding.dart';
import 'package:cxhighversion2/machine/machine_pay_page.dart';
import 'package:cxhighversion2/machine/machine_register.dart';
import 'package:cxhighversion2/mine/identityAuthentication/identity_authentication.dart';
import 'package:cxhighversion2/mine/mine_help_center.dart';
import 'package:cxhighversion2/mine/myWallet/my_wallet.dart';
import 'package:cxhighversion2/mine/myWallet/my_wallet_deal_list.dart';
import 'package:cxhighversion2/pay/share_invite.dart';
import 'package:cxhighversion2/product/product.dart';
import 'package:cxhighversion2/product/product_purchase_list.dart';
import 'package:cxhighversion2/rank/rank.dart';
import 'package:cxhighversion2/service/http.dart' as ht;
import 'package:cxhighversion2/service/http_config.dart';
import 'package:cxhighversion2/service/urls.dart';
import 'package:cxhighversion2/statistics/userManage/statistics_user_manage.dart';
import 'package:cxhighversion2/util/EventBus.dart';
import 'package:cxhighversion2/util/app_default.dart';
import 'package:cxhighversion2/util/notify_default.dart';
import 'package:cxhighversion2/util/storage_default.dart';
import 'package:cxhighversion2/util/toast.dart';
import 'package:cxhighversion2/util/tools.dart';
import 'package:cxhighversion2/util/user_default.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dynamic_icon_flutter/dynamic_icon_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'businessSchool/business_school_list_page.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
  }
}

class HomeController extends FullLifeCycleController {
  // PageController bannerCtrl = PageController();
  //从后台到前台时刷新公共数据
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        // refreshPublicHomeData();
        // Map data = await compute(HomeController.backUpRefreshPublicData, false);
        // parsePublicData(data, notify: false);
        break;
      case AppLifecycleState.inactive:
        // DynamicIconFlutter.setIcon(
        //     icon: "vip2", listAvailableIcon: ["vip1", "vip2", "MainActivity"]);
        break;
      default:
    }
  }

  List btnDatas = [];
  //导航方式 1.立体旋转 2.底部按钮
  final _pageStyle = 0.obs;
  int get pageStyle => _pageStyle.value;
  set pageStyle(v) {
    if (_pageStyle.value != v) {
      _pageStyle.value = v;
      bus.emit(NOTIFY_CHANGE_PAGE_STYLE, {"value": pageStyle});
    }
  }

  String drawBoundStr = "";

  // 奖金池金额
  final _bonusPoolMoney = 0.0.obs;
  double get bonusPoolMoney => _bonusPoolMoney.value;
  set bonusPoolMoney(v) => _bonusPoolMoney.value = v;

  //是否有个人数据模块
  final _havePersionData = false.obs;
  bool get havePersionData => _havePersionData.value;
  set havePersionData(v) => _havePersionData.value = v;
  //是否有团队数据模块
  final _haveTeamData = false.obs;
  bool get haveTeamData => _haveTeamData.value;
  set haveTeamData(v) => _haveTeamData.value = v;
  //是否有积分商城模块
  final _haveIntegral = false.obs;
  bool get haveIntegral => _haveIntegral.value;
  set haveIntegral(v) => _haveIntegral.value = v;
  //积分商城数据
  final _integralData = Rx<List>([]);
  set integralData(v) => _integralData.value = v;
  List get integralData => _integralData.value;

  bool haveNews = false;

  //请求积分商城
  loadIntegral() {
    simpleRequest(
      url: Urls.userProductHomeInfo(2),
      params: {},
      success: (success, json) {
        if (success) {
          Map data = json["data"] ?? {};
          if (data["recommend"] != null) {
            integralData = data["recommend"];
            if (integralData.length > 4) {
              integralData = integralData.sublist(0, 4);
            }
            UserDefault.saveStr(
                HOME_INTEGRAL_DATA_STORAGE, convert.jsonEncode(integralData));
          }
        }
      },
      after: () {},
    );
  }

  //是否有商学院模块
  final _haveBusiness = false.obs;
  bool get haveBusiness => _haveBusiness.value;
  set haveBusiness(v) => _haveBusiness.value = v;
  //商学院数据
  final _businessData = Rx<List>([]);
  List get businessData => _businessData.value;
  set businessData(v) => _businessData.value = v;
  //请求商学院数据
  loadBusiness() {
    simpleRequest(
      url: Urls.userBusinessSchoolInfo,
      params: {},
      success: (success, json) {
        if (success) {
          Map data = json["data"] ?? {};
          if (data["typeList"] != null && data["typeList"].isNotEmpty) {
            List items = [];
            for (var e in (data["typeList"] ?? [])) {
              if (e["items"] != null && e["items"].isNotEmpty) {
                items.addAll(e["items"]);
              }
            }
            businessData = items;
            if (businessData.length > 4) {
              businessData = businessData.sublist(0, 4);
            }
            UserDefault.saveStr(
                HOME_BUSINESS_DATA_STORAGE, convert.jsonEncode(businessData));
          }
        }
      },
      after: () {},
    );
  }

  //是否有产品模块
  final _haveProduct = false.obs;
  bool get haveProduct => _haveProduct.value;
  set haveProduct(v) => _haveProduct.value = v;
  //产品数据
  final _productData = Rx<List>([]);
  List get productData => _productData.value;
  set productData(v) => _productData.value = v;
  //请求产品数据
  loadProductData() {
    simpleRequest(
      url: Urls.userLevelGiftList,
      params: {"pageNo": 1, "pageSize": 4, "levelType": "2"},
      success: (success, json) {
        if (success) {
          Map data = json["data"] ?? {};
          if (data["data"] != null) {
            productData = data["data"];
            if (productData.length > 4) {
              productData = productData.sublist(0, 4);
            }
            UserDefault.saveStr(
                HOME_PRODUCT_DATA_STORAGE, convert.jsonEncode(productData));
          }
        }
      },
      after: () {},
    );
  }

  //是否实名
  bool isAuth = false;
  //是否绑卡
  bool isBindCard = false;
  //是否弹窗
  bool haveAlertShow = false;
  //是否已经存在升级弹窗
  bool updateAlertExist = false;
  //弹出窗口
  showHomeAlert() {
    AppDefault().firstAlertFromLogin = false;
    if (haveAlertShow) {
      return;
    }
    bool haveAlertNews = false;

    if (homeData["authentication"] != null &&
        homeData["authentication"]["isCertified"] != null) {
      isAuth = (homeData["authentication"] ?? {})["isCertified"] ?? false;
    }

    if (homeData["appHomeNews"] != null && homeData["appHomeNews"].isNotEmpty) {
      imagePerLoad(homeData["appHomeNews"][0]["n_Image"] ?? "");
      haveAlertNews = true;
    }
    haveAlertShow = true;
    homeFirst = false;
    if (haveAlertNews) {
      Future.delayed(const Duration(milliseconds: 500), () {
        showNewsAlert(
          context: Global.navigatorKey.currentContext!,
          newData: homeData["appHomeNews"][0],
          barrierDismissible: true,
          close: () {
            haveAlertShow = false;
            if (!isAuth) {
              if (Global.navigatorKey.currentContext != null) {
                showAuthAlert(
                    barrierDismissible: true,
                    context: Global.navigatorKey.currentContext!,
                    isAuth: true);
              }
            }
          },
        );
      });
    } else {
      if (!isAuth) {
        // homeFirst = false;
        Future.delayed(const Duration(milliseconds: 500), () {
          showAuthAlert(
            context: Global.navigatorKey.currentContext!,
            isAuth: true,
            barrierDismissible: true,
            close: () {
              haveAlertShow = false;
            },
          );
        });
      }
    }
  }

  //请求HomeData
  refreshHomeData({Function(bool succ)? succ, bool format = true}) async {
    AppDefault appDefault = AppDefault();
    if (appDefault.deviceId.isEmpty) {
      String? dId = await PlatformDeviceId.getDeviceId;
      appDefault.deviceId = dId ?? "";
    }
    if (appDefault.version.isEmpty) {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      appDefault.version = packageInfo.version;
      appDefault.appName = packageInfo.appName;
      appDefault.buildNumber = packageInfo.buildNumber;
      appDefault.packageName = packageInfo.packageName;
    }
    simpleRequest(
      url: Urls.homeData,
      params: {
        "phoneKey": appDefault.deviceId,
        "versionNumber": appDefault.version,
        "versionOrigin": appDefault.versionOrigin
      },
      success: (success, json) async {
        Map data = json["data"] ?? {};
        if (success) {
          setUserDataFormat(true, data, {}, {}).then((value) async {
            await getHomeData();
            if (format) {
              dataFormat(isHomeData: true);
            }
            bus.emit(HOME_DATA_UPDATE_NOTIFY);
          });
        }
        if (succ != null) {
          succ(success);
        }
      },
      after: () {
        Future.delayed(const Duration(seconds: 10), () {
          if (succ != null) {
            succ(false);
          }
        });
      },
    );
  }

  //请求PublicHomeData
  refreshPublicHomeData({bool coerce = false}) async {
    if (!coerce && !AppDefault().loginStatus) {
      return;
    }
    simpleRequest(
      url: Urls.publicHomeData,
      params: {},
      success: (success, json) {
        if (success) {
          Map data = json["data"] ?? {};
          parsePublicData(data);
          // pullCtrl?.refreshCompleted();
        } else {
          // pullCtrl?.refreshFailed();
        }
      },
      after: () {},
    );
  }

  static Future<Map> backUpRefreshPublicData(bool noNotify) async {
    // if (!coerce && !AppDefault().loginStatus) {
    //   return;
    // }
    dio.Response response = await ht.Http().dio.post(
      Urls.publicHomeData,
      data: {},
    );
    if (response.statusCode == 200) {
      Map<dynamic, dynamic> data = response.data;
      if (response.data["success"] ?? false) {
        return data["data"] ?? {};
      }
    }

    return {};
  }

  parsePublicData(Map data, {bool notify = true}) {
    setUserDataFormat(true, {}, data, {}).then((value) {
      getHomeData();
      dataFormat(isHomeData: false);
      if (notify) {
        bus.emit(HOME_PUBLIC_DATA_UPDATE_NOTIFY);
      }
    });
  }

  homeOnRefresh({Function(bool success)? succ}) {
    refreshHomeData(succ: succ);
    refreshPublicHomeData();
  }

  final scrollCtrl = ScrollController();

  Map homeData = {};
  Map publicHomeData = {};
  List myMessages = [];

  final _topBanners = Rx<List<BannerData>>([]);
  List<BannerData> get topBanners => _topBanners.value;
  set topBanners(v) => _topBanners.value = v;

  String imageUrl = "";
  final _centerBtnIndex = 0.obs;
  get centerBtnIndex => _centerBtnIndex.value;
  set centerBtnIndex(value) => _centerBtnIndex.value = value;
  bool homeFirst = true;
  @override
  void onInit() async {
    ambiguate(WidgetsBinding.instance)?.addObserver(this);
    bus.on(NOTIFY_LOGIN_BACK_CHECK_HOME_ALERT, (arg) {
      if (AppDefault().loginStatus) {
        showHomeAlert();
      }
    });
    needUpdate();
    refreshHomeData();
    bus.on(USER_LOGIN_NOTIFY, getUserLoginNotify);
    super.onInit();
  }

  getUserLoginNotify(arg) {
    needUpdate();
  }

  @override
  void onClose() {
    ambiguate(WidgetsBinding.instance)?.removeObserver(this);
    scrollCtrl.dispose();
    bus.off(USER_LOGIN_NOTIFY, getUserLoginNotify);
    super.onClose();
  }

  needUpdate() async {
    await getHomeData();
    dataFormat();
  }

  getHomeData() async {
    homeData = AppDefault().homeData;
    publicHomeData = AppDefault().publicHomeData;
    if (homeData.isEmpty || publicHomeData.isEmpty) {
      await getUserData();
    }
    homeData = AppDefault().homeData;
    publicHomeData = AppDefault().publicHomeData;
    if (homeData.isEmpty) {
      setUserDataFormat(false, {}, {}, {})
          .then((value) => toLogin(isErrorStatus: true, errorCode: 202));
      return;
    } else {
      Map authData = homeData["authentication"] ?? {};
      isAuth = authData["isCertified"] ?? false;
      isBindCard = authData["isBank"] ?? false;
      imageUrl = AppDefault().imageUrl;
      // if (!isAuth) {
      //   if (Global.navigatorKey.currentContext != null) {
      //     showAuthAlert(
      //         context: Global.navigatorKey.currentContext!, isAuth: true);
      //   }
      // }
    }
  }

  final _haveAddModule = false.obs;
  bool get haveAddModule => _haveAddModule.value;
  set haveAddModule(v) => _haveAddModule.value = v;
  List middleIcons = [];

  String subTitle = "";

  dataFormat({bool isHomeData = false}) {
    if (!AppDefault().loginStatus) {
      return;
    }
    /*
    //标板2.0没有自定义首页
    if (homeData.isNotEmpty) {
      modules = homeData["homeModule"] ?? [];
      haveAddModule = false;
      for (var e in modules) {
        if (e["module_Flag"] == 0) {
          haveAddModule = true;
          break;
        }
      }
      loadModulesData();
    }
     */

    // cClient = (homeData["u_Role"] ?? 0) == 0;
    // cClient = true;
    // if ((homeData["u_Role"] ?? 0) == 0) {
    // }
    haveNews = homeData["news"] != null && homeData["news"].isNotEmpty;
    myMessages = homeData["news"] ?? [];
    if (publicHomeData.isNotEmpty) {
      List tmpBanners = (publicHomeData["appCofig"] ?? {})["topBanner"] ?? [];
      tmpBanners = tmpBanners.where((e) {
        String type = e["u_Type"] ?? "";
        List types = type.split(",");
        if (cClient && types.contains("2")) {
          return true;
        } else if (!cClient && types.contains("1")) {
          return true;
        } else {
          return false;
        }
      }).toList();
      topBanners = tmpBanners.map((e) {
        return BannerData(
            imagePath: "$imageUrl${e["apP_Pic"]}",
            id: "${e["id"]}",
            data: e,
            boxFit: BoxFit.fill);
      }).toList();
      btnDatas = [];
      List tmpMiddle = publicHomeData["appCofig"]["middleIcon"];
      middleIcons = [];
      if (AppDefault().checkDay) {
        middleIcons = publicHomeData["appCofig"]["middleIcon"];
      } else {
        for (var e in tmpMiddle) {
          if (e["id"] != 2082 && e["id"] != 2083) {
            middleIcons.add(e);
          }
        }
      }

      List tmpBtnDatas = middleIcons.map((e) {
        return Map<String, dynamic>.from({
          "img": "$imageUrl${e["apP_Pic"]}",
          "name": e["apP_Title"] ?? "",
          "id": e["id"],
          "path": e["apP_Url"]
        });
      }).toList();

      int centerBtnIdx = 0;
      for (var i = 0; i < tmpBtnDatas.length; i++) {
        if (i % 8 == 0) {
          if (i != 0) centerBtnIdx++;
          btnDatas.add([]);
        }
        Map e = tmpBtnDatas[i];
        btnDatas[centerBtnIdx].add(Map<String, dynamic>.from({
          "img": e["img"],
          "name": e["name"],
          "id": e["id"],
          "path": e["path"]
        }));
      }

      subTitle =
          ((publicHomeData["webSiteInfo"] ?? {})["app"])["apP_SubTitle"] ?? "";
      subTitle = "欢迎您，联聚云团队!";
    }
    if (!cClient &&
        AppDefault().safeAlert &&
        isHomeData &&
        (AppDefault().firstAlertFromLogin || homeFirst)) {
      showHomeAlert();
    }
    update();
    // if (cClient) {
    //   // if (!homeFirst) {
    //   //   loadWebView();
    //   // }
    //   // loadWebView();
    //   update(["lotteryWebView_buildId"]);
    // }
  }

  final _cClient = false.obs;
  bool get cClient => _cClient.value;
  set cClient(v) => _cClient.value = v;

  double webViewHeight = 447;
  // WebViewController? _myWebCtrl;
  // LotteryChannel? lotteryChannel;
  // set myWebCtrl(v) {
  //   _myWebCtrl = v;
  //   loadWebView();
  //   lotteryChannel ??= LotteryChannel(webViewCtrl: myWebCtrl);
  // }

  // WebViewController? get myWebCtrl => _myWebCtrl;

  // loadWebView() {
  //   if (AppDefault().token.isEmpty || homeData.isEmpty) {
  //     return;
  //   }
  //   String params = "";
  //   if (homeData["lotteryConfig"] != null &&
  //       homeData["lotteryConfig"] is List &&
  //       homeData["lotteryConfig"].isNotEmpty) {
  //     Map lData = homeData["lotteryConfig"][0];
  //     params += "&prizeList=${convert.jsonEncode(lData["prizeList"] ?? [])}";
  //     params += "&costAmount=${lData["costAmount"] ?? 0}";
  //     params += "&lotteryDesc=${lData["lotteryDesc"] ?? ""}";
  //     params += "&no=${lData["no"] ?? ""}";
  //   } else {
  //     return;
  //   }
  //   if ((homeData["u_Account"] ?? []).isNotEmpty) {
  //     for (var e in (homeData["u_Account"] ?? [])) {
  //       if (e["a_No"] == 4) {
  //         params += "&amout=${e["amout"] ?? 0}";
  //       }
  //     }
  //   }

  //   String lotteryUrl =
  //       "${HttpConfig.lotteryUrl}?token=${AppDefault().token}&baseUrl=${HttpConfig.baseUrl}$params&imageUrl=${AppDefault().imageUrl}";
  //   // lotteryUrl = Uri.encodeFull(lotteryUrl);
  //   myWebCtrl?.loadUrl(lotteryUrl);
  // }

  applyRequest() {
    simpleRequest(
      url: Urls.approveApply,
      params: {},
      success: (success, json) {
        if (success) {
          String messages = json["messages"] ?? "";
          if (messages.isNotEmpty) {
            ShowToast.normal(messages);
          }
        }
      },
      after: () {},
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  State<Home> createState() => _HomeState();
  static refreshBackUp(int num) async {
    Get.find<HomeController>().refreshPublicHomeData();
  }
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin {
  HomeController ctrl = Get.find<HomeController>();

  double jgwidth = 345;
  double jgRunSpace = 20;
  double jgBtnGap = 3;
  double jgImageHeight = 35;
  double jgHeight = 0;
  double jgFontSize = 14;
  double jgTagMarginTop = 17;
  double jgTextHeight = 0;

  final pullCtrl = RefreshController();
  final yjScrollCtrl =
      ScrollController(initialScrollOffset: 500 * 285.w - 15.w);

  @override
  void initState() {
    super.initState();
  }

  yjScrollListener() {}

  @override
  void dispose() {
    yjScrollCtrl.removeListener(yjScrollListener);
    yjScrollCtrl.dispose();

    pullCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: getDefaultAppBar(context, "",
            color: Colors.transparent,
            leading: gemp(),
            flexibleSpace: SizedBox(
              width: 375.w,
              // height: kToolbarHeight,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(top: paddingSizeTop(context)),
                  child: sbRow([
                    centRow([
                      Image.asset(
                        assetsName("home/top_logo"),
                        width: 61.5.w,
                        fit: BoxFit.fitWidth,
                      ),
                      gwb(10),
                      GetBuilder<HomeController>(
                        builder: (_) {
                          return ctrl.subTitle.isEmpty
                              ? gwb(0)
                              : gline(1, 14.5, color: AppColor.text2);
                        },
                      ),
                      gwb(10),
                      GetBuilder<HomeController>(
                        builder: (_) {
                          return getSimpleText(
                              ctrl.subTitle, 14, AppColor.text2,
                              textHeight: 1.1);
                        },
                      )
                    ]),
                    CustomButton(
                      onPressed: () {
                        push(const ContactCustomerService(), context,
                            binding: ContactCustomerServiceBinding());
                      },
                      child: SizedBox(
                        width: 50.w,
                        height: kToolbarHeight,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Image.asset(
                            assetsName("home/btn_kf"),
                            width: 24.w,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                    )
                  ], width: 345),
                ),
              ),
            )),
        // backgroundColor: const Color(0xFFF7F7F7),
        body: SmartRefresher(
          physics: const BouncingScrollPhysics(),
          controller: pullCtrl,
          onRefresh: () {
            ctrl.homeOnRefresh(
              succ: (success) {
                if (pullCtrl.isRefresh) {
                  success
                      ? pullCtrl.refreshCompleted()
                      : pullCtrl.refreshFailed();
                }
              },
            );
          },
          enablePullDown: true,
          enablePullUp: false,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                // GetX<HomeController>(
                //   init: ctrl,
                //   builder: (_) {
                //     return
                // ctrl.cClient
                //     ? cClientPage() :
                centClm([
                  // 轮播图/金刚区
                  GetBuilder<HomeController>(
                      init: ctrl,
                      builder: (_) {
                        AppDefault().scaleWidth = 1.w;
                        return topContent();
                      }),

                  //公告
                  GetBuilder<HomeController>(
                    builder: (_) {
                      return messageView();
                    },
                  ),
                  // 本月数据
                  // GetBuilder<HomeController>(
                  //   builder: (_) {
                  //     return thisMonData();
                  //   },
                  // ),
                  GetBuilder<HomeController>(
                    builder: (_) {
                      return ghb(ctrl.haveNews ? 30 : 10);
                    },
                  ),

                  //奖金池
                  bonusPool(),
                  ghb(15.5),
                  yjView(),
                  ghb(15.5),
                  //新手专区
                  newUserView(),
                  ghb(15.5),
                  //商学院
                  businessView(),
                  //排行榜/会员权益
                  // activityView(),
                  // 精选活动/积分抽奖
                  // redPack(),
                  // lotteryView(),
                ]),
                // ;
                //   },
                // ),
                ghb(14),
                // ghb(kIsWeb ? 30 : 66),
                GetBuilder<HomeController>(
                  builder: (_) {
                    return AppBottomTips(
                      pData: ctrl.publicHomeData,
                    );
                  },
                )
              ],
            ),
          ),
        ));
  }

  bannerPress(Map data) {
    if (data.isNotEmpty &&
        data["apP_Url"] != null &&
        data["apP_Url"].isNotEmpty) {
      String path = data["apP_Url"] ?? "";
      if (path.contains("http")) {
        push(
            CustomWebView(
              title: data["apP_Title"] ?? "",
              url: path,
            ),
            context);
      } else {
        if (path.contains("news")) {
          toBannerDetail(0, path);
        } else if (path.contains("businessschool")) {
          toBannerDetail(1, path);
        }
      }
    }
  }

  toBannerDetail(int type, String path) {
    int id = -1;
    List subs = path.split("?");
    path = subs.length > 1 ? subs[1] : "";
    if (path.isEmpty) {
      return;
    }
    List params = path.split("&");
    for (String e in params) {
      List l = e.split("=");
      if (l.isNotEmpty && l.length > 1 && l[0] == "id") {
        id = int.tryParse(l[1]) != null ? int.parse(l[1]) : -1;
        break;
      }
    }
    if (type == 0) {
      push(
          NewsDetail(
            newsData: {"id": id},
          ),
          context);
    } else if (type == 1) {
      Get.to(BusinessSchoolDetail(id: id),
          binding: BusinessSchoolDetailBinding());
    }
  }

  Widget cClientPage() {
    return centClm([
      GetBuilder<HomeController>(
        init: ctrl,
        builder: (_) {
          return AppBanner(
            // controller: ctrl.bannerCtrl,
            // isFullScreen: false,
            width: 375,
            height: 218,
            banners: ctrl.topBanners,
            borderRadius: 5,
            bannerClick: (data) {
              bannerPress(data);
            },
          );
        },
      ),
      ghb(15),
      Container(
        width: 345.w,
        padding: EdgeInsets.only(top: 17.w, bottom: 15.w),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12.w)),
        child: Center(
          child: sbRow(
              List.generate(4, (index) {
                String title = "我的积分";
                String img = "btn_integral";
                switch (index) {
                  case 0:
                    title = "我的积分";
                    img = "btn_integral";
                    break;
                  case 1:
                    title = "账户余额";
                    img = "btn_account";
                    break;
                  case 2:
                    title = "代理申请";
                    img = "btn_facility";
                    break;
                  case 3:
                    title = "关联设备";
                    img = "btn_glsb";
                    break;
                }

                return cClientBtn(
                  title,
                  img,
                  onPressed: () {
                    List wallets = ctrl.homeData["u_Account"] ?? [];

                    if (index == 0) {
                      Map walletData = {};
                      for (var e in wallets) {
                        if (e["a_No"] == AppDefault.jfWallet) {
                          walletData = e;
                        }
                      }
                      if (walletData.isNotEmpty) {
                        push(
                            MyWalletDealList(
                              walletData: walletData,
                              fromHome: true,
                              title: "我的积分",
                            ),
                            null,
                            binding: MyWalletDealListBinding());
                      }
                    } else if (index == 1) {
                      Map walletData = {};
                      for (var e in wallets) {
                        if (e["a_No"] == AppDefault.awardWallet) {
                          walletData = e;
                        }
                      }
                      if (walletData.isNotEmpty) {
                        push(
                            MyWalletDealList(
                              walletData: walletData,
                              fromHome: true,
                              title: "账户余额",
                            ),
                            null,
                            binding: MyWalletDealListBinding());
                      }
                    } else if (index == 2) {
                      showAlert(
                        context,
                        "确定要申请代理吗",
                        confirmOnPressed: () {
                          ctrl.applyRequest();
                          Navigator.pop(context);
                        },
                      );
                    } else if (index == 3) {
                      push(const TerminalBinding(), context);
                    }
                  },
                );
              }),
              width: 345 - 25 * 2),
        ),
      ),
      ghb(15),
      GetBuilder<HomeController>(
        id: "lotteryWebView_buildId",
        builder: (_) {
          return AppDefault().token.isEmpty
              ? ghb(0)
              : ClipRRect(
                  borderRadius: BorderRadius.circular(12.w),
                  child: SizedBox(
                    width: 345.w,
                    height: ctrl.webViewHeight,
                    child: AppLotteryWebView(
                      getScollerHeight: (scrollHeight) {
                        if (ctrl.webViewHeight != scrollHeight) {
                          ctrl.webViewHeight = scrollHeight;
                          ctrl.update(["lotteryWebView_buildId"]);
                        }
                      },
                    ),
                    // WebView(
                    //   javascriptMode: JavascriptMode.unrestricted,
                    //   // initialUrl: lotteryUrl,
                    //   onPageFinished: (url) async {
                    //     if (ctrl.myWebCtrl != null) {
                    //       var originalHeight = await ctrl.myWebCtrl!
                    //           .runJavascriptReturningResult(
                    //               "document.body.scrollHeight;");
                    //       ctrl.webViewHeight = double.parse(originalHeight);
                    //       ctrl.webViewHeight = ctrl.webViewHeight <= 0
                    //           ? 0
                    //           : ctrl.webViewHeight;
                    //       ctrl.update(["lotteryWebView_buildId"]);
                    //       ctrl.lotteryChannel!.setCount();
                    //     }
                    //   },
                    //   onWebViewCreated: (webCtrl) {
                    //     ctrl.myWebCtrl = webCtrl;
                    //   },
                    //   javascriptChannels:
                    //       const LotteryChannel().getChannelSet(),
                    // )
                  ),
                );
        },
      )
    ]);
  }

  Widget cClientBtn(
    String title,
    String img, {
    Function()? onPressed,
  }) {
    return CustomButton(
      onPressed: onPressed,
      child: centClm([
        Image.asset(
          assetsName("limit/$img"),
          width: 50.w,
          fit: BoxFit.fitWidth,
        ),
        ghb(8),
        getSimpleText(title, 14, AppColor.textBlack),
      ]),
    );
  }

  Widget topContent() {
    jgTextHeight = calculateTextHeight(
        "设备管理", jgFontSize, FontWeight.normal, double.infinity, 1, context);
    // jgHeight = (jgTextHeight + jgBtnGap.w + jgImageHeight.w) * 2 +
    //     jgRunSpace.w;
    double bottomPadding = 18;
    double height = (jgTextHeight + jgBtnGap.w + jgImageHeight.w) * 2 +
        jgRunSpace.w +
        (kIsWeb ? 12.w : 0);
    double tagHeight = ctrl.btnDatas.length > 1
        ? (jgTagMarginTop.w + 3.w + 12.w)
        : bottomPadding.w;

    return SizedBox(
        width: 375.w,
        // height: 375.w,
        // height: (218).w + height + tagHeight,
        child: Column(
          children: [
            AppBanner(
              // controller: ctrl.bannerCtrl,
              // isFullScreen: false,
              width: 345,
              height: 128,
              banners: ctrl.topBanners,
              borderRadius: 8,
              bannerClick: (data) {
                bannerPress(data);
              },
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: Column(
                children: [
                  ghb(20),
                  SizedBox(
                      width: jgwidth.w,
                      height: height,
                      child: PageView.builder(
                        physics:
                            ctrl.btnDatas == null || ctrl.btnDatas.length == 1
                                ? const NeverScrollableScrollPhysics()
                                : const BouncingScrollPhysics(),
                        itemCount:
                            ctrl.btnDatas != null && ctrl.btnDatas.isNotEmpty
                                ? ctrl.btnDatas.length
                                : 0,
                        itemBuilder: (context, index) {
                          return Center(
                            child: SizedBox(
                              width: jgwidth.w,
                              height: height,
                              child: Wrap(
                                  runSpacing: jgRunSpace.w,
                                  children: homeButtons(
                                      ctrl.btnDatas[index], context)),
                            ),
                          );
                        },
                        onPageChanged: (value) {
                          ctrl.centerBtnIndex = value;
                        },
                      )),
                  //金刚区滑动标记
                  Visibility(
                    visible: ctrl.btnDatas.length > 1,
                    child: Padding(
                        padding: EdgeInsets.only(top: jgTagMarginTop.w),
                        child: GetX<HomeController>(
                          builder: (_) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(1.5.w),
                              child: centRow([
                                ...ctrl.btnDatas
                                    .asMap()
                                    .entries
                                    .map((e) => Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 0.w),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                ctrl.centerBtnIndex == e.key
                                                    ? 1.5.w
                                                    : 0),
                                            color: ctrl.centerBtnIndex == e.key
                                                ? AppDefault()
                                                        .getThemeColor() ??
                                                    AppColor.blue
                                                : AppDefault()
                                                            .getThemeColor() ==
                                                        null
                                                    ? const Color(0xFFA9DAFC)
                                                    : AppDefault()
                                                        .getThemeColor()!
                                                        .withOpacity(0.3),
                                          ),
                                          width: ctrl.centerBtnIndex == e.key
                                              ? 11.w
                                              : 5.w,
                                          height: 3.w,
                                        ))
                                    .toList()
                              ]),
                            );
                          },
                        )),
                  ),
                  ghb(ctrl.btnDatas.length > 1 ? 12 : bottomPadding),
                ],
              ),
            )
          ],
        ));
  }

  Widget messageView() {
    return Column(
      children: [
        ghb(ctrl.haveNews ? 10 : 0),
        //消息中心
        !ctrl.haveNews
            ? ghb(0)
            : GestureDetector(
                onTap: () {
                  push(const NewsList(), context, binding: NewsListBinding());
                },
                child: Container(
                  height: 40.w,
                  width: 345.w,
                  decoration: BoxDecoration(
                      color: AppColor.pageBackgroundColor,
                      borderRadius: BorderRadius.circular(8.w)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 13.5.w),
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/images/home/icon_notifi.png",
                          width: 28.w,
                          fit: BoxFit.fitWidth,
                        ),
                        gwb(10),
                        gline(1, 12, color: AppColor.assisText),
                        gwb(7),
                        Image.asset(
                          assetsName("home/icon_message"),
                          width: 24.w,
                          fit: BoxFit.fitWidth,
                        ),
                        gwb(3.5),
                        GetBuilder<HomeController>(
                          init: ctrl,
                          builder: (_) {
                            return CustomMessage(
                              datas: ctrl.myMessages,
                              width: 243.3.w,
                              height: 50.w,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ],
    );
  }

  Widget bonusPool() {
    return centClm([
      Container(
        width: 345.w,
        height: 40.w,
        decoration: BoxDecoration(
            gradient: simpleGradient([
              const Color(0xFFFDD2A7),
              const Color(0xFFFFF2DB),
            ]),
            borderRadius: BorderRadius.vertical(top: Radius.circular(8.w))),
        child: Center(
          child: sbRow([
            getSimpleText("奖金池", 16, const Color(0xFF5A2F0F), isBold: true),
            centRow([
              getSimpleText("今日剩余待领取奖金", 10, const Color(0xFF5A2F0F)),
              Container(
                height: 16.w,
                margin: EdgeInsets.symmetric(horizontal: 3.w),
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                decoration: BoxDecoration(
                    color: const Color(0xFFF3C274),
                    borderRadius: BorderRadius.circular(2.w)),
                child: Center(
                  child: GetX<HomeController>(
                    builder: (_) {
                      return getSimpleText(
                          priceFormat(ctrl.bonusPoolMoney), 15, Colors.white,
                          isBold: true, textHeight: 1.1);
                    },
                  ),
                ),
              ),
              getSimpleText("元", 10, const Color(0xFF5A2F0F)),
            ])
          ], width: 345 - 15.5 * 2),
        ),
      ),
      Container(
        width: 345.w,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(8.w),
            ),
            color: Colors.white),
        child: Column(
          children: [
            ghb(10),
            Center(
              child: sbRow([
                centRow([
                  Image.asset(
                    assetsName("home/icon_jjc"),
                    width: 60.w,
                    fit: BoxFit.fitWidth,
                  ),
                  gwb(8),
                  centClm([
                    getSimpleText("超级福利大放送", 15, AppColor.text, isBold: true),
                    // ghb(1),
                    getSimpleText("百万现等你来领！", 12, AppColor.text3),
                  ], crossAxisAlignment: CrossAxisAlignment.start)
                ]),
                centRow([
                  CustomButton(
                    onPressed: () {
                      if (ctrl.drawBoundStr.isNotEmpty) {
                        ShowToast.normal(ctrl.drawBoundStr);
                        return;
                      }
                      Get.find<BounsPoolController>().drawBoundAction();
                    },
                    child: Container(
                      width: 75.w,
                      height: 30.w,
                      decoration: BoxDecoration(
                          gradient: simpleGradient([
                            const Color(0xFFFFF2DB),
                            const Color(0xFFFDD2A7),
                          ]),
                          borderRadius: BorderRadius.circular(15.w)),
                      child: Center(
                        child:
                            getSimpleText("立即领取", 12, const Color(0xFF5A2F0F)),
                      ),
                    ),
                  )
                ])
              ], width: 345 - 7.5 * 2),
            ),
            ghb(10),
          ],
        ),
      )
    ]);
  }

  bool handleNotification(UserScrollNotification notification) {
    print("notification is ${notification.runtimeType}");
    return true;
  }

  Widget yjView() {
    return Column(
      children: [
        gwb(375),
        cellTitle("收益统计"),
        SizedBox(
          width: 375.w,
          height: 135.w,
          child: Listener(
            onPointerUp: (event) {
              double margin = 15.w;
              double width = 285.w;
              double overSet = yjScrollCtrl.offset % width;
              double toSet = 0;
              if (overSet < 85.w) {
                toSet = yjScrollCtrl.offset - overSet - margin;
              } else {
                toSet = yjScrollCtrl.offset + (width - overSet) - margin;
              }
              yjScrollCtrl.animateTo(toSet,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.linearToEaseOut);
            },
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              controller: yjScrollCtrl,
              itemCount: 1000,
              itemBuilder: (context, idx) {
                int index = idx % 3;
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.only(right: 15.w),
                    width: 270.w,
                    height: 135.w,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage(
                                assetsName("home/bg_wallet${index + 1}")))),
                    child: Column(
                      children: [
                        gwb(270),
                        sbhRow(
                          [
                            centRow([
                              Image.asset(
                                assetsName("home/icon_wallet${index + 1}"),
                                width: 18.w,
                                fit: BoxFit.fitWidth,
                              ),
                              gwb(7),
                              getSimpleText(
                                  index == 0
                                      ? "本月业绩"
                                      : index == 1
                                          ? "全部业绩"
                                          : "昨日业绩",
                                  16,
                                  index == 0
                                      ? const Color(0xFFED8103)
                                      : index == 1
                                          ? const Color(0xFF0576CF)
                                          : const Color(0xFF493AEC),
                                  isBold: true,
                                  textHeight: 1.25)
                            ])
                          ],
                          width: 270 - 15 * 2,
                          height: 45,
                        ),
                        Container(
                          width: 270.w,
                          height: 90.w - 0.1.w,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(8.w))),
                          child: GetBuilder<HomeController>(
                            builder: (_) {
                              Map data = ctrl.homeData["homeBouns"] ?? {};
                              return Column(
                                children: [
                                  ghb(22),
                                  sbRow([
                                    centClm([
                                      getSimpleText(
                                          index == 0
                                              ? "本月收益(元)"
                                              : index == 1
                                                  ? "全部收益(元)"
                                                  : "本月收益(元)",
                                          10,
                                          AppColor.text2),
                                      ghb(4),
                                      getSimpleText(
                                          priceFormat(data[index == 0
                                                  ? "totalBouns"
                                                  : index == 1
                                                      ? "thisMBouns"
                                                      : "lastDBouns"] ??
                                              "0"),
                                          30,
                                          AppColor.text,
                                          isBold: true)
                                    ],
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start),
                                    centClm([
                                      // getSimpleText(
                                      //     "${index == 0 ? "本月交易额" : index == 1 ? "全部交易额" : "本月交易额"}￥${3462.00}",
                                      //     10,
                                      //     AppColor.text2),
                                      // ghb(5),
                                      // getSimpleText("交易笔数 126", 10, AppColor.text2),
                                    ],
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end),
                                  ],
                                      width: 270 - 14 * 2,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start)
                                ],
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        )
      ],
    );
  }

  Widget newUserView() {
    return SizedBox(
      width: 345.w,
      child: Column(
        children: [
          cellTitle("新手专区"),
          sbRow([
            CustomButton(
              onPressed: () {
                push(
                    const FodderLib(
                      key: ValueKey("Home"),
                    ),
                    context,
                    binding: FodderLibBinding());
              },
              child: Container(
                  width: 155.w,
                  height: 125.w,
                  padding: EdgeInsets.only(left: 15.w),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(assetsName("home/bg_sck")),
                          fit: BoxFit.fitWidth)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ghb(22),
                      getSimpleText("素材库", 16, AppColor.text, isBold: true),
                      ghb(6),
                      getSimpleText("精美营销素材使用", 12, const Color(0xFF999999)),
                      ghb(8),
                      getSimpleButton(
                          null, getSimpleText("去下载", 10, Colors.white),
                          width: 55,
                          height: 18,
                          colors: [
                            const Color(0xFFFEA764),
                            const Color(0xFFFF5156),
                          ])
                    ],
                  )),
            ),
            centClm([
              CustomButton(
                onPressed: () {
                  push(const MineHelpCenter(), context,
                      binding: MineHelpCenterBinding(),
                      arguments: {"index": 0});
                },
                child: Container(
                    width: 180.w,
                    height: 57.5.w,
                    padding: EdgeInsets.only(left: 17.w, bottom: 2.w),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(assetsName("home/bg_czzn")),
                            fit: BoxFit.fitWidth)),
                    child: centClm([
                      getSimpleText("操作指南", 14, AppColor.text, isBold: true),
                      ghb(5),
                      getSimpleButton(
                          null, getSimpleText("立即查看", 10, Colors.white),
                          width: 55,
                          height: 18,
                          colors: [
                            const Color(0xFF8DB3FD),
                            const Color(0xFF5496F9),
                          ]),
                    ], crossAxisAlignment: CrossAxisAlignment.start)),
              ),
              ghb(10),
              CustomButton(
                onPressed: () {
                  push(const MineHelpCenter(), context,
                      binding: MineHelpCenterBinding(),
                      arguments: {"index": 1});
                },
                child: Container(
                    width: 180.w,
                    height: 57.5.w,
                    padding: EdgeInsets.only(left: 17.w, bottom: 2.w),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(assetsName("home/bg_zclc")),
                            fit: BoxFit.fitWidth)),
                    child: centClm([
                      getSimpleText("注册流程", 14, AppColor.text, isBold: true),
                      ghb(5),
                      getSimpleButton(
                        null,
                        getSimpleText("立即查看", 10, Colors.white),
                        width: 55,
                        height: 18,
                        colors: [
                          const Color(0xFF0FDDB4),
                          const Color(0xFF1BC69C),
                        ],
                      )
                    ], crossAxisAlignment: CrossAxisAlignment.start)),
              ),
            ]),
          ], width: 345)
        ],
      ),
    );
  }

  Widget businessView() {
    return SizedBox(
      width: 345.w,
      child: Column(
        children: [
          cellTitle(
            "商学院",
            right: [
              getSimpleText("赋能企业搭建在线学习平台", 12, AppColor.text3),
              gwb(3),
              Padding(
                padding: EdgeInsets.only(top: 2.5.w),
                child: Image.asset(
                  assetsName("home/icon_right_arrow"),
                  width: 12.w,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ],
            rightOnPressed: () {
              push(const BusinessSchoolListPage(), context,
                  binding: BusinessSchoolListPageBinding(),
                  arguments: {"index": 0});
            },
          ),
          CustomButton(
            onPressed: () {
              push(const BusinessSchoolListPage(), context,
                  binding: BusinessSchoolListPageBinding(),
                  arguments: {"index": 0});
            },
            child: Image.asset(
              assetsName("home/btn_businessSchool"),
              width: 345.w,
              fit: BoxFit.fitWidth,
            ),
          )
        ],
      ),
    );
  }

  Widget cellTitle(String title,
      {List<Widget> right = const [], Function()? rightOnPressed}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.w),
      child: sbRow([
        centRow([
          Image.asset(
            assetsName("home/cell_tag"),
            width: 6.w,
            fit: BoxFit.fitWidth,
          ),
          gwb(9),
          getSimpleText(title, 16, AppColor.text, isBold: true),
        ]),
        CustomButton(onPressed: rightOnPressed, child: centRow(right))
      ], width: 345),
    );
  }

  Widget lotteryView() {
    return // 新版积分抽奖
        GetBuilder<HomeController>(
      builder: (_) {
        List lotteryConfigList = ctrl.homeData["lotteryConfig"] ?? [];
        return Visibility(
          visible: lotteryConfigList.isNotEmpty,
          child: Container(
            width: 345.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.w),
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(10.w, 10.w, 10.w, 10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  getSimpleText("精选活动", 16, AppColor.textBlack),
                  ghb(10),
                  SizedBox(
                    width: 325.w - 0.1.w,
                    child: Wrap(
                      runSpacing: 19.5.w,
                      children: [
                        ...lotteryConfigList
                            .map((e) => CustomButton(
                                onPressed: () {
                                  LotteryType type = LotteryType.zhuan;
                                  if (e["title"] != null &&
                                      e["title"] is String &&
                                      e["title"].isNotEmpty) {
                                    if ((e["title"] as String).contains("转")) {
                                      type = LotteryType.zhuan;
                                    } else if ((e["title"] as String)
                                        .contains("翻")) {
                                      type = LotteryType.fanpai;
                                    } else if ((e["title"] as String)
                                        .contains("老虎")) {
                                      type = LotteryType.laohu;
                                    }
                                  }
                                  push(
                                      AppLotteryWebView(
                                        type: type,
                                        id: e["no"] ?? "",
                                        title: e["title"] ?? "",
                                      ),
                                      context,
                                      binding: AppLotteryWebViewBinding());
                                },
                                child: SizedBox(
                                  width: 325.w / 4 - 0.1.w,
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        "assets/images/home/icon_jfcj.png",
                                        width: 71.w,
                                        height: 79.w,
                                        fit: BoxFit.fill,
                                      ),
                                      ghb(6),
                                      getSimpleText(e["title"] ?? "", 12,
                                          AppColor.textBlack),
                                    ],
                                  ),
                                )))
                            .toList(),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget thisMonData() {
    return centClm([
      ghb(10),
      getDefaultTilte("本月数据"),
      ghb(10),
      Container(
          width: 345.w,
          height: 150.w,
          decoration: getBBDec(colors: [
            const Color(0xFF3E98F7),
            const Color(0xFF1C5BFF),
          ], color: AppDefault().getThemeColor()),
          child: Stack(
            children: [
              Positioned.fill(
                  child: Image.asset(
                assetsName("home/bg_sy2"),
                width: 345.w,
                height: 150.w,
                fit: BoxFit.fill,
              )),
              Positioned(
                  left: 11.w,
                  top: 0,
                  width: 295.w,
                  height: 93.w,
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                        AppDefault().getThemeColor(index: 1) ?? Colors.white,
                        BlendMode.modulate),
                    child: Image.asset(
                      assetsName("home/bg_sy3"),
                      width: 295.w,
                      height: 93.w,
                      fit: BoxFit.fill,
                    ),
                  )),
              Positioned.fill(
                  child: GetBuilder<HomeController>(
                init: ctrl,
                builder: (_) {
                  Map homeTeamTanNo = ctrl.homeData["homeTeamTanNo"] ?? {};
                  return Column(
                    children: [
                      ghb(15),
                      dataView(
                          priceFormat(homeTeamTanNo["teamThisMAmount"] ?? 0),
                          "交易金额(元)",
                          type: 0),
                      ghb(18),
                      sbRow([
                        dataView("新增伙伴(人)",
                            "${homeTeamTanNo["teamThisMAddUser"] ?? 0}"),
                        dataView("绑定机具(台)",
                            "${homeTeamTanNo["teamThisMAddMerchant"] ?? 0}"),
                      ], width: 345 - 57 * 2),
                    ],
                  );
                },
              ))
            ],
          )),
    ]);
  }

  Widget activityView() {
    return Container(
      width: 345.w,
      height: 84.w,
      decoration: getBBDec(),
      child: centRow([
        hdBtn(
          0,
          onPressed: () {
            push(const Rank(), context, binding: RankBinding());
            // push(const ShareInvite(), context,
            //     binding: ShareInviteBinding());
          },
        ),
        gwb(11),
        getCustomDashLine(25, 1,
            v: true,
            color: Colors.white,
            dashSingleGap: 2,
            dashSingleWidth: 2,
            strokeWidth: 1),
        gwb(11),
        hdBtn(
          1,
          onPressed: () {
            push(const MemberCharge(), context, binding: MemberChargeBinding());
          },
        ),
      ]),
    );
  }

  Widget redPack() {
    return !AppDefault().checkDay
        ? ghb(0)
        : GetBuilder<HomeController>(
            builder: (_) {
              return CustomButton(
                onPressed: () {
                  Get.to(() => const RedPacket(), binding: RedPacketBinding());
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 15.w),
                  width: 345.w,
                  height: 180.w,
                  child: Stack(
                    children: [
                      Positioned.fill(
                          child: Image.asset(
                        assetsName("home/deal_bg"),
                        width: 345.w,
                        height: 180.w,
                        fit: BoxFit.fill,
                      )),
                      Positioned.fill(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            getSimpleText(
                                "￥${(ctrl.homeData["tolTranAmount"] ?? 0) == 0 ? 0 : priceFormat(ctrl.homeData["tolTranAmount"] ?? 0)}",
                                28,
                                Colors.white,
                                isBold: true),
                            ghb(5),
                            Container(
                              width: 280.w,
                              height: 40.w,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.w),
                                  color: Colors.amber[300]),
                              child: Center(
                                child: getSimpleText(
                                    "累计奖励金${(ctrl.homeData["tolTranAmount"] ?? 0) == 0 ? 0 : priceFormat(ctrl.homeData["tolAmount"] ?? 0)}元",
                                    19,
                                    Colors.blue[600],
                                    isBold: true),
                              ),
                            ),
                            ghb(20),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
  }

  Widget hdBtn(int type, {Function()? onPressed}) {
    return CustomButton(
      onPressed: onPressed,
      child: sbhRow([
        centClm([
          getSimpleText(type == 0 ? "排行榜" : "会员权益", 18, AppColor.textBlack3),
          ghb(8),
          getSimpleText(
              type == 0 ? "每日排行 火速比拼" : "高额比例 亿万收益", 11, AppColor.textGrey4),
        ], crossAxisAlignment: CrossAxisAlignment.start),
        Image.asset(
          assetsName("home/icon_${type == 0 ? "phb" : "hyqy"}"),
          width: 44.w,
          height: 44.w,
          fit: BoxFit.fill,
        )
      ], width: 146, height: 84),
    );
  }

  Widget dataView(String t1, String t2, {int type = 1}) {
    return centClm([
      getSimpleText(t1, type == 0 ? 30 : 12, Colors.white,
          fw: type == 0 ? FontWeight.w500 : FontWeight.w400),
      ghb(type == 0 ? 6 : 5),
      getSimpleText(t2, type == 0 ? 18 : 12, Colors.white,
          fw: type == 0 ? FontWeight.w400 : FontWeight.w500),
    ]);
  }

  List<Widget> homeButtons(List data, BuildContext context) {
    List<Widget> buttons = [];

    for (var e in data) {
      buttons.add(CustomButton(
        onPressed: () {
          String path = e["path"] ?? "";
          if (e["path"] == "/home/machinemanage") {
            // 设备管理
            push(const MachineManage(), context,
                binding: MachineManageBinding());
          } else if (e['id'] == 2079) {
            // 分享注册
            Get.to(const ShareInvite(), binding: ShareInviteBinding());
            // Get.to(const ShareInvitePage(), binding: ShareInvitePageBinding());
          } else if (e["path"] == "/home/productpurchase") {
            // 礼包商城
            Get.to(const ProductPurchaseList(),
                binding: ProductPurchaseListBinding());
          } else if (e["path"] == "/home/teammanage") {
            // 团队管理
            Get.to(() => const MyTeam(), binding: MyTeamBinding());
          } else if (e['id'] == 2084 ||
              e["path"] == "/pages/authentication/authentication") {
            // 实名认证
            Get.to(const IdentityAuthentication(),
                binding: IdentityAuthenticationBinding());
          } else if (e["path"] == "/home/businessinfo") {
            // 商户信息
            push(const MyBusiness(), context, binding: MyBusinessBinding());
          } else if (e["path"] == "/home/integralstore") {
            // 产品采购
            // push(const IntegralStore(shopType: 2), context,
            //     binding: IntegralStoreBinding());
            ShowToast.normal("敬请期待!");
          } else if (e["path"] == "/home/machinetransfer") {
            // 机具划拨
            Get.to(
                const MachineTransfer(
                  isLock: false,
                ),
                binding: MachineTransferBinding());
          } else if (e['path'] == "/home/machinetransferback") {
            // 机具回拨
            Get.to(
                const MachineTransferUserList(
                  isTerminalBack: true,
                ),
                binding: MachineTransferUserListBinding());
          } else if (e["path"] == "/home/shareinvite") {
            push(const ShareInvite(), context, binding: ShareInviteBinding());
          } else if (e["path"] == "/home/vipstore") {
            pushStore(e);
          } else if (e["path"] == "/home/businessschool") {
            // 商学院
            push(const BusinessSchoolListPage(), context,
                binding: BusinessSchoolListPageBinding(),
                arguments: {"index": 0});
            // 联系客服
            // push(const ContactCustomerService(), context,
            //     binding: ContactCustomerServiceBinding());
            // 积分复购

            // push(const IntegralRepurchase(), context,
            //     binding: IntegralRepurchaseBinding());

            //设备采购
            // push(const MachinePayPage(), context,
            //     binding: MachinePayPageBinding());

          } else if (path == "/home/usermanage") {
            // 用户管理
            push(const StatisticsUserManage(), context,
                binding: StatisticsUserManageBinding());
          } else if (path == "/home/contactcustomerservice") {
            // 联系客服
            push(const ContactCustomerService(), context,
                binding: ContactCustomerServiceBinding());
          } else if (path == "/home/integralrepurchase") {
            // 积分复购
            push(const IntegralRepurchase(), context,
                binding: IntegralRepurchaseBinding());
          } else if (path == "/home/machineregister") {
            //设备注册
            push(const MachineRegister(), context,
                binding: MachineRegisterBinding());
          } else if (path == "/home/mywallet") {
            //设备注册
            push(const MyWallet(), context, binding: MyWalletBinding());
          } else if (path == "/home/machinestore") {
            push(const MachinePayPage(), context,
                binding: MachinePayPageBinding());
          } else if (e["path"] == "/home/merchantaccessnetwork") {
            push(const MerchantAccessNetwork(), context,
                binding: MerchantAccessNetworkBinding());
          } else if (e["path"] == "/pages/booked/booked") {
          } else if (e["path"] == "/home/terminalreceive") {
            // push(const TerminalReceive(), context,
            //     binding: TerminalReceiveBinding());
            push(const Product(subPage: true), context,
                binding: ProductBinding());
          } else if (e["path"] == "/home/terminalbinding") {
            push(const TerminalBinding(), context);
          }
        },
        child: SizedBox(
          width: jgwidth.w / 4 - 0.1.w,
          child: centClm(
            [
              CustomNetworkImage(
                key: ValueKey(e),
                src: e["img"],
                height: jgImageHeight.w,
                // height: jgImageHeight.w,
                fit: BoxFit.fitHeight,
                errorWidget: gemp(),
              ),
              ghb(jgBtnGap),
              getSimpleText(e["name"], jgFontSize, AppColor.textBlack3)
            ],
          ),
        ),
      ));
    }
    return buttons;
  }

  changeIosLogo(String icon) async {
    try {
      if (await DynamicIconFlutter.supportsAlternateIcons) {
        await DynamicIconFlutter.setAlternateIconName(
            icon == "MainActivity" ? "main" : icon);
        print("App icon change successful");
        return;
      }
    } on PlatformException catch (e) {
      if (await DynamicIconFlutter.supportsAlternateIcons) {
        await DynamicIconFlutter.setAlternateIconName(null);
        print("Change app icon back to default");
        return;
      } else {
        print("Failed to change app icon");
      }
    }
  }

  pushStore(Map e) async {
    String token = await UserDefault.get(USER_TOKEN);
    String? dId = await PlatformDeviceId.getDeviceId;
    Map appData = {
      "homeData": AppDefault().homeData,
      "publicHomeData": AppDefault().publicHomeData,
      "token": token,
      "version": AppDefault().version,
      "deviceId": dId ?? "",
      "imageUrl": AppDefault().imageUrl,
      "baseUrl": HttpConfig.baseUrl,
    };

    if (mounted) {
      push(
          VipStore(
            title: e["name"] ?? "VIP礼包",
            appData: appData,
          ),
          context);
    }
  }

  @override
  bool get wantKeepAlive => true;
}
