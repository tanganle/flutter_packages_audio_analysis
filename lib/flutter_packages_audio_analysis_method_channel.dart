import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_packages_audio_analysis_platform_interface.dart';

/// An implementation of [FlutterPackagesAudioAnalysisPlatform] that uses method channels.
class MethodChannelFlutterPackagesAudioAnalysis
    extends FlutterPackagesAudioAnalysisPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_packages_audio_analysis');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<int> addTwoNumbers(int a, int b) async {
    try {
      final result =
          await methodChannel.invokeMethod('addTwoNumbers', {'a': a, 'b': b});
      return result;
    } on PlatformException catch (e) {
      print("调用 Python 失败: '${e.message}'.");
      return -1;
    }
  }

  @override
  Future<double?> estimateHeartRate(
      List<int> ringbufferData, int sampleRate) async {
    try {
      final result = await methodChannel.invokeMethod('estimateHeartRate',
          {'ringbufferData': ringbufferData, "sampleRate": sampleRate});
      return result;
    } on PlatformException catch (e) {
      print("调用 Python 失败: '${e.message}'.");
      return -1;
    }
  }

  @override
  Future<double?> estimateAudioQuality(
      List<int> ringbufferData, String filePath, int sampleRate) async {
    try {
      final result = await methodChannel.invokeMethod('estimateAudioQuality', {
        'ringbufferData': ringbufferData,
        'filePath': filePath,
        "sampleRate": sampleRate
      });
      return result;
    } on PlatformException catch (e) {
      print(
          "调用 Python 失败:${ringbufferData.length} $filePath $sampleRate '${e.message}'.");
      return -1;
    }
  }
}
