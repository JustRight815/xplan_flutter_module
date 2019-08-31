import 'package:dio/dio.dart';
import 'package:xplan_flutter/common/util/ToastUtil.dart';
/**
 * 网络处理类
 */
class HttpManager {
  static const String GET = "get";
  static const String POST = "post";

  static void get(String url, Function callBack,
      {Map<String, String> params, Function errorCallBack}) async {
    _request(url, callBack,
        method: GET, params: params, errorCallBack: errorCallBack);
  }

  static void post(String url, Function callBack,
      {Map<String, String> params, Function errorCallBack}) async {
    _request(url, callBack,
        method: POST, params: params, errorCallBack: errorCallBack);
  }

  static void _request(String url, Function callBack,
      {String method,
        Map<String, String> params,
        Function errorCallBack}) async {
    print("<net> url :<" + method + ">" + url);

    if (params != null && params.isNotEmpty) {
      print("<net> params :" + params.toString());
    }

    String errorMsg = "";
    int statusCode;

    try {
      Response response;

      BaseOptions options = new BaseOptions(
        headers: {
          'Accept': '*/*',
          'Accept-Encoding': 'gzip, deflate, br',
          'Accept-Language': 'zh-CN,zh;q=0.9',
          'Connection': 'keep-alive',
          'User-Agent':
          'Mozilla/5.0 (Windows NT 6.2; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.87 Safari/537.36',
        },
      );
      Dio dio = new Dio(options);

      if (method == GET) {
        if (params != null && params.isNotEmpty) {
          StringBuffer sb = new StringBuffer("?");
          params.forEach((key, value) {
            sb.write("$key" + "=" + "$value" + "&");
          });
          String paramStr = sb.toString();
          paramStr = paramStr.substring(0, paramStr.length - 1);
          url += paramStr;
        }
        print("<net> GET url ==== " + url.toString());
        response = await dio.get(url);
      } else {
        if (params != null && params.isNotEmpty) {
          response = await dio.post(url, data: params);
        } else {
          response = await dio.post(url);
        }
      }
      print("<net> response data:" + response.toString());
      statusCode = response.statusCode;
      print("<net> response statusCode:" + statusCode.toString());
      if (statusCode < 0) {
        errorMsg = "<net> error code:" + statusCode.toString();
        _handError(errorCallBack, errorMsg);
        return;
      }
      if (callBack != null && statusCode == 200) {
        callBack(response.data);
      }
    } catch (exception) {
      if(exception == null){
        _handError(errorCallBack, "exception == null");
      }else{
        _handError(errorCallBack, exception.toString());
      }
    }
  }

  static void _handError(Function errorCallback, String errorMsg) {
    print("<net> errorMsg :" + errorMsg);
    ToastUtil.shortToast("网络出错了");
    if (errorCallback != null) {
      errorCallback(errorMsg);
    }
  }

}

