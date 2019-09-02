import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:xplan_flutter/common/net/http_manager.dart';
import 'package:xplan_flutter/common/widget/LoadStateWidget.dart';
import 'package:xplan_flutter/common/widget/SmartRefreshWidget.dart';
import 'package:xplan_flutter/constant/AppConst.dart';
import 'package:xplan_flutter/ui/video/model/VideoBean.dart';
import 'package:xplan_flutter/ui/video/widget/VideoItemWidget.dart';

class VideoPage extends StatefulWidget{
  static const String ROUTER_NAME = '/';
  final String category ="all";

  @override
  State<StatefulWidget> createState() => _VideoPageState();

}

class _VideoPageState extends State<VideoPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  //页面加载状态，默认为加载中
  LoadState _layoutState = LoadState.State_Loading;
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
    return Scaffold(
        appBar: _buildAppBar(),
        body: LoadStateWidget(
          state: _layoutState,
          errorRetry: () {
            setState(() {
              _layoutState = LoadState.State_Loading;
            });
            //错误按钮点击过后进行重新加载
            getData("");
          },
          successWidget: Container(
            color: Color(0x0FFFFFFF),
            child: SmartRefreshWidget(
                controller: _refreshController,
                child: ListView.builder(
                    itemCount: _gankItems?.length ?? 0,
                    itemBuilder: (context, index) =>
                        VideoItemWidget(_gankItems[index])
                ),
                onRefresh: _onRefresh,
                onLoading: _onLoading
            ),
          ),
        )
    );
  }

  void getData(String date,{bool loadMore = false}) async {
    String requestUrl = AppConst.API_DAILY + "?date=" + date;
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
            _layoutState = LoadState.State_Success;
          });
        } else {
          _refreshController.refreshCompleted();
          setState(() {
            _gankItems = videoList;
            _layoutState = LoadState.State_Success;
          });
        }

      }else{
        _onRefreshNoData(loadMore);
        if(_gankItems.length <= 0){
          setState(() {
            _layoutState = LoadState.State_Empty;
          });
        }
      }
    },errorCallBack:(errorMsg){
      _onRefreshError(loadMore);
      if(_gankItems.length <= 0){
        setState(() {
          _layoutState = LoadState.State_Error;
        });
      }
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

  ///build AppBar.
  Widget _buildAppBar() {
    return AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
            AppConst.video,
            style: new TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            ))
    );
  }
}
