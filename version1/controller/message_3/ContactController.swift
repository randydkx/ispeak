//
//  ContactController.swift
//  version1
//
//  Created by 苹果 on 2020/11/2.
//  Copyright © 2020 NJUST. All rights reserved.
//

import UIKit

class ContactController: UIViewController {

    var likenum:Int=0
    var scroll:UIScrollView?
    var curheight:CGFloat=0

    var list_of_post: [PostEntity] = []
    var audio_player: audioPlay?
    var current_playing_button_tag: Int?
    var playing_timer: Timer?
    var buttonGroup: [UIButton] = []
    var buttonGroupState: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden=true
        self.navigationController?.isToolbarHidden=true
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.backgroundColor=UIColor.clear
        let tit=UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        tit.text="用户消息"
        tit.textAlignment = .center
        tit.font=UIFont.systemFont(ofSize: 20)
        self.navigationItem.titleView=tit
        
        let item2 = UIBarButtonItem(image: UIImage(named: "返回2")?.reSizeImage(reSize: CGSize(width: 32, height: 32)).withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(backToPrevious))
        self.navigationItem.leftBarButtonItems = [item2]
        self.navigationController?.navigationBar.tintColor=UIColor.black
        self.view.backgroundColor = UIColor.init(red: 239.0/255.0, green: 238.0/255.0, blue: 245.0/255.0, alpha: 1)
        
        scroll=UIScrollView(frame: self.view.frame)
        scroll?.contentSize=CGSize(width: self.view.frame.width, height: self.view.frame.height)
        scroll?.backgroundColor=UIColor.white
        self.view.addSubview(scroll!)
        
