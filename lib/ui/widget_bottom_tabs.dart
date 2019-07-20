import 'package:flutter/material.dart';
import 'package:xplan_flutter/constant/AppStrings.dart';
import 'package:xplan_flutter/ui/widget_icon_font.dart';

class BottomTabs extends StatefulWidget {
  final PageController pageController;
  final ValueChanged<int> onTap;

  BottomTabs(this.pageController, this.onTap);

  @override
  _BottomTabsState createState() => _BottomTabsState();
}

class _BottomTabsState extends State<BottomTabs> {
  int currentIndex = 0;
  var tabImages = [
    [getTabImage('images/menu_pic.png'), getTabImage('images/menu_pic_pre.png')],
    [getTabImage('images/menu_video.png'), getTabImage('images/menu_video_pre.png')],
    [getTabImage('images/menu_news.png'), getTabImage('images/menu_news_pre.png')],
    [getTabImage('images/menu_my.png'), getTabImage('images/menu_my_pre.png')]
  ];

  @override
  Widget build(BuildContext context) {
    var _bottomTabs = <BottomNavigationBarItem>[
      ///视频
      BottomNavigationBarItem(
        icon: getTabIcon(0),
        title: Text(AppStrings.video),
      ),

      ///图片
      BottomNavigationBarItem(
        icon: getTabIcon(1),
        title:
            Text(AppStrings.picture),
      ),

      ///头条
      BottomNavigationBarItem(
        icon: getTabIcon(2),
        title: Text(AppStrings.toutiao),
      ),

      ///设置
      BottomNavigationBarItem(
        icon: getTabIcon(3),
        title:
            Text(AppStrings.setting),
      ),
    ];
    return BottomNavigationBar(
      items: _bottomTabs,
      type: BottomNavigationBarType.fixed,
      iconSize: 32,
      currentIndex: currentIndex,
      onTap: (int index) {
        if (widget.onTap != null) {
          setState(() {
            currentIndex = index;
          });
          widget.pageController.jumpToPage(index);
          widget.onTap(index);
        }
      },
    );
  }

  /*
   * 根据image路径获取图片
   */
  static Image getTabImage(path) {
    return new Image.asset(path, width: 30.0, height: 30.0);
  }

  Image getTabIcon(int curIndex) {
    if (curIndex == currentIndex) {
      return tabImages[curIndex][1];
    }
    return tabImages[curIndex][0];
  }


}
