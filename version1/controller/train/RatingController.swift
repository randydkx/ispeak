//
//  HistoryController.swift
//  version1
//
//  Created by 苹果 on 2020/10/1.
//  Copyright © 2020 NJUST. All rights reserved.
//

import UIKit
import CoreData

class RatingController: UIViewController,NSFetchedResultsControllerDelegate {

    @IBOutlet weak var component1: UIView!
    @IBOutlet weak var component1_1: UIView!
    @IBOutlet weak var component2: UIView!
    @IBOutlet weak var component3: UIView!
    @IBOutlet weak var component3_1: UITextView!
    @IBOutlet weak var ratio: UITextView!
    @IBOutlet weak var problem: UITextView!
    @IBOutlet weak var duplicatedLabel: UITextView!
    @IBOutlet weak var stopLabel: UITextView!
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
//    显示录音时间的标签
    @IBOutlet weak var time_label: UITextView!
    
//    获得的星星和钻石的数量
    var star_count: Int = 0
    
    var single_train = TrainEntity()
//    录音的总时间
    var total_time: Int = 0
    
//    播放录音按钮
    var listenButton: UIButton?
//    播放录音按钮的状态,初始为停止状态
    var button_state: Int = 0
//    录音的名称+扩展名
    var audio_path: String = ""
//   播放录音的字符串
    var audio_full_path: String = ""
//    播放器控制
    var audio_player: audioPlay?
//    播放器定时器
    var audio_player_timer: Timer?
    
//    最近一次的口吃率标签
    @IBOutlet weak var latest_ratio_label: UITextView!
    
//    训练对应的时间
    @IBOutlet weak var current_train_time: UITextView!
    
//    训练次数标签
    @IBOutlet weak var train_count_label: UITextView!
    
//    头像和昵称
    
    @IBOutlet weak var user_avatar: UIImageView!
    @IBOutlet weak var user_nickname: UITextView!
//    训练对应的模块
    var focused_item: Int = 0
    
    var time_label_text: String = ""
    var letestScore: String = "40%"
    var alg: Algorithm = Algorithm(input: "测试")
    var pass: String = ""
    var numOfDuplicated: Int = 10
    var numOfStop: Int = 10
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.shadowImage = UIImage()
        //去掉（重设）NavigationBar上的一条线
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.tintColor=UIColor.white
        
        //去掉（重设）NavigationBar上的背景图片
//        let item1 = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(click))
        let item1 = UIBarButtonItem(image: UIImage(named: "返回2")?.reSizeImage(reSize: CGSize(width: 32, height: 32)).withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(_repeat))
        let item2 = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(click))
        self.navigationItem.leftBarButtonItems = [item1]
        self.navigationItem.rightBarButtonItems = [item2]
        self.navigationController?.navigationBar.tintColor=UIColor.white;
        
        let scroll=UIScrollView(frame: CGRect(x:0,y:0,width: self.view.bounds.width
            ,height: self.view.bounds.height-50));
        scroll.contentSize=CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height+5);
        scroll.addSubview(component1);
        scroll.addSubview(component2);
        scroll.addSubview(component3);
        self.view.addSubview(scroll);
        
        component1?.layer.cornerRadius=component1.frame.height/4;
        component1?.layer.shadowOpacity=0.5;
        component1?.layer.shadowColor=UIColor.black.cgColor;
        component1?.layer.masksToBounds=false;
        component1?.layer.shadowOffset=CGSize(width:5.0,height:5.0);
        
        component2?.layer.cornerRadius=component2.frame.height/4;
        component2?.layer.shadowOpacity=0.5;
        component2?.layer.shadowColor=UIColor.black.cgColor;
        component2?.layer.masksToBounds=false;
        component2?.layer.shadowOffset=CGSize(width:5.0,height:5.0);
        
        component3?.layer.cornerRadius=component3.frame.height/4;
        component3?.layer.shadowOpacity=0.5;
        component3?.layer.shadowColor=UIColor.black.cgColor;
        component3?.layer.masksToBounds=false;
        component3?.layer.shadowOffset=CGSize(width:5.0,height:5.0);
        
        component1_1?.layer.cornerRadius=component1_1.frame.height/2;

        //通过富文本来设置行间距
        let paraph = NSMutableParagraphStyle()
        //将行间距设置为28
        paraph.lineSpacing = 16
        //样式属性集合
        let attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16),
                          NSAttributedString.Key.paragraphStyle: paraph]
        component3_1?.attributedText = NSAttributedString(string: component3_1.text, attributes: attributes);
        component3_1.isEditable=false
        
        let recommendbutton=UIButton(type: .system)
        recommendbutton.frame=CGRect(x: 220, y: 40, width: 120, height: 40)
        recommendbutton.tintColor=UIColor.white
        recommendbutton.layer.cornerRadius=recommendbutton.frame.height/2;
        recommendbutton.layer.masksToBounds=false;
        recommendbutton.layer.shadowOffset=CGSize(width: 5.0, height: 5.0);
        recommendbutton.layer.shadowOpacity=0.5;
        recommendbutton.layer.shadowColor=UIColor(red: 23.0/255.0, green: 150.0/255.0, blue: 77.0/255.0, alpha: 1).cgColor;
        recommendbutton.setTitle("相似推荐", for: .normal)
        recommendbutton.backgroundColor=UIColor(red: 23.0/255.0, green: 150.0/255.0, blue: 77.0/255.0, alpha: 1);
        recommendbutton.titleLabel?.font=UIFont.init(name: "Helvetica", size: 16)
        recommendbutton.addTarget(self, action: #selector(to_similar_recom_page), for: .touchUpInside)
        component2.addSubview(recommendbutton)

        let repeatbutton2=UIButton(type: .system)
        repeatbutton2.frame=CGRect(x: 50, y: 780, width: 130, height: 56)
        repeatbutton2.tintColor=UIColor.white
        repeatbutton2.layer.cornerRadius=repeatbutton2.frame.height/2;
        repeatbutton2.layer.masksToBounds=false;
        repeatbutton2.layer.shadowOffset=CGSize(width: 5.0, height: 5.0);
        repeatbutton2.layer.shadowOpacity=0.5;
        repeatbutton2.layer.shadowColor=UIColor(red: 23.0/255.0, green: 150.0/255.0, blue: 77.0/255.0, alpha: 1).cgColor;
        repeatbutton2.setTitle("再来一遍", for: .normal)
        repeatbutton2.backgroundColor=UIColor(red: 23.0/255.0, green: 150.0/255.0, blue: 77.0/255.0, alpha: 1);
        repeatbutton2.titleLabel?.font=UIFont.init(name: "Helvetica", size: 18)
        repeatbutton2.addTarget(self, action: #selector(newstarttraining), for: .touchUpInside)
        self.view.addSubview(repeatbutton2)
        
        let trainbutton2=UIButton(type: .system)
        trainbutton2.frame=CGRect(x: self.view.frame.width-180, y: 780, width: 130, height: 56)
        trainbutton2.tintColor=UIColor.white
        trainbutton2.layer.cornerRadius=trainbutton2.frame.height/2;
        trainbutton2.layer.masksToBounds=false;
        trainbutton2.layer.shadowOffset=CGSize(width: 5.0, height: 5.0);
        trainbutton2.layer.shadowOpacity=0.5;
        trainbutton2.layer.shadowColor=UIColor(red: 23.0/255.0, green: 150.0/255.0, blue: 77.0/255.0, alpha: 1).cgColor;
        trainbutton2.setTitle("针对训练", for: .normal)
        trainbutton2.addTarget(self, action: #selector(_segmentTrain), for: .touchUpInside)
        trainbutton2.backgroundColor=UIColor(red: 23.0/255.0, green: 150.0/255.0, blue: 77.0/255.0, alpha: 1);
        trainbutton2.titleLabel?.font=UIFont.init(name: "Helvetica", size: 18)
        self.view.addSubview(trainbutton2)
        
        
//        更新录音时间标签
        self.time_label.text = self.time_label_text
        
//        录音检测结果填写
        if self.pass.count != 0{
            self.component3_1.text = pass
            print("pass: \(pass)")
            ratio.text = self.alg.Score()
            self.problem.text = alg.problem
            
        }else{
            self.component3_1.text="未检测到您的声音，请您重新发言"
            self.problem.text = "不存在问题哦"
            ratio.text = "0.0%"
        }
        self.numOfStop = alg.numOfStop
        self.numOfDuplicated = alg.numOfDuplicated
        self.duplicatedLabel.text = "\(self.numOfDuplicated)次"
        self.stopLabel.text = "\(self.numOfStop)次"
        if self.alg.scoreDouble <= 0.3333{
            self.star1.isHidden = false
            self.star2.isHidden = false
            self.star3.isHidden = false
            appUser?.star = (appUser?.star)! + 3
            modify_one_user_star(phoneNum: (appUser?.phoneNum)!, add_count: 3)
        }
        if self.alg.scoreDouble > 0.3333 && self.alg.scoreDouble < 0.667{
            self.star1.isHidden = false
            self.star2.isHidden = false
            self.star3.isHidden = true
            appUser?.star = (appUser?.star)! + 2
            modify_one_user_star(phoneNum: (appUser?.phoneNum)!, add_count: 2)
        }
        if self.alg.scoreDouble >= 0.667{
            self.star1.isHidden = false
            self.star2.isHidden = true
            self.star3.isHidden = true
            appUser?.star = (appUser?.star)! + 1
            modify_one_user_star(phoneNum: (appUser?.phoneNum)!, add_count: 1)
        }
        
        
//        播放按钮
        listenButton = UIButton.init(frame: CGRect(x: 320, y: 120, width: 40, height: 40))
        listenButton?.setBackgroundImage(UIImage(named: "组 1225"), for: .normal)
        self.view.addSubview(listenButton!)
//        为播放按钮添加点击事件
        listenButton?.isUserInteractionEnabled = true
        listenButton?.addTarget(self, action: #selector(toggle), for: .touchUpInside)
        
        
        print("全路径： "+self.audio_full_path)
//       播放器控制器
        audio_player = audioPlay.init(path: self.audio_full_path)
        
//        最近一次口吃率标志
        self.latest_ratio_label.text = "最近一次口吃率：" + last_train_ratio
        last_train_ratio = ratio.text
        
//        当前时间
        self.current_train_time.text = self.single_train.trainTime
        
//        训练次数
        self.train_count_label.text = "第" + String((appUser?.trainCount)!) + "次训练"
        
//        设置头像以及nickname
        
        self.user_avatar.backgroundColor=UIColor.systemGray
        self.user_avatar.image = UIImage.init(contentsOfFile: getImageFullPath((appUser?.avatar)!))
        
        self.user_nickname.text = (appUser?.nickname)!
     }
    @objc func click(){
        let con = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "shareTrain") as! shareTrainController
        con.audio_path = self.audio_path
        con.total_audio_time = self.total_time
        con.post.audio_time = self.total_time
        con.focused_button = self.focused_item
        self.navigationController?.pushViewController(con, animated: true)
    }
    
//    跳转到相似推荐页面
    @objc func to_similar_recom_page(){
        let con = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "similarRecom") as UIViewController
        self.navigationController?.pushViewController(con, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        let alg = Algorithm(input: self.pass)
        let score = alg.Score()
        ratio.text = score
        self.navigationController?.navigationBar.tintColor=UIColor.white
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor=UIColor.white
    }
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    @objc func _repeat(){
        self.backToPrevious()
    }
//    跳转到针对训练页面
    @objc func _segmentTrain(){
        print("to segmenttrain page")
        let con = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "segmentTrain") as! segmentTrainController
//        let list: [Substring] = self.component3_1.text.split(separator: "，")
//        con.sentences.removeAll()
//        for str in list{
//            let string = String(str)
//            con.sentences.append(string)
//        }
        let alg = Algorithm(input: self.pass)
        con.SpeechText = String(alg.listOfDuplicated)
        self.navigationController?.pushViewController(con, animated: true)
    }
    
    func backToPrevious(){
        let views = self.navigationController?.viewControllers
        for view in views!{
            if view.isKind(of: TrainViewController.self){
                self.navigationController?.popToViewController(view, animated: true)
            }
        }
    }
    @objc func newstarttraining(){
        let views = self.navigationController?.viewControllers
        for view in views!{
            if view.isKind(of: TrainViewController.self){
                self.navigationController?.popToViewController(view, animated: true)
            }
        }
    }
    
//    按钮的点击事件
    @objc func toggle() {
        if button_state == 0{
            button_state = 1
            listenButton?.setBackgroundImage(UIImage(named: "组 1222"), for: .normal)
            print(self.audio_player?.path)
            self.audio_player?.play_audio()
//            如果不按停止按钮的话就设定定时器，播放完之后toggle
            self.audio_player_timer = Timer.scheduledTimer(timeInterval: TimeInterval(self.total_time), target: self, selector: #selector(toggle), userInfo: nil, repeats: false)
        }
        else{
            button_state = 0
            listenButton?.setBackgroundImage(UIImage(named: "组 1225"), for: .normal)
            self.audio_player?.stop_audio()
            self.audio_player_timer?.invalidate()
            self.audio_player_timer = nil
        }
    }
    
    func modify_one_user_star(phoneNum: String,add_count: Int){
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
                c.star = c.star + Int32(add_count)
                print("星星数量修改成: \(c.star)")
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
}
