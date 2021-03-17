//
//  segmentTrainController.swift
//  ispeak
//
//  Created by mac on 2020/10/3.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit
import SnapKit
import AVFoundation
import Speech

class segmentTrainController: UIViewController {

  @IBOutlet weak var scrollView: UIScrollView!
    
//    语音识别相关的控制
    var SpeechText: String = ""
    fileprivate var recordRequest: SFSpeechAudioBufferRecognitionRequest?
    fileprivate var recordTask: SFSpeechRecognitionTask?
    fileprivate let audioEngine = AVAudioEngine()
    fileprivate lazy var recognizer: SFSpeechRecognizer = {//
        let recognize = SFSpeechRecognizer(locale: Locale(identifier: "zh-CN"))
        recognize?.delegate = self
        return recognize!
    }()
    
//    训练句子
  var sentences: [String] = []
//    当前视图的高度
    var current_height: CGFloat = 80
//    每个视图的高度
    var ViewHeight: CGFloat = 60
//    展开之后的那个视图的高度
    var extentHeight: CGFloat = 150
//    所有组件的view数组
    var list_of_view: [UIView] = []
//    视图之间的间距
    let spacing: CGFloat = 30
//    视图数量
    var viewnumber: Int = 0
//    所有视图的frame
    var list_of_frame: [CGRect] = []
//    当前显示的突出视图
    var current_show: UIView?
//    文字
    let text = UILabel()
//    听的按钮的背景
    let listen_button_back = UIImageView()
//    听的按钮
    let listen_button = UIButton()
//    说的按钮背景
    let speak_button_back = UIImageView()
//    说的按钮
    let speak_button = UIButton()
//    表情
    let face = UIImageView()
//    判断是否在录音
    var is_speaking: Bool = false
//    目前选中的对象编号
    var focused: Int?
//  扩展的大小
    let new_extend:CGFloat = 30
//    水波纹
    var waterwave = UIImageView()
//    富文本
    var mutableString: NSMutableAttributedString?
//    当前扫描到的字数
    var scaned: Int? = 0
//    定时控制
    var timer: Timer?
//    音频分析
    var audioProc: audioProcessing?
//    音频播放
    var audioPlayer: audioPlay?
//    是否正在播放录音
    var islistening: Bool = false
//    单次记录到的说话时长
    var length: Int = 0
//    记录说话时长的定时器
    var speaking_timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.isNavigationBarHidden = false

        
    scrollView.frame=self.view.frame
    scrollView.contentSize=CGSize(width: self.view.frame.width, height: self.view.frame.height*1.1)
//    sentences=["高效辅助治疗口吃","希望能和大家成为朋友，希望能和大家成为朋友","别让开口成为一种恐惧","今天的天气很好，是一个做水果蛋糕的好日子","口吃者应该这样学发音","我我我我我我我我是是是是是喵喵喵喵喵喵喵喵喵喵喵喵喵喵喵喵喵喵喵喵"]
    for sentence in sentences{
      addSentence(content: sentence)
    }
    self.view.layoutIfNeeded()
    current_show = UIView()
    current_show?.frame.size = CGSize(width: 374, height: extentHeight)

    let image = UIImageView.init(frame: CGRect(x: -30, y: -30, width: current_show!.frame.width + 60, height: current_show!.frame.height + 60))
    image.image = UIImage(named: "组 1266")
    image.contentMode = .scaleToFill
    image.tag = 1
    current_show?.addSubview(image)
        
        text.text = ""
        text.font = UIFont.systemFont(ofSize: 23)
        text.textAlignment = .center
        text.tag = 2
        current_show?.addSubview(text)
        text.snp.makeConstraints({
            (maker) in
            maker.leading.equalToSuperview().offset(25)
            maker.trailing.equalToSuperview().offset(-25)
            maker.top.equalToSuperview().offset(20)
        })
        
        listen_button_back.image = UIImage(named: "椭圆 307")
        listen_button_back.contentMode = .scaleToFill
        current_show?.addSubview(listen_button_back)
        listen_button_back.snp.makeConstraints({
            (maker) in
            maker.leading.equalToSuperview().offset(31)
            maker.bottom.equalToSuperview().offset(-29)
            maker.width.equalTo(40)
            maker.height.equalTo(40)
        })
        
//        listen_button.frame.size = CGSize(width: 21, height: 23)
        listen_button.setImage(UIImage(named: "多边形 12"), for: .normal)
        current_show?.addSubview(listen_button)
        listen_button.snp.makeConstraints({
            (maker) in
            maker.bottom.equalToSuperview().offset(-37)
            maker.leading.equalToSuperview().offset(44)
            maker.width.equalTo(21)
            maker.height.equalTo(23)
        })
        
        
        speak_button_back.frame.size = CGSize(width: 55, height: 55)
        speak_button_back.image = UIImage(named: "椭圆 437")
        current_show?.addSubview(speak_button_back)
        speak_button_back.snp.makeConstraints({
            (maker) in
            maker.bottom.equalToSuperview().offset(-21)
            maker.leading.equalToSuperview().offset(160)
        })
        
