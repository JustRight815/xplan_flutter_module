import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:xplan_flutter/model/common_model.dart';
import 'package:xplan_flutter/ui/picture/widget/PictureGridItem.dart';
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
  List<CommonModel> gridList = []; //瀑布流图片列表
  ScrollController _scrollController = ScrollController();

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

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _initData() {
    bannerList = new List<CommonModel>();
    for (int i = 0; i < 5; i++) {
      bannerList.add(new CommonModel(
          icon: "https://m.360buyimg.com/mobilecms/s720x322_jfs/t4903/41/12296166/85214/15205dd6/58d92373N127109d8.jpg!q70.jpg"));
    }
    menuList = new List<CommonModel>();
    menuList.add(new CommonModel(icon: "images/hone_menu_icon_0.png",title: "美食"));
    menuList.add(new CommonModel(icon: "images/hone_menu_icon_0.png",title: "电影"));
    menuList.add(new CommonModel(icon: "images/hone_menu_icon_0.png",title: "酒店"));
    menuList.add(new CommonModel(icon: "images/hone_menu_icon_0.png",title: "酒店"));
    menuList.add(new CommonModel(icon: "images/hone_menu_icon_0.png",title: "酒店"));

    gridList = new List<CommonModel>();
    for (int i = 0; i < 20; i++) {
      gridList.add(
          new CommonModel(icon: "https://m.360buyimg.com//mobilecms/s276x276_jfs/t3175/148/8125248346/324991/3a60c04b/58bfcea9Ne6a3b000.jpg!q70.jpg", title: "快来看妹子了"));
    }
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
            child: Padding(/*local导航*/
              padding: EdgeInsets.fromLTRB(7, 4, 7, 4),
              child: LocalNav(
                localNavList: menuList,
              ),
            ),
          ),
          SliverGrid(
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,//横轴元素个数
              mainAxisSpacing: 5,//垂直子Widget之间间距
              crossAxisSpacing: 5,//水平子Widget之间间距
              childAspectRatio: 0.8,//子Widget宽高比例
            ),
            delegate: new SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return PictureGridItem(commonModel: gridList[index]);
              },
              childCount: gridList.length,
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
//        if (item.article.urls != null && item.article.urls.length > 0) {
////          NavigatorUtil.push(
////              context,
////              WebView(
////                url: item.article.urls[0].h5Url,
////                title: '详情',
////              ));
////        }
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

