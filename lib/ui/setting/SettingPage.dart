import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xplan_flutter/constant/AppStrings.dart';

import '../WebLoadPage.dart';

class SettingPage extends StatefulWidget{
  static const String ROUTER_NAME = '/';

  @override
  State<StatefulWidget> createState() => _SettingPageState();

}

class _SettingPageState extends State<SettingPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  bool _isLoading = true;
  MethodChannel methodChannel = const MethodChannel(AppConst.NATIVE_CHANNEL);

  @override
  void initState() {
    _isLoading = false;
//    _initData();
    super.initState();
  }

  void _initData() {
    Future.delayed(Duration(milliseconds: 200)).then((_) {
      setState(() {
        _isLoading = false;
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
                child: new ListView(
                  children: <Widget>[
                    new Container(
                        height: 160,
                        child: new Center(
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new ClipOval(
                                child: FadeInImage.assetNetwork(
                                  width: 70,
                                  height: 70,
                                  placeholder: "images/setting_ic_head_default.png",
                                  image: "images/hone_menu_icon_0.png",
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 4),
                                child: Text(
                                  "上传头像",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black87),
                                ),
                              ),
                            ],
                          ),
                        )
                    ),
                    _commonDivider(),
                    getItem("关于项目", () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  WebviewPage(
                                      title: "关于项目",
                                      url: "https://github.com/JustRight815/xplan_kotlin")
                          )
                      );
                    }),
                    _commonDivider(),
                    getItem("切换主题", () {}),
                    _commonDivider(),
                    getItem("扫一扫", () {
                      methodChannel.invokeMethod(
                          AppConst.NATIVE_OPEN_CAPTURE);
                    }),
                    _commonDivider(),
                    getItem("设置", () {}),
                    _commonDivider(),
                  ],
                )
            ),
            Offstage(
              offstage: !_isLoading,
              child: Center(
                child: CupertinoActivityIndicator(),
              ),
            )
          ],
        )
    );
  }

  Widget _commonDivider() {
    return Divider(height: 1.0);
  }

  Widget getItem(String title, Function tap) {
    return new ListTile(
      title: new Text(title),
      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: () {
        tap();
      },
    );
  }

  Widget getIconImage(path) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
      child: Image.asset(path,
          width: 30, height: 30),
    );
  }

  Widget getItem1(String title, Function tap) {
    return InkWell( //添加水波纹
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
        child: Row(
          children: <Widget>[
            getIconImage("images/hone_menu_icon_0.png"),
            Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 16.0),
                )),
            Icon(Icons.keyboard_arrow_right)
          ],
        ),
      ),
      onTap: () {
        tap();
      },
    );
  }

}