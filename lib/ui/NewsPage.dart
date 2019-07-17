import 'package:flutter/material.dart';
import 'package:xplan_flutter/ui/widget_bottom_tabs.dart';

class NewsPage extends StatefulWidget{
  static const String ROUTER_NAME = '/';

  @override
  State<StatefulWidget> createState() => _NewsPageState();

}

class _NewsPageState extends State<NewsPage>{

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
              new Text(
                '我是新闻',
              )
            ],
          ),
        )
    );
  }

}