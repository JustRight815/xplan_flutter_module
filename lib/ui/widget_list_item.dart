import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:xplan_flutter/model/VideoBean.dart';
import 'WebLoadPage.dart';
import 'SettingPage.dart';

class GankListItem extends StatefulWidget {
  final ItemList gankItem;

  GankListItem(this.gankItem);

  @override
  _GankListItemState createState() => _GankListItemState();
}

class _GankListItemState extends State<GankListItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) =>
                  SettingPage()
//              new WebviewPage(
//                  title: widget.gankItem.data.title,
//                  url: widget.gankItem.data.webUrl.raw)
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
                children: <Widget>[
                  Container(
                    height: 200,
                    decoration: new BoxDecoration(
                      shape: BoxShape.rectangle,
                      image: new DecorationImage(
                        fit: BoxFit.cover,
                        image: new CachedNetworkImageProvider(
                            widget.gankItem.data.cover.detail),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 16, left: 8),
                    child: Text(
                      widget.gankItem.data.title,
                      textAlign: TextAlign.left,
                      style: new TextStyle(
                        color: Colors.white,
                        fontSize: 17.0,
                      ),
                    ),
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
                            "视频时长：" + widget.gankItem.data.duration.toString(),
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
