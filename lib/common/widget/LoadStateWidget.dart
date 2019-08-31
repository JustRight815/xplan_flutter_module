import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

///四种视图状态
enum LoadState {
  State_Success,
  State_Error,
  State_Loading,
  State_Empty,
  State_transparent_Loading
}

///根据不同状态来展示不同的视图
class LoadStateWidget extends StatefulWidget {
  final LoadState state; //页面状态
  final Widget successWidget; //成功视图
  final Function errorRetry; //错误事件处理

  LoadStateWidget(
      {Key key,
      this.state = LoadState.State_Loading, //默认为加载状态
      this.successWidget,
      this.errorRetry})
      : super(key: key);

  @override
  _LoadStateWidgetState createState() => _LoadStateWidgetState();
}

class _LoadStateWidgetState extends State<LoadStateWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      //宽高都充满屏幕剩余空间
      width: double.infinity,
      height: double.infinity,
      child: _buildWidget,
    );
  }

  ///根据不同状态来显示不同的视图
  Widget get _buildWidget {
    switch (widget.state) {
      case LoadState.State_Success:
        return widget.successWidget;
        break;
      case LoadState.State_Error:
        return _errorView;
        break;
      case LoadState.State_Loading:
        return _loadingView;
        break;
      case LoadState.State_Empty:
        return _emptyView;
        break;
      case LoadState.State_transparent_Loading:
        return _loadingView1;
        break;
      default:
        return null;
    }
  }

  ///加载中视图
  Widget get _loadingView {
    return Container(
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CupertinoActivityIndicator(),
          Container(
              padding: EdgeInsets.only(left: 5),
              child: Text(
                '正在加载中',
                style: TextStyle(color: Colors.black, fontSize: 14),
              ))
        ],
      ),
    );
  }

  ///加载中视图
  Widget get _loadingView1 {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(color: Colors.transparent),
      alignment: Alignment.center,
      child: Container(
        height: 80,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Color(0x77000000), borderRadius: BorderRadius.circular(6)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            CupertinoActivityIndicator(),
            Text(
              '正在加载',
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }

  ///错误视图
  Widget get _errorView {
    return InkWell(
      onTap: widget.errorRetry,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'images/stateview_net_error.png',
              height: 80,
              width: 100,
            ),
            Text("加载失败，点击屏幕重新加载"),
          ],
        ),
      ),
    );
  }

  ///数据为空的视图
  Widget get _emptyView {
    return InkWell(
        onTap: widget.errorRetry,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'images/stateview_data_error.png',
                height: 80,
                width: 80,
              ),
              Padding(
                padding: EdgeInsets.only(top: 5),
                child: Text('暂无数据'),
              )
            ],
          ),
        ));
  }
}
