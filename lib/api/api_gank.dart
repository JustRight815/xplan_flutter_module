
class GankApi {

  //开眼每日精选
  static const String DAILY = "http://baobab.kaiyanapp.com/api/v4/tabs/selected";
  //头条新闻
  static const String API_TOU_TIAO = "http://is.snssdk.com/api/news/feed/v62/?refer=1&count=20&loc_mode=4&device_id=34960436458&iid=13136511752";

  /// gank api urls.
  static const String API_GANK_HOST = 'http://gank.io';
  static const String API_SPECIAL_DAY = "$API_GANK_HOST/api/day/";
  static const String API_DATA = "$API_GANK_HOST/api/data/";
  static const String API_SEARCH = "$API_GANK_HOST/api/search/query";
  static const String API_TODAY = "$API_GANK_HOST/api/today";
  static const String API_HISTORY = "$API_GANK_HOST/api/day/history";
  static const String API_HISTORY_CONTENT =
      "$API_GANK_HOST/api/history/content";
  static const String API_SUBMIT = "$API_GANK_HOST/api/add2gank";
  static const String CHECK_UPDATE = "$API_GANK_HOST/api/checkversion";

}