        speak_button.frame.size = CGSize(width: 24, height: 36)
        current_show?.addSubview(speak_button)
        speak_button.setImage(UIImage(named: "路径 5471"), for: .normal)
        speak_button.snp.makeConstraints({
            (maker) in
            maker.bottom.equalToSuperview().offset(-31)
            maker.leading.equalToSuperview().offset(175)
        })
        
        
        face.image = UIImage(named: "表情")
        current_show?.addSubview(face)
        face.snp.makeConstraints({
            (maker) in
            maker.bottom.equalToSuperview().offset(-29)
            maker.leading.equalToSuperview().offset(313)
            maker.width.equalTo(40)
            maker.height.equalTo(40)
        })
        
        waterwave = UIImageView()
        waterwave.frame.size = CGSize(width: (current_show?.frame.width)! + 40, height: 100)
        waterwave.image = UIImage(named: "路径 5475")
        self.current_show?.addSubview(waterwave)
        waterwave.isHidden = true
        waterwave.snp.makeConstraints({
            (maker) in
            maker.bottom.equalToSuperview().offset(-30)
            maker.leading.equalToSuperview().offset(-10)
        })
        
        current_show?.center = CGPoint(x: self.view.frame.width / 2, y: -150)
        
//        添加事件处理
        speak_button.addTarget(self, action: #selector(start_speak), for: .touchUpInside)
        
        
        //        为屏幕添加左滑动事件
                let gesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(backToPrevious(sender:)))
                        gesture.edges = .left
                self.view.addGestureRecognizer(gesture)
  }
    
//    回到上一个页面
    @objc func backToPrevious(sender: UIScreenEdgePanGestureRecognizer){
        if sender.state == .ended{
            self.navigationController?.popViewController(animated: true);
        }
    }
    
//    开始说话的点击事件
    @objc func start_speak(){
        if is_speaking{
//            正在录音跳转到录音结束状态
            listen_button.isHidden = false
            listen_button_back.isHidden = false
            speak_button.isHidden = false
            speak_button_back.isHidden = false
            face.isHidden = false
            self.spread(tag: self.focused!,flag: 0)
            waterwave.isHidden = true
//            结束说话检测
            self.stopRecognize()
//            停止录音
            audioProc?.stopRecording()
            self.audioProc = nil
            listen_button_back.image = UIImage(named: "椭圆 439")
            self.listen_button.addTarget(self, action: #selector(listen_button_clicked), for: .touchUpInside)
        }else{
//            跳转到开始录音状态
            listen_button.isHidden = true
            listen_button_back.isHidden = true
            speak_button.isHidden = true
            speak_button_back.isHidden = true
            face.isHidden = true
            //        配置录音设备
                    self.audioProc = audioProcessing.init()
            //        配置音频recoder
                    self.audioPlayer = audioPlay.init(path: get_audio_full_path(path: (self.audioProc?.audio_path)!))
//            开始进行检测
            self.startRecognize()
//            开始语音识别
            audioProc?.startRecording()
//            设置定时器更新字体状态
            self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(0.2), target: self, selector: #selector(speaking_controller), userInfo: nil, repeats: true)
//            扩展面板大小
            self.spread(tag: self.focused!,flag: 1)
//            加上水波纹，说话控制
            waterwave.isHidden = false
            self.mutableString = NSMutableAttributedString(string: sentences[self.focused!], attributes: nil)
        }
        is_speaking = !is_speaking
        print("is_speaking: \(is_speaking)")
    }
    
//      控制说话时候每秒改变状态
    @objc func change_length(){
        self.length += 1
    }
    
//    播放按钮被点击
    @objc func listen_button_clicked(){
        if !islistening{
//            开始播放录音
            listen_button.setImage(UIImage(named: "组 1269"), for: .normal)
            listen_button.snp.remakeConstraints({
                (maker) in
                maker.bottom.equalToSuperview().offset(-37)
                maker.leading.equalToSuperview().offset(41)
                maker.width.equalTo(21)
                maker.height.equalTo(23)
            })
            audioPlayer?.play_audio()
//            采样判断是否结束
            self.speaking_timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(judge_is_ended), userInfo: self, repeats: true)
        }else{
            listen_button.setImage(UIImage(named: "多边形 12"), for: .normal)
            listen_button.snp.remakeConstraints({
                (maker) in
                maker.bottom.equalToSuperview().offset(-37)
                maker.leading.equalToSuperview().offset(44)
                maker.width.equalTo(21)
                maker.height.equalTo(23)
            })
            audioPlayer?.stop_audio()
            
        }
        islistening = !islistening
    }
