import 'package:cxhighversion2/component/custom_network_image.dart';
import 'package:flutter/material.dart';

import 'package:cxhighversion2/component/custom_button.dart';
import 'package:cxhighversion2/util/app_default.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'points_mall_page.dart';
import 'package:get/get.dart';

class MallCartPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MallCartPageController>(() => MallCartPageController());
  }
}

class MallCartPageController extends GetxController {
  List MallTypeList = [
    {
      "id": 1,
      "title": "美妆护肤",
      "children": [
        {
          "id": 2,
          "pid": 1,
          "title": "拔草推荐",
          "children": [
            {"id": 3, "pid": 2, "title": "明星同款面膜", "imgUrl": "https://img14.360buyimg.com/focus/s140x140_jfs/t1/91206/20/13565/9379/5e5f262bE45790537/0373287c48fa2317.jpg"},
            {"id": 4, "pid": 2, "title": "显白口红", "imgUrl": "https://img10.360buyimg.com/focus/s140x140_jfs/t1/95022/3/13977/20829/5e5f2636E20222316/bbc6e2cf5b10669e.jpg"},
            {"id": 5, "pid": 2, "title": "小美盒", "imgUrl": "https://img10.360buyimg.com/focus/s140x140_jfs/t1/102819/1/13751/13266/5e5f2642Ea72e3802/828ddc1e738c1e07.jpg"},
            {"id": 6, "pid": 2, "title": "新品速递", "imgUrl": "https://img14.360buyimg.com/focus/s140x140_jfs/t1/85282/32/13974/33702/5e5f272cE97839976/3b5ccf856f171658.jpg"}
          ]
        },
        {
          "id": 7,
          "pid": 1,
          "title": "猫咪",
          "children": [
            {"id": 8, "pid": 7, "title": "喵喵"},
            {"id": 9, "pid": 7, "title": "喵粮"},
            {"id": 10, "pid": 7, "title": "喵零食"},
          ]
        }
      ]
    },
    {
      "id": 11,
      "title": "手机数码",
      "children": [
        {
          "id": 12,
          "pid": 11,
          "title": "热门品牌",
          "children": [
            {"id": 13, "pid": 12, "title": "小米", "imgUrl": "https://img30.360buyimg.com/focus/s140x140_jfs/t13411/188/926813276/3945/a4f47292/5a1692eeN105a64b4.png"},
            {"id": 14, "pid": 12, "title": "华为", "imgUrl": "https://img14.360buyimg.com/focus/s140x140_jfs/t11929/135/2372293765/1396/e103ec31/5a1692e2Nbea6e136.jpg"},
            {"id": 15, "pid": 12, "title": "Apple", "imgUrl": "https://img20.360buyimg.com/focus/s140x140_jfs/t13759/194/897734755/2493/1305d4c4/5a1692ebN8ae73077.jpg"},
          ]
        }
      ]
    },
    {
      "id": 1,
      "title": "美妆护肤",
      "children": [
        {
          "id": 2,
          "pid": 1,
          "title": "拔草推荐",
          "children": [
            {"id": 3, "pid": 2, "title": "明星同款面膜", "imgUrl": "https://img14.360buyimg.com/focus/s140x140_jfs/t1/91206/20/13565/9379/5e5f262bE45790537/0373287c48fa2317.jpg"},
            {"id": 4, "pid": 2, "title": "显白口红", "imgUrl": "https://img10.360buyimg.com/focus/s140x140_jfs/t1/95022/3/13977/20829/5e5f2636E20222316/bbc6e2cf5b10669e.jpg"},
            {"id": 5, "pid": 2, "title": "小美盒", "imgUrl": "https://img10.360buyimg.com/focus/s140x140_jfs/t1/102819/1/13751/13266/5e5f2642Ea72e3802/828ddc1e738c1e07.jpg"},
            {"id": 6, "pid": 2, "title": "新品速递", "imgUrl": "https://img14.360buyimg.com/focus/s140x140_jfs/t1/85282/32/13974/33702/5e5f272cE97839976/3b5ccf856f171658.jpg"}
          ]
        },
        {
          "id": 7,
          "pid": 1,
          "title": "猫咪",
          "children": [
            {"id": 8, "pid": 7, "title": "喵喵"},
            {"id": 9, "pid": 7, "title": "喵粮"},
            {"id": 10, "pid": 7, "title": "喵零食"},
          ]
        }
      ]
    },
    {
      "id": 11,
      "title": "手机数码",
      "children": [
        {
          "id": 12,
          "pid": 11,
          "title": "热门品牌",
          "children": [
            {"id": 13, "pid": 12, "title": "小米", "imgUrl": "https://img30.360buyimg.com/focus/s140x140_jfs/t13411/188/926813276/3945/a4f47292/5a1692eeN105a64b4.png"},
            {"id": 14, "pid": 12, "title": "华为", "imgUrl": "https://img14.360buyimg.com/focus/s140x140_jfs/t11929/135/2372293765/1396/e103ec31/5a1692e2Nbea6e136.jpg"},
            {"id": 15, "pid": 12, "title": "Apple", "imgUrl": "https://img20.360buyimg.com/focus/s140x140_jfs/t13759/194/897734755/2493/1305d4c4/5a1692ebN8ae73077.jpg"},
          ]
        }
      ]
    },
    {
      "id": 1,
      "title": "美妆护肤",
      "children": [
        {
          "id": 2,
          "pid": 1,
          "title": "拔草推荐",
          "children": [
            {"id": 3, "pid": 2, "title": "明星同款面膜", "imgUrl": "https://img14.360buyimg.com/focus/s140x140_jfs/t1/91206/20/13565/9379/5e5f262bE45790537/0373287c48fa2317.jpg"},
            {"id": 4, "pid": 2, "title": "显白口红", "imgUrl": "https://img10.360buyimg.com/focus/s140x140_jfs/t1/95022/3/13977/20829/5e5f2636E20222316/bbc6e2cf5b10669e.jpg"},
            {"id": 5, "pid": 2, "title": "小美盒", "imgUrl": "https://img10.360buyimg.com/focus/s140x140_jfs/t1/102819/1/13751/13266/5e5f2642Ea72e3802/828ddc1e738c1e07.jpg"},
            {"id": 6, "pid": 2, "title": "新品速递", "imgUrl": "https://img14.360buyimg.com/focus/s140x140_jfs/t1/85282/32/13974/33702/5e5f272cE97839976/3b5ccf856f171658.jpg"}
          ]
        },
        {
          "id": 7,
          "pid": 1,
          "title": "猫咪",
          "children": [
            {"id": 8, "pid": 7, "title": "喵喵"},
            {"id": 9, "pid": 7, "title": "喵粮"},
            {"id": 10, "pid": 7, "title": "喵零食"},
          ]
        }
      ]
    },
    {
      "id": 11,
      "title": "手机数码",
      "children": [
        {
          "id": 12,
          "pid": 11,
          "title": "热门品牌",
          "children": [
            {"id": 13, "pid": 12, "title": "小米", "imgUrl": "https://img30.360buyimg.com/focus/s140x140_jfs/t13411/188/926813276/3945/a4f47292/5a1692eeN105a64b4.png"},
            {"id": 14, "pid": 12, "title": "华为", "imgUrl": "https://img14.360buyimg.com/focus/s140x140_jfs/t11929/135/2372293765/1396/e103ec31/5a1692e2Nbea6e136.jpg"},
            {"id": 15, "pid": 12, "title": "Apple", "imgUrl": "https://img20.360buyimg.com/focus/s140x140_jfs/t13759/194/897734755/2493/1305d4c4/5a1692ebN8ae73077.jpg"},
          ]
        },
      ]
    },
    {
      "id": 1,
      "title": "美妆护肤",
      "children": [
        {
          "id": 2,
          "pid": 1,
          "title": "拔草推荐",
          "children": [
            {"id": 3, "pid": 2, "title": "明星同款面膜", "imgUrl": "https://img14.360buyimg.com/focus/s140x140_jfs/t1/91206/20/13565/9379/5e5f262bE45790537/0373287c48fa2317.jpg"},
            {"id": 4, "pid": 2, "title": "显白口红", "imgUrl": "https://img10.360buyimg.com/focus/s140x140_jfs/t1/95022/3/13977/20829/5e5f2636E20222316/bbc6e2cf5b10669e.jpg"},
            {"id": 5, "pid": 2, "title": "小美盒", "imgUrl": "https://img10.360buyimg.com/focus/s140x140_jfs/t1/102819/1/13751/13266/5e5f2642Ea72e3802/828ddc1e738c1e07.jpg"},
            {"id": 6, "pid": 2, "title": "新品速递", "imgUrl": "https://img14.360buyimg.com/focus/s140x140_jfs/t1/85282/32/13974/33702/5e5f272cE97839976/3b5ccf856f171658.jpg"}
          ]
        },
        {
          "id": 7,
          "pid": 1,
          "title": "猫咪",
          "children": [
            {"id": 8, "pid": 7, "title": "喵喵"},
            {"id": 9, "pid": 7, "title": "喵粮"},
            {"id": 10, "pid": 7, "title": "喵零食"},
          ]
        }
      ]
    },
    {
      "id": 11,
      "title": "手机数码",
      "children": [
        {
          "id": 12,
          "pid": 11,
          "title": "热门品牌",
          "children": [
            {"id": 13, "pid": 12, "title": "小米", "imgUrl": "https://img30.360buyimg.com/focus/s140x140_jfs/t13411/188/926813276/3945/a4f47292/5a1692eeN105a64b4.png"},
            {"id": 14, "pid": 12, "title": "华为", "imgUrl": "https://img14.360buyimg.com/focus/s140x140_jfs/t11929/135/2372293765/1396/e103ec31/5a1692e2Nbea6e136.jpg"},
            {"id": 15, "pid": 12, "title": "Apple", "imgUrl": "https://img20.360buyimg.com/focus/s140x140_jfs/t13759/194/897734755/2493/1305d4c4/5a1692ebN8ae73077.jpg"},
          ]
        }
      ]
    },
    {
      "id": 1,
      "title": "美妆护肤",
      "children": [
        {
          "id": 2,
          "pid": 1,
          "title": "拔草推荐",
          "children": [
            {"id": 3, "pid": 2, "title": "明星同款面膜", "imgUrl": "https://img14.360buyimg.com/focus/s140x140_jfs/t1/91206/20/13565/9379/5e5f262bE45790537/0373287c48fa2317.jpg"},
            {"id": 4, "pid": 2, "title": "显白口红", "imgUrl": "https://img10.360buyimg.com/focus/s140x140_jfs/t1/95022/3/13977/20829/5e5f2636E20222316/bbc6e2cf5b10669e.jpg"},
            {"id": 5, "pid": 2, "title": "小美盒", "imgUrl": "https://img10.360buyimg.com/focus/s140x140_jfs/t1/102819/1/13751/13266/5e5f2642Ea72e3802/828ddc1e738c1e07.jpg"},
            {"id": 6, "pid": 2, "title": "新品速递", "imgUrl": "https://img14.360buyimg.com/focus/s140x140_jfs/t1/85282/32/13974/33702/5e5f272cE97839976/3b5ccf856f171658.jpg"}
          ]
        },
        {
          "id": 7,
          "pid": 1,
          "title": "猫咪",
          "children": [
            {"id": 8, "pid": 7, "title": "喵喵"},
            {"id": 9, "pid": 7, "title": "喵粮"},
            {"id": 10, "pid": 7, "title": "喵零食"},
          ]
        }
      ]
    },
    {
      "id": 11,
      "title": "手机数码",
      "children": [
        {
          "id": 12,
          "pid": 11,
          "title": "热门品牌",
          "children": [
            {"id": 13, "pid": 12, "title": "小米", "imgUrl": "https://img30.360buyimg.com/focus/s140x140_jfs/t13411/188/926813276/3945/a4f47292/5a1692eeN105a64b4.png"},
            {"id": 14, "pid": 12, "title": "华为", "imgUrl": "https://img14.360buyimg.com/focus/s140x140_jfs/t11929/135/2372293765/1396/e103ec31/5a1692e2Nbea6e136.jpg"},
            {"id": 15, "pid": 12, "title": "Apple", "imgUrl": "https://img20.360buyimg.com/focus/s140x140_jfs/t13759/194/897734755/2493/1305d4c4/5a1692ebN8ae73077.jpg"},
          ]
        }
      ]
    },
    {
      "id": 1,
      "title": "美妆护肤",
      "children": [
        {
          "id": 2,
          "pid": 1,
          "title": "拔草推荐",
          "children": [
            {"id": 3, "pid": 2, "title": "明星同款面膜", "imgUrl": "https://img14.360buyimg.com/focus/s140x140_jfs/t1/91206/20/13565/9379/5e5f262bE45790537/0373287c48fa2317.jpg"},
            {"id": 4, "pid": 2, "title": "显白口红", "imgUrl": "https://img10.360buyimg.com/focus/s140x140_jfs/t1/95022/3/13977/20829/5e5f2636E20222316/bbc6e2cf5b10669e.jpg"},
            {"id": 5, "pid": 2, "title": "小美盒", "imgUrl": "https://img10.360buyimg.com/focus/s140x140_jfs/t1/102819/1/13751/13266/5e5f2642Ea72e3802/828ddc1e738c1e07.jpg"},
            {"id": 6, "pid": 2, "title": "新品速递", "imgUrl": "https://img14.360buyimg.com/focus/s140x140_jfs/t1/85282/32/13974/33702/5e5f272cE97839976/3b5ccf856f171658.jpg"}
          ]
        },
        {
          "id": 7,
          "pid": 1,
          "title": "猫咪",
          "children": [
            {"id": 8, "pid": 7, "title": "喵喵"},
            {"id": 9, "pid": 7, "title": "喵粮"},
            {"id": 10, "pid": 7, "title": "喵零食"},
          ]
        }
      ]
    },
    {
      "id": 11,
      "title": "手机数码",
      "children": [
        {
          "id": 12,
          "pid": 11,
          "title": "热门品牌",
          "children": [
            {"id": 13, "pid": 12, "title": "小米", "imgUrl": "https://img30.360buyimg.com/focus/s140x140_jfs/t13411/188/926813276/3945/a4f47292/5a1692eeN105a64b4.png"},
            {"id": 14, "pid": 12, "title": "华为", "imgUrl": "https://img14.360buyimg.com/focus/s140x140_jfs/t11929/135/2372293765/1396/e103ec31/5a1692e2Nbea6e136.jpg"},
            {"id": 15, "pid": 12, "title": "Apple", "imgUrl": "https://img20.360buyimg.com/focus/s140x140_jfs/t13759/194/897734755/2493/1305d4c4/5a1692ebN8ae73077.jpg"},
          ]
        }
      ]
    },
    {
      "id": 1,
      "title": "美妆护肤11",
      "children": [
        {
          "id": 2,
          "pid": 1,
          "title": "拔草推荐",
          "children": [
            {"id": 3, "pid": 2, "title": "明星同款面膜", "imgUrl": "https://img14.360buyimg.com/focus/s140x140_jfs/t1/91206/20/13565/9379/5e5f262bE45790537/0373287c48fa2317.jpg"},
            {"id": 4, "pid": 2, "title": "显白口红", "imgUrl": "https://img10.360buyimg.com/focus/s140x140_jfs/t1/95022/3/13977/20829/5e5f2636E20222316/bbc6e2cf5b10669e.jpg"},
            {"id": 5, "pid": 2, "title": "小美盒", "imgUrl": "https://img10.360buyimg.com/focus/s140x140_jfs/t1/102819/1/13751/13266/5e5f2642Ea72e3802/828ddc1e738c1e07.jpg"},
            {"id": 6, "pid": 2, "title": "新品速递", "imgUrl": "https://img14.360buyimg.com/focus/s140x140_jfs/t1/85282/32/13974/33702/5e5f272cE97839976/3b5ccf856f171658.jpg"}
          ]
        },
        {
          "id": 7,
          "pid": 1,
          "title": "猫咪",
          "children": [
            {"id": 8, "pid": 7, "title": "喵喵"},
            {"id": 9, "pid": 7, "title": "喵粮"},
            {"id": 10, "pid": 7, "title": "喵零食"},
          ]
        }
      ]
    },
    {
      "id": 11,
      "title": "手机数码13",
      "children": [
        {
          "id": 12,
          "pid": 11,
          "title": "热门品牌",
          "children": [
            {"id": 13, "pid": 12, "title": "小米", "imgUrl": "https://img30.360buyimg.com/focus/s140x140_jfs/t13411/188/926813276/3945/a4f47292/5a1692eeN105a64b4.png"},
            {"id": 14, "pid": 12, "title": "华为", "imgUrl": "https://img14.360buyimg.com/focus/s140x140_jfs/t11929/135/2372293765/1396/e103ec31/5a1692e2Nbea6e136.jpg"},
            {"id": 15, "pid": 12, "title": "Apple", "imgUrl": "https://img20.360buyimg.com/focus/s140x140_jfs/t13759/194/897734755/2493/1305d4c4/5a1692ebN8ae73077.jpg"},
          ]
        }
      ]
    }
  ];

