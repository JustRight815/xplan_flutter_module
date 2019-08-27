import 'package:flutter/material.dart';
import 'package:xplan_flutter/constant/AppStrings.dart';
import 'package:xplan_flutter/ui/NewsPage.dart';
import 'package:xplan_flutter/ui/setting/SettingPage.dart';
import 'package:xplan_flutter/ui/picture/PicturePage.dart';
import 'package:xplan_flutter/ui/video/VideoPage.dart';
import 'package:xplan_flutter/ui/widget_bottom_tabs.dart';
import 'package:xplan_flutter/widget/ToastUtil.dart';

class HomePage extends StatefulWidget{
  static const String ROUTER_NAME = '/';

  @override
  State<StatefulWidget> createState() => _HomePageState();

}

class _HomePageState extends State<HomePage>{
  int _currentPageIndex = 0;
  PageController _pageController;
  var appBarTitles = [ AppStrings.video, AppStrings.picture, AppStrings.toutiao, AppStrings.setting];
  final bodyList = [VideoPage(), PicturePage(), NewsPage(), SettingPage()];

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
        bottomNavigationBar: BottomTabs(_pageController, _currentPageIndex),
      body: _buildBody()
    );
  }

  ///build AppBar.
  Widget _buildAppBar() {
    return AppBar(
      elevation: 5,
      centerTitle: true,
      title: Text(
        getTitleText(),
        style: new TextStyle(
        color: Colors.white,
        fontSize: 18.0,
      ))
    );
  }

  String getTitleText(){
    return appBarTitles[_currentPageIndex];
  }

  ///build main body.
  Widget _buildBody() {
    return Stack(
      children: <Widget>[
        PageView(
          physics: NeverScrollableScrollPhysics(), //屏蔽左右滚动
          onPageChanged: onPageChanged,
          controller: _pageController,
          children: bodyList,
        )
      ],
    );
  }

  void onPageChanged(int index) {
    if (_currentPageIndex != index) {
      setState(() {
        _currentPageIndex = index;
      });
    }
  }

  static Widget homeDrawer() {
    return new ListView(padding: const EdgeInsets.only(), children: <Widget>[
      new UserAccountsDrawerHeader(),
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
}