import 'package:flutter/material.dart';
import 'package:xplan_flutter/ui/NewsPage.dart';
import 'package:xplan_flutter/ui/PicturePage.dart';
import 'package:xplan_flutter/ui/SettingPage.dart';
import 'package:xplan_flutter/ui/VideoPage.dart';
import 'package:xplan_flutter/ui/widget_bottom_tabs.dart';
import 'package:xplan_flutter/widget/ToastUtil.dart';

class HomePage extends StatefulWidget{
  static const String ROUTER_NAME = '/';

  @override
  State<StatefulWidget> createState() => _HomePageState();

}

class _HomePageState extends State<HomePage>{
  int _currentPageIndex = 0;
  String _currentDate;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = new PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: new Drawer(child: homeDrawer()),
      appBar: _buildAppBar(),
      bottomNavigationBar: BottomTabs(_pageController, _pageChange),
      body: _buildBody()
    );
  }

  ///build AppBar.
  Widget _buildAppBar() {
    return AppBar(
      elevation: 5,
      centerTitle: true,
      title: Offstage(
        offstage: _currentPageIndex != 0,

        ///标题栏显示当前日期
        child: Text(_currentDate ?? ''),
      )
    );
  }

  ///页面切换回调
  void _pageChange(int index) {
    setState(() {
      if (_currentPageIndex != index) {
        _currentPageIndex = index;
      }
    });
  }

  static Widget homeDrawer() {
    return new ListView(padding: const EdgeInsets.only(), children: <Widget>[
      _drawerHeader(),
      new ClipRect(
        child: new ListTile(
          leading: new CircleAvatar(child: new Text("1")),
          title: new Text('测试测试'),
          onTap: () => {
            ToastUtil.shortToast("还没开发呢")
          },
        ),
      ),
      new ListTile(
        leading: new CircleAvatar(child: new Text("2")),
        title: new Text('下拉刷新'),
        onTap: () => {ToastUtil.shortToast("还没开发呢")},
      ),
      new ListTile(
        leading: new CircleAvatar(child: new Text("3")),
        title: new Text('关于我们'),
        onTap: () => {ToastUtil.shortToast("还没开发呢")},
      ),
    ]);
  }

  static Widget _drawerHeader() {
    return new UserAccountsDrawerHeader(
    );
  }

  ///build main body.
  Widget _buildBody() {
    return Stack(
      children: <Widget>[
        PageView(
          physics: NeverScrollableScrollPhysics(),//屏蔽左右滚动
          onPageChanged: _pageChange,
          controller: _pageController,
          children: <Widget>[
            VideoPage(),
            PicturePage(),
            NewsPage(),
            SettingPage()
          ],
        )
      ],
    );
  }
}