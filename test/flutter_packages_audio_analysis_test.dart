import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_packages_audio_analysis/flutter_packages_audio_analysis.dart';
import 'package:flutter_packages_audio_analysis/flutter_packages_audio_analysis_platform_interface.dart';
import 'package:flutter_packages_audio_analysis/flutter_packages_audio_analysis_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterPackagesAudioAnalysisPlatform
    with MockPlatformInterfaceMixin
    implements FlutterPackagesAudioAnalysisPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterPackagesAudioAnalysisPlatform initialPlatform = FlutterPackagesAudioAnalysisPlatform.instance;

  test('$MethodChannelFlutterPackagesAudioAnalysis is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterPackagesAudioAnalysis>());
  });

  test('getPlatformVersion', () async {
    FlutterPackagesAudioAnalysis flutterPackagesAudioAnalysisPlugin = FlutterPackagesAudioAnalysis();
    MockFlutterPackagesAudioAnalysisPlatform fakePlatform = MockFlutterPackagesAudioAnalysisPlatform();
    FlutterPackagesAudioAnalysisPlatform.instance = fakePlatform;

    expect(await flutterPackagesAudioAnalysisPlugin.getPlatformVersion(), '42');
  });
}
