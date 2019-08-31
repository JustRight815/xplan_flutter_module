import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xplan_flutter/constant/AppConst.dart';
import 'NewsChannelPage.dart';

class NewsPage extends StatefulWidget{
  static const String ROUTER_NAME = '/';

  @override
  State<StatefulWidget> createState() => _NewsPageState();

}

class _NewsPageState extends State<NewsPage> with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin{
  @override
  bool get wantKeepAlive => true;
  Map<String,String> _selectChannels = Map();
  TabController tabController;

  @override
  void initState() {
    super.initState();
    _selectChannels = AppConst.getNewsChannel();
    tabController = TabController(length: _selectChannels.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: PreferredSize(
          preferredSize:Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
          child:SafeArea(
            top: true,
            child: Offstage(),
          ),
        ),
        body: Column(
          children: <Widget>[
            TabBar(
              indicatorColor: Colors.blueAccent,
              controller: tabController,
              isScrollable: true,
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.black,
              labelStyle:TextStyle(color: Colors.blue,fontSize: 16),
              unselectedLabelStyle:TextStyle(color: Colors.black,fontSize: 16),
              tabs: parseTabs(),
            ),
            Expanded(
              flex: 1,
              child: TabBarView(
                controller: tabController,
                children: parsePages(),
              ),
            ),
          ],
        )
    );
  }

  List<Widget> parseTabs(){
    List<Widget> tabs = List();
    _selectChannels.forEach((key,value){
      var tab = Tab(
        text: '$key',
      );
      tabs.add(tab);
    });
    return tabs;
  }

  parsePages(){
    List<MewsChannelPage> pages = List();
    _selectChannels.forEach((key,code){
      var isVideoPage = false;
      if(code == "video"){
        isVideoPage = true;
      }
      var page = MewsChannelPage(channelCode: code,isVideoPage: isVideoPage);
      pages.add(page);
    });
    return pages;
  }

}