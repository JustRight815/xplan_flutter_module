import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:xplan_flutter/model/common_model.dart';
import 'package:xplan_flutter/widget/cached_image.dart';
import 'package:xplan_flutter/widget/local_nav.dart';

class PicturePage extends StatefulWidget {
  static const String ROUTER_NAME = '/';

  @override
  State<StatefulWidget> createState() => _PicturePageState();
}

class _PicturePageState extends State<PicturePage> {
  List<CommonModel> bannerList = []; //轮播图列表
  List<CommonModel> menuList = []; //菜单列表

  @override
  void initState() {
    _initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _listView
    );
  }

  void _initData() {
    bannerList = new List<CommonModel>();
    bannerList.add(new CommonModel(
        icon: "https://m.360buyimg.com/mobilecms/s720x322_jfs/t4903/41/12296166/85214/15205dd6/58d92373N127109d8.jpg!q70.jpg"));
    bannerList.add(new CommonModel(
        icon: "https://m.360buyimg.com/mobilecms/s720x322_jfs/t4903/41/12296166/85214/15205dd6/58d92373N127109d8.jpg!q70.jpg"));
    bannerList.add(new CommonModel(
        icon: "https://m.360buyimg.com/mobilecms/s720x322_jfs/t4903/41/12296166/85214/15205dd6/58d92373N127109d8.jpg!q70.jpg"));
    bannerList.add(new CommonModel(
        icon: "https://m.360buyimg.com/mobilecms/s720x322_jfs/t4903/41/12296166/85214/15205dd6/58d92373N127109d8.jpg!q70.jpg"));
    bannerList.add(new CommonModel(
        icon: "https://m.360buyimg.com/mobilecms/s720x322_jfs/t4903/41/12296166/85214/15205dd6/58d92373N127109d8.jpg!q70.jpg"));

    menuList = new List<CommonModel>();
    menuList.add(new CommonModel(icon: "images/hone_menu_icon_0.png",title: "美食"));
    menuList.add(new CommonModel(icon: "images/hone_menu_icon_0.png",title: "电影"));
    menuList.add(new CommonModel(icon: "images/hone_menu_icon_0.png",title: "酒店"));
    menuList.add(new CommonModel(icon: "images/hone_menu_icon_0.png",title: "酒店"));
    menuList.add(new CommonModel(icon: "images/hone_menu_icon_0.png",title: "酒店"));
  }


  //listView列表
  Widget get _listView {
    return ListView(
      children: <Widget>[
        _banner, /*轮播图*/
        Padding(/*local导航*/
          padding: EdgeInsets.fromLTRB(7, 4, 7, 4),
          child: LocalNav(
            localNavList: menuList,
          ),
        ),
      ],
    );
  }

  /*banner轮播图*/
  Widget get _banner {
    return Container(
      height: 160,
      child: Swiper(
        autoplay: true,
        loop: true,
        pagination: SwiperPagination(),
        itemCount: bannerList.length,
        itemBuilder: (BuildContext context, int index) {
          return CachedImage(
            imageUrl: bannerList[index].icon,
            fit: BoxFit.fill,
          );
        },
        onTap: (index) {

        },
      ),
    );
  }
}


