import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_packages_audio_analysis_method_channel.dart';

abstract class FlutterPackagesAudioAnalysisPlatform extends PlatformInterface {
  /// Constructs a FlutterPackagesAudioAnalysisPlatform.
  FlutterPackagesAudioAnalysisPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterPackagesAudioAnalysisPlatform _instance =
      MethodChannelFlutterPackagesAudioAnalysis();

  /// The default instance of [FlutterPackagesAudioAnalysisPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterPackagesAudioAnalysis].
  static FlutterPackagesAudioAnalysisPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterPackagesAudioAnalysisPlatform] when
  /// they register themselves.
  static set instance(FlutterPackagesAudioAnalysisPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<int?> addTwoNumbers(int a, int b) {
    throw UnimplementedError('addTwoNumbers() has not been implemented.');
  }

  Future<double?> estimateHeartRate(List<int> ringbufferData, int sampleRate) {
    throw UnimplementedError('addTwoNumbers() has not been implemented.');
  }

  Future<double?> estimateAudioQuality(
      List<int> ringbufferData, String filePath, int sampleRate) {
    throw UnimplementedError('addTwoNumbers() has not been implemented.');
  }
}
