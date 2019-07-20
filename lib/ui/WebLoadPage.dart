import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

///加载网页
class WebviewPage extends StatefulWidget {
  var title = "";
  var url = "";

  @override
  _WebviewPageState createState() => _WebviewPageState();

  WebviewPage({Key key, @required this.title, @required this.url})
      : super(key: key);
}

class _WebviewPageState extends State<WebviewPage> {
  TextEditingController controller = TextEditingController();
  FlutterWebviewPlugin flutterWebviewPlugin = FlutterWebviewPlugin();
  var foregroundWidget = new Container(
    alignment: AlignmentDirectional.center,
    child: CircularProgressIndicator(),
  );

  launchUrl() {
    setState(() {
      widget.url = controller.text;
      flutterWebviewPlugin.reloadUrl(widget.url);
    });
  }

  @override
  void initState() {
    super.initState();
    flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged wvs) {
      if (wvs.type.toString() == 'WebViewState.finishLoad') {
        //web page finishLoad
        setState(() {
          foregroundWidget = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: false,
          controller: controller,
          textInputAction: TextInputAction.go,
          onSubmitted: (url) => launchUrl(),
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: widget.title,
            hintStyle: TextStyle(color: Colors.white),
          ),
        ),
      ),
      url: widget.url,
      withZoom: false,
    );
  }
}
