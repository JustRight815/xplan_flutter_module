import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:xplan_flutter/common/net/http_manager.dart';
import 'package:xplan_flutter/constant/AppConst.dart';
import 'package:xplan_flutter/utils/CacheImageUtil.dart';
import 'package:xplan_flutter/utils/SPUtil.dart';
import '../WebLoadPage.dart';
import 'news.dart';
import 'news_data.dart';
import 'news_response.dart';

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
  MethodChannel methodChannel = const MethodChannel(AppConst.NATIVE_CHANNEL);
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
//    lastTime = SpManager.singleton.getInt("news_" + widget.channelCode);
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
                      if (widget.channelCode == '"video"' ||
                          widget.isVideoPage) {
                        //视频page
                        return buildVideoItem(newsList[index],index);
                      } else {
                        //普通 page
                        return buildItem(newsList[index]);
                      }
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

  //普通条目
  Widget buildItem(News item) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) =>
              new WebviewPage(
                  title: item.title,
                  url: item.article_url)
          ),
        );
      },
      child: Column(
        children: <Widget>[
          classifyChild(item),
          Divider(
            color: Colors.grey,
            height: 1,
            indent: 15,
          ),
        ],
      ),
    );
  }

  Widget classifyChild(News item) {
    if (item.has_video) {
      //有视频
      if (item.video_style == 0) {
        //右侧视频
        if (item.middle_image == null || item.middle_image.url.isEmpty) {
          //纯文字布局(文章、广告)
          //TEXT_NEWS
          return buildTextNews(item);
        }
        //右侧小图布局(1.小图新闻；2.视频类型，右下角显示视频时长)
        //RIGHT_PIC_VIDEO_NEWS
        return buildRightPicVideoNews(item);
      } else if (item.video_style == 2) {
        //居中大图布局(1.单图文章；2.单图广告；3.视频，中间显示播放图标，右侧显示时长)
        //居中视频    CENTER_SINGLE_PIC_NEWS
        return buildCenterSinglePicNews(item);
      }
    } else {
      //非视频新闻
      print('assetion bool ${item.has_image}');
      if (item.has_image == null || !item.has_image) {
        //纯文字新闻
        //TEXT_NEWS
        return buildTextNews(item);
      } else {
        if (item.image_list == null || item.image_list.isEmpty) {
          //图片列表为空，则是右侧图片
          //RIGHT_PIC_VIDEO_NEWS
          return buildRightPicVideoNews(item);
        }

        if (item.gallary_image_count == 3) {
          //图片数为3，则为三图
          //THREE_PICS_NEWS
          return build3PicNews(item);
        }

        //中间大图，右下角显示图数
        //CENTER_SINGLE_PIC_NEWS
        return buildCenterSinglePicNews(item);
      }
    }
    //TEXT_NEWS
    return buildTextNews(item);
  }

  /**
   * 纯文字布局(文章、广告)
   * TEXT_NEWS
   */

  Widget buildTextNews(News item) {
    bool isTop = newsList.indexOf(item) == 0 && widget.channelCode == ""; //属于置顶
    bool isHot = item.hot == 1; //属于热点新闻
    bool isAD = ((item.tag != null && item.tag.isNotEmpty)
        ? item.tag == AppConst.ARTICLE_GENRE_AD
        : false); //属于广告新闻
    bool isMovie = ((item.tag != null && item.tag.isNotEmpty)
        ? item.tag == AppConst.TAG_MOVIE
        : false); //影视
    print(
        "zh ========== buildTextNews ========================================" +
            item.title);
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          //news title
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              '${item.title}',
              maxLines: 2,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
          ),
          //news bottom
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              margin: EdgeInsets.only(top: 10),
              child: Row(
                children: <Widget>[
                  // 标签： 置顶、热、广告、影视
                  buildLittleTag(isTop, isHot, isAD, isMovie),
                  //author
                  Container(
                    margin: EdgeInsets.only(left: 5),
                    child: Text(
                      '${item.source}',
                      style: TextStyle(fontSize: 11),
                    ),
                  ),
                  //评论数
                  Container(
                    margin: EdgeInsets.only(left: 5),
                    child: Text(
                      '${item.comment_count}',
                      style: TextStyle(fontSize: 11),
                    ),
                  ),
                  //时间
                  Container(
                    margin: EdgeInsets.only(left: 5),
                    child: Text(
                      '${DateTime.fromMillisecondsSinceEpoch(item.behot_time)}',
                      style: TextStyle(fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /**
   * 右侧小图布局(1.小图新闻；2.视频类型，右下角显示视频时长)
   * RIGHT_PIC_VIDEO_NEWS
   */
  Widget buildRightPicVideoNews(News item) {
    var screenSize = MediaQuery.of(context).size;

    bool isTop = newsList.indexOf(item) == 0 && widget.channelCode == ""; //属于置顶
    bool isHot = item.hot == 1; //属于热点新闻
    bool isAD = ((item.tag != null && item.tag.isNotEmpty)
        ? item.tag == AppConst.ARTICLE_GENRE_AD
        : false); //属于广告新闻
    bool isMovie = ((item.tag != null && item.tag.isNotEmpty)
        ? item.tag == AppConst.TAG_MOVIE
        : false); //影视
    print(
        "zh ========== buildRightPicVideoNews ========================================" +
            item.title);
    return Container(
      width: screenSize.width,
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          //左侧文字
          Expanded(
            flex: 1,
            child: Column(
              children: <Widget>[
                //标题
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    '${item.title}',
                    maxLines: 2,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
//                Expanded(
//                  flex: 1,
//                ),
                //bottom title
                buildLittleTag(isTop, isHot, isAD, isMovie),
              ],
            ),
          ),
          //右侧图片
          Container(
            width: 130,
            height: 80,
            child: Stack(
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(left: 15),
                    child: CacheImageUtil.cachedNetworkImage(
                        item.middle_image.url)),
                Positioned(
                  right: 5,
                  bottom: 10,
                  child: playBtnDurationWidget(item),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /**
   * 居中大图布局(1.单图文章；2.单图广告；3.视频，中间显示播放图标，右侧显示时长)
   * CENTER_SINGLE_PIC_NEWS
   */
  Widget buildCenterSinglePicNews(News item) {
    var screenSize = MediaQuery.of(context).size;

    bool isTop = newsList.indexOf(item) == 0 && widget.channelCode == ""; //属于置顶
    bool isHot = item.hot == 1; //属于热点新闻
    bool isAD = ((item.tag != null && item.tag.isNotEmpty)
        ? item.tag == AppConst.ARTICLE_GENRE_AD
        : false); //属于广告新闻
    bool isMovie = ((item.tag != null && item.tag.isNotEmpty)
        ? item.tag == AppConst.TAG_MOVIE
        : false); //影视

    print(
        "zh ========== buildCenterSinglePicNews ========================================" +
            item.title);

    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          //标题
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              '${item.title}',
              maxLines: 2,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
          ),

          //content
          Container(
            margin: EdgeInsets.only(top: 10),
            height: 180,
            width: screenSize.width,
            child: Stack(
              children: <Widget>[
                //video large image
                SizedBox(
                    height: 180,
                    width: double.infinity,
                    child: CacheImageUtil.cachedNetworkImage(
                        hasVideoOrGallery(item))),
                //play icon
                playBtnWidget(item),
                //video 时长
                playDurationWidget(item),
              ],
            ),
          ),

          //bottom title
          buildLittleTag(isTop, isHot, isAD, isMovie),
        ],
      ),
    );
  }

  /**
   * 三张图片布局(文章、广告)
   * THREE_PICS_NEWS
   */
  Widget build3PicNews(News item) {
    var screenSize = MediaQuery.of(context).size;

    bool isTop = newsList.indexOf(item) == 0 && widget.channelCode == ""; //属于置顶
    bool isHot = item.hot == 1; //属于热点新闻
    bool isAD = ((item.tag != null && item.tag.isNotEmpty)
        ? item.tag == AppConst.ARTICLE_GENRE_AD
        : false); //属于广告新闻
    bool isMovie = ((item.tag != null && item.tag.isNotEmpty)
        ? item.tag == AppConst.TAG_MOVIE
        : false); //影视
    print(
        "zh ========== build3PicNews ========================================" +
            item.title);
    print(
        "zh ========== build3PicNews ========================================" +
            item.image_list[0].url.toString());
    print(
        "zh ========== build3PicNews ========================================" +
            item.image_list[1].url.toString());
    print(
        "zh ========== build3PicNews ========================================" +
            item.image_list[2].url.toString());
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          //标题
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              '${item.title}',
              maxLines: 2,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
          ),
          //中间图片
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Row(
              children: <Widget>[
                //image 1
                Expanded(
                    flex: 1,
                    child: Container(
                        height: 80,
                        child: CacheImageUtil.cachedNetworkImage(
                            item.image_list[0].url))),
                //image 2
                Expanded(
                  flex: 1,
                  child: Container(
                      height: 80,
                      child: CacheImageUtil.cachedNetworkImage(
                          item.image_list[1].url)),
                ),
                //image 3
                Expanded(
                  flex: 1,
                  child: Container(
                      height: 80,
                      child: CacheImageUtil.cachedNetworkImage(
                          item.image_list[2].url)),
                ),
              ],
            ),
          ),

          //bottom info
          buildLittleTag(isTop, isHot, isAD, isMovie),
        ],
      ),
    );
  }

  Widget buildLittleTag(bool isTop, bool isHot, bool isAD, bool isMovie) {
    if (isTop || isHot || isAD || isMovie) {
      //显示
      if (isTop) {
        Align align = Align(
          alignment: Alignment.bottomLeft,
          child: SizedBox(
              height: 12,
              child: Container(
                color: Colors.pinkAccent,
                child: Text(
                  '置顶',
                  style: TextStyle(fontSize: 9),
                ),
              )),
        );
        return align;
      } else if (isHot) {
        Align align = Align(
            alignment: Alignment.bottomLeft,
            child: SizedBox(
                height: 12,
                child: Container(
                  color: Colors.red,
                  child: Text(
                    '热',
                    style: TextStyle(fontSize: 9),
                  ),
                )));
        return align;
      } else if (isAD) {
        Align align = Align(
          alignment: Alignment.bottomLeft,
          child: SizedBox(
              height: 12,
              child: Container(
                color: Colors.blue,
                child: Text(
                  '广告',
                  style: TextStyle(fontSize: 9),
                ),
              )),
        );

        return align;
      } else if (isMovie) {
        Align align = Align(
          alignment: Alignment.bottomLeft,
          child: SizedBox(
              height: 12,
              child: Container(
                color: Colors.pinkAccent,
                child: Text(
                  '影视',
                  style: TextStyle(fontSize: 9),
                ),
              )),
        );

        return align;
      }
    }
    return SizedBox(
      width: 10,
    );
  }

  Widget playBtnDurationWidget(News item) {
    if (item.has_video) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.all(2),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.play_arrow,
                color: Colors.black,
                size: 8,
              ),
              Container(
                margin: EdgeInsets.only(left: 2),
                child: Text(
                  getMinuteFromMill(item.video_duration),
                  style: TextStyle(fontSize: 8),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return SizedBox(
      width: 0,
      height: 0,
    );
  }

  String getMinuteFromMill(int duration) {
    if (duration == null) {
      return "";
    }
    int minute = (duration / 60).floor();
    int second = duration - (minute * 60);
    return "$minute : $second";
  }

  String hasVideoOrGallery(News item) {
    print(
        "zh ========== hasVideoOrGallery ========================================");
    if (item.has_video) {
      print("zh ========== has_video " +
          item.video_detail_info.detail_video_large_image.url);
      return item.video_detail_info.detail_video_large_image.url;
    } else {
      print("zh ========== hasVideoOrGallery " + item.image_list[0].url);
      return item.image_list[0].url;
    }
  }

  Widget playBtnWidget(News item) {
    if (item.has_video) {
      return Align(
        alignment: Alignment.center,
        child: Icon(
          Icons.play_circle_outline,
          color: Colors.grey,
          size: 60.0,
        ),
      );
    }
    return SizedBox(
      width: 0,
      height: 0,
    );
  }

  Widget playDurationWidget(News item) {
    if (item.has_video) {
      return Align(
        alignment: Alignment.bottomRight,
        child: Container(
          padding: EdgeInsets.all(5),
          color: Colors.black12,
          child: Text(
            getMinuteFromMill(item.video_duration),
            style: TextStyle(fontSize: 8),
          ),
        ),
      );
    }
    return SizedBox(
      width: 0,
      height: 0,
    );
  }

  //视频条目
  Widget buildVideoItem(News item,int index){
    return GestureDetector(
      onTap: (){
        //click
        methodChannel.invokeMethod(
            AppConst.NATIVE_OPEN_PLAY_DETAIL, {
          "playUrl": "",
          "playTitle": item.title,
          "playDescription": "",
          "playPic": item.video_detail_info.detail_video_large_image.url,
          "playId": item.video_detail_info.video_id
        });
      },
      child: Column(
        children: <Widget>[
          Container(
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                    height: 200,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    child: CacheImageUtil.cachedNetworkImage(
                        item.video_detail_info.detail_video_large_image.url)
                ),
                Positioned(
                  top: 6.0,
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    margin: EdgeInsets.only(left: 10,right: 10),
                    child: Text(
                      '${item.title}',
                      style: TextStyle(
                          fontSize: 16, color: Colors.white
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  width: 50,
                  child: Image.asset("images/video_play.png"),
                ),
//                //视频时长
//                Positioned(
//                  right: 20,
//                  bottom: 40,
//                  child: Container(
//                    padding: EdgeInsets.all(5),
//                    color: Colors.black12,
//                    child: Text(
//                      getMinuteFromMill(item.video_duration),
//                      style: TextStyle(fontSize: 8),
//                    ),
//                  ),
//                ),

              ],
            ),
          ),
          //视频出处
          Container(
            padding: EdgeInsets.only(left: 10,right: 10),
            color: Colors.white,
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      height: 30,
                      width: 30,
                      child: ClipOval(
                        child: CacheImageUtil.cachedNetworkImage(
                            item.user_info.avatar_url, width: 30, height: 30),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text(
                        '${item.user_info.name}',
                        style: TextStyle(
                          fontSize:14,color: Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    children: <Widget>[
                      //评论
                      Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.chat_bubble_outline,
                                  color: Colors.black38),
                              Container(
                                margin: EdgeInsets.only(left: 5),
                                child: Text(
                                  "${item.comment_count}",
                                  style: TextStyle(
                                      fontSize: 12,color: Colors.black
                                  ),
                                ),
                              ),
                            ],
                          )
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Divider(
            color: Colors.white,
            height: 5,
            indent: 15,
          ),
        ],
      ),
    );
  }

}
