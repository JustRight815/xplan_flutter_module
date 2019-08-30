import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:xplan_flutter/common/net/http_manager.dart';
import 'package:xplan_flutter/constant/AppConst.dart';
import 'package:xplan_flutter/ui/news/widget/NewsItemWidget.dart';
import 'package:xplan_flutter/utils/SPUtil.dart';
import 'model/news.dart';
import 'model/news_data.dart';
import 'model/news_response.dart';

class MewsChannelPage extends StatefulWidget {
  static const String ROUTER_NAME = '/';
  String channelCode = "";
  bool isVideoPage = false;

  MewsChannelPage({@required this.channelCode, this.isVideoPage});

  @override
  State<StatefulWidget> createState() => _MewsChannelPageState();
}

class _MewsChannelPageState extends State<MewsChannelPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  bool _isLoading = true;
  int lastTime;
  int currentTime;
  List<News> newsList = List();

  RefreshController _refreshController;

  @override
  void initState() {
    _refreshController = new RefreshController();
    _initData(true);
    super.initState();
  }

  void _initData(bool isRefresh) {
    Future<int> futureTime = SpManager.singleton.getInt("news_" + widget.channelCode);
    futureTime.then((time) {
      lastTime = time;
      if (lastTime == null) {
        lastTime = DateTime.now().millisecond;
      }
      currentTime = DateTime.now().millisecond;
      String requestUrl = AppConst.API_NEWS;
      Map<String, String> params = new Map();
      params["refer"] = "1";
      params["count"] = "20";
      params["loc_mode"] = "4";
      params["device_id"] = "34960436458";
      params["iid"] = "13136511752";
      params["category"] = widget.channelCode;
      params["min_behot_time"] = lastTime.toString();
      params["last_refresh_sub_entrance_interval"] = currentTime.toString();
      HttpManager.get(
          requestUrl,
              (result) {
            if (null != result) {
              SpManager.singleton.save("news_" + widget.channelCode, lastTime);
              NewsResponse newsResponse = NewsResponse.fromJson(result);
              List<News> list = List();
              for (NewsData item in newsResponse.data) {
                News news = News.fromJson(json.decode(item.content));
                if (news == null ||
                    (news.has_video &&
                        (news.video_detail_info == null ||
                            news.video_detail_info.video_id == null))) {
                  continue;
                }
                if (widget.isVideoPage && !news.has_video) {
                  continue;
                }
                if (news.title.isEmpty) {
                  //由于汽车、体育等频道第一条属于导航的内容，所以如果第一条没有标题，则移除
                  continue;
                }
                if(widget.channelCode == "" && !isRefresh && newsList.length > 0 && news.label == "置顶"){
                  continue;
                }
                list.add(news);
              }
              print('httpManager=====>newsList.length  ' + list.length.toString());
              if (isRefresh) {
                _refreshController.refreshCompleted();
                setState(() {
                  if(widget.channelCode == "" && newsList.length >= 2){
                    newsList.removeAt(0);
                    newsList.removeAt(0);
                  }
                  newsList.insertAll(0,list);
                  _isLoading = false;
                });
              } else {
                _refreshController.loadComplete();
                setState(() {
                  newsList.addAll(list);
                  _isLoading = false;
                });
              }
            } else {
              _onRefreshNoData(!isRefresh);
            }
          },
          params: params,
          errorCallBack: (errorMsg) {
            _onRefreshError(!isRefresh);
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
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
                    idleIcon:
                        new Icon(Icons.arrow_downward, color: Colors.black),
                    releaseIcon:
                        new Icon(Icons.arrow_upward, color: Colors.black),
                    refreshingText: '正在刷新...',
                    textStyle: Theme.of(context).textTheme.body2,
                  ),
                  onRefresh: _onRefresh,
                  onLoading: _onLoading,
                  enablePullUp: true,
                  child: ListView.builder(
                    itemCount: newsList.length,
                    itemBuilder: (context, index) {
                      return NewsItemWidget(item: newsList[index],
                          isVideoPage: (widget.channelCode == "video" ||
                              widget.isVideoPage));
                    },
                  )),
            ),
            Offstage(
              offstage: !_isLoading,
              child: Center(
                child: CupertinoActivityIndicator(),
              ),
            )
          ],
        ));
  }

  void _onRefresh() {
    _initData(true);
  }

  void _onLoading() {
    _initData(false);
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
