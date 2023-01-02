// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'components/page_view_swiper.dart';

/// This sample app shows an app with two screens.
///
/// The first route '/' is mapped to [HomeScreen], and the second route
/// '/details' is mapped to [DetailsScreen].
///
/// The buttons use context.go() to navigate to each destination. On mobile
/// devices, each destination is deep-linkable and on the web, can be navigated
/// to using the address bar.
void main() {
  runApp(const MyApp());
  if (Platform.isAndroid) {
    // 以下两行 设置android状态栏为透明的沉浸。写在组件渲染之后，是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前       MaterialApp组件会覆盖掉这个值。
    SystemUiOverlayStyle systemUiOverlayStyle =
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

/// The main app.
class MyApp extends StatelessWidget {
  /// Constructs a [MyApp]
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // debugShowCheckedModeBanner: false,
      title: 'CliCili',
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  final List<Widget> views = [
    Scaffold(
      drawer: drawerDemo(),
      // endDrawer: const Drawer(),
      appBar: AppBar(title: const Text('首页')),
      body: const ViewPage(),
    ),
    const SafeArea(child: Text('频道')),
    const Text('动态'),
    const Text('会员购'),
    const Text('我的'),
  ];
  final List<String> tabs = ["首页", "频道", "动态", "会员购", "我的"];
  final List icons = [0xe69b, 0xe6ec, 0xe699, 0xe6e3, 0xe6a0];
  TextStyle styles() {
    return const TextStyle(
      fontWeight: FontWeight.w900,
    );
  }

  @override
  Widget build(BuildContext context) {
    final len = tabs.length;
    double itemWidth = MediaQuery.of(context).size.width / len;
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Row(children: <Widget>[
          SizedBox(height: 47, width: itemWidth, child: tabbar(0)),
          SizedBox(height: 47, width: itemWidth, child: tabbar(1)),
          SizedBox(height: 47, width: itemWidth, child: tabbar(2)),
          SizedBox(height: 47, width: itemWidth, child: tabbar(3)),
          SizedBox(height: 47, width: itemWidth, child: tabbar(4)),
        ]),
      ),
      body: views[_selectedIndex],
    );
  }

  Widget tabbar(int index) {
    //设置默认未选中的状态
    Color color = const Color(0xFF6a6b66);
    TextStyle style = TextStyle(
      fontSize: 12,
      color: color,
    );

    if (_selectedIndex == index) {
      //选中的话
      style = TextStyle(
        fontSize: 13,
        color: color,
        fontWeight: FontWeight.w600,
      );
    }
    //构造返回的Widget
    Widget item = GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            IconData(icons[index], fontFamily: 'MyIcons'),
            color: color,
          ),
          Text(
            tabs[index],
            style: style,
          )
        ],
      ),
      onTap: () {
        if (_selectedIndex != index) {
          setState(() {
            _selectedIndex = index;
          });
        }
      },
    );
    return item;
  }
}

Widget animaDemo() {
  return Center(
    child: TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 100.0, end: 150.0),
      duration: const Duration(seconds: 2),
      builder: (context, value, child) {
        return SizedBox(
          height: value,
          width: value,
          child: child,
        );
      },
      onEnd: () {
        print('ending');
      },
      child: Image.network(
        'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg',
        fit: BoxFit.fill,
      ),
    ),
  );
}

Widget drawerDemo() {
  return Drawer(child: Builder(
    builder: (context) {
      return Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: UserAccountsDrawerHeader(
                  accountName: const Text('账户名称'),
                  accountEmail: const Text('123456789@qq.com'),
                  currentAccountPicture: const CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://www.itying.com/images/flutter/3.png'),
                  ), //用户头像
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                          'https://www.itying.com/images/flutter/2.png'),
                      fit: BoxFit.cover,
                    ),
                  ), //背景
                  otherAccountsPictures: <Widget>[
                    Image.network(
                        'https://www.itying.com/images/flutter/4.png'),
                    Image.network(
                        'https://www.itying.com/images/flutter/5.png'),
                    const Text('data')
                  ],
                ),
              ),
            ],
          ),
          ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.home),
            ),
            title: const Text('我的空间'),
            onTap: () {
              Navigator.of(context).pop(); //隐藏侧边栏
              // Navigator.pushNamed(context, '/user');
            },
          ),
          const Divider(), // 增加一条线
          const ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.people),
            ),
            title: Text('用户中心'),
          ),
          const Divider(), // 增加一条线
          const ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.settings),
            ),
            title: Text('设置'),
          ),
        ],
      );
    },
  ));
}
