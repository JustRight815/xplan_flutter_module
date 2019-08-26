package com.example.flutter_module.host;

import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import android.content.Intent;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "flutter_open_native";

  @Override
  protected void onCreate(Bundle savedInstanceState) {
      super.onCreate(savedInstanceState);
      GeneratedPluginRegistrant.registerWith(this);
      new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
              new MethodChannel.MethodCallHandler() {
                  @Override
                  public void onMethodCall(MethodCall call, MethodChannel.Result result) {
                      if ("openCapture".equals(call.method)) {
                          //打开新的Activity
                          Intent intent = new Intent();
                          intent.setClassName("com.zh.xplan","com.zh.xplan.ui.zxing.activity.CaptureActivity");
                          startActivity(intent);
                      } else {
                          result.notImplemented();
                      }
                  }
              });
  }
}
