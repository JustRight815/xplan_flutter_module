import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebviewPage extends StatefulWidget {
  final String title;
  final String url;

  const WebviewPage({Key key, this.title, this.url}) : super(key: key);

  @override
  State<StatefulWidget> createState() => WebviewPageState();
}

class WebviewPageState extends State<WebviewPage> {
  bool isLoading = true;
  int progress = 0;
  final flutterWebViewPlugin = new FlutterWebviewPlugin();
  Timer _timer;

  @override
  void initState() {
    super.initState();
    flutterWebViewPlugin.onStateChanged.listen((state) {
      if (state.type == WebViewState.finishLoad) {
        //加载完成
        setState(() {
          isLoading = false;
        });
      } else if (state.type == WebViewState.shouldStart) {
        setState(() {
          isLoading = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: widget.url,
      appBar: AppBar(
        elevation: 0.1,
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.white,fontSize: 16),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        bottom: PreferredSize(
          child: _progressBar(),
          preferredSize: Size.fromHeight(2.0),
        ),
      ),
      withZoom: false,
      withLocalStorage: true,
      withJavascript: true,
    );
  }

  Widget _progressBar() {
    timerCancel();
    print(progress);
    return SizedBox(
      height: isLoading ? 2 : 0,
      child: LinearProgressIndicator(
        value: isLoading ? progress / 100 : 1,
        backgroundColor: Color(0xfff3f3f3),
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.green),
      ),
    );
  }

  /// 模拟异步加载
  Future _simulateProgress() async {
    if (_timer == null) {
      _timer = Timer.periodic(Duration(milliseconds: 50), (time) {
        progress++;
        if (progress > 98) {
          _timer.cancel();
          _timer = null;
          return;
        } else {
          setState(() {});
        }
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
  }

  void timerCancel() {
    if (!isLoading) {
      progress = 0;
      if (_timer != null) {
        _timer.cancel();
        _timer = null;
      }
    } else {
      _simulateProgress();
    }
  }

}
