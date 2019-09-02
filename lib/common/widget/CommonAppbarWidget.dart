import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:xplan_flutter/constant/AppConst.dart';

/**
 * 统一的下拉刷新样式
 */
class CommonAppbarWidget extends StatefulWidget implements PreferredSizeWidget{
  String title;

  CommonAppbarWidget({
    Key key,
    @required this.title,
  }) : super(key: key);

  @override
  _CommonAppbarWidgetState createState() => _CommonAppbarWidgetState();

  @override
  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}

class _CommonAppbarWidgetState extends State<CommonAppbarWidget> {
  @override
  Widget build(BuildContext context) {
    return new Container(
      color: AppConst.COLOR_APPBAR_BG,
      child: new Align(
        child: Text(
          widget.title,
          style: TextStyle(fontSize: 18.0,color: Colors.white),
        ),
      ),
    );
  }
}
