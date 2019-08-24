import 'package:flutter/material.dart';

import '../WebLoadPage.dart';

class SettingPage extends StatefulWidget{
  static const String ROUTER_NAME = '/';

  @override
  State<StatefulWidget> createState() => _SettingPageState();

}

class _SettingPageState extends State<SettingPage>{

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: new ListView(
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
                          placeholder: "images/hone_menu_icon_0.png",
                          image: "images/hone_menu_icon_0.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 4),
                        child: Text(
                          "上传头像",
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                )
            ),
            _commonDivider(),
            new ListTile(
              title: new Text('切换主题'),
              onTap: () =>
              {
              },
            ),
            _commonDivider(),
            new ListTile(
              title: new Text('打开相机'),
              onTap: () =>
              {
              },
            ),
            _commonDivider(),
            new ListTile(
              title: new Text('关于项目'),
              onTap: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) =>
                        new WebviewPage(
                            title: "关于项目",
                            url: "https://github.com/JustRight815/xplan_kotlin")
                    )
                );
              },
            ),
            _commonDivider(),
            new Container(
              child: new ListTile(
                title: new Text("设置"),
              ),
              color: Colors.white,
            ),
            _commonDivider(),
          ],
      )
    );
  }

  Widget _commonDivider() {
    return Divider(height: 1.0, color: Colors.black,);
  }

}