//    判断播放的录音是否结束了
    @objc func judge_is_ended(){
//        判断播放是否停止
        if self.audioPlayer?.player != nil && (self.audioPlayer?.player?.isPlaying)! == false{
//            改变图片的背景
            listen_button.setImage(UIImage(named: "多边形 12"), for: .normal)
            listen_button.snp.remakeConstraints({
                (maker) in
                maker.bottom.equalToSuperview().offset(-37)
                maker.leading.equalToSuperview().offset(44)
                maker.width.equalTo(21)
                maker.height.equalTo(23)
            })
        }
    }
    
//    控制说话之后的字体颜色变化
    @objc func speaking_controller(){
        self.scaned! += 1
        
            mutableString?.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemOrange], range: NSRange(location: 0, length: self.scaned!))
            if self.scaned == sentences[focused!].count{
                self.timer?.invalidate()
                self.timer = nil
//                定时器跑完之后停止识别和录音
                start_speak()
                mutableString?.removeAttribute(NSAttributedString.Key.foregroundColor, range: NSRange(location: 0, length: self.scaned!))
                mutableString?.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemGray], range: NSRange(location: 0, length: self.scaned!))
                self.scaned = 0
//                录音完毕
            }
            text.attributedText = mutableString
        
    }
//    传入中文字，计算行高
    func line_number(content: String) -> Int{
        if content.count > 0 && content.count <= 13{
            return 1
        }else if content.count > 13 && content.count <= 26{
            return 2
        }else if content.count > 26{
            return 3
        }
        return 0
    }
// 添加按钮
  func addSentence(content: String){
    let lineNum = self.line_number(content: content)
    let offset = CGFloat((lineNum - 1)*25)
    let view = UIView.init(frame: CGRect(x: 20, y: current_height, width: 374, height: ViewHeight + offset))
    current_height += ViewHeight + offset + spacing
    view.backgroundColor = ZHFColor.zhf_color(withRed: 237, green: 236, blue: 236)
    view.layer.cornerRadius = 20
    view.layer.masksToBounds = true
    
    let label = UILabel()
    label.text = content
    label.textAlignment = .center
    label.textColor = UIColor.systemGray
    label.numberOfLines = lineNum
    label.lineBreakMode = .byTruncatingTail
    label.font = UIFont.systemFont(ofSize: 21)
    view.tag = viewnumber
    viewnumber += 1
    label.center = view.center
    view.addSubview(label)
    label.snp.makeConstraints({
        (maker) in
        maker.center.equalToSuperview()
        maker.leading.lessThanOrEqualToSuperview().offset(30)
        maker.trailing.lessThanOrEqualToSuperview().offset(-30)
    })
    self.list_of_view.append(view)
    self.scrollView.addSubview(view)
    let gesture = UITapGestureRecognizer(target: self, action: #selector(on_tap(tap:)))
    view.addGestureRecognizer(gesture)

    self.list_of_frame.append(view.frame)
    
  }
//    响应点击事件
    @objc func on_tap(tap: UITapGestureRecognizer){
        let view = (tap.view)!
        let tag = view.tag
        self.focused = tag
        UIView.animate(withDuration: 0.5, animations: { [self] in
            for i in 0..<self.viewnumber{
                let current = self.list_of_view[i]
                let frame = self.list_of_frame[i]
                current.frame = frame
                current.layer.cornerRadius = 20
                current.isHidden = false
            }
            let frame = self.list_of_frame[tag]
            let offset = CGFloat((line_number(content: sentences[tag]) - 1) * 25)
            let new_frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: self.extentHeight + offset)
//            view.removeFromSuperview()
            view.isHidden = true
            self.current_show?.frame = new_frame
//           卡片发生移动的时候设置状态初始化
            listen_button_back.image = UIImage(named: "椭圆 307")
            self.length = 0
            self.listen_button.setImage(UIImage(named: "多边形 12"), for: .normal)
            let label = self.current_show?.viewWithTag(2) as! UILabel
            label.numberOfLines = line_number(content: sentences[tag])
            label.text = sentences[tag]
            self.current_show?.viewWithTag(1)?.frame = CGRect(x: -30, y: -30, width: new_frame.width + 60, height: new_frame.height + 60)
            self.scrollView.addSubview(self.current_show!)

            

            if tag <= (self.viewnumber - 1){
                for i in tag..<self.viewnumber{
                    let current = self.list_of_view[i]
                    let frame = self.list_of_frame[i]
                    current.frame = CGRect(x: frame.minX, y: frame.minY + self.extentHeight - self.ViewHeight, width: frame.width, height: frame.height)
                    current.layer.cornerRadius = 20
                }
            }
        })
    }
    
    func spread(tag: Int,flag: Int){
        let view = list_of_view[tag]
        UIView.animate(withDuration: 0.5, animations: { [self] in
            for i in 0..<self.viewnumber{
                let current = self.list_of_view[i]
                let frame = self.list_of_frame[i]
                current.frame = frame
                current.layer.cornerRadius = 20
                current.isHidden = false
            }
            let frame = self.list_of_frame[tag]
            let offset = CGFloat((line_number(content: sentences[tag]) - 1) * 25)
            let new_frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: self.extentHeight + CGFloat(flag) * self.new_extend + offset)
            view.isHidden = true
            self.current_show?.frame = new_frame
            let label = self.current_show?.viewWithTag(2) as! UILabel
            label.numberOfLines = line_number(content: sentences[tag])
            label.text = sentences[tag]
            self.current_show?.viewWithTag(1)?.frame = CGRect(x: -30, y: -30, width: new_frame.width + 60, height: new_frame.height + 60)
            self.scrollView.addSubview(self.current_show!)

            

            if tag <= (self.viewnumber - 1){
                for i in tag..<self.viewnumber{
                    let current = self.list_of_view[i]
                    let frame = self.list_of_frame[i]
                    current.frame = CGRect(x: frame.minX, y: frame.minY + self.extentHeight + CGFloat(flag) * self.new_extend - self.ViewHeight, width: frame.width, height: frame.height)
                    current.layer.cornerRadius = 20
                }
            }
        })
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
}

