import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xplan_flutter/constant/AppConst.dart';
import 'package:xplan_flutter/ui/news/model/news.dart';
import 'package:xplan_flutter/utils/CacheImageUtil.dart';
import '../../WebLoadPage.dart';

class NewsItemWidget extends StatelessWidget {
  final News item;
  final bool isVideoPage;
  static MethodChannel methodChannel =
      const MethodChannel(AppConst.NATIVE_CHANNEL);

  const NewsItemWidget({
    Key key,
    @required this.item,
    @required this.isVideoPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _items(context);
  }

  Widget _items(BuildContext context) {
    if (isVideoPage) {
      //视频page
      return buildVideoItem(context, item);
    } else {
      //普通 page
      return buildNewsItem(context, item);
    }
  }

  Widget buildNewsItem(BuildContext context, News item) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) =>
                  new WebviewPage(title: item.title, url: item.article_url)),
        );
      },
      child: Column(
        children: <Widget>[
          classifyChild(context, item),
          Divider(
            color: Colors.grey,
            height: 1,
            indent: 10,
            endIndent: 10,
          ),
        ],
      ),
    );
  }

  Widget classifyChild(BuildContext context, News item) {
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
        return buildRightPicVideoNews(context, item);
      } else if (item.video_style == 2) {
        //居中大图布局(1.单图文章；2.单图广告；3.视频，中间显示播放图标，右侧显示时长)
        //居中视频    CENTER_SINGLE_PIC_NEWS
        return buildCenterSinglePicNews(context, item);
      }
    } else {
      //非视频新闻
      print('assetion bool ${item.has_image}');
      if (item.has_image == null || !item.has_image) {
        //纯文字新闻
        return buildTextNews(item);
      } else {
        if (item.image_list == null || item.image_list.isEmpty) {
          //图片列表为空，则是右侧图片
          return buildRightPicVideoNews(context, item);
        }

        if (item.gallary_image_count == 3) {
          //图片数为3，则为三图
          return build3PicNews(item);
        }

        //中间大图，右下角显示图数
        return buildCenterSinglePicNews(context, item);
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
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          getTitleWidget(item),
          getBottomWidget(item),
        ],
      ),
    );
  }

  Widget getTitleWidget(News item) {
    return Align(
      alignment: Alignment.topLeft,
      child: Text(
        '${item.title}',
        maxLines: 3,
        softWrap: true,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 16, color: Colors.black),
      ),
    );
  }

  Widget getBottomWidget(News item) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.only(top: 10),
        child: Row(

          children: <Widget>[
            getAuthor(item.source),
            getCommentCount(item.comment_count),
            getNewsTime(item.behot_time),
            getNewsTag(item),
          ],
        ),
      ),
    );
  }

  Widget getAuthor(String author) {
    return Text(
      author,
      style: getNewsBottomTextStyle(),
    );
  }

  TextStyle getNewsBottomTextStyle() {
    return TextStyle(fontSize: 11, color: Color(0xFF999999));
  }

  Widget getCommentCount(int commentCount) {
    return Container(
      margin: EdgeInsets.only(left: 5),
      child: Text(
        '$commentCount评论',
        style: getNewsBottomTextStyle(),
      ),
    );
  }

  Widget getNewsTime(int timeSamp) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(left: 5,top: 2),
      child: Text(
        '${formatDate(DateTime.fromMillisecondsSinceEpoch(timeSamp * 1000), [
          yyyy,
          '-',
          mm,
          '-',
          dd
        ])}',
        style: getNewsBottomTextStyle(),
      ),
    );
  }

  /**
   * 右侧小图布局(1.小图新闻；2.视频类型，右下角显示视频时长)
   */
  Widget buildRightPicVideoNews(BuildContext context, News item) {
    var screenSize = MediaQuery.of(context).size;
    return Container(
      width: screenSize.width,
      padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                getTitleWidget(item),
                Padding(padding: EdgeInsets.only(top: 15)),
                getBottomWidget(item),
              ],
            ),
          ),
          Container(
            width: 130,
            height: 80,
            alignment: Alignment.center,
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
  Widget buildCenterSinglePicNews(BuildContext context, News item) {
    var screenSize = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          getTitleWidget(item),
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
          getBottomWidget(item),
        ],
      ),
    );
  }

  /**
   * THREE_PICS_NEWS
   */
  Widget build3PicNews(News item) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          getTitleWidget(item),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Row(
              children: <Widget>[
                get3PicItem(item.image_list[0].url),
                get3PicItem(item.image_list[1].url),
                get3PicItem(item.image_list[2].url),
              ],
            ),
          ),
          getBottomWidget(item),
        ],
      ),
    );
  }

  Widget get3PicItem(String url) {
    return Expanded(
        flex: 1,
        child: Container(
            height: 80, child: CacheImageUtil.cachedNetworkImage(url)));
  }

  Widget getNewsTag(News item) {
    if (item.label != null && item.label.isNotEmpty) {
      return Align(
        child: SizedBox(
            child: Container(
          margin: EdgeInsets.only(left: 6),
          padding: EdgeInsets.only(left: 1.5, right: 1.5),
          decoration: new BoxDecoration(
            border: new Border.all(color: Colors.red, width: 0.8), // 边色与边宽度
            color: Colors.white, // 底色
            borderRadius: new BorderRadius.circular((2.0)), // 圆角度
          ),
          child: Text(
            item.label,
            style: TextStyle(fontSize: 8, color: Colors.red),
          ),
        )),
      );
    }
    return new Container(height: 0.0, width: 0.0);
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
    if (item.has_video) {
      return item.video_detail_info.detail_video_large_image.url;
    } else {
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
  Widget buildVideoItem(BuildContext context, News item) {
    return InkWell(
      onTap: () {
        //click
        methodChannel.invokeMethod(AppConst.NATIVE_OPEN_PLAY_DETAIL, {
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
                    width: MediaQuery.of(context).size.width,
                    child: CacheImageUtil.cachedNetworkImage(
                        item.video_detail_info.detail_video_large_image.url)),
                Positioned(
                  top: 6.0,
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: Text(
                      '${item.title}',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  width: 50,
                  child: Image.asset("images/video_play.png"),
                ),
              ],
            ),
          ),
          //视频出处
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
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
                            item.user_info.avatar_url,
                            width: 30,
                            height: 30),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text(
                        '${item.user_info.name}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
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
                                      fontSize: 12, color: Colors.black),
                                ),
                              ),
                            ],
                          )),
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
