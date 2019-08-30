import 'package:flutter/material.dart';

class AppConst  {
  //开眼每日精选
  static const String API_DAILY = "http://baobab.kaiyanapp.com/api/v4/tabs/selected";
  //头条新闻
  static const String API_NEWS = "http://is.snssdk.com/api/news/feed/v62/";

  static const String picture = '图片';
  static const String video = '视频';
  static const String toutiao = '头条';
  static const String setting = '设置';
  static const String NATIVE_CHANNEL = 'flutter_open_native';
  static const String NATIVE_OPEN_CAPTURE = 'flutter_open_capture';
  static const String NATIVE_OPEN_PLAY_DETAIL = 'flutter_open_play_detail';

  /**
  * 获取默认频道
  */
  static Map<String,String> getNewsChannel(){
    Map<String,String> channel = Map();
    channel["推荐"] = "";
    channel["视频"] = "video";
    channel["热点"] = "news_hot";
    channel["社会"] = "news_society";
    channel["娱乐"] = "news_entertainment";
    channel["科技"] = "news_tech";
    channel["汽车"] = "news_car";
    channel["体育"] = "news_sports";
    channel["财经"] = "news_finance";
    channel["军事"] = "news_military";
    channel["国际"] = "news_world";
    channel["时尚"] = "news_fashion";
    channel["游戏"] = "news_game";
    channel["旅游"] = "news_travel";
    channel["历史"] = "news_history";
    channel["探索"] = "news_discovery";
    channel["美食"] = "news_food";
    channel["育儿"] = "news_baby";
    channel["养生"] = "news_regimen";
    channel["故事"] = "news_story";
    channel["美文"] = "news_essay";
    return channel;
  }

  static final String CHANNEL_CODE = "channelCode";
  static final String IS_VIDEO_LIST = "isVideoList";
  static final String ARTICLE_GENRE_VIDEO = "video";
  static final String  ARTICLE_GENRE_AD = "ad";
  static final String TAG_MOVIE = "video_movie";
  static final String URL_VIDEO = "/video/urls/v/1/toutiao/mp4/%s?r=%s";

  static final Color IMAGE_DEFAULT_BG = const Color(0xFFDDDDDD);
}
