//
//  OtherSpaceController.swift
//  version1
//
//  Created by 苹果 on 2020/11/11.
//  Copyright © 2020 NJUST. All rights reserved.
//

import UIKit
import CoreData
import ProgressHUD

class OtherSpaceController: UIViewController,NSFetchedResultsControllerDelegate {
    
//    用户
    var user: UserEntity?
    
    var scroll2height:CGFloat=0
    var scroll3height:CGFloat=0
    
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    
    @IBOutlet weak var separator: UILabel!
    @IBOutlet weak var whole: UIScrollView!
    
    var component2:UIView=UIView()
    var component3:UIView=UIView()

    @IBOutlet weak var name_label: UITextView!
//    头像view
    var avtar:UIImageView?
    
//    钻石，星星，粉丝和关注的数量
    @IBOutlet weak var diamond_label: UITextView!
    @IBOutlet weak var star_label: UITextView!
    @IBOutlet weak var fans_label: UITextView!
    @IBOutlet weak var attention_label: UITextView!
//    个性标签
    @IBOutlet weak var signature_label: UITextView!
    
    var list_of_post: [PostEntity] = []
    var audio_player: audioPlay?
    var current_playing_button_tag: Int?
    var playing_timer: Timer?
    var buttonGroup: [UIButton] = []
    var buttonGroupState: [Int] = []
    
    var postORcollect:String="post"
    
    //    评论按钮组
        var remark_button_group: [UIButton] = []
    //    评论按钮的状态
        var remark_button_state: [Int] = []
    //    收藏按钮组
        var cherish_button_group: [UIButton] = []
    //    收藏按钮的状态
        var cherish_button_state: [Int] = []
    //    评论数量text
        var remark_num_text: [UILabel] = []
    //   点赞数量text
        var cherish_num_text: [UILabel] = []
    //    选中的礼物时钻石还是星星
        var selected_gift: Int = 0
    //    是否自定义赠送的数量
        var is_user_defined: Bool?
    //    用户自定义的数量
        var user_defined_num: Int = 1
    //    数量按钮组
        var num_button_group: [UIButton] = []
    //   赠送礼物的按钮索引
        var send_gift_button_index: Int = 0
    //   所有的用户收藏post
    var list_of_all_cherish: [PostEntity] = []
//    关注的发起者
    var from_phoneNum: String = (appUser?.phoneNum)!
//    关注的接受者
    var to_phoneNum: String = ""
//    当前是否已经关注ta
    var has_attention: Bool?
//     关注的编号
    var attention_id: String?
//    关注按钮，全局控制状态
    var attention_button: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.edgesForExtendedLayout = UIRectEdge.top
        let bottom=UIView(frame: CGRect(x: 0, y: self.view.frame.height-120, width: self.view.frame.width, height: 120))
        bottom.backgroundColor=UIColor.white
        
        self.attention_button = UIButton(type: .system)
        attention_button!.backgroundColor=UIColor(red: 23.0/255.0, green: 150.0/255.0, blue: 77.0/255.0, alpha: 1)
        if self.has_attention ?? false{
            attention_button!.setTitle("取 消", for: .normal)
        }else{
            attention_button!.setTitle("关 注", for: .normal)
        }
        
