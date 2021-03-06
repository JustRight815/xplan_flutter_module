import 'package:flutter/material.dart';
import 'package:xplan_flutter/common/util/StringUtil.dart';
import 'package:xplan_flutter/ui/video/model/VideoBean.dart';
import 'package:xplan_flutter/common/util/CacheImageUtil.dart';
import '../../webview/WebviewPage.dart';

class VideoItemWidget extends StatefulWidget {
  final ItemList gankItem;

  VideoItemWidget(this.gankItem);

  @override
  _VideoItemWidgetState createState() => _VideoItemWidgetState();
}

class _VideoItemWidgetState extends State<VideoItemWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) =>
//                  SettingPage()
              new WebviewPage(
                  title: widget.gankItem.data.title,
                  url: widget.gankItem.data.webUrl.raw)
        ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            border: Border(
              bottom:
                  BorderSide(width: 0.0, color: Theme.of(context).dividerColor),
            )),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _buildGankListItem(context),
          ),
        ),
      ),
    );
  }

  ///build gank list item.
  List<Widget> _buildGankListItem(BuildContext context) {
    var contentWidgets = <Widget>[
      Expanded(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 8),
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    height: 200,
                      width: MediaQuery.of(context).size.width,
                    child: CacheImageUtil.cachedNetworkImage(widget.gankItem.data.cover.detail)
                  ),
                  Positioned(
                    top: 10.0,
                    width: MediaQuery.of(context).size.width,
                    child:Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text(
                        widget.gankItem.data.title,
                        textAlign: TextAlign.left,
                        style: new TextStyle(
                          color: Colors.white,
                          fontSize: 17.0,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 50,
                    width: 50,
                    child: Image.asset("images/video_play.png"),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 8, bottom: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 1.0),
                        child: SizedBox(
                            child: Text(
                          widget.gankItem.data.title,
                          maxLines: 1,
                          textAlign: TextAlign.left,
                          style: new TextStyle(
                            color: Colors.grey,
                            fontSize: 16.0,
                          ),
                          overflow: TextOverflow.ellipsis,
                        )),
                      )
                    ],
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 1.0, top: 2),
                          child: Text(
                            "视频时长：" + StringUtil.generateTime(widget.gankItem.data.duration),
                            textAlign: TextAlign.left,
                            style: new TextStyle(
                              color: Colors.grey,
                              fontSize: 12.0,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ];
    return contentWidgets;
  }
}
