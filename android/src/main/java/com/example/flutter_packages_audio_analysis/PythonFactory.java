package com.example.flutter_packages_audio_analysis;

import android.content.Context;
import com.chaquo.python.PyObject;
import com.chaquo.python.Python;
import com.chaquo.python.android.AndroidPlatform;

public class PythonFactory {
    private static PythonFactory instance = null; // 静态实例
    private Python pythonInstance; // Python 环境实例
    private PyObject calcModule; // Python 模块
    private PyObject audioModule; // Python 模块
    private PyObject fetalHeartRateFunction; // 心率函数 模块

    // 私有化构造函数，确保外部无法直接实例化
    private PythonFactory(Context context) {
        if (!Python.isStarted()) {
            Python.start(new AndroidPlatform(context)); // 需要传入上下文
            pythonInstance = Python.getInstance(); // 初始化 Python 环境
            calcModule = pythonInstance.getModule("calc"); // 加载 calc.py 模块
            audioModule = pythonInstance.getModule("audio_processing"); // 加载 audio.py 模块
            // FetalHeartRateFunction的值是audio_processing.py中定义的estimate_heart_rate函数名
        }

    }

    // 获取单例工厂实例
    public static synchronized PythonFactory getInstance(Context context) {
        if (instance == null) {
            instance = new PythonFactory(context); // 初始化一次
        }
        return instance;
    }

    // 工厂方法：调用 Python 中的加法函数
    public int addTwoNumbers(int a, int b) {
        PyObject result = calcModule.callAttr("add", a, b); // 调用 Python 中的 add 方法
        return result.toInt(); // 将结果返回为整数
    }

    public static final int CHANNEL_CONFIGURATION_MONO = 2;
    public static final int ENCODING_PCM_16BIT = 2;
    private final static int[] sampleRates = { 48000, 8000 };

    // 解析心率
    public double estimateHeartRate(int[] ringbufferData, int sampleRate) {
        PyObject FHRResult = audioModule.callAttr("estimate_heart_rate", ringbufferData, sampleRate); // 加载
        // estimate_heart_rate
        // 函数
        // 心跳率评估结果
        double FHRRes = Double.parseDouble(FHRResult.toString());
        return FHRRes;
    }

    // 解析音频质量
    public double estimateAudioQuality(int[] ringbufferData, String filePath, int sampleRate) {
        PyObject QCResult = audioModule.callAttr("quality_classification", ringbufferData, sampleRate, filePath);
        // 质量评估结果
        double qcResult = Double.parseDouble(QCResult.toString());
        return qcResult;

    }

    // 调用音频解析函数,入参是文件路径,返回值是对象类型,也可能为空

    // public PyObject processAudio(int[] ringbufferData, String filePath) {

    // // int TIMER_INTERVAL = 120;
    // // int sampleRate = sampleRates[1];

    // // int framePeriod = sampleRate * TIMER_INTERVAL / 1000;

    // // short bSamples = 16;
    // // short nChannels = 1;
    // // byte[] buffer;
    // // buffer = new byte[framePeriod * bSamples / 8 * nChannels];

    // // 用buffer去读取音频数据

    // // FetalHeartRateFunction = audioProcessingObject.get( "estimate_heart_rate"
    // );
    // // // Python function required to estimate FHR
    // // QualityClassiferFunction = audioProcessingObject.get(
    // // "quality_classification" ); // Python Function required to run QC model
    // // resampleFunction = audioProcessingObject.get("signal_resample"); // P
    // PyObject FHRResult = audioModule.callAttr("estimate_heart_rate",
    // ringbufferData, 48000); // 加载
    // // estimate_heart_rate
    // // 函数
    // PyObject QCResult = audioModule.callAttr("quality_classification",
    // ringbufferData, 48000, filePath);

    // // 心跳率评估结果
    // double FHRRes = Double.parseDouble(FHRResult.toString());
    // // 质量评估结果
    // double qcResult = Double.parseDouble(QCResult.toString());

    // }

}