        attention_button?.titleLabel?.isHidden=false
        attention_button?.titleLabel?.font=UIFont.systemFont(ofSize: 18)
        attention_button?.titleLabel?.tintColor=UIColor.white
        attention_button?.titleLabel?.textColor=UIColor.white
        attention_button!.frame=CGRect(x: 30, y: 10, width: 100, height: 50)
        attention_button!.layer.cornerRadius = attention_button!.frame.height/2
        attention_button!.layer.masksToBounds=false
        attention_button!.layer.shadowOffset=CGSize(width: 5.0, height: 5.0);
        attention_button!.layer.shadowOpacity=0.5
        attention_button!.layer.shadowColor=UIColor(red: 23.0/255.0, green: 150.0/255.0, blue: 77.0/255.0, alpha: 1).cgColor
        attention_button!.addTarget(self, action: #selector(modify_attention), for: .touchUpInside)
        bottom.addSubview(attention_button!)
        
        let btn22=UIButton(type: .system)
        btn22.frame=CGRect(x: 350, y: 10, width: 100, height: 40)
        btn22.layer.cornerRadius=btn22.frame.height/2
        btn22.layer.masksToBounds=false
        btn22.layer.shadowOffset=CGSize(width: 5.0, height: 5.0);
        btn22.layer.shadowOpacity=0.5
        btn22.layer.shadowColor=UIColor(red: 23.0/255.0, green: 150.0/255.0, blue: 77.0/255.0, alpha: 1).cgColor
        bottom.addSubview(btn22)
        
        let vertical=UILabel(frame: CGRect(x: 207, y: 20, width: 1, height: 35))
        vertical.backgroundColor=UIColor.lightGray
        bottom.addSubview(vertical)
        
        let talkimg=UIImageView(image: UIImage(named: "评论"))
        talkimg.frame=CGRect(x: 280, y: 29, width: 24, height: 24)
        talkimg.contentMode = .scaleToFill
        bottom.addSubview(talkimg)
        
        let talkword=UITextView(frame: CGRect(x: 310, y: 20, width: 100, height: 60))
        talkword.text="聊天"
        talkword.font=UIFont.systemFont(ofSize: 18)
        talkword.textColor=UIColor.systemGray
        bottom.addSubview(talkword)
        
        
        self.view.addSubview(bottom)
        
        self.navigationController?.isToolbarHidden=true
        self.view.backgroundColor = ZHFColor.white
        self.tabBarController?.tabBar.isHidden=true
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        let item2 = UIBarButtonItem(image: UIImage(named: "返回2")?.reSizeImage(reSize: CGSize(width: 32, height: 32)).withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(backToPrevious))
        self.navigationItem.leftBarButtonItems = [item2]
        self.navigationController?.navigationBar.tintColor=UIColor.white;
//        self.tabBarController?.tabBar.isHidden=true
      
        whole.layer.frame.size.height=944;
//        whole.contentSize=CGSize(width: whole.layer.frame.width, height: 1500)
        
        btn1.titleLabel?.text="发帖记录"
        btn2.titleLabel?.text="我的收藏"
        btn1.titleLabel?.font=UIFont.systemFont(ofSize: 20)
        btn2.titleLabel?.font=UIFont.systemFont(ofSize: 18)
        btn1.tintColor=UIColor.systemGreen
        btn2.tintColor=UIColor.systemGray
        
        btn1.addTarget(self, action: #selector(btn1click), for: .touchUpInside)
        btn2.addTarget(self, action: #selector(btn2click), for: .touchUpInside)
        
        
        separator.frame.size=CGSize(width: separator.frame.width,height: 1)
        
        setupcomponent3()
        setupcomponent2()
        
//       设置头像和背景
            avtar=UIImageView(frame: CGRect(x: 155, y: 152, width: 100, height: 100))
            avtar?.layer.cornerRadius=50
            avtar?.backgroundColor = UIColor.init(red: 205.0/255.0, green: 205.0/255.0, blue: 205.0/255.0, alpha: 1)
        avtar?.image = UIImage.init(contentsOfFile: getImageFullPath((appUser?.avatar)!))
        avtar?.isUserInteractionEnabled=false
        whole.addSubview(avtar!)
        
        let avtap=UITapGestureRecognizer(target: self, action: #selector(ontapav))
        avtar?.addGestureRecognizer(avtap)
        avtar?.isUserInteractionEnabled=false
        avtar?.layer.cornerRadius =  50
        avtar?.layer.masksToBounds = true
        
//        设置nickname标签
        self.name_label.text = appUser?.nickname
//        设置星星等附加标签
        self.star_label.text = String((appUser?.star!)!)
        self.diamond_label.text = String((appUser?.diamond!)!)
        self.fans_label.text = String((appUser?.fans!)!)
        self.attention_label.text = String((appUser?.attention!)!)
        
//        设置个性标签
        self.signature_label.text = appUser?.signature!
        
//        左滑更换tabview
        let gesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(change_view(sender:)))
        gesture.edges = .left
        self.view.addGestureRecognizer(gesture)
    }
    
//    关注状态的变化
    @objc func modify_attention(){
        let flag: Int32 = self.has_attention! ? -1 : 1
        if self.has_attention!{
//            删除一条attention实例
            self.attention_button?.setTitle("关注", for: .normal)
            let att = AttentionExtention()
            att.attentionid = self.attention_id!
            self.attention_id = nil
            self.modify_attention_info(attention: att, command: "delete")
            self.attention_button?.layer.opacity = 1
        }else{
//            创建一条attention实例
            self.attention_button?.setTitle("取消", for: .normal)
            let att = AttentionExtention()
            att.from_phoneNum = self.from_phoneNum
            att.to_phoneNum = self.to_phoneNum
            self.modify_attention_info(attention: att, command: "insert")
            self.attention_button?.layer.opacity = 0.5
            self.attention_id = att.attentionid
        }
        
//        展示控件
        if self.has_attention! {
            self.progress_show(content: "取消关注")
        }else {
            self.progress_show(content: "设置关注")
        }
        self.has_attention = !self.has_attention!
        
        print("from_phoneNum: \(self.from_phoneNum)")
        print("to_phoneNum: \(self.to_phoneNum)")
//        修改关注和粉丝的数量
        //获取委托
        let app = UIApplication.shared.delegate as! AppDelegate
        //获取数据上下文对象
        let context = getContext()
        //声明数据的请求，声明一个实体结构
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        //查询条件
        fetchRequest.predicate = NSPredicate(format: "phoneNum='\(self.from_phoneNum)'", "")
        // 返回结果在finalResult中
        let asyncFecthRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { (result: NSAsynchronousFetchResult!) in
            //对返回的数据做处理。
            let fetchObject  = result.finalResult! as! [User]
            for c in fetchObject{
                c.attention += 1 * flag
                appUser?.attention = (appUser?.attention)! + Int32(1) * flag
                app.saveContext()
            }
        }
        
        let fetchRequest2 = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        //查询条件
        fetchRequest2.predicate = NSPredicate(format: "phoneNum='\(self.to_phoneNum)'", "")
        // 返回结果在finalResult中
        let asyncFecthRequest2 = NSAsynchronousFetchRequest(fetchRequest: fetchRequest2) { (result: NSAsynchronousFetchResult!) in
            //对返回的数据做处理。
            let fetchObject  = result.finalResult! as! [User]
            for c in fetchObject{
                c.fans += 1 * flag
                app.saveContext()
            }
        }
        // 执行异步请求调用execute
        do {
            try context.execute(asyncFecthRequest)
            try context.execute(asyncFecthRequest2)
        } catch  {
            print("error")
        }
    }
    
//    操作关注的信息
    func modify_attention_info(attention: AttentionExtention,command: String){
//        插入一条关注信息
        if command == "insert"{
            let context = getContext()
            let Entity = NSEntityDescription.entity(forEntityName: "Attention", in: context)
            let AttentionEntity = NSManagedObject(entity: Entity!, insertInto: context)
           
            AttentionEntity.setValue(attention.attentionid, forKey: "attentionid")
            AttentionEntity.setValue(attention.from_phoneNum, forKey: "from_phoneNum")
            AttentionEntity.setValue(attention.to_phoneNum, forKey: "to_phoneNum")
            AttentionEntity.setValue(attention.time, forKey: "time")

            do {
                try context.save()
                
            }catch{
                let error = error as NSError
                fatalError("错误：\(error)\n\(error.userInfo)")
            }
        }
//        删除一条从某人到某人的关注信息
        else if command == "delete"{
            //获取委托
            let app = UIApplication.shared.delegate as! AppDelegate
            //获取数据上下文对象
            let context = getContext()
            //声明数据的请求，声明一个实体结构
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Attention")
            fetchRequest.predicate = NSPredicate(format: "attentionid='\(attention.attentionid)'", "")
            
            let asyncFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { (result:NSAsynchronousFetchResult) in
                //对返回的数据做处理。
                let fetchObject = result.finalResult! as! [Attention]
                for c in fetchObject{
                    print("has info and is deleting...")
                    //所有删除信息
                    context.delete(c)
                }
                 app.saveContext()
            }
              // 执行异步请求调用execute
            do {
                try context.execute(asyncFetchRequest)
            } catch  {
                print("error")
            }
        }
    }
    
    func progress_show(content: String){
        ProgressHUD.show(content, interaction: true)
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(end), userInfo: nil, repeats: false)
    }
    @objc func end(){
        ProgressHUD.dismiss()
    }
    
    @objc func btn1click(){
        if self.postORcollect=="post"{
            return
        }
        self.postORcollect="post"
        btn1.titleLabel?.font=UIFont.systemFont(ofSize: 20)
        btn2.titleLabel?.font=UIFont.systemFont(ofSize: 18)
        btn1.tintColor=UIColor.systemGreen
        btn2.tintColor=UIColor.systemGray
        self.whole.contentSize=CGSize(width: 414,height: 510+self.scroll2height)
        UIView.animate(withDuration: 0.5, animations: {
            self.component2.frame=CGRect(x: 0, y: 460, width: 414, height: self.scroll2height)
            self.component3.frame=CGRect(x: 400, y: 460, width: 414, height: self.scroll3height)
        })
    }
    @objc func btn2click(){
        if self.postORcollect=="collect"{
            return
        }
        self.postORcollect="collect"
        btn1.titleLabel?.font=UIFont.systemFont(ofSize: 18)
        btn2.titleLabel?.font=UIFont.systemFont(ofSize: 20)
        btn1.tintColor=UIColor.systemGray
        btn2.tintColor=UIColor.systemGreen
        self.whole.contentSize=CGSize(width: 414,height: 510+self.scroll3height)
        UIView.animate(withDuration: 0.5, animations: {
            self.component2.frame=CGRect(x: -400, y: 460, width: 414, height: self.scroll2height)
            self.component3.frame=CGRect(x: 0, y: 460, width: 414, height: self.scroll3height)
        })
    }
    
    func setupcomponent2(){
        component2=UIView(frame: CGRect(x: 0, y: 460, width: 414, height: 0))
//        component2.backgroundColor=UIColor.white
//        component2.layer.cornerRadius=25;
        createitem(view: component2)
        createitem(view: component2)
//        createitem(view: component2)
//        createitem(view: component2)
//        createitem(view: component2)
        
        self.whole.addSubview(component2)
        self.whole.contentSize=CGSize(width: 414,height: 510+self.scroll2height)
//        print(self.whole.contentSize.height)
    }
    func setupcomponent3(){
        component3=UIView(frame: CGRect(x: 400, y: 460, width: 414, height: 0))
//        component2.backgroundColor=UIColor.white
//        component2.layer.cornerRadius=25;
        createitem_(view: component3)
        createitem_(view: component3)
        createitem_(view: component3)
//        createitem_(view: component3)
//        createitem(view: component2)
        
        self.whole.addSubview(component3)
        self.whole.contentSize=CGSize(width: 414,height: 510+self.scroll3height)
//        print(self.whole.contentSize.height)
    }
    
    func createitem(view:UIView){
        createcard(view: view)
        self.scroll2height+=280
        self.component2.frame.size=CGSize(width: 414,height: self.component2.frame.height+280)
    }
    func createitem_(view:UIView){
        createcard_(view: view)
        self.scroll3height+=280
        self.component3.frame.size=CGSize(width: 414,height: self.component3.frame.height+280)
    }
    
    func createcard(view:UIView){
        let img=UIImageView(frame: CGRect(x: 0, y: self.scroll2height, width: self.view.frame.width, height: 320))
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
        createinteraction(view:img)
    }
    func createinteraction(view:UIView){
        let offset=0
        var bottomView = UIView.init(frame: CGRect(x: 25, y: 235+offset, width: 366, height: 28))
        let button1 = UIButton(frame: CGRect(x:33,y:5,width:22,height: 20))
//        button1.addTarget(self, action: #selector(remark_button_clicked(button:)), for: .touchUpInside)
        button1.setImage(UIImage(named: "评论"), for: .normal)
        bottomView.addSubview(button1)
                
        let button2 = UIButton(frame: CGRect(x:120,y:0,width:30,height: 28))
//        button2.setImage(UIImage(named: "收藏"), for: .normal)
        button2.setImage(UIImage(named: "收 藏(1)"), for: .normal)
//        print("\(numOfItem) : \(cherish_button_state[numOfItem])")
//        if cherish_button_state[numOfItem] == 1{
//            button2.setImage(UIImage(named: "收 藏(1)"), for: .normal)
//            let transform = button2.transform
//            button2.transform = transform.scaledBy(x: 1.3, y: 1.3)
//        }
        bottomView.addSubview(button2)
//        button1.tag = 2000+numOfItem
//        button2.tag = 3000+numOfItem
//        button2.addTarget(self, action: #selector(cherish_button_clicked(button:)), for: .touchUpInside)
        
        //        数量标签
        let numOfReview = UILabel(frame: CGRect(x:63,y:5,width:47,height: 21))
//        numOfReview.text = String(post.comment)
        numOfReview.text = "10"
        numOfReview.font = UIFont.systemFont(ofSize: 14)
        numOfReview.textColor = UIColor.systemGray
        bottomView.addSubview(numOfReview)
                
        let numOfCharish = UILabel(frame: CGRect(x:150,y:5,width:47,height: 21))
//        numOfCharish.text = String(post.cherish)
        numOfCharish.text = "20"
        numOfCharish.font = UIFont.systemFont(ofSize: 14)
        numOfCharish.textColor = UIColor.systemGray
        bottomView.addSubview(numOfCharish)
        
        //            保存评论数量和点赞数量的状态的状态
        self.remark_num_text.append(numOfReview)
        self.cherish_num_text.append(numOfCharish)
        
        view.addSubview(bottomView)
    }
    
    
    func createcard_(view:UIView){
        let img=UIImageView(frame: CGRect(x: 0, y: self.scroll3height, width: self.view.frame.width, height: 320))
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
        createinteraction(view:img)
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
        
        let container_small = UIView(frame: CGRect(x: 35, y: 178, width: 180, height: 44))
        
        let long_image = UIImageView.init(frame: CGRect(x: 8, y: 4, width: 162, height: 36))
        long_image.image = UIImage(named: "组 1221")
        long_image.contentMode = .scaleToFill
        container_small.addSubview(long_image)
        
        let toPlaybutton = UIButton.init(frame: CGRect(x: 18, y: 10, width: 25, height: 25))
        toPlaybutton.setImage(UIImage(named: "组 1225"), for: .normal)
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
        txt.isUserInteractionEnabled=false
        view.addSubview(txt)
    }
    func createcrown(view:UIView){
        let crown=UIImageView(image: UIImage(named: "王冠"))
        crown.frame=CGRect(x: 170, y: 50, width: 20, height: 20)
        view.addSubview(crown)
        let txt=UITextView(frame: CGRect(x: 195, y: 45, width: 90, height: 40))
        txt.textColor=UIColor.orange
        txt.font=UIFont.systemFont(ofSize: 13)
        txt.text="口吃达人"
        txt.isUserInteractionEnabled=false
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
    
    @objc func change_view(sender: UIScreenEdgePanGestureRecognizer){
        if sender.state == .ended{
            self.tabBarController?.selectedIndex = 1
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
//    视图显示的时候将
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = false
        //        设置nickname标签
        self.name_label.text = user?.nickname!
        //        设置星星等附加标签
        self.star_label.text = String((user!.star)!)
        self.diamond_label.text = String((user!.diamond)!)
        self.fans_label.text = String((user?.fans!)!)
        self.attention_label.text = String((user?.attention!)!)
        //        设置个性标签
        self.signature_label.text = user?.signature!
        self.avtar?.image = UIImage.init(contentsOfFile: getImageFullPath((user?.avatar)!))
        
        
//        获取用用户所有的发帖记录
        self.get_user_all_post(phoneNum: (user?.phoneNum)!)
//        获取用户搜有的收藏帖子信息
        self.get_all_cherished_post(phoneNum: (user?.phoneNum)!)
        
        self.to_phoneNum = (user?.phoneNum)!
        
    }
//    获得用户所有的发帖内容
    @objc func get_user_all_post(phoneNum: String){
        self.list_of_post.removeAll()
        let context = getContext()
        let entity: NSEntityDescription? = NSEntityDescription.entity(forEntityName: "Post", in: context)
        let request = NSFetchRequest<Post>(entityName: "Post")
        request.fetchOffset = 0
        request.entity = entity
        request.predicate = NSPredicate(format: "phoneNum='\(phoneNum)'", "")
        
        do{
            let result:[AnyObject]? = try context.fetch(request)
            
            print("其他人的用户主页： 发表的帖子总数： \((result?.count)!)")
            var index = 0
            for c: Post in result as! [Post]{
                let post = PostEntity()
                post.audio_path = (c.audio_path)!
                post.audio_time = Int(c.audio_time)
                post.cherish = Int(c.cherish)
                post.content = (c.content)!
                post.comment = Int(c.comment)
                post.has_audio = c.has_audio
                post.id = (c.id)!
                post.image1_path = (c.image1_path)!
                post.image2_path = (c.image2_path)!
                post.module = (c.module)!
                post.time = c.time!
                post.phoneNum = (c.phoneNum)!
                post.num_of_image = Int(c.num_of_image)
                post.user = self.user
                self.list_of_post.append(post)
                
                index += 1
            }
            
        }catch{
            print("post数据获取失败")
        }
    }
    
//    获得用户收藏的所有帖子内容,参数： 主页对应的用户
    @objc func get_all_cherished_post(phoneNum: String){
        self.list_of_all_cherish.removeAll()
        var tmp_cherish_list: [String] = []
        let context = getContext()
        let entity: NSEntityDescription? = NSEntityDescription.entity(forEntityName: "UserAllCherish", in: context)
        let request = NSFetchRequest<UserAllCherish>(entityName: "UserAllCherish")
        request.fetchOffset = 0
        request.entity = entity
        request.predicate = NSPredicate(format: "phoneNum='\(phoneNum)'", "")
        
        do{
            let result:[AnyObject]? = try context.fetch(request)
            
            print("其他人的用户主页： 收藏的帖子总数： \((result?.count)!)")
            for c: UserAllCherish in result as! [UserAllCherish]{
                tmp_cherish_list.append(c.cherishid!)
            }
//            通过postid搜索所有的post
            for i in 0..<tmp_cherish_list.count{
                let entity2: NSEntityDescription? = NSEntityDescription.entity(forEntityName: "Post", in: context)
                let request2 = NSFetchRequest<User>(entityName: "Post")
                request2.fetchOffset = 0
                request2.entity = entity2
                request2.predicate = NSPredicate(format: "id='\(tmp_cherish_list[i])'", "")
                
                do{
                    let fetchedObject : [AnyObject]? = try context.fetch(request2)
                    for c in fetchedObject as! [Post] {
                        let post = PostEntity()
                        post.audio_path = (c.audio_path)!
                        post.audio_time = Int(c.audio_time)
                        post.cherish = Int(c.cherish)
                        post.content = (c.content)!
                        post.comment = Int(c.comment)
                        post.has_audio = c.has_audio
                        post.id = (c.id)!
                        post.image1_path = (c.image1_path)!
                        post.image2_path = (c.image2_path)!
                        post.module = (c.module)!
                        post.time = c.time!
                        post.phoneNum = (c.phoneNum)!
                        post.num_of_image = Int(c.num_of_image)
                        
                        self.list_of_all_cherish.append(post)
                    }
                }catch{
                    print("error: 不能获取其他用户主页的发帖信息")
                }
            }
            
        }catch{
            print("post数据获取失败")
        }
    }

    @objc func ontapav(){
        let con=UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "changeboard") as! ChangeController
        con.avtar=UIImageView(image: self.avtar?.image)
        self.navigationController?.pushViewController(con, animated: true)
    }
    @objc func backToPrevious(){
        self.navigationController!.popViewController(animated: true)
    }
    

}