        createItem()
        createItem()
        createItem()
        createItem()
        // Do any additional setup after loading the view.
    }
    
    @objc func backToPrevious(){
        self.navigationController!.popViewController(animated: true)
    }
    
    func createItem(){
        let item=UIView()
        item.frame=CGRect(x: 0, y: self.curheight, width: self.view.frame.width, height: 360)
        
        createcard(view: item)
        createavater(view: item)
//        createline(view: item)
        createname(view: item)
        createdate(view: item)
        createlabel(view: item)
        
        curheight+=370
        self.scroll?.addSubview(item)
        self.scroll?.contentSize=CGSize(width: self.view.frame.width,height: max(curheight+20,self.view.frame.height))
    }
    func createcard(view:UIView){
        let img=UIImageView(frame: CGRect(x: 0, y: 80, width: self.view.frame.width, height: 280))
        img.isUserInteractionEnabled = true
        img.image=UIImage(named: "组 1308")
        img.contentMode = .scaleToFill
        view.addSubview(img)
        view.layer.cornerRadius=15
        view.layer.masksToBounds=true
        createavater(view: img,x:40,y:45)
        createname(view: img,x:90,y:45)
        createdate(view: img,x:90,y:65)
        createcrown(view: img)
        createtag(view: img)
        createtxt(view: img)
        createaudio(view: img)
    }
    func createtxt(view:UIView){
        let label=UITextView(frame: CGRect(x: 40, y: 100, width: self.view.frame.width-80, height: 90))
        label.isEditable=false
        label.textContainer.maximumNumberOfLines=2
        label.textContainer.lineBreakMode = .byTruncatingTail
        view.addSubview(label)
        
        let mutableString = NSMutableAttributedString(string: "认识问题是解决问题的前提，好比是去医院看病，医生会先给你做检查，然后才能对症下药，对症下药了才能继续做检查，如此循环往复，你的病就好了。", attributes: nil)
        let space=NSMutableParagraphStyle()
        space.lineSpacing=10
        mutableString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemGray,NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16),NSAttributedString.Key.paragraphStyle:space], range: NSRange(location: 0, length: mutableString.length))
        label.attributedText=mutableString
    }
    func createaudio(view:UIView){
        
        let container_small = UIView(frame: CGRect(x: 30, y: 180, width: 180, height: 44))
        
        let long_image = UIImageView.init(frame: CGRect(x: 8, y: 4, width: 162, height: 36))
        long_image.image = UIImage(named: "组 1221")
        long_image.contentMode = .scaleToFill
        container_small.addSubview(long_image)
        
        let toPlaybutton = UIButton.init(frame: CGRect(x: 18, y: 10, width: 25, height: 25))
        toPlaybutton.setImage(UIImage(named: "组 1225"), for: .normal)
        toPlaybutton.addTarget(self, action: #selector(LikeController.toPlayButtonClicked(button:)), for: .touchUpInside)
        toPlaybutton.isEnabled=true
        toPlaybutton.tag = buttonGroup.count
        print(toPlaybutton.tag)
        buttonGroup.append(toPlaybutton)
        buttonGroupState.append(0)
        container_small.addSubview(toPlaybutton)
        
        let audio_time_label = UILabel.init(frame: CGRect(x: 119, y: 17, width: 39, height: 12))
        audio_time_label.text = int_time_transform(total_time: 92)
        audio_time_label.font = UIFont.systemFont(ofSize: 14)
        container_small.addSubview(audio_time_label)
        
        view.addSubview(container_small)
    }
    func createtag(view:UIView){
        let txt=UITextView(frame: CGRect(x: 295, y: 50, width: 90, height: 30))
        txt.backgroundColor=UIColor.clear
        txt.textColor=UIColor.lightGray
        txt.font=UIFont.systemFont(ofSize: 16)
        txt.text="#自我介绍"
        view.addSubview(txt)
    }
    func createcrown(view:UIView){
        let crown=UIImageView(image: UIImage(named: "王冠"))
        crown.frame=CGRect(x: 170, y: 50, width: 20, height: 20)
        view.addSubview(crown)
        let txt=UITextView(frame: CGRect(x: 195, y: 45, width: 90, height: 30))
        txt.textColor=UIColor.orange
        txt.font=UIFont.systemFont(ofSize: 13)
        txt.text="口吃达人"
        view.addSubview(txt)
    }
    func createline(view:UIView){
        let label=UILabel(frame: CGRect(x: 10, y: 310, width: self.view.frame.width-40, height: 1))
        label.backgroundColor=UIColor.blue
        view.addSubview(label)
    }
    func createavater(view:UIView,x:CGFloat=30,y:CGFloat=20){
        let img=UIImageView(image: UIImage(named: "组 1227"))
        img.frame=CGRect(x: x, y: y, width: 44, height: 44)
        img.image = img.image?.toCircle()
        view.addSubview(img)
    }
    func createname(view:UIView,x:CGFloat=80,y:CGFloat=20){
        let label=UILabel(frame: CGRect(x: x, y: y, width: 100, height: 30))
        label.backgroundColor=UIColor.clear
        label.textAlignment = .left
        label.font=UIFont.systemFont(ofSize: 16)
        label.text="爱哭的猫"
        view.addSubview(label)
    }
    func createdate(view:UIView,x:CGFloat=80,y:CGFloat=40){
        let label=UILabel(frame: CGRect(x: x, y: y, width: 100, height: 30))
        label.backgroundColor=UIColor.clear
        label.textAlignment = .left
        label.font=UIFont.systemFont(ofSize: 13)
        label.textColor=UIColor.lightGray
        label.text="2020-10-1"
        view.addSubview(label)
    }
    func createlabel(view:UIView){
        let label=UILabel(frame: CGRect(x: 33, y: 72, width: 150, height: 30))
        label.backgroundColor=UIColor.clear
        label.textAlignment = .left
        label.font=UIFont.systemFont(ofSize: 18)
        label.text="赞了这条帖子"
        view.addSubview(label)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @objc func toPlayButtonClicked(button: UIButton){
        let tag = button.tag
        if buttonGroupState[tag] == 0 {
////            点击之后开始播放录音
////            获取本条发布的信息
//            let post_ = list_of_post[tag]
//            let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0]
//
//            let full_path = "\(docDir)/\(post_.audio_path!)"
//            print("完全路径： "+full_path)
//
//            self.audio_player = audioPlay.init(path: full_path)
//            audio_player?.play_audio()
            self.current_playing_button_tag = tag
            self.playing_timer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(recover_button_status), userInfo: nil, repeats: false)
            buttonGroup[tag].setImage(UIImage(named: "组 1222"), for: .normal)
        }else{
////            点击之后停止播放录音
//            audio_player?.stop_audio()
//            self.audio_player = nil
////            定时器失效
//            self.playing_timer?.invalidate()
//            self.playing_timer = nil
            buttonGroup[tag].setImage(UIImage(named: "组 1225"), for: .normal)
        }
        buttonGroupState[tag] = 1-buttonGroupState[tag]
    }
    //        恢复按钮的状态
    @objc func recover_button_status(){
        let tag = self.current_playing_button_tag
        if tag != nil{
//            停止播放录音并且恢复按钮的状态
            audio_player?.stop_audio()
            self.audio_player = nil
            buttonGroup[tag!].setImage(UIImage(named: "组 1225"), for: .normal)
//        改变按钮的状态
            buttonGroupState[tag!] = 1-buttonGroupState[tag!]
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