  final _currentIndex = 0.obs; // 默认第一个
  int get currentIndex => _currentIndex.value;
  set currentIndex(v) => _currentIndex.value = v;

  @override
  void onInit() {
    super.onInit();
  }
}

class MallCartPage extends GetView<MallCartPageController> {
  const MallCartPage({super.key});

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getDefaultAppBar(
        context,
        "分类",
        action: [],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: Colors.white,
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            right: 0,
            child: Column(
              children: [
                MallCartSearch(),
              ],
            ),
          ),

          Positioned(
            top: kToolbarHeight,
            left: 0,
            right: 0,
            bottom: 0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  child: CategoryTab(),
                ),
                SingleChildScrollView(
                  child: CategoryContent(),
                )
              ],
            ),
          )

          // Positioned(
          //   left: 0,
          //   top: 54.5.w,
          //   child: CategoryTab(),
          // ),
          // Positioned(left: 90.w, top: 54.5.w, child: CategoryContent())
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '首页'),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: '分类'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: '购物车'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '我的'),
        ],
        currentIndex: 1,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.amber[800],
        onTap: (index) {
          switch (index) {
            case 0:
              push(const PointsMallPage(), null, binding: PointsMallPageBinding());
              break;
            case 1:
              push(const MallCartPage(), null, binding: MallCartPageBinding());
              break;
            default:
          }
        },
      ),
    );
  }

  // 搜索
  Widget MallCartSearch() {
    return Container(
      decoration: BoxDecoration(color: Color(0xFFFFFFFF)),
      width: 375.w,
      child: Column(children: [
        ghb(5),
        gwb(375),
        CustomButton(
          child: Container(
            width: 345.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: Color(0xFFF5F5F7),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: sbRow([
                Text('请输入想要搜索的商品'),
                Image.asset(
                  assetsName("business/mall/icon_search"),
                  width: 18.w,
                ),
              ], width: 345 - 20.5 * 2),
            ),
          ),
          onPressed: () => print(""),
        ),
        ghb(9.5.w),
      ]),
    );
  }

  // 左侧分类
  Widget CategoryTab() {
    return Container(
      width: 90.w,
      child: Column(
        children: List.generate(controller.MallTypeList.length, (index) {
          Map data = controller.MallTypeList[index];

          return GetBuilder<MallCartPageController>(
            builder: (_) {
              return GestureDetector(onTap: () {
                controller.currentIndex = index;
              }, child: GetX<MallCartPageController>(
                builder: (controller) {
                  return Container(
                    decoration: BoxDecoration(color: Color(controller.currentIndex == index ? 0xFFFFFFFF : 0xFFF5F5F7)),
                    alignment: Alignment.center,
                    width: 90.w,
                    height: 50.w,
                    child: Text(
                      data['title'],
                      style: TextStyle(fontSize: 15, color: Color(controller.currentIndex == index ? 0xFFFF6231 : 0xFF333333)),
                    ),
                  );
                },
              ));
            },
          );
        }),
      ),
    );
  }

  // 分类区域

  Widget CategoryContent() {
    return Container(
      width: 285.w,
      padding: EdgeInsets.all(8.w),
      child:
          // Container(child: Text("${controller.MallTypeList[controller.currentIndex]['children']}")
          GetX<MallCartPageController>(
        init: MallCartPageController(),
        initState: (_) {},
        builder: (_) {
          return Column(
            children: List.generate(controller.MallTypeList[controller.currentIndex]['children'].length, (level2Index) {
              Map _level2Item = controller.MallTypeList[controller.currentIndex]['children'][level2Index];
              List _level3data = _level2Item['children'];
              return Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(_level2Item['title']),
                  ),
                  ghb(10.5.w),
                  // Text('${level2data["children"]}')
                  SizedBox(
                    child: Wrap(
                      spacing: 10.w,
                      runSpacing: 20.w,
                      children: List.generate(_level3data.length, (level3Index) {
                        Map level3item = _level3data[level3Index];
                        return Container(
                          child: Column(children: [
                            // Image.network("${level3item['imgUrl']}"),
                            CustomNetworkImage(
                              src: "${level3item['imgUrl']}",
                              width: 70.w,
                              height: 70.w,
                            ),

                            Text("${level3item['title']}"),
                          ]),
                        );
                      }),
                    ),
                  ),
                  ghb(10.5.w),
                ],
              );
            }),
          );
        },
      ),
    );
  }
}



// [
//                 Align(
//                   child: Text("ceshi"),
//                   alignment: Alignment.centerLeft,
//                 ),
//                 SizedBox(
//                   child: Wrap(
//                     spacing: 10.w,
//                     runSpacing: 10.w,
//                     children: List.generate(controller.MallTypeList[controller.currentIndex].length, (index) {
//                       Map data = controller.MallTypeList[index];
//                       return Container(
//                         width: 70.w,
//                         height: 90.w,
//                         child: Column(
//                           children: [
//                             // Image.network(
//                             //   data[""],
//                             //   width: 70.w,
//                             //   height: 70.w,
//                             // ),
//                             Text("gougo")
//                           ],
//                         ),
//                       );
//                     }),
//                   ),
//                 )
//               ]