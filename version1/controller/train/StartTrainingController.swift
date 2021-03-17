
import UIKit
import AVFoundation
import Speech
import CoreData
import ProgressHUD
import CameraBackground
import SweeterSwift

class StartTrainingController: UIViewController,NSFetchedResultsControllerDelegate {

    var SpeechText: String = ""
    fileprivate var recordRequest: SFSpeechAudioBufferRecognitionRequest?
    fileprivate var recordTask: SFSpeechRecognitionTask?
    fileprivate let audioEngine = AVAudioEngine()
    fileprivate lazy var recognizer: SFSpeechRecognizer = {//
        let recognize = SFSpeechRecognizer(locale: Locale(identifier: "zh-CN"))
        recognize?.delegate = self
        return recognize!
    }()
    
    @IBOutlet weak var cameraimg: UIImageView!
    //    录音控制器
    @IBOutlet weak var cameraview: UIImageView!
    var isCameraActive=false
    var audioProc: audioProcessing?
//   录音播放集成控制
    var audio_player: audioPlay?
    
    @IBOutlet weak var trainTitle: UILabel!
    @IBOutlet weak var trainLabel1: UILabel!
    @IBOutlet weak var trainLabel2: UILabel!
    @IBOutlet weak var trainLabel3: UILabel!
    @IBOutlet weak var trainLabel4: UILabel!

    @IBOutlet weak var recoder: UIButton!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var listenButton: UIButton!
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var currentRatioLabel: UILabel!
    
//    不错呦图标以及控制animation的开始位置
    @IBOutlet weak var animationView1: UIImageView!
    let animationView1_start_x: CGFloat = 232
    let animationView1_start_y: CGFloat = 602
//    再坚持会图标以及控制animation的开始位置
    @IBOutlet weak var animationView2: UIImageView!
    let animationView2_start_x: CGFloat = 28
    let animationView2_start_y: CGFloat = 576
//   再接再厉图标以及控制animation的开始位置
    @IBOutlet weak var animationView3: UIImageView!
    let animationView3_start_x: CGFloat = 18
    let animationView3_start_y:CGFloat = 602
    
    @IBOutlet weak var animationView4: UIImageView!
    let animationView4_start_x: CGFloat = 289
    let animationView4_start_y: CGFloat = 719
    
    
    @IBOutlet weak var bottom_time_label: UILabel!
    //    控制animation的定时器
    var timer1: Timer?
    var timer2: Timer?
    var timer3: Timer?
    var timer4: Timer?
    var starTimer: Timer?
    var diamondTimer: Timer?
    
    var time_counter: Timer?
//    底部翻转时间控制器
    var buttom_taggle_timer: Timer?
//    控制定时器是否生效
    var timerEnable: Bool = false
    
    let starSize: CGFloat = 41
    let diamondSize: CGFloat = 35
    
