import 'package:xplan_flutter/constant/AppConst.dart';
import 'package:xplan_flutter/widget/cached_image.dart';
import 'package:flutter/material.dart';

class CacheImageUtil{

  static Widget defaultPlaceholder = Container(
    color: AppConst.IMAGE_DEFAULT_BG,
  );

  static Widget defaultErrorWidget = Container(
    color: AppConst.IMAGE_DEFAULT_BG,
  );

  static Widget cachedNetworkImage(String url,{double width,double height}) {
    return CachedImage(
        imageUrl: url,
        width: width,
        height: height,
        placeholder: (context, url) => defaultPlaceholder,
        errorWidget: (context, url, error) => defaultErrorWidget,
        fit: BoxFit.cover);
  }

}