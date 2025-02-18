package com.example.flutter_packages_audio_analysis;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import java.util.*;

/** FlutterPackagesAudioAnalysisPlugin */
public class FlutterPackagesAudioAnalysisPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native
  /// Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine
  /// and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "flutter_packages_audio_analysis");
    channel.setMethodCallHandler(this);
    pythonFactory = PythonFactory.getInstance(flutterPluginBinding.getApplicationContext());
  }

  private PythonFactory pythonFactory;

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else if (call.method.equals("addTwoNumbers")) {
      int a = call.argument("a");
      int b = call.argument("b");
      // 使用工厂类调用 Python 的加法函数
      int sum = pythonFactory.addTwoNumbers(a, b);
      result.success(sum); // 将结果返回给 Flutter 端
    } else if (call.method.equals("estimateHeartRate")) {
      List<Integer> ringbufferData = call.argument("ringbufferData");
      Integer sampleRate = call.argument("sampleRate");

      double sum = pythonFactory.estimateHeartRate(ringbufferData.stream().mapToInt(Integer::intValue).toArray(),
          sampleRate);
      result.success(sum); // 将结果返回给 Flutter 端
    } else if (call.method.equals("estimateAudioQuality")) {
      List<Integer> ringbufferData = call.argument("ringbufferData");
      Integer sampleRate = call.argument("sampleRate");

      String filePath = call.argument("filePath");
      double sum = pythonFactory.estimateAudioQuality(ringbufferData.stream().mapToInt(Integer::intValue).toArray(),
          filePath, sampleRate);
      result.success(sum); // 将结果返回给 Flutter 端
    }

    else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}
