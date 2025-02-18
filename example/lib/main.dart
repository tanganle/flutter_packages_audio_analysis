import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_packages_audio_analysis/flutter_packages_audio_analysis.dart';
import 'dart:io';
import 'dart:developer' as developer;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _flutterPackagesAudioAnalysisPlugin = FlutterPackagesAudioAnalysis();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await _flutterPackagesAudioAnalysisPlugin.getPlatformVersion() ??
              'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  int addRes = 0;
  add() async {
    int a = 8;
    int b = 9;
    addRes =
        await _flutterPackagesAudioAnalysisPlugin.addTwoNumbers(a, b) ?? 100;
    setState(() {});
  }

  add1() async {
    //读取/storage/emulated/0/Documents/safe_natal/Patient-haha-SN_GA_00025/Visit-1/725954970804_p1v1_2_angelSoundsDevice_725955334363.wav的文件
    await readFile(
        '/storage/emulated/0/Documents/safe_natal/Patient-haha-SN_GA_00025/Visit-1/726044491513_p1v1_1_angelSoundsDevice_726044567767.wav');
  }

  List<int> bufferToInt16(Uint8List buffer) {
    // 创建一个 Int 数组，长度为 buffer 的一半，因为每两个字节构成一个 Int16
    List<int> int16Buffer = List<int>.filled(buffer.length ~/ 2, 0);

    for (int i = 0; i < int16Buffer.length; i++) {
      // 组合两个字节（小端序），使用 & 0xFF 确保字节被当作无符号处理
      int firstByte = buffer[2 * i] & 0xFF;
      int secondByte = buffer[2 * i + 1] & 0xFF;

      // 将第二个字节左移 8 位并加上第一个字节，组成 16 位的 Int
      int16Buffer[i] = (secondByte << 8) | firstByte;

      // 如果需要将其转换为带符号的 Int16，可以先转换为 Short 类型，然后再转换为 Int
      int16Buffer[i] = ((secondByte << 8) | firstByte).toSigned(16);
    }

    return int16Buffer;
  }

  Future<void> readFile(String filePath) async {
    try {
      var raf = File(filePath).openSync(mode: FileMode.read);
      var length = raf.lengthSync();
      Uint8List contents = raf.readSync(length);
      // developer.log('文件内容: ${contents}');

      List<int> contentsList = bufferToInt16(contents);
      // 每640长度分割数组,形成一个二维数组
      List<List<int>> subArrays = [];
      int bufLength = 180000;
      for (var i = 0; i < contentsList.length; i += bufLength) {
        if (i + bufLength > contentsList.length) {
          subArrays.add(contentsList.sublist(i));
        } else {
          subArrays.add(contentsList.sublist(i, i + bufLength));
        }
      }
      int i = 0;
      // print("为0的值个数:${subArrays[17]}");

      while (i < subArrays.length) {
        // print("i:$i   ,length : ${subArrays.length}");
        List<int> list = subArrays[i];
        // 如果list内容全部为0，则跳过
        // if (list.every((value) => value == 0)) {
        if (list.every((value) => value == 0)) {
          i++;
          continue;
        }
        double? res = await _flutterPackagesAudioAnalysisPlugin
            .estimateHeartRate(list, 48000);
        print("res:$res");

        double? res1 = await _flutterPackagesAudioAnalysisPlugin
            .estimateAudioQuality(list, filePath, 4000);
        print("res1:$res1");

        i++;
      }
    } catch (e) {
      print('读取文件时出错: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Running on: $_platformVersion\n'),
              ElevatedButton(onPressed: add, child: Text('Add')),
              Text("相加结果:${addRes}"),
              ElevatedButton(onPressed: add1, child: Text('Add1')),
            ],
          ),
        ),
      ),
    );
  }
}
