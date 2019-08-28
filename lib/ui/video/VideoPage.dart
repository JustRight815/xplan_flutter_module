import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:xplan_flutter/api/api_gank.dart';
import 'package:xplan_flutter/common/net/http_manager.dart';
import 'package:xplan_flutter/model/VideoBean.dart';
import 'package:xplan_flutter/ui/widget_list_item.dart';

class VideoPage extends StatefulWidget{
  static const String ROUTER_NAME = '/';
  final String category ="all";

  @override
  State<StatefulWidget> createState() => _VideoPageState();

}

class _VideoPageState extends State<VideoPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  bool _isLoading = true;
  List<ItemList> _gankItems = new List();
  String mDate = "";
  RefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    _refreshController = new RefreshController();
    getData("");
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      color: Colors.white,
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
                releaseIcon: new Icon(Icons.arrow_upward, color: Colors.black),
                refreshingText: '正在刷新...',
                textStyle: Theme.of(context).textTheme.body2,
              ),
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              enablePullUp: true,
              child: ListView.builder(
                  itemCount: _gankItems?.length ?? 0,
                  itemBuilder: (context, index) =>
                      GankListItem(_gankItems[index])
              ),
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
    );
  }

  void getData(String date,{bool loadMore = false}) async {
    String requestUrl = GankApi.DAILY + "?date=" + date;
    HttpManager.get(requestUrl, (data) {
      if(null != data) {
        print('httpManager=====>response ' + data.toString());
        VideoBean home = VideoBean.fromJson(data);
        List<ItemList> gankItems = home.itemList;
        List<ItemList> videoList = new List();
        if(gankItems!= null ) {
          for (ItemList itemListBean in gankItems) {
            if(itemListBean != null && "video".compareTo(itemListBean.type) == 0){
              videoList.add(itemListBean);
            }
          }
          int end = home.nextPageUrl.lastIndexOf("&num");
          int start = home.nextPageUrl.lastIndexOf("date=");
          mDate = home.nextPageUrl.substring(start + 5, end);
        }
        print('httpManager=====>_gankItems length ' + gankItems.length.toString());
        if (loadMore) {
          print('httpManager=====>loadMore');
          _refreshController.loadComplete();
          setState(() {
            _gankItems.addAll(videoList);
            _isLoading = false;
          });
        } else {
          _refreshController.refreshCompleted();
          setState(() {
            _gankItems = videoList;
            _isLoading = false;
          });
        }

      }else{
        _onRefreshNoData(loadMore);
      }
    },errorCallBack:(errorMsg){
      _onRefreshError(loadMore);
    });
  }


  void _onRefresh() {
    getData("");
  }

  void _onLoading() {
    getData(mDate,loadMore: true);
  }

  void _onRefreshNoData(bool loadMore) {
    if(loadMore){
      _refreshController.loadNoData();
    }else{
      _refreshController.refreshCompleted();
    }
  }

  void _onRefreshError(bool loadMore) {
    if(loadMore){
      _refreshController.loadFailed();
    }else{
      _refreshController.refreshFailed();
    }
  }

}
