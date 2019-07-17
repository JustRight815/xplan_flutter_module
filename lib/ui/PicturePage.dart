import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PicturePage extends StatefulWidget {
  static const String ROUTER_NAME = '/';

  @override
  State<StatefulWidget> createState() => _PicturePageState();
}

class _PicturePageState extends State<PicturePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: new Center(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          //网络缓存
      //网络缓存
      new Container(
          width: 200,
          height: 200,
          child: new CachedNetworkImage(
            imageUrl: "https://img-blog.csdn.net/20160510110020141",
          )
      )
        ],
      ),
    ));
  }
}
