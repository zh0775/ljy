import 'dart:async';

import 'package:blur/blur.dart';
import 'package:cxhighversion2/app_binding.dart';
import 'package:cxhighversion2/bounspool/bonuspool.dart';
import 'package:cxhighversion2/business/business.dart';
import 'package:cxhighversion2/component/app_launch_splash.dart';
import 'package:cxhighversion2/component/custom_button.dart';
import 'package:cxhighversion2/component/splash_view.dart';
import 'package:cxhighversion2/home/home.dart';
import 'package:cxhighversion2/login/user_login.dart';
import 'package:cxhighversion2/mine/mine_page.dart';
import 'package:cxhighversion2/routers/app_pages.dart';
import 'package:cxhighversion2/statistics/statistics.dart';
import 'package:cxhighversion2/util/EventBus.dart';
import 'package:cxhighversion2/util/app_default.dart';
import 'package:cxhighversion2/util/notify_default.dart';
import 'package:cxhighversion2/util/storage_default.dart';
import 'package:cxhighversion2/util/user_default.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

// import 'third/pageviewj-0.0.3/view_page.dart';

class GLObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    if (route is GetPageRoute && route.binding is! MainPageBinding) {
      AppDefault().safeAlert = false;
    }
    if (route is GetPageRoute && route.binding is MainPageBinding) {
      AppDefault().safeAlert = true;
    }
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    if (route is GetPageRoute &&
        route.binding is UserLoginBinding &&
        previousRoute != null &&
        previousRoute is GetPageRoute &&
        previousRoute.binding is MainPageBinding) {
      AppDefault().safeAlert = true;
      bus.emit(NOTIFY_LOGIN_BACK_CHECK_HOME_ALERT);
    }
    super.didPop(route, previousRoute);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // debugProfileBuildsEnabled = true;
  // if (!kIsWeb) ScreenUtil.ensureScreenSize();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  if (!kIsWeb) {
    await Hive.initFlutter();
  }
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);
  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  // final GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();
  bool? spashEnble;
  late SplashView splashView;

  Uint8List? qrByte;
  String shareNum = "";

  @override
  void initState() {
    if (kIsWeb) {
      spashEnble = false;
      AppDefault.firstLaunchApp = false;
    } else {
      splashView = SplashView(
        closeSplash: () {
          UserDefault.saveBool(APP_SPLASH_ENABLE, false);
          setState(() {
            spashEnble = false;
          });
        },
      );
      UserDefault.get(APP_SPLASH_ENABLE).then((value) {
        setState(() {
          spashEnble = (value == null || value == true);
          // spashEnble = true;
          if (spashEnble ?? false) {
            AppDefault.firstLaunchApp = true;
          }
          // if (!spashEnble!) {
          //   if (mounted) {
          //     Future.delayed(Duration(seconds: 3), () {
          //       showLaunchSpash();
          //     });
          //   }
          // }
        });
      });
    }
    super.initState();
  }

  Widget fakeLaunch({bool empty = false, required BuildContext ctx}) {
    double height = ScreenUtil().screenHeight;
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          return empty
              ? Container(
                  color: Colors.white,
                )
              : Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image:
                              AssetImage(assetsName("common/launch_image")))));
        },
        home: empty
            ? Container(
                color: Colors.white,
              )
            : SizedBox(
                width: double.infinity,
                height: height,
                child: Image.asset(
                  assetsName("common/launch_image"),
                  width: double.infinity,
                  height: height,
                  fit: BoxFit.fill,
                ),
              ));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (kIsWeb) {
          return false;
        } else {
          return true;
        }
      },
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (BuildContext buildContext, Widget? child) {
          return spashEnble == null
              ? fakeLaunch(ctx: buildContext)
              : spashEnble!
                  ? MaterialApp(
                      title: AppDefault.projectName,
                      home: Scaffold(body: splashView),
                      debugShowCheckedModeBanner: false,
                    )
                  : pullRefresh(
                      child: skeletonTheme(
                        child: GetMaterialApp(
                          theme: ThemeData(
                            primaryColor: AppColor.theme,
                            // splashFactory: NoSplashFactory(),
                            primarySwatch: AppColor.mTheme,
                            splashColor: Colors.transparent,
                            scaffoldBackgroundColor:
                                AppColor.pageBackgroundColor,
                            textTheme: TextTheme(
                                bodyText1: TextStyle(
                                    color: AppColor.text, fontSize: 15.sp),
                                bodyText2: TextStyle(
                                    color: AppColor.text2, fontSize: 15.sp)),
                          ),
                          navigatorKey: Global.navigatorKey,
                          initialRoute: AppDefault.firstLaunchApp
                              ? Routes.main
                              : Routes.splash,
                          debugShowCheckedModeBanner: false,
                          defaultTransition: Transition.rightToLeft,
                          getPages: [
                            GetPage(
                              name: Routes.main,
                              page: () => const MainPage(),
                              binding: MainPageBinding(),
                            ),
                            GetPage(
                              name: Routes.splash,
                              page: () => const AppLaunchSplash(),
                              binding: AppLaunchSplashBinding(),
                            ),
                          ],
                          initialBinding: AppBinding(),
                          useInheritedMediaQuery: false,
                          enableLog: true,

                          title: AppDefault.projectName,
                          // home: MainPage(),
                          localizationsDelegates: const [
                            RefreshLocalizations.delegate,
                            GlobalMaterialLocalizations.delegate,
                            GlobalCupertinoLocalizations.delegate,
                            GlobalWidgetsLocalizations.delegate
                          ],
                          supportedLocales: const [Locale("en"), Locale("zh")],

                          builder: (getCtx, materialAppChild) {
                            return MediaQuery(
                                data: MediaQuery.of(getCtx).copyWith(
                                    textScaleFactor: 1.0, boldText: false),
                                child: materialAppChild!);
                          },
                          navigatorObservers: [GLObserver()],
                        ),
                      ),
                    );
        },
      ),
    );
  }

  Widget pullRefresh({required Widget child}) {
    return RefreshConfiguration(
      headerBuilder: () => WaterDropHeader(
        refresh: const CupertinoActivityIndicator(),
        complete: getSimpleText("刷新完成", 15, AppColor.text3),
      ), // 配置默认头部指示器,假如你每个页面的头部指示器都一样的话,你需要设置这个
      footerBuilder: () => const ClassicFooter(), // 配置默认底部指示器
      headerTriggerDistance: 80.0.w, // 头部触发刷新的越界距离
      springDescription: SpringDescription(
          stiffness: 170.w,
          damping: 16,
          mass: 1.9), // 自定义回弹动画,三个属性值意义请查询flutter api
      maxOverScrollExtent: 100, //头部最大可以拖动的范围,如果发生冲出视图范围区域,请设置这个属性
      maxUnderScrollExtent: 0, // 底部最大可以拖动的范围
      enableScrollWhenRefreshCompleted:
          true, //这个属性不兼容PageView和TabBarView,如果你特别需要TabBarView左右滑动,你需要把它设置为true
      enableLoadingWhenFailed: true, //在加载失败的状态下,用户仍然可以通过手势上拉来触发加载更多
      hideFooterWhenNotFull: false, // Viewport不满一屏时,禁用上拉加载更多功能
      enableBallisticLoad: true, // 可以通过惯性滑动触发加载更多
      child: child,
    );
  }

  Widget skeletonTheme({required Widget child}) {
    return child;
    // return SkeletonTheme(
    //   // themeMode: ThemeMode.light,
    //   shimmerGradient: const LinearGradient(
    //     colors: [
    //       Color(0xFFD8E3E7),
    //       Color(0xFFC8D5DA),
    //       Color(0xFFD8E3E7),
    //     ],
    //     stops: [
    //       0.1,
    //       0.5,
    //       0.9,
    //     ],
    //   ),
    //   darkShimmerGradient: const LinearGradient(
    //     colors: [
    //       Color(0xFF222222),
    //       Color(0xFF242424),
    //       Color(0xFF2B2B2B),
    //       Color(0xFF242424),
    //       Color(0xFF222222),
    //     ],
    //     stops: [
    //       0.0,
    //       0.2,
    //       0.5,
    //       0.8,
    //       1,
    //     ],
    //     begin: Alignment(-2.4, -0.2),
    //     end: Alignment(2.4, 0.2),
    //     tileMode: TileMode.clamp,
    //   ),
    //   child: child,
    // );
  }
}

class MainPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainPageCtrl>(() => MainPageCtrl());
  }
}

class MainPageCtrl extends GetxController {
  List<Widget> _mainViews = [];
  get mainViews => _mainViews;

  final _initPage = 2.obs;
  get initPage => _initPage.value;
  set initPage(value) => _initPage.value = value;

  final _tabbarIndex = 0.obs;
  get tabbarIndex => _tabbarIndex.value;
  set tabbarIndex(value) => _tabbarIndex.value = value;

  updatePageView(int index) {
    update();
  }

  bool haveSplash = false;

  //解决初次启动白屏bug
  final _ready = false.obs;
  set ready(value) => _ready.value = value;
  get ready => _ready.value;

  final _pageStyle = 1.obs;
  int get pageStyle => _pageStyle.value;
  set pageStyle(v) {
    _pageStyle.value = v;
  }

  //动画相关属性
  final _showView = false.obs;
  get showView => _showView.value;
  set showView(value) => _showView.value = value;
  final _aniValue = 0.0.obs;
  get aniValue => _aniValue.value;
  set aniValue(value) => _aniValue.value = value;
  final _startScrollIndex = 0.obs;
  get startScrollIndex => _startScrollIndex.value;
  set startScrollIndex(value) => _startScrollIndex.value = value;

  Timer? _timer;
  double timerCount = 0.5;
  double labelWidth = (375 - 30 * 2).w / (AppDefault().checkDay ? 5 : 4);
  bool isLeft = true;

  int pageIndex = 0;
  int i = 0;

  @override
  void onReady() {
    _ready.value = true;
    super.onReady();
  }

  _getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final ad = AppDefault();
    ad.appName = packageInfo.appName;
    ad.packageName = packageInfo.packageName;
    ad.version = packageInfo.version;
    ad.buildNumber = packageInfo.buildNumber;
  }

  List<Widget> bViews = [];

  @override
  void onInit() {
    bViews = [
      const Home(),
      const Business(),
      const BounsPool(),
      const Statistics(),
      const MinePage(),
    ];
    AppDefault.firstLaunchApp = false;
    bus.on(NOTIFY_CHANGE_USER_STATUS, userStatusChangeNotify);
    // bus.on(HOME_PUBLIC_DATA_UPDATE_NOTIFY, publicHomeDataUpdateNotify);
    _getAppVersion();
    initMain();
    super.onInit();
  }

  bool appIsCclient = false;
  initMain() {
    // bool? isCclient = await UserDefault.get(USER_STATUS_DATA);
    // appIsCclient = isCclient ?? false;
    updateTap();
  }

  publicHomeDataUpdateNotify(arg) {
    update();
  }

  userStatusChangeNotify(arg) {
    updateTap();
  }

  updateTap() {
    _mainViews = bViews;
    // update();
  }

  @override
  void onClose() {
    bus.off(HOME_PUBLIC_DATA_UPDATE_NOTIFY, publicHomeDataUpdateNotify);
    bus.off(NOTIFY_CHANGE_USER_STATUS, userStatusChangeNotify);
    super.onClose();
  }

  bool isFirst = true;
  BuildContext? context;

  dataInit(BuildContext ctx) {
    if (!isFirst) return;
    isFirst = false;
    context = ctx;
  }
}

class MainPage extends GetView<MainPageCtrl> {
  final bool firstLaunch;
  const MainPage({Key? key, this.firstLaunch = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.dataInit(context);
    return GetBuilder<MainPageCtrl>(
      builder: (_) {
        return Scaffold(
          body: GetX<MainPageCtrl>(
            builder: (_) {
              return IndexedStack(
                index: controller.tabbarIndex,
                children: controller._mainViews,
              );
            },
          ),
          bottomNavigationBar: Container(
            height: 60.w + paddingSizeBottom(context),
            width: 375.w,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
            ),
          ).blurred(
            colorOpacity: 0.1,
            blur: 20,
            // blurColor: const Color.fromRGBO(255, 255, 255, 0.1),
            overlay: Padding(
              padding: EdgeInsets.only(bottom: paddingSizeBottom(context)),
              child: GetX<MainPageCtrl>(
                initState: (_) {},
                builder: (_) {
                  return Row(
                    children: List.generate(
                        controller._mainViews.length, (index) => getTab(index)),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget getTab(int index) {
    String title = "";
    String img = "";

    switch (index) {
      case 0:
        title = "首页";
        img = "sy_";
        break;
      case 1:
        title = "商业圈";
        img = "syq_";
        break;
      case 2:
        title = "奖金池";
        img = "jjc";
        break;
      case 3:
        title = "统计";
        img = "tj_";
        break;
      case 4:
        title = "我的";
        img = "wd_";
        break;
    }

    return CustomButton(
        onPressed: () {
          controller.tabbarIndex = index;
        },
        child: SizedBox(
          width: 375.w / controller._mainViews.length,
          height: 60.w,
          child: Padding(
            padding: EdgeInsets.only(bottom: index == 2 ? 4.w : 3.w),
            child: Center(
              child: centClm([
                ColorFiltered(
                  colorFilter: ColorFilter.mode(
                      AppDefault().getThemeColor() == null
                          ? Colors.white
                          : controller.tabbarIndex == index
                              ? AppDefault().getThemeColor()!
                              : Colors.white,
                      BlendMode.modulate),
                  child: Image.asset(
                    assetsName(
                        "common/tabbar/btn_tabbar_$img${index == 2 ? "" : (controller.tabbarIndex == index && AppDefault().getThemeColor() == null ? "selected" : "normal")}"),
                    height: index == 2 ? 45.w : 24.5.w,
                    fit: BoxFit.fitHeight,
                  ),
                ),
                ghb(index == 2 ? 0 : 3),
                index == 2
                    ? ghb(0)
                    : getSimpleText(
                        title,
                        kIsWeb ? 11.5 : 10,
                        controller.tabbarIndex == index
                            ? (AppDefault().getThemeColor() ?? AppColor.blue)
                            : AppColor.textGrey,
                        isBold: controller.tabbarIndex == index)
              ]),
            ),
          ),
        ));
  }
}
