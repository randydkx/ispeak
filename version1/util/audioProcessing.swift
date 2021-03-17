//
//  audioProcessing.swift
//  version1
//
//  Created by mac on 2020/10/25.
//  Copyright © 2020 NJUST. All rights reserved.
//

import Foundation
import AVFoundation

class audioProcessing{
    var recorder:AVAudioRecorder? //录音器
    var player:AVAudioPlayer? //播放器
    var recorderSeetingsDic:[String : Any]? //录音器设置参数数组
    var volumeTimer:Timer! //定时器线程，循环监测录音的音量大小
//    var aacPath:String? //录音存储路径
    var session: AVAudioSession?//录音会话
//    音频的名称加上扩展名
    var audio_path: String = ""
//    完全路径
    var path: String = ""
    
    init(){
        //初始化录音器
        session = AVAudioSession.sharedInstance()
        
        //设置录音类型
        try! session!.setCategory(AVAudioSession.Category.playAndRecord)
        //设置支持后台
        try! session!.setActive(true)
        //获取Document目录
        
        //初始化字典并添加设置参数
        recorderSeetingsDic =
            [
                AVFormatIDKey: NSNumber(value: kAudioFormatMPEG4AAC),
                AVNumberOfChannelsKey: 2, //录音的声道数，立体声为双声道
                AVEncoderAudioQualityKey : AVAudioQuality.max.rawValue,
                AVEncoderBitRateKey : 320000,
                AVSampleRateKey : 44100.0 //录音器每秒采集的录音样本数
        ]
        self.path = self.getNewFileName()
    }
    
//    开始录音
    func startRecording(){
        
        print("开始录音")
        
        //初始化录音器
        recorder = try! AVAudioRecorder(url: URL(string: path)!,
                                        settings: recorderSeetingsDic!)
        if recorder != nil {
            //开启仪表计数功能
            recorder!.isMeteringEnabled = true
            //准备录音
            recorder!.prepareToRecord()
            //开始录音
            recorder!.record()
            //启动定时器，定时更新录音音量
            volumeTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self,
                                selector: #selector(levelTimer),
                                userInfo: nil, repeats: true)
        }
    }
//   暂停录音状态
    func pauseRecording(){
        print("暂停录音")
        recorder?.pause()
//        暂停定时器
        volumeTimer.invalidate()
    }
    
//    继续录音状态
    func continueRecording(){
        if recorder != nil{
            recorder?.record()
            print("继续录音")
            volumeTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self,selector: #selector(levelTimer),userInfo: nil, repeats: true)
        }
        else {
            print("继续录音失败")
        }
    }
    
//    结束录音状态
    func stopRecording(){
        if recorder != nil{
            recorder?.stop()
            recorder = nil
            volumeTimer.invalidate()
            volumeTimer = nil
            print("结束录音")
        }
        else {
            print("结束录音时候检测到没有recorder")
        }
    }
//   通过uuid创建新的文件名称
    func getNewFileName() -> String{
        let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                         .userDomainMask, true)[0]
        //组合录音文件路径
        let uuid = CFUUIDCreateString(nil, CFUUIDCreate(nil))
//        实际路径
        self.path = docDir + "/\(uuid!).aac"
        
        self.audio_path = "\(uuid!).aac"
        print("新创建的音频文件保存路径：\(uuid!)")
        return self.path
    }
    
    //定时检测录音音量
    @objc func levelTimer(){
        recorder!.updateMeters() // 刷新音量数据
    }
}

class audioPlay{
    var player:AVAudioPlayer?
//    音频在沙盒中的完全路径
    var path: String = ""
    
//   设置音频的位置
    init(path: String) {
        self.path = path
    }
    //    播放录制的声音
        func play_audio() {
            //播放
            do{
//                try AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
                let audioSession = AVAudioSession.sharedInstance()
                try audioSession.setCategory(.playback)
                try audioSession.setActive(true)
            } catch _ {
             
            }
            let sound_url = URL(fileURLWithPath: self.path)
    //        通过路径获取音频
            player = try! AVAudioPlayer(contentsOf: sound_url)
            
            player?.volume = 1
            
            if player == nil {
                print("播放失败")
            }else{
                player?.prepareToPlay()
                player?.play()
                print("开始播放")
            }
        }
    func stop_audio(){
        self.player?.stop()
    }
}
