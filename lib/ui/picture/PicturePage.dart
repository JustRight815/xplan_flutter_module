import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:xplan_flutter/constant/AppConst.dart';
import 'package:xplan_flutter/model/common_model.dart';
import 'package:xplan_flutter/ui/picture/widget/PictureGridItem.dart';
import 'package:xplan_flutter/widget/cached_image.dart';
import 'package:xplan_flutter/ui/picture/widget/PicMenuWidget.dart';

class PicturePage extends StatefulWidget {
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
  ScrollController _scrollController = ScrollController();

  bool _isLoading = true;
  RefreshController _refreshController;

  @override
  void initState() {
    _refreshController = new RefreshController();
    _initData();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: _buildAppBar(),
        body: Container(
          color: Color(0x0FFFFFFF),
          child: Stack(
            children: <Widget>[
              Offstage(
                offstage: _isLoading,
                child: SmartRefresher(
                    controller: _refreshController,
                    header: new ClassicHeader(
                      failedText: '刷新失败!',
                      completeText: '刷新完成!',
                      releaseText: '释放可以刷新',
                      idleText: '下拉刷新哦!',
                      failedIcon: new Icon(Icons.clear, color: Colors.black),
                      completeIcon: new Icon(Icons.done, color: Colors.black),
                      idleIcon: new Icon(Icons.arrow_downward, color: Colors.black),
                      releaseIcon: new Icon(
                          Icons.arrow_upward, color: Colors.black),
                      refreshingText: '正在刷新...',
                      textStyle: Theme
                          .of(context)
                          .textTheme
                          .body2,
                    ),
                    onRefresh: _onRefresh,
                    onLoading: _onLoading,
                    enablePullUp: true,
                    child: _listView
                ),
              ),
              Offstage(
                offstage: !_isLoading,
                child: Center(
                  child: CupertinoActivityIndicator(),
                ),
              )
            ],
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
        _isLoading = false;
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
          SliverToBoxAdapter(
              child: Container(
                  color: Colors.white,
                  height: 10
              )
          ),
          SliverPadding(
            padding: EdgeInsets.only(top: 0, bottom: 0),
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
          SliverToBoxAdapter(
              child: Container(
                  color: Colors.white,
                  height: 10
              )
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


//        StaggeredGridView.countBuilder(
//          controller: _scrollController,
//          crossAxisCount: 2,
//          itemCount: gridList?.length ?? 0,
//          itemBuilder: (BuildContext context, int index) =>
//              _TravelItem(index: index, item: gridList[index]),
//          staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
//        ),


class _TravelItem extends StatelessWidget {
  final CommonModel item;
  final int index;

  const _TravelItem({Key key, this.item, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
      },
      child: Card(
        child: PhysicalModel(
          color: Colors.transparent,
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.circular(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _itemImage,
              Container(
                padding: EdgeInsets.all(4),
                child: Text(
                  item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ),
              _infoText,
            ],
          ),
        ),
      ),
    );
  }

  Widget get _itemImage {
    return Stack(
      children: <Widget>[
        CachedImage(
          inSizedBox: true,
          imageUrl: item.icon,
        ),
        Positioned(
          bottom: 8,
          left: 8,
          child: Container(
            padding: EdgeInsets.fromLTRB(5, 1, 5, 1),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 3),
                  child: Icon(
                    Icons.location_on,
                    color: Colors.white,
                    size: 12,
                  ),
                ),
                LimitedBox(
                  maxWidth: 130,
                  child: Text(
                    _poiName(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget get _infoText {
    return Container(
      padding: EdgeInsets.fromLTRB(6, 0, 6, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              PhysicalModel(
                color: Colors.transparent,
                clipBehavior: Clip.antiAlias,
                borderRadius: BorderRadius.circular(12),
                child: CachedImage(
                  imageUrl: item.icon,
                  width: 24,
                  height: 24,
                ),
              ),
              Container(
                padding: EdgeInsets.all(5),
                width: 90,
                child: Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12),
                ),
              )
            ],
          ),
          Row(
            children: <Widget>[
              Icon(
                Icons.thumb_up,
                size: 14,
                color: Colors.grey,
              ),
              Padding(
                padding: EdgeInsets.only(left: 3),
                child: Text(
                  item.title,
                  style: TextStyle(fontSize: 10),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  String _poiName() {
    return "未知";
  }
}

