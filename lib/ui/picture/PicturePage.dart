import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:xplan_flutter/common/widget/LoadStateWidget.dart';
import 'package:xplan_flutter/common/widget/SmartRefreshWidget.dart';
import 'package:xplan_flutter/constant/AppConst.dart';
import 'package:xplan_flutter/ui/base/BaseWidget.dart';
import 'package:xplan_flutter/ui/picture/model/common_model.dart';
import 'package:xplan_flutter/ui/picture/widget/PictureGridItem.dart';
import 'package:xplan_flutter/common/widget/CachedImageWidget.dart';
import 'package:xplan_flutter/ui/picture/widget/PicMenuWidget.dart';

class PicturePage extends BaseWidget {
  static const String ROUTER_NAME = '/';

  @override
  State<StatefulWidget> createState() => _PicturePageState();
}

class _PicturePageState extends State<PicturePage> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;

  List<CommonModel> bannerList = []; //轮播图列表
  List<CommonModel> menuList = []; //菜单列表
  List<CommonModel> gridList = new List<CommonModel>(); //瀑布流图片列表

  RefreshController _refreshController;
  //页面加载状态，默认为加载中
  LoadState _layoutState = LoadState.State_Loading;

  @override
  void initState() {
    _refreshController = new RefreshController();
    _initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: _buildAppBar(),
        body: LoadStateWidget(
          state: _layoutState,
          errorRetry: () {
            setState(() {
              _layoutState = LoadState.State_Loading;
            });
            //错误按钮点击过后进行重新加载
            _initData();
          },
          successWidget: Container(
            color: Color(0x0FFFFFFF),
            child: SmartRefreshWidget(
                controller: _refreshController,
                child: _listView,
                onRefresh: _onRefresh,
                onLoading: _onLoading
            ),
          ),
        )
    );
  }

  void _onRefresh() {
    _initData();
  }

  void _onLoading() {
    _initData(loadMore: true);
  }

  void _initData({bool loadMore = false}) {
    Future.delayed(Duration(milliseconds: 300)).then((_) {
      bannerList = new List<CommonModel>();
      bannerList.add(new CommonModel(
            icon: "https://m.360buyimg.com/mobilecms/s720x322_jfs/t4903/41/12296166/85214/15205dd6/58d92373N127109d8.jpg!q70.jpg"));
      bannerList.add(new CommonModel(
          icon: "https://img1.360buyimg.com/da/jfs/t4309/113/2596274814/85129/a59c5f5e/58d4762cN72d7dd75.jpg"));
      bannerList.add(new CommonModel(
          icon: "https://m.360buyimg.com/mobilecms/s720x322_jfs/t4675/88/704144946/137165/bbbe8a4e/58d3a160N621fc59c.jpg!q70.jpg"));
      bannerList.add(new CommonModel(
          icon: "https://m.360buyimg.com/mobilecms/s720x322_jfs/t4627/177/812580410/198036/24a79c26/58d4f1e9N5b9fc5ee.jpg!q70.jpg"));
      bannerList.add(new CommonModel(
          icon: "https://m.360buyimg.com/mobilecms/s720x322_jfs/t3097/241/9768114398/78418/47e4335e/58d8a637N6f178fbd.jpg!q70.jpg"));

      menuList = new List<CommonModel>();
      menuList.add(
          new CommonModel(icon: "images/ic_category_0.png", title: "美食"));
      menuList.add(
          new CommonModel(icon: "images/ic_category_1.png", title: "电影"));
      menuList.add(
          new CommonModel(icon: "images/ic_category_2.png", title: "住宿"));
      menuList.add(
          new CommonModel(icon: "images/ic_category_3.png", title: "生活"));
      menuList.add(
          new CommonModel(icon: "images/ic_category_4.png", title: "KTV"));
      menuList.add(
          new CommonModel(icon: "images/ic_category_5.png", title: "旅游"));
      menuList.add(
          new CommonModel(icon: "images/ic_category_6.png", title: "学习"));
      menuList.add(
          new CommonModel(icon: "images/ic_category_7.png", title: "汽车"));
      menuList.add(
          new CommonModel(icon: "images/ic_category_8.png", title: "摄影"));
      menuList.add(
          new CommonModel(icon: "images/ic_category_15.png", title: "全部分类"));

      List<CommonModel> list = new List<CommonModel>();
      for (int i = 0; i < 20; i++) {
        list.add(
            new CommonModel(
                icon: "https://m.360buyimg.com//mobilecms/s276x276_jfs/t3175/148/8125248346/324991/3a60c04b/58bfcea9Ne6a3b000.jpg!q70.jpg",
                title: "快来看妹子了"));
      }

      if (loadMore) {
        gridList.addAll(list);
        _refreshController.loadComplete();
      } else {
        _refreshController.refreshCompleted();
        gridList.clear();
        gridList.addAll(list);
      }
      setState(() {
        _layoutState = LoadState.State_Success;
      });
    });
  }

  ///build AppBar.
  Widget _buildAppBar() {
    return AppBar(
        elevation: 5,
        centerTitle: true,
        title: Text(
            AppConst.picture,
            style: new TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            ))
    );
  }

  //listView列表
  Widget get _listView {
    return
      CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: _banner,
          ),
          SliverPadding(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            sliver: SliverGrid(
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5, //横轴元素个数
              ),
              delegate: new SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  return PicMenuWidget(commonModel: menuList[index]);
                },
                childCount: menuList.length,
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.only(left: 10, right: 10),
            sliver: SliverGrid(
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, //横轴元素个数
                mainAxisSpacing: 5, //垂直子Widget之间间距
                crossAxisSpacing: 5, //水平子Widget之间间距
                childAspectRatio: 0.8, //子Widget宽高比例
              ),
              delegate: new SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  return PictureGridItem(commonModel: gridList[index]);
                },
                childCount: gridList.length,
              ),
            ),
          ),
        ],
      );
  }

  Widget getItemContainer(String item) {
    return Container(
      width: 5.0,
      height: 5.0,
      alignment: Alignment.center,
      child: Text(
        item,
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
      color: Colors.blue,
    );
  }

  /*banner轮播图*/
  Widget get _banner {
    if (bannerList.length > 0) {
      return Container(
        height: 160,
        child: Swiper(
          itemBuilder: (BuildContext context, int index) {
            return CachedImage(
              imageUrl: bannerList[index].icon,
              fit: BoxFit.fill,
            );
          },
          onTap: (index) {

          },
          itemCount: bannerList.length,
          pagination: SwiperPagination(),
          autoplay: true,
        ),
      );
    } else {
      return new Container(height: 0.0, width: 0.0);
    }
  }

}
