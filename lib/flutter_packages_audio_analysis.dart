import 'flutter_packages_audio_analysis_platform_interface.dart';

class FlutterPackagesAudioAnalysis {
  Future<String?> getPlatformVersion() {
    return FlutterPackagesAudioAnalysisPlatform.instance.getPlatformVersion();
  }

  Future<int?> addTwoNumbers(int a, int b) {
    return FlutterPackagesAudioAnalysisPlatform.instance.addTwoNumbers(a, b);
  }

  Future<double?> estimateHeartRate(List<int> ringbufferData, int sampleRate) {
    return FlutterPackagesAudioAnalysisPlatform.instance
        .estimateHeartRate(ringbufferData, sampleRate);
  }

  Future<double?> estimateAudioQuality(
      List<int> ringbufferData, String filePath, int sampleRate) {
    return FlutterPackagesAudioAnalysisPlatform.instance
        .estimateAudioQuality(ringbufferData, filePath, sampleRate);
  }
}