    var starty: CGFloat = 111
    var startx:CGFloat = 137
    var focused: Int = 4
    var current_train_type: String = "家庭成员"
//    状态0代表未正在录音状态，状态1代表结束状态，状态2代表暂停状态
    var buttonStatus: Int = 1
    var listenButtonStatus: Int = 0
    
//    时间线和尾部的点
    var lineView: UIView?
    var lineWidth: CGFloat = 0
    var line_end_dot: UIImageView?
    
//    录音的总时间
    var total_time: Int = 0
    
//    具体的时间标签
    @IBOutlet weak var time_label: UILabel!
    
//    训练次数标签
    @IBOutlet weak var total_train_count_label: UILabel!
//    星星数量
    var num_of_star: Int = 0
//    钻石数量
    var num_of_diamond: Int = 0
//    星星数量标签
    @IBOutlet weak var num_of_star_label: UILabel!
//    钻石数量标签
    @IBOutlet weak var num_of_diamond_label: UILabel!

//    模块数组
    let modules: [module] = [module(),module1,module2,module3,module4,module5,module6,module7,module8,module9,module10,module11,module12]
//    头像背后的圆形背景
    @IBOutlet weak var circle: UIImageView!
//   控制背景是否可变化
    var can_transform: Bool = false
//    控制波浪线是否可以移动
    var can_slide: Bool = false
//    波浪钱构成的数组
    var list_of_wave1: [UIView] = []
    var list_of_wave2: [UIView] = []
    var list_of_wave3: [UIView] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animationView1.isHidden = true
        animationView2.isHidden = true
        animationView3.isHidden = true
        animationView4.isHidden = true
        self.view.frame=CGRect(x:0,y:0,width: 414,height: 896)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        let item1 = UIBarButtonItem(image: UIImage(named: "设")?.reSizeImage(reSize: CGSize(width: 25, height: 25)), style: .plain, target: self, action: #selector(click))
        let item2 = UIBarButtonItem(image: UIImage(named: "返回2")?.reSizeImage(reSize: CGSize(width: 32, height: 32)).withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(backToPrevious))
        self.navigationItem.rightBarButtonItems = [item1]
        self.navigationItem.leftBarButtonItems = [item2]
        self.navigationController?.navigationBar.tintColor=UIColor.gray;
        self.navigationController?.navigationBar.isHidden = false
        
        let touch = UITapGestureRecognizer(target: self, action: #selector(bottomHidden))
        self.view.addGestureRecognizer(touch)
        prepareFoucesed()
        
        let longTap = UILongPressGestureRecognizer(target: self, action: #selector(longTapGesture))
        recoder.setBackgroundImage(UIImage(named: "组 1230"), for: .normal)
        recoder.addGestureRecognizer(longTap)
        recoder.addTarget(self, action: #selector(recoderClicked), for: .touchUpInside)
        
        bottomView.backgroundColor = UIColor.white
        bottomView.layer.masksToBounds = false
        bottomView.layer.shadowColor = UIColor.black.cgColor
        bottomView.layer.shadowOpacity = 0.5
        bottomView.layer.shadowOffset = CGSize(width: 5, height: -5)
        bottomView.layer.cornerRadius = 10
        
        listenButton.addTarget(self, action: #selector(toggle), for: .touchUpInside)
//        添加录音权限
        detailButton.addTarget(self, action: #selector(showDetailButtonClicked), for: .touchUpInside)
        addSpeechRecordLimit()
        
        
//        创建进度条实例
        lineView = UIView.init(frame: CGRect(x: 47, y: 225, width: 5, height: 3))
        lineView?.backgroundColor = UIColor.systemGreen
        let end_x = (lineView?.frame.minX)!+(lineView?.frame.width)!
        let end_y = (lineView?.frame.minY)!+1.5
        lineView?.layer.cornerRadius = 1.5
        line_end_dot = UIImageView(image: UIImage(named: "选中时"))
        let width:CGFloat = 10
        let height:CGFloat = 10
        let dot_x = end_x - width/2
        let dot_y = end_y - height/2
        line_end_dot?.frame = CGRect(x: dot_x, y: dot_y, width: width, height: height)
        self.view.addSubview(lineView!)
        self.view.addSubview(line_end_dot!)
        time_label.text = "00:00"
        
        
//        设置录音
        self.audioProc = audioProcessing.init()
//        设置播放器
        audio_player = audioPlay.init(path: (self.audioProc?.path)!)
        
//        设置星星数量标签和钻石数量标签
        self.num_of_star_label.text = "星星：\(num_of_star)"
        self.num_of_diamond_label.text = "钻石：\(num_of_diamond)"
        
        initial_wave()
        
        let ges=UITapGestureRecognizer(target: self, action: #selector(cameraActive))
        cameraimg.isUserInteractionEnabled=true
        cameraimg.addGestureRecognizer(ges)
        cameraview.isUserInteractionEnabled=true
    }
    @objc func cameraActive(){
//        print("hello")
        if self.isCameraActive==false{
            self.isCameraActive=true
            self.cameraview.image=UIImage()
            self.cameraview.addCameraBackground(showButtons: true,buttonMargins: UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10))
            self.cameraview.layer.masksToBounds=true
            self.cameraview.layer.cornerRadius=self.cameraview.frame.height/2
            self.cameraimg.contentMode = .center
            self.cameraimg.image=UIImage(named: "相机")?.scaleImage(scaleSize: 0.12)
        }
        else{
            self.isCameraActive=false
            self.cameraview.removeCameraBackground()
            self.cameraview.image=UIImage(named: "组 1260")
            self.cameraimg.image=UIImage(named: "组 1262")
//            self.cameraimg.contentMode = .scaleToFill
        }
    }
    func progress_show(content: String){
        ProgressHUD.show(content, interaction: true)
        Timer.scheduledTimer(timeInterval: 0.8, target: self, selector: #selector(end), userInfo: nil, repeats: false)
    }
    @objc func end(){
        ProgressHUD.dismiss()
        bottomout()
    }
//    初始化波浪线控件
    func initial_wave(){
//        设置水波纹
        let wave1 = UIImageView.init(frame: CGRect(x: 0, y: 470 + 70, width: self.view.frame.width*2, height: 100))
        wave1.image = UIImage(named: "曲线1")
        wave1.contentMode = .scaleAspectFit
        self.view.addSubview(wave1)
        self.list_of_wave1.append(wave1)
        for i in 1..<32{
            let last_view = list_of_wave1[i-1]
            let view = UIImageView.init(frame: CGRect(x: last_view.frame.maxX, y: last_view.frame.minY, width: self.view.frame.width*2, height: 100))
            view.image = UIImage(named: "曲线1")
            view.contentMode = .scaleAspectFit
            self.list_of_wave1.append(view)
            self.view.addSubview(view)
        }
        
        let wave2 = UIImageView.init(frame: CGRect(x: -50, y: 470 + 70, width: self.view.frame.width*2, height: 100))
        wave2.image = UIImage(named: "曲线2")
        wave2.contentMode = .scaleAspectFit
        self.view.addSubview(wave2)
        self.list_of_wave2.append(wave2)
        for i in 1..<32{
            let last_view = list_of_wave2[i-1]
            let view = UIImageView.init(frame: CGRect(x: last_view.frame.maxX, y: last_view.frame.minY, width: self.view.frame.width*2, height: 100))
            view.image = UIImage(named: "曲线2")
            view.contentMode = .scaleAspectFit
            self.list_of_wave2.append(view)
            self.view.addSubview(view)
        }
        
        let wave3 = UIImageView.init(frame: CGRect(x: -100, y: 470 + 70, width: self.view.frame.width, height: 100))
        wave3.image = UIImage(named: "曲线3")
        wave3.contentMode = .scaleAspectFit
        self.view.addSubview(wave3)
        self.list_of_wave3.append(wave3)
        for i in 1..<32{
            let last_view = list_of_wave3[i-1]
            let view = UIImageView.init(frame: CGRect(x: last_view.frame.maxX, y: last_view.frame.minY, width: self.view.frame.width*2, height: 100))
            view.image = UIImage(named: "曲线3")
            view.contentMode = .scaleAspectFit
            self.list_of_wave3.append(view)
            self.view.addSubview(view)
        }
        self.can_slide = true
    }
//    波浪线的动画效果
    func wave_animation_on(){
        if self.can_slide{
            let count = CGFloat(self.list_of_wave1.count)
            UIView.animate(withDuration: 360.0, delay: 0, options: .curveEaseOut, animations: {
                for view in self.list_of_wave1{
                    view.frame = CGRect(x: view.frame.minX - count * view.frame.width, y: view.frame.minY, width: view.frame.width, height: view.frame.height)
                }
            }, completion: {
                (finish) in
            })
            
            UIView.animate(withDuration: 240.0, delay: 0, options: .curveEaseOut, animations: {
                for view in self.list_of_wave2{
                    view.frame = CGRect(x: view.frame.minX - count * view.frame.width, y: view.frame.minY, width: view.frame.width, height: view.frame.height)
                }
            }, completion: {
                (finish) in
            })
            
            UIView.animate(withDuration: 260.0, delay: 0, options: .curveEaseOut, animations: {
                for view in self.list_of_wave3{
                    view.frame = CGRect(x: view.frame.minX - count * view.frame.width, y: view.frame.minY, width: view.frame.width, height: view.frame.height)
                }
            }, completion: nil)
        }
    }
    func update_time_label(){
        self.total_time += 1
        var _time: String = ""
        if self.total_time < 60{
            if self.total_time < 10{
                _time = "00:0\(self.total_time)"
            }
            else{
                _time = "00:\(self.total_time)"
            }
        }
        else {
            let min = self.total_time / 60
            let second = self.total_time % 60
            if second < 10{
                _time = "0\(min):0\(second)"
            }
            else{
                _time = "0\(min):\(second)"
            }
        }
        self.time_label.text = _time
        self.bottom_time_label.text = _time
    }
    
//    背景圆形的缩放
    @objc func circle_animation_on(){
        if self.can_transform{
            let transform = circle.transform
            UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseOut, animations: {
                self.circle.transform = transform.scaledBy(x: 1.1, y: 1.1)
            }, completion: {
                (finish) in
                self.circle.transform = transform.scaledBy(x: 1, y: 1)
                self.circle_animation_on()
            })
        }
    }
    
//    每秒移动6像素
    @objc func update_line_and_dot(){
        update_time_label()
        var end_x = (lineView?.frame.minX)!+(lineView?.frame.width)!
        let end_y = (lineView?.frame.minY)!+1.5
        end_x += 6
        var width_of_line = (lineView?.frame.width)!+6
        let width:CGFloat = 10
        let height:CGFloat = 10
        let dot_x = end_x - width/2
        let dot_y = end_y - height/2
        if width_of_line > 414-47*2{
            end_x = 47+5
            width_of_line = 5
        }
//        更新圆点的位置
        line_end_dot?.frame = CGRect(x: dot_x, y: dot_y, width: width, height: height)
//        更新线的长度
        lineView!.frame = CGRect(x:47,y: 225,width: width_of_line,height: 3)
        lineView?.backgroundColor = UIColor.systemGreen
        lineView?.layer.cornerRadius = 1.5
    }
    
//    除去录音时间定时器
    func remove_line_timer(){
        self.time_counter?.invalidate()
        self.time_counter = nil
    }
//    重新启动录音时间定时器
    func start_line_timer(){
        self.time_counter = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(update_line_and_dot), userInfo: nil, repeats: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isToolbarHidden=true
        self.navigationController?.isNavigationBarHidden = false
    }
    func start_View_1_Timer(){
        self.timer1 = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(updateTimer1), userInfo: nil, repeats: false)
    }
    func start_View_2_Timer(){
        self.timer2 = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(updateTimer2), userInfo: nil, repeats: false)
    }
    func start_View_3_Timer(){
        self.timer3 = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(updateTimer3), userInfo: nil, repeats: false)
    }
    func start_View_4_Timer(){
        self.timer4 = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(updateTimer4), userInfo: nil, repeats: false)
    }
//    定时器，控制不错哟图标的animation
    @objc func updateTimer1(){
        self.animationView1.isHidden = false
        let x = self.animationView1_start_x
        let y = self.animationView1_start_y
        let width = self.animationView1.frame.width
        let height = self.animationView1.frame.height
        UIView.animate(withDuration: 2, delay: 0, options: [.transitionFlipFromRight], animations: {
            self.animationView1.frame = CGRect(x: x, y: y-200, width: width, height: height)
        }, completion: {
            (value: Bool) in
            self.animationView1.isHidden = true
            self.animationView1.frame = CGRect(x: x, y: y, width: width, height: height)
            if self.timerEnable {
                self.start_View_2_Timer()
            }
            
        })
    }
//    控制定时器2的animation
    @objc func updateTimer2(){
        self.animationView2.isHidden = false
        let x = self.animationView2_start_x
        let y = self.animationView2_start_y
        let width = self.animationView2.frame.width
        let height = self.animationView2.frame.height
        UIView.animate(withDuration: 2, delay: 0, options: [.transitionFlipFromRight], animations: {
            self.animationView2.frame = CGRect(x: x, y: y-220, width: width, height: height)
        }, completion: {
            (value: Bool) in
            self.animationView2.isHidden = true
            self.animationView2.frame = CGRect(x: x, y: y, width: width, height: height)
            if self.timerEnable {
                self.start_View_3_Timer()
            }
        })
    }
    
    @objc func updateTimer3(){
        self.animationView3.isHidden = false
        let x = self.animationView3_start_x
        let y = self.animationView3_start_y
        let width = self.animationView3.frame.width
        let height = self.animationView3.frame.height
        UIView.animate(withDuration: 2, delay: 0, options: [.transitionFlipFromRight], animations: {
            self.animationView3.frame = CGRect(x: x, y: y-220, width: width, height: height)
        }, completion: {
            (value: Bool) in
            self.animationView3.isHidden = true
            self.animationView3.frame = CGRect(x: x, y: y, width: width, height: height)
            if self.timerEnable {
                self.start_View_4_Timer()
            }
        })
    }
    
    @objc func updateTimer4(){
        self.animationView4.isHidden = false
        let x = self.animationView4_start_x
        let y = self.animationView4_start_y
        let width = self.animationView4.frame.width
        let height = self.animationView4.frame.height
        UIView.animate(withDuration: 2, delay: 0, options: [.transitionFlipFromRight], animations: {
            self.animationView4.frame = CGRect(x: x, y: y-220, width: width, height: height)
        }, completion: {
            (value: Bool) in
            self.animationView4.isHidden = true
            self.animationView4.frame = CGRect(x: x, y: y, width: width, height: height)
            if self.timerEnable {
                self.start_View_1_Timer()
            }
        })
    }
//    随机从制定y位置的地方弹出一颗星星
    @objc func give_a_star(){
        let minx: Int = 0
        let maxx: Int = 414 - 60
        let x = CGFloat((Int(arc4random()) % (maxx - minx)) + minx)
        let y = self.animationView1_start_y
        let starView = UIImageView(frame: CGRect(x: x, y: y, width: starSize, height: starSize))
        starView.image = UIImage(named: "组 1234")
        self.view.addSubview(starView)
        UIView.animate(withDuration: 2.0, animations: {
            starView.frame = CGRect(x: x, y: y-350, width: self.starSize, height: self.starSize)
        }, completion: {_ in
            starView.removeFromSuperview()
            self.update_star_num_text()
        })
    }
    

    @objc func give_a_diamond(){
        let minx: Int = 0
        let maxx: Int = 414 - 60
        let x = CGFloat((Int(arc4random()) % (maxx - minx)) + minx)
        let y = self.animationView1_start_y
        let starView = UIImageView(frame: CGRect(x: x, y: y, width: starSize, height: starSize))
        starView.image = UIImage(named: "组 1235")
        self.view.addSubview(starView)
        UIView.animate(withDuration: 2.5, animations: {
            starView.frame = CGRect(x: x, y: y-250, width: self.starSize, height: self.starSize)
        }, completion: {_ in
            starView.removeFromSuperview()
            self.update_diamond_num_text()
        })
    }
//    更新星星数量标签
    func update_star_num_text(){
        self.num_of_star += 1
        self.num_of_star_label.text = "星星：\(self.num_of_star)"
    }
//    更新钻石数量标签
    func update_diamond_num_text(){
        self.num_of_diamond += 1
        self.num_of_diamond_label.text = "钻石：\(self.num_of_diamond)"
    }
//    开启星星和钻石的定时器
    func start_star_and_diamond_timer(){
        self.starTimer = Timer.scheduledTimer(timeInterval: 2.1, target: self, selector: #selector(give_a_star), userInfo: nil, repeats: true)
        
        self.diamondTimer = Timer.scheduledTimer(timeInterval: 2.6, target: self, selector: #selector(give_a_diamond), userInfo: nil, repeats: true)
    }
//    开启其他小控件的定时器
    func start_all_timer(){
        self.timerEnable = true
        self.start_star_and_diamond_timer()
        self.start_View_1_Timer()
        self.start_line_timer()
    }
    
//    跳转到问题分析的详细页面
    @objc func showDetailButtonClicked(_ sender: UIButton) {
//        更新数据库的信息
       
        
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ratingboard") as! RatingController
        print("传递：\(self.SpeechText)")
        vc.pass = self.SpeechText
        vc.alg = Algorithm(input: self.SpeechText)
        vc.time_label_text = self.time_label.text!
        vc.audio_full_path = (self.audio_player?.path)!
        vc.audio_path = (self.audioProc?.audio_path)!
        vc.total_time = self.total_time
//        设置选中的模块信息，传递到share页面
        vc.focused_item = self.focused
        
        vc.single_train.trainTime = get_current_time()
        vc.single_train.train_length = Int32(self.total_time)

        self.navigationController?.pushViewController(vc, animated: true)
    }
    
//    控制底部按钮的播放和停止状态并且设置按钮的状态和播放控制等
    @objc func toggle(){
//          1->0结束播放
        if listenButtonStatus == 1{
//            改变按钮的背景
            listenButton.setBackgroundImage(UIImage(named: "组 1225"), for: .normal)
//            停止播放
            audio_player?.stop_audio()
            
            self.buttom_taggle_timer?.invalidate()
            self.buttom_taggle_timer = nil
        }else{
//            0->1开始播放录音
            audio_player?.play_audio()
//           改变按钮的图形
            self.buttom_taggle_timer = Timer.scheduledTimer(timeInterval: TimeInterval(self.total_time), target: self, selector: #selector(toggle), userInfo: nil, repeats: false)
            listenButton.setBackgroundImage(UIImage(named: "组 1222"), for: .normal)
        }
        listenButtonStatus = 1-listenButtonStatus
    }
    @objc func  backToPrevious(){
        self.navigationController!.popViewController(animated: true)
    }
    @objc func click(){
        print("click")
    }
//    按钮的三种状态之间的转换
//    开始录音状态
    func startRecordingMode(){
        buttonStatus = 0
        recoder.setBackgroundImage(UIImage(named: "组 1232"), for: .normal)
    }
//    暂停录音状态
    func pauseRecordingMode(){
        buttonStatus = 2
        recoder.setBackgroundImage(UIImage(named: "组 1231"), for: .normal)
    }
//    结束录音状态
    func stopRecordingMode(){
        buttonStatus = 1
        recoder.setBackgroundImage(UIImage(named: "组 1230"), for: .normal)
    }
    
    @objc func recoderClicked(){
        if buttonStatus == 1{
//            结束状态跳转到开始录音状态
            startRecordingMode()
//            开启所有的控件定时器
            start_all_timer()
//            开始进行录音检测
            startRecognize()
//             开始录音
            audioProc?.startRecording()
            self.can_transform = true
            self.circle_animation_on()
            self.wave_animation_on()
        }
        else if buttonStatus == 0{
//            正在录音状态，点击之后跳转到暂停状态
            pauseRecordingMode()
//            关闭所有的定时器
            invalid_all_timer()
//            录音暂停
            audioProc?.pauseRecording()
        }
        else if buttonStatus == 2 {
//            暂停状态跳转到开始录音状态
            startRecordingMode()
//            开启所有的定时器
            start_all_timer()
//            继续录音状态
            audioProc?.continueRecording()
        }
        print("\(buttonStatus)")
    }
    func invalid_all_timer(){
        self.timerEnable = false
        self.timer1?.invalidate()
        self.animationView1.isHidden = true
        self.timer2?.invalidate()
        self.animationView2.isHidden = true
        self.timer3?.invalidate()
        self.animationView3.isHidden = true
        self.timer4?.invalidate()
        self.animationView4.isHidden = true
        
        self.starTimer?.invalidate()
        self.diamondTimer?.invalidate()
        
        self.remove_line_timer()
    }
//    删除所有的波浪线控件
    func remove_all_wave(){
        for view in self.list_of_wave1{
            view.removeFromSuperview()
        }
        for view in self.list_of_wave2{
            view.removeFromSuperview()
        }
        for view in self.list_of_wave3{
            view.removeFromSuperview()
        }
    }
    @objc func longTapGesture(){
        if (buttonStatus == 0) || (buttonStatus == 2){
//            跳转到结束录音状态
            stopRecordingMode()
//            停止语音识别
            stopRecognize()
//            停止定时器
            self.invalid_all_timer()
//            结束录音设备
            self.audioProc?.stopRecording()
            
            let alg = Algorithm(input: self.SpeechText)
            currentRatioLabel.text = "本次口吃率："+alg.Score()
            
//            动画停止
            self.can_transform = false
            
//            移除所有的波浪线控件
            self.remove_all_wave()
            
//            更新训练次数信息
            self.add_user_train_count(phoneNum: (appUser?.phoneNum)!)
            
//      设置训练实体的相关字段
            let trainEntity = TrainEntity()
            trainEntity.audio = (self.audioProc?.audio_path)!
            trainEntity.num_of_stop = Int32(alg.numOfStop)
            trainEntity.num_of_duplicate = Int32(alg.numOfDuplicated)
            trainEntity.ratio = alg.scoreDouble
            trainEntity.problem = alg.problem
            trainEntity.user_phoneNum = (appUser?.phoneNum)!
            trainEntity.trainTime = get_current_time()
            trainEntity.type = self.current_train_type
            trainEntity.train_length = Int32(self.total_time)
            if self.SpeechText != ""{
                trainEntity.content = self.SpeechText
            }

            trainEntity.show()
            
            
            
//        设置总训练次数标签
            self.total_train_count_label.text = "恭喜你，完成第" + String((appUser?.trainCount)!+1)+"次训练"
//            插入一个训练记录
            insert_train_info(train: trainEntity)
//            底部框弹出
            self.progress_show(content: "处理中...")
        }
        else if buttonStatus == 1{}
        print("\(buttonStatus)")
    }
    
//    底部窗口弹出
    func bottomout(){
        self.cameraimg.isHidden = true
//        底部窗口弹出的时候表示一次训练完毕，此时记录数据库信息
        self.update_post_count_info(index: self.focused)
        UIView.animate(withDuration: 0.5, animations: {
            self.bottomView.frame = CGRect(x:0,y:500,width:414,height: 323)
            self.bottomView.layer.opacity = 1
        })
    }
    
    @objc func bottomHidden(){
//        从视图中将原来的组件移除
        self.lineView?.removeFromSuperview()
        self.line_end_dot?.removeFromSuperview()
        self.cameraimg.isHidden = false
//        添加新的组件
        
        lineView = UIView.init(frame: CGRect(x: 47, y: 225, width: 5, height: 3))
        lineView?.backgroundColor = UIColor.systemGreen
        let end_x = (lineView?.frame.minX)!+(lineView?.frame.width)!
        let end_y = (lineView?.frame.minY)!+1.5
        lineView?.layer.cornerRadius = 1.5
        line_end_dot = UIImageView(image: UIImage(named: "选中时"))
        let width:CGFloat = 10
        let height:CGFloat = 10
        let dot_x = end_x - width/2
        let dot_y = end_y - height/2
        line_end_dot?.frame = CGRect(x: dot_x, y: dot_y, width: width, height: height)
        self.view.addSubview(lineView!)
        self.view.addSubview(line_end_dot!)
        time_label.text = "00:00"
        self.total_time = 0
        self.num_of_star = 0
        self.num_of_diamond = 0
        self.num_of_star_label.text = "星星：\(self.num_of_star)"
        self.num_of_diamond_label.text = "钻石：\(self.num_of_diamond)"
        
//        重绘波浪线
        self.initial_wave()
        
        UIView.animate(withDuration: 0.5, animations: {
            self.bottomView.frame = CGRect(x:0,y:900,width:414,height: 323)
        })
    }
    
//    修改界面元素信息
    func prepareFoucesed(){
        trainTitle.text = modules[self.focused].title
        trainLabel1.text = modules[self.focused].word1
        trainLabel2.text = modules[self.focused].word2
        trainLabel3.text = modules[self.focused].word3
        trainLabel4.text = modules[self.focused].word4
        self.current_train_type = modules[self.focused].title
    }
    
//    用户训练总次数增加一个
    func add_user_train_count(phoneNum: String){
        //获取委托
        let app = UIApplication.shared.delegate as! AppDelegate
        //获取数据上下文对象
        let context = getContext()
        //声明数据的请求，声明一个实体结构
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        //查询条件
        fetchRequest.predicate = NSPredicate(format: "phoneNum='\(phoneNum)'", "")
        // 异步请求由两部分组成：普通的request和completion handler
        // 返回结果在finalResult中
        let asyncFecthRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { (result: NSAsynchronousFetchResult!) in
            //对返回的数据做处理。
            let fetchObject  = result.finalResult! as! [User]
            for c in fetchObject{
                c.trainCount += 1
                appUser?.trainCount = (appUser?.trainCount)!+1
                app.saveContext()
            }
        }
        // 执行异步请求调用execute
        do {
            try context.execute(asyncFecthRequest)
        } catch  {
            print("error")
        }
    }
    
    func insert_train_info(train: TrainEntity){
        let context = getContext()
        let Entity = NSEntityDescription.entity(forEntityName: "Train", in: context)
        let trainEntity = NSManagedObject(entity: Entity!, insertInto: context)
        
        
            trainEntity.setValue(train.audio, forKey: "audio")
            trainEntity.setValue(train.num_of_duplicate, forKey: "num_of_duplicate")
            trainEntity.setValue(train.num_of_stop, forKey: "num_of_stop")
            trainEntity.setValue(train.problem, forKey: "problem")
            trainEntity.setValue(train.ratio, forKey: "ratio")
            trainEntity.setValue(train.type, forKey: "type")
            trainEntity.setValue(train.trainTime, forKey: "trainTime")
            trainEntity.setValue(train.train_length, forKey: "train_length")
        trainEntity.setValue(train.content, forKey: "content")
        trainEntity.setValue(train.user_phoneNum!, forKey: "user_phoneNum")
        
        do {
            try context.save()
        }catch{
            let error = error as NSError
            fatalError("错误：\(error)\n\(error.userInfo)")
        }
    }
//    改变某一个模块的训练人数标签的数量
    func update_post_count_info(index: Int){
        //获取委托
        let app = UIApplication.shared.delegate as! AppDelegate
        //获取数据上下文对象
        let context = getContext()
        //声明数据的请求，声明一个实体结构
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Module")
        //查询条件
        fetchRequest.predicate = NSPredicate(format: "id=\(index)", "")
        let asyncFecthRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { (result: NSAsynchronousFetchResult!) in
            //对返回的数据做处理。
            let fetchObject  = result.finalResult! as! [Module]
            for c in fetchObject{
                c.post_count += Int32(1)
            }
        }
        // 执行异步请求调用execute
        do {
            try context.execute(asyncFecthRequest)
        } catch  {
            print("error")
        }
    }
}
extension StartTrainingController{
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
extension StartTrainingController: SFSpeechRecognizerDelegate{
    //监视语音识别器的可用性
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
//        recordBtn.isEnabled = available
        if available {
            print("available")
        }
    }
}