//控制声音的检测
extension segmentTrainController{
    //开始识别
    fileprivate func startRecognize(){
        //1. 停止当前任务
        stopRecognize()
        
//        //2. 创建音频会话
//        audioProc = audioProcessing.init()
        
        //3. 创建识别请求
        recordRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine.inputNode
        
        //开始识别获取文字。回调函数对结果以及错误进行处理
        recordTask = recognizer.recognitionTask(with: recordRequest!, resultHandler: { (result, error) in
            if result != nil {
                var text = ""
//最好的转写结果转化成字符串
                text = result?.bestTranscription.formattedString ?? ""
                self.SpeechText = text
                print("检测："+self.SpeechText)
                
                if error != nil || result!.isFinal{
                    self.audioEngine.stop()
                    inputNode.removeTap(onBus: 0)
                    self.recordRequest = nil
                    self.recordTask = nil
                }
            }
        })
        let recordFormat = inputNode.outputFormat(forBus: 0)
//        将听写的结果保存到记录中
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordFormat, block: { (buffer, time) in
            self.recordRequest?.append(buffer)
        })
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            print("无法开启语音识别功能")
        }
    }
    
    //停止识别
    fileprivate func stopRecognize(){
        if recordTask != nil{
            recordTask?.cancel()
            recordTask = nil
        }
        removeTask()
    }
    
    //销毁录音任务
    fileprivate func removeTask(){
        self.audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        self.recordRequest = nil
        self.recordTask = nil
    }
    
    ///语音识别权限认证
    fileprivate func addSpeechRecordLimit(){
        SFSpeechRecognizer.requestAuthorization { (state) in
            var isEnable = false
            switch state {
            case .authorized:
                isEnable = true
                print("已授权语音识别")
            case .notDetermined:
                isEnable = false
                print("没有授权语音识别")
            case .denied:
                isEnable = false
                print("用户已拒绝访问语音识别")
            case .restricted:
                isEnable = false
                print("不能在该设备上进行语音识别")
            }
            DispatchQueue.main.async {
//                self.recordBtn.isEnabled = isEnable
//                self.recordBtn.backgroundColor = isEnable ? UIColor(red: 255/255.0, green: 64/255.0, blue: 64/255.0, alpha: 1) : UIColor.lightGray
            }
        }
    }
}

//MARK:
extension segmentTrainController: SFSpeechRecognizerDelegate{
    //监视语音识别器的可用性
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
//        recordBtn.isEnabled = available
        if available {
            print("available")
        }
    }
}
