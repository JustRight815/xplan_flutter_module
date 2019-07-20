import 'package:dio/dio.dart';
/**
 * Created by zh
 * Date: 2019-07-20
 */
class StringUtil {

  /**
   * 转换时间显示
   *
   * @param time
   *            毫秒
   * @return
   */
  static String generateTime(int time) {
    int seconds = time % 60;
    int minutes = ((time / 60) % 60).truncate();
    String minutesStr = (minutes).toString().padLeft(2, '0');
    String secondsStr = (seconds).toString().padLeft(2, '0');
    return "$minutesStr:$secondsStr";
  }
}

