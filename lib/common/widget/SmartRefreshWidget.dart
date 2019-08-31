import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/**
 * 统一的下拉刷新样式
 */
class SmartRefreshWidget extends StatefulWidget {
  RefreshController controller;
  Function onRefresh;
  Function onLoading;
  Widget child;

  SmartRefreshWidget(
      {Key key,
      @required this.controller,
      @required this.child,
      this.onRefresh,
      this.onLoading})
      : super(key: key);

  @override
  _SmartRefreshWidgetState createState() => _SmartRefreshWidgetState();
}

class _SmartRefreshWidgetState extends State<SmartRefreshWidget> {
  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
        controller: widget.controller,
        header: new ClassicHeader(
          failedText: '刷新失败!',
          completeText: '刷新完成!',
          releaseText: '释放可以刷新',
          idleText: '下拉刷新哦!',
          failedIcon: new Icon(Icons.clear, color: Colors.black),
          completeIcon: new Icon(Icons.done, color: Colors.black),
          idleIcon: new Icon(Icons.arrow_downward, color: Colors.black),
          releaseIcon: new Icon(Icons.arrow_upward, color: Colors.black),
          refreshingText: '正在刷新...',
          textStyle: Theme.of(context).textTheme.body2,
        ),
        onRefresh: widget.onRefresh,
        onLoading: widget.onLoading,
        enablePullUp: true,
        child: widget.child
    );
  }
}
