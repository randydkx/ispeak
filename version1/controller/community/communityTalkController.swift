//
//  communityTalkController.swift
//  ispeak
//
//  Created by mac on 2020/10/4.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit
import CoreData
import ProgressHUD

class communityTalkController:UIViewController,NSFetchedResultsControllerDelegate,UITextFieldDelegate {

  var scroll: UIScrollView?
  var topScroll: UIScrollView?
  @IBOutlet weak var name1: UILabel!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    var currentTopScrollWidth: CGFloat = 8
    @IBOutlet weak var board: UIView!
    var currentItemCount: Int = 0
    @IBOutlet weak var changeBatch: UIButton!
    @IBOutlet weak var label3: UILabel!

    var addButton: UIButton?
    var heightMax: CGFloat = 18
    var lineH: CGFloat = 1
    var titleHeight: CGFloat = 44.0
    var newOrHot: Int = 1
    var buttonGroup: [UIButton] = []
    var buttonGroupState: [Int] = []
    var numOfItem: Int = 0
    var giftButtonGroup: [UIButton] = []
    var hasMessage: [Int] = [0,0,1]
    @IBOutlet weak var numButton1: UIButton!
    @IBOutlet weak var numButton2: UIButton!
    @IBOutlet weak var numButton3: UIButton!
    @IBOutlet weak var numButton5: UIButton!
    @IBOutlet weak var numButton10: UIButton!
//    自定义输入按钮
    @IBOutlet weak var more_text: UITextField!
    
    @IBOutlet weak var buttomBoard: UIView!
    @IBOutlet weak var comfirmButton: UIButton!
    @IBOutlet weak var starBack: UIView!
    @IBOutlet weak var diamondBack: UIView!
    @IBOutlet weak var starNum: UILabel!
    @IBOutlet weak var diamondNum: UILabel!
    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var diamondButton: UIButton!
    
//    发布的信息列表
    var list_of_post: [PostEntity] = []
//    录音播放器
    var audio_player: audioPlay?
//    当前正在播放的对象对应的按钮
    var current_playing_button_tag: Int?
//    播放定时器
    var playing_timer: Timer?
//    表格视图
    var main_table_view: UITableView?
//    手势控制的开始和结束位置
    var start_x: CGFloat?
    var start_y: CGFloat?
    var end_x: CGFloat?
    var end_y: CGFloat?
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
//    头像构成的数组
    var list_of_avatar: [UIImageView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initial_and_setup_UI()
    }
    func clearViews() {
        for v in self.view.subviews as [UIView] {
            v.removeFromSuperview()
        }
    }
    
        func setUI(){
            self.view.backgroundColor=UIColor.init(red: 205.0/255.0, green: 205.0/255.0, blue: 205.0/255.0, alpha: 0.2)
            
          scroll = UIScrollView.init(frame: self.view.frame)
            scroll!.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height*2)
          self.view.addSubview(scroll!)
            self.scroll!.addSubview(name1)
          topScroll = UIScrollView.init(frame: CGRect(x:16,y:59,width:382,height:153))
          topScroll!.contentSize = CGSize(width: 1200, height: topScroll!.frame.height)
          topScroll!.backgroundColor = UIColor.white
          topScroll!.layer.cornerRadius = 30
          topScroll!.layer.masksToBounds = true
//          添加顶部的十二个模块
            scroll?.addSubview(changeBatch)
            scroll?.addSubview(label3)
            scroll?.addSubview(button1)
            scroll?.addSubview(button2)
            scroll!.addSubview(topScroll!)
            for i in 1...12{
                topScroll?.addSubview(createItem(imageName: modules[i].image, topicString: modules[i].title))
            }

            
          topScroll?.showsHorizontalScrollIndicator = false
            
            board.layer.cornerRadius = 30
            board.layer.masksToBounds = true
            scroll?.addSubview(board)
            
            print("总数： \(self.list_of_post.count)")
            for i in 0..<self.list_of_post.count {
                if i != 0{
                    createLine()
                }
                create_post(post: self.list_of_post[i])
            }
            
            addButton  = UIButton(frame: CGRect(x:272,y:291,width:91,height:91))
            addButton?.center = CGPoint(x:350,y:600)
            addButton?.setBackgroundImage(UIImage(named: "添加"), for: .normal)
            addButton?.contentMode = .scaleToFill
            addButton?.addTarget(self, action: #selector(addTalk), for: .touchUpInside)
            let handDrag = UIPanGestureRecognizer(target: self, action: #selector(funDrag))
            addButton?.addGestureRecognizer(handDrag)
            self.view.addSubview(addButton!)
            if newOrHot==0 {
                button1.setTitleColor(UIColor.systemGreen, for: .normal)
                button2.setTitleColor(UIColor.systemGray, for: .normal)
            }else{
                button1.setTitleColor(UIColor.systemGray
                    , for: .normal)
                button2.setTitleColor(UIColor.systemGreen, for: .normal)
            }
            button1.tag = -1
            button2.tag = -2
            button1.addTarget(self, action: #selector(toggle), for: .touchUpInside)
            button2.addTarget(self, action: #selector(toggle), for: .touchUpInside)
            buttomBoard.layer.cornerRadius = 50
            
            more_text.layer.cornerRadius = more_text.frame.height/2
            more_text.layer.masksToBounds = true
            
            numButton1.backgroundColor = UIColor.systemOrange
            numButton1.layer.cornerRadius = numButton1.frame.height/2
            numButton1.layer.masksToBounds = true
            numButton1.tag = 4
            numButton2.layer.cornerRadius = numButton1.frame.height/2
            numButton2.layer.masksToBounds = true
            numButton2.tag = 5
            numButton3.layer.cornerRadius = numButton1.frame.height/2
            numButton3.layer.masksToBounds = true
            numButton3.tag = 6
            numButton5.layer.cornerRadius = numButton1.frame.height/2
            numButton5.layer.masksToBounds = true
            numButton5.tag = 7
            numButton10.layer.cornerRadius = numButton1.frame.height/2
            numButton10.layer.masksToBounds = true
            numButton10.tag = 8
            numButton1.addTarget(self, action: #selector(numButtonClicked), for: .touchUpInside)
            numButton2.addTarget(self, action: #selector(numButtonClicked), for: .touchUpInside)
            numButton3.addTarget(self, action: #selector(numButtonClicked), for: .touchUpInside)
            numButton5.addTarget(self, action: #selector(numButtonClicked), for: .touchUpInside)
            numButton10.addTarget(self, action: #selector(numButtonClicked), for: .touchUpInside)
            self.view.addSubview(buttomBoard)
            
            self.num_button_group = [numButton1,numButton2,numButton3,numButton5,numButton10]
            
            comfirmButton.addTarget(self, action: #selector(comfirmButtonClicked), for: .touchUpInside)
            let clickout = UITapGestureRecognizer(target: self, action: #selector(clickOut))
            scroll?.addGestureRecognizer(clickout)
//            星星按钮的标签是2
//            钻石按钮的标签是3
            starButton.tag = 2
            diamondButton.tag = 3
            starButton.addTarget(self, action: #selector(on_tap), for: .touchUpInside)
            diamondButton.addTarget(self, action: #selector(on_tap), for: .touchUpInside)
            let gesture = UITapGestureRecognizer(target: self, action: #selector(change_selected(tap:)))
            starBack.layer.cornerRadius = 15
            starBack.layer.masksToBounds = true
            starBack.addSubview(starButton)
            starBack.addSubview(starNum)
            diamondBack.layer.cornerRadius = 15
            diamondBack.layer.masksToBounds = true
            diamondBack.addSubview(diamondButton)
            diamondBack.addSubview(diamondNum)
            starBack.backgroundColor = ZHFColor.zhf_color(withRed: 182, green: 238, blue: 230)
//            设置触摸事件
            let gesture2 = UITapGestureRecognizer(target: self, action: #selector(change_selected(tap:)))
            starBack.addGestureRecognizer(gesture2)
            diamondBack.addGestureRecognizer(gesture)
            
//            设置星星和钻石的数量
            diamondNum.text = "\((appUser?.diamond)!)颗"
            starNum.text = "\((appUser?.star)!)颗"
            
            more_text.delegate = self
            more_text.placeholder = "自定义"
            
//            监听bord的收回事件
            self.buttomBoard.isUserInteractionEnabled = true
            let down_drag = UIPanGestureRecognizer(target: self, action: #selector(buttom_out_controller(sender:)))
            buttomBoard.addGestureRecognizer(down_drag)
        }
    @objc func refresh(){
        
    }

//    设置按钮的颜色
    func set_button_color(selected: Int){
        for i in 0..<5{
            if i == selected{
                num_button_group[i].backgroundColor = UIColor.systemOrange
            }else{
                num_button_group[i].backgroundColor = UIColor.white
            }
        }
//        消除更多按钮的颜色
        self.clear_more_text_color()
    }
//    清除所有按钮的颜色
    func clear_all_button_color(){
        for i in 0..<5{
            num_button_group[i].backgroundColor = UIColor.white
        }
    }

//    改变选中的对象
    @objc func change_selected(tap: UITapGestureRecognizer){
        print("tap")
        let point = tap.location(in: self.buttomBoard)
        let x = point.x
        let y = point.y
        if x > starBack.frame.minX && x < starBack.frame.maxX && y > starBack.frame.minY && y < starBack.frame.maxY{
            starBack.backgroundColor = ZHFColor.zhf_color(withRed: 182, green: 238, blue: 230)
            diamondBack.backgroundColor = UIColor.white
            self.selected_gift = 0
            print("选中了星星")
        }
        else if x > diamondBack.frame.minX && x < diamondBack.frame.maxX && y > diamondBack.frame.minY && y < diamondBack.frame.maxY{
            starBack.backgroundColor = UIColor.white
            diamondBack.backgroundColor = ZHFColor.zhf_color(withRed: 182, green: 238, blue: 230)
            self.selected_gift = 1
            print("选中了钻石")
        }
    }
    @objc func buttom_out_controller(sender: UIPanGestureRecognizer){
        let Point = sender.translation(in: self.board);//现对于起始点的移动位置

        if sender.state == .began{
            start_x = Point.x
            start_y = Point.y
        }
        else if sender.state == .ended{
            end_x = Point.x
            end_y = Point.y
            print("start_x: \(start_x)")
            print("start_y: \(start_y)")
            print("end_x: \(end_x)")
            print("end_y: \(end_y)")
            if end_x! - start_x! < 100 && end_x! - start_x! > -100 && end_y! - start_y! > 100{
                more_text.resignFirstResponder()
                self.scroll?.isUserInteractionEnabled = true
                UIView.animate(withDuration: 0.3, animations: {
                    self.scroll!.layer.opacity = 1
                    self.buttomBoard.frame = CGRect(x:0,y:744,width: self.buttomBoard.frame.width,height: self.buttomBoard.frame.height)
                })
//                控制按钮回到初始状态
                self.set_button_color(selected: 0)
                self.user_defined_num = 1
                self.clear_more_text_color()
                self.more_text.text = nil
                starBack.backgroundColor = ZHFColor.zhf_color(withRed: 182, green: 238, blue: 230)
                diamondBack.backgroundColor = UIColor.white
                self.selected_gift = 0
            }
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if more_text.isFirstResponder{
            more_text.resignFirstResponder()
            self.scroll?.isUserInteractionEnabled = true
            self.buttomBoard.frame = CGRect(x: buttomBoard.frame.minX, y: buttomBoard.frame.minY + 150, width: buttomBoard.frame.width, height: buttomBoard.frame.height)
            if more_text.text == nil || more_text.text == ""{
                more_text.text = nil
            }
        }
    }
//    键盘弹出事件
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("should_begin_editing")
        textField.keyboardType = .numberPad
        self.buttomBoard.frame = CGRect(x: buttomBoard.frame.minX, y: buttomBoard.frame.minY - 150, width: buttomBoard.frame.width, height: buttomBoard.frame.height)
        return true
    }
//    搜索数据库并且建立UI界面
//    使用同步方法获取数据
    func initial_and_setup_UI(){
        var tmp_list: [PostEntity] = []
        let context = getContext()
        let entity: NSEntityDescription? = NSEntityDescription.entity(forEntityName: "Post", in: context)
        let request = NSFetchRequest<Post>(entityName: "Post")
//        request.fetchLimit = 10
        request.fetchOffset = 0
        request.entity = entity
        do{
            let result:[AnyObject]? = try context.fetch(request)
            
            print("post总数： \((result?.count)!)")
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
                tmp_list.append(post)
                
                index += 1
            }
            let request2 = NSFetchRequest<User>(entityName: "User")
            for post in tmp_list{
                request2.predicate = NSPredicate(format: "phoneNum='\(post.phoneNum!)'", "")
//                同步获取数据
                do{
                    let user_list:[AnyObject]? = try context.fetch(request2)
    //                设置每条post中的user值
                    for user in user_list as! [User]{
                        post.user = UserEntity.init()
                        post.user?.phoneNum = user.phoneNum
                        post.user?.avatar = user.avatar
                        post.user?.nickname = user.nickname
                        self.list_of_post.append(post)
                    }
                }catch{
                    print("post中通过phonenum获取用户数据失败")
                }
                self.list_of_post.reverse()
                self.cherish_button_state.removeAll()
                for i in 0..<list_of_post.count{
                    let post = list_of_post[i]
                    if has_cherished(postid: post.id!){
                        self.cherish_button_state.append(Int(1))
                    }else {
                        self.cherish_button_state.append(Int(0))
                    }
                }
            }
            
        }catch{
            print("post数据获取失败")
        }
        setUI()
    }
//    判断用户是否点击过这个post
    func has_cherished(postid: String) -> Bool{
        if (appUser?.cherish_set.contains(postid))!{
            return true
        }
        return false
    }
//    星星和钻石的触摸事件
    @objc func on_tap(button: UIButton){
        let tag = button.tag
        print("\(tag)--->on_tap")
        if tag == 2 {
            starBack.backgroundColor = ZHFColor.zhf_color(withRed: 182, green: 238, blue: 230)
            diamondBack.backgroundColor = UIColor.white
            self.selected_gift = 0
        }
        if tag == 3{
            starBack.backgroundColor = UIColor.white
            diamondBack.backgroundColor = ZHFColor.zhf_color(withRed: 182, green: 238, blue: 230)
            self.selected_gift = 1
        }
    }
    @objc func numButtonClicked(button: UIButton){
        let tag = button.tag
        if(tag == 4){
//            并非用户定义
            if !(is_user_defined == nil || is_user_defined == false){
                is_user_defined = false
                self.more_text.text = nil
                self.more_text.placeholder = "自定义"
            }
            set_button_color(selected: 0)
            self.user_defined_num = 1
        }
        else if(tag == 5){
            if !(is_user_defined == nil || is_user_defined == false){
                is_user_defined = false
                self.more_text.text = nil
                self.more_text.placeholder = "自定义"
            }
            set_button_color(selected: 1)
            self.user_defined_num = 2
        }
        else if(tag == 6){
            if !(is_user_defined == nil || is_user_defined == false){
                is_user_defined = false
                self.more_text.text = nil
                self.more_text.placeholder = "自定义"
            }
            set_button_color(selected: 2)
            self.user_defined_num = 3
        }
        else if(tag == 7){
            if !(is_user_defined == nil || is_user_defined == false){
                is_user_defined = false
                self.more_text.text = nil
                self.more_text.placeholder = "自定义"
            }
            set_button_color(selected: 3)
            self.user_defined_num = 5
        }
        else if(tag == 8){
            if !(is_user_defined == nil || is_user_defined == false){
                is_user_defined = false
                self.more_text.text = nil
                self.more_text.placeholder = "自定义"
            }
            set_button_color(selected: 4)
            self.user_defined_num = 10
        }
        print("选择的数量\(self.user_defined_num)")
    }
//    创建横向滚动栏的子内容
  func createItem(imageName: String,topicString: String) -> UIView  {
        let container = UIView(frame: CGRect(x:currentTopScrollWidth,y:22,width:90,height: 105))
        currentTopScrollWidth+=container.frame.width
        currentItemCount+=1
        let imageView = UIImageView(image: UIImage(named: imageName))
        imageView.frame = CGRect(x:13,y:8,width: 63, height: 63)
    
        imageView.contentMode = .scaleToFill
    imageView.layer.cornerRadius = imageView.frame.height/2
        imageView.layer.masksToBounds = true
        container.addSubview(imageView)
        let topic = UILabel(frame: CGRect(x:0,y:84,width:90,height: 17))
        topic.font = UIFont.systemFont(ofSize: 15)
    topic.textAlignment = .center
        topic.textColor = UIColor.gray
        topic.text = topicString
        container.addSubview(topic)
    topScroll?.contentSize = CGSize(width: currentTopScrollWidth+40, height: topScroll!.frame.height)
    return container
  }
    
//    画分割线
    func createLine(){
        let line = UIView(frame: CGRect(x:0,y:heightMax,width:self.board.frame.width*0.9,height: lineH))
           line.backgroundColor = ZHFColor.zhf_color(withRed: 232, green: 233, blue: 232)
           line.center = CGPoint(x:self.board.frame.width/2,y: heightMax+lineH/2)
      line.layer.cornerRadius=lineH/2
        heightMax+=lineH
        self.board.addSubview(line)
    }
//    文本内容变化
    func content_change(content: String) -> NSMutableAttributedString{
//        获得最大33个字的前缀
        let subString = content.prefix(33)
        let start = subString.count + 3
        let length = 2
        let content_extend = subString + "...全文"
        let ans = NSMutableAttributedString(string: String(content_extend), attributes: nil)
//        设置字体
        ans.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 15), range: NSRange(location: 0, length: content_extend.count))
//        设置最后面显示的文字的颜色是绿色
        ans.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init(red: 52.0/255.0, green: 175.0/255.0, blue: 128.0/255.0, alpha: 1), range: NSRange(location: start, length: length))
//        其余文字的颜色是灰色
        ans.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemGray, range: NSRange(location: 0, length: subString.count))
        
        return ans
    }
    @objc func go_to_detail_post_page(sender: UITapGestureRecognizer){
        let view = sender.view!
        let index = view.tag - 4000
        let post = list_of_post[index]
//        print(post.id)
        let con = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "detailpost") as! detailPostController
        con.post = post
        self.navigationController?.pushViewController(con, animated: true)
    }
//    查看主页
    @objc func view_homePage(sender: UITapGestureRecognizer){
        let post = sender.view!
        let tag = post.tag - 10000
        if sender.state == .ended{
            print("avtar --- on_tap tag: \(tag)")
            let phoneNum = self.list_of_post[tag].phoneNum!
            if phoneNum == (appUser?.phoneNum)! {
                self.tabBarController?.selectedIndex = 2
            }else{
                let con = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "othersboard") as! OtherSpaceController
                
                let context = getContext()
                let entity: NSEntityDescription? = NSEntityDescription.entity(forEntityName: "User", in: context)
                let request = NSFetchRequest<User>(entityName: "User")
                
                request.fetchOffset = 0
                request.entity = entity
                request.predicate = NSPredicate(format: "phoneNum='\(phoneNum)'", "")
                
                do{
                    let result:[AnyObject]? = try context.fetch(request)
            
                    for c: User in result as! [User]{
                        let user = UserEntity()
                        user.phoneNum = c.phoneNum
                        user.password = c.password
                        user.nickname = c.nickname
                        user.avatar = c.avatar
                        user.diamond = c.diamond
                        user.star = c.star
                        user.fans = c.fans
                        user.signature = c.signature
                        user.attention = c.attention
                        user.gender = c.gender
                        user.trainCount = c.trainCount
                        
                        
//                            设置别人主页的用户
                        con.user = user
                    }
                    
                }catch{
                    print("to_other_home_page: User数据获取失败")
                }
                
                let entity2: NSEntityDescription? = NSEntityDescription.entity(forEntityName: "Attention", in: context)
                let request2 = NSFetchRequest<Attention>(entityName: "Attention")
                request2.fetchOffset = 0
                request2.entity = entity2
//                查看是否已经关注过这个人
                request2.predicate = NSPredicate(format: "from_phoneNum='\((appUser?.phoneNum)!)' and to_phoneNum='\(phoneNum)'", "")
                
                do{
                    let result:[AnyObject]? = try context.fetch(request2)
                    
                    if result?.count == 0{
                        con.attention_id = nil
                        con.has_attention = false
                        print("没有关注")
                    }
            
                    for c: Attention in result as! [Attention]{
                        print("已经关注")
                        con.attention_id = c.attentionid!
                        con.has_attention =  true
                    }
                    
                }catch{
                    print("to_other_home_page: User数据获取失败")
                }
                self.navigationController?.pushViewController(con, animated: true)
            }
        }
    }
//    通过电话获得用户的全部信息
    
    
    //    创建一个法帖内容
    func create_post(post: PostEntity){
//     有音频+没有图片+有文字
        if (post.has_audio)! && post.num_of_image == 0{
            let lineNum = self.get_line_number(content: post.content!)
            let offset = (lineNum - 1) * 20
            let view = UIView.init(frame: CGRect(x: 8, y: Int(heightMax), width: 366, height: 212 - 30 + offset))
            
            heightMax += view.frame.height
            if heightMax + 291 > self.view.frame.height{
                scroll?.contentSize = CGSize(width: self.view.frame.width, height: heightMax+600)
            }else{
                scroll?.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 100)
            }
            self.board.frame = CGRect(x: board.frame.minX, y: board.frame.minY, width: self.board.frame.width, height: heightMax+40)
            
            
            
            let avatar = UIImageView.init(frame: CGRect(x: 10, y: 10, width: 50, height: 50))
    //        设置头像
            avatar.image = UIImage.init(contentsOfFile: getImageFullPath(post.user!.avatar!))
            avatar.backgroundColor = UIColor.systemGray
            avatar.contentMode = .scaleToFill
            avatar.layer.cornerRadius = avatar.frame.width/2
            avatar.layer.masksToBounds = true
            avatar.tag = 10000 + numOfItem
            let tap_gesture = UITapGestureRecognizer(target: self, action: #selector(view_homePage(sender:)))
            avatar.isUserInteractionEnabled = true
            avatar.addGestureRecognizer(tap_gesture)
            view.addSubview(avatar)
            
            let name_label = UILabel.init(frame: CGRect(x: 75, y: 15, width: 66, height: 20))
            name_label.text = post.user!.nickname!
            name_label.font = UIFont.systemFont(ofSize: 16)
            view.addSubview(name_label)
            
            let time_label = UILabel.init(frame: CGRect(x: 75, y: 39, width: 84, height: 21))
            time_label.text = post.time
            time_label.textColor = UIColor.systemGray
            time_label.font = UIFont.systemFont(ofSize: 14)
            view.addSubview(time_label)
            
            let huang_guan = UIImageView.init(frame: CGRect(x: 156, y: 11, width: 20, height: 20))
            huang_guan.image = UIImage(named: "王冠")
            view.addSubview(huang_guan)
            
            let label = UILabel.init(frame: CGRect(x: 183, y: 11, width: 70, height: 21))
            label.text = "说话达人"
            label.textColor = UIColor.systemOrange
            label.font = UIFont.systemFont(ofSize: 17)
            view.addSubview(label)
            
            let module_label = UILabel.init(frame: CGRect(x: 287, y: 13, width: 66, height: 17))
            module_label.text = "#"+post.module!
            module_label.font = UIFont.systemFont(ofSize: 14)
            module_label.textColor = UIColor.systemGray
            view.addSubview(module_label)
            

            let content_view = UILabel.init(frame: CGRect(x: 5, y: 73, width: 343, height: 21 + offset))
            if lineNum == 1{
                content_view.text = post.content!
                content_view.font = UIFont.systemFont(ofSize: 15)
                content_view.textColor = UIColor.systemGray
            }else {
                content_view.attributedText = content_change(content: post.content!)
            }
            content_view.numberOfLines = lineNum
//            添加双击手势控制
            let gesture = UITapGestureRecognizer(target: self, action: #selector(go_to_detail_post_page(sender:)))
//            设置单个手指双击触发条件
            gesture.numberOfTapsRequired = 2
            gesture.numberOfTouchesRequired = 1
            content_view.addGestureRecognizer(gesture)
            content_view.tag = 4000 + numOfItem
            content_view.isUserInteractionEnabled = true
            view.addSubview(content_view)
            
            let container_small = UIView(frame: CGRect(x: 5, y: 95 + offset, width: 180, height: 44))
            let long_image = UIImageView.init(frame: CGRect(x: 8, y: 4, width: 162, height: 36))
            long_image.image = UIImage(named: "组 1221")
            long_image.contentMode = .scaleToFill
            container_small.addSubview(long_image)
            
            let toPlaybutton = UIButton.init(frame: CGRect(x: 18, y: 10, width: 25, height: 25))
            toPlaybutton.setImage(UIImage(named: "组 1225"), for: .normal)
            toPlaybutton.addTarget(self, action: #selector(toPlayButtonClicked), for: .touchUpInside)
            toPlaybutton.tag = buttonGroup.count
            buttonGroup.append(toPlaybutton)
            buttonGroupState.append(0)
            container_small.addSubview(toPlaybutton)
            let audio_time_label = UILabel.init(frame: CGRect(x: 119, y: 17, width: 39, height: 12))
            audio_time_label.text = int_time_transform(total_time: post.audio_time!)
            audio_time_label.font = UIFont.systemFont(ofSize: 14)
            container_small.addSubview(audio_time_label)
            view.addSubview(container_small)
            
            var bottomView = UIView.init(frame: CGRect(x: 5, y: 175 - 30 + offset, width: 366, height: 28))
            
//            评论按钮
            let button1 = UIButton(frame: CGRect(x:14,y:5,width:22,height: 20))
            button1.setImage(UIImage(named: "评论"), for: .normal)
            button1.addTarget(self, action: #selector(remark_button_clicked(button:)), for: .touchUpInside)
            bottomView.addSubview(button1)
//            点赞按钮
            let button2 = UIButton(frame: CGRect(x:101,y:5,width:22,height: 20))
            button2.setImage(UIImage(named: "收藏"), for: .normal)
//            根据数据库中查找到的用户是否点赞的信息设置按钮的背景颜色
            if cherish_button_state[numOfItem] == 1{
                button2.setImage(UIImage(named: "收 藏(1)"), for: .normal)
                let transform = button2.transform
                button2.transform = transform.scaledBy(x: 1.3, y: 1.3)
            }
            bottomView.addSubview(button2)
            button1.tag = 2000+numOfItem
            button2.tag = 3000+numOfItem
            button2.addTarget(self, action: #selector(cherish_button_clicked(button:)), for: .touchUpInside)
            
    //        数量标签
            let numOfReview = UILabel(frame: CGRect(x:44,y:5,width:47,height: 21))
            numOfReview.text = String(post.comment)
            numOfReview.font = UIFont.systemFont(ofSize: 14)
            numOfReview.textColor = UIColor.systemGray
            bottomView.addSubview(numOfReview)

            
            let numOfCharish = UILabel(frame: CGRect(x:131,y:5,width:47,height: 21))
            numOfCharish.text = String(post.cherish)
            numOfCharish.font = UIFont.systemFont(ofSize: 14)
            numOfCharish.textColor = UIColor.systemGray
            bottomView.addSubview(numOfCharish)
            
            //            保存评论数量和点赞数量的状态的状态
            self.remark_num_text.append(numOfReview)
            self.cherish_num_text.append(numOfCharish)
            
    //        礼物标签
            let sendGiftButton = UIButton(frame: CGRect(x:329,y:8,width:22,height: 20))
            sendGiftButton.contentMode = .scaleToFill
            sendGiftButton.setBackgroundImage(UIImage(named: "礼物 (1)"), for: .normal)
            sendGiftButton.tag = 1000+numOfItem
            numOfItem += 1
        
            sendGiftButton.addTarget(self, action: #selector(sendGiftButtonClicked), for: .touchUpInside)
        
            giftButtonGroup.append(sendGiftButton)
            bottomView.addSubview(sendGiftButton)
            view.addSubview(bottomView)
    //       将当前视图添加到容器中
            self.board.addSubview(view)
        }
//        有音频+有图片
        else if (post.has_audio)! && post.num_of_image! > 0{
            let view_height = 280
            let view = UIView.init(frame: CGRect(x: 8, y: Int(heightMax), width: 366, height: view_height))
            heightMax += view.frame.height
            if heightMax + 291 > self.view.frame.height{
                scroll?.contentSize = CGSize(width: self.view.frame.width, height: heightMax+600)
            }else{
                scroll?.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 100)
            }
            self.board.frame = CGRect(x: board.frame.minX, y: board.frame.minY, width: self.board.frame.width, height: heightMax+40)
            let avatar = UIImageView.init(frame: CGRect(x: 10, y: 10, width: 50, height: 50))
    //        设置头像
            avatar.image = UIImage.init(contentsOfFile: getImageFullPath(post.user!.avatar!))
            avatar.contentMode = .scaleToFill
            avatar.layer.cornerRadius = avatar.frame.width/2
            avatar.layer.masksToBounds = true
            avatar.backgroundColor = UIColor.systemGray
            avatar.tag = 10000 + numOfItem
            let tap_gesture = UITapGestureRecognizer(target: self, action: #selector(view_homePage(sender:)))
            avatar.isUserInteractionEnabled = true
            avatar.addGestureRecognizer(tap_gesture)
            view.addSubview(avatar)
            
            let name_label = UILabel.init(frame: CGRect(x: 75, y: 15, width: 66, height: 20))
            name_label.text = post.user!.nickname!
            name_label.font = UIFont.systemFont(ofSize: 16)
            view.addSubview(name_label)
            
            let time_label = UILabel.init(frame: CGRect(x: 75, y: 39, width: 84, height: 21))
            time_label.text = post.time
            time_label.textColor = UIColor.systemGray
            time_label.font = UIFont.systemFont(ofSize: 14)
            view.addSubview(time_label)
            
            let huang_guan = UIImageView.init(frame: CGRect(x: 156, y: 11, width: 20, height: 20))
            huang_guan.image = UIImage(named: "王冠")
            view.addSubview(huang_guan)
            
            let label = UILabel.init(frame: CGRect(x: 183, y: 11, width: 70, height: 21))
            label.text = "说话达人"
            label.textColor = UIColor.systemOrange
            label.font = UIFont.systemFont(ofSize: 17)
            view.addSubview(label)
            
            let module_label = UILabel.init(frame: CGRect(x: 287, y: 13, width: 66, height: 17))
            module_label.text = "#"+post.module!
            module_label.font = UIFont.systemFont(ofSize: 14)
            module_label.textColor = UIColor.systemGray
            view.addSubview(module_label)
//            设置默认内容
            let content_view = UILabel.init(frame: CGRect(x: 5, y: 73, width: 343, height: 20))
            content_view.text = post.content!
            content_view.font = UIFont.systemFont(ofSize: 15)
            content_view.textColor = UIColor.systemGray
            content_view.numberOfLines = 1
//            添加双击手势控制
            let gesture = UITapGestureRecognizer(target: self, action: #selector(go_to_detail_post_page(sender:)))
//            设置单个手指双击触发条件
            gesture.numberOfTapsRequired = 2
            gesture.numberOfTouchesRequired = 1
            content_view.addGestureRecognizer(gesture)
            content_view.tag = 4000 + numOfItem
            content_view.isUserInteractionEnabled = true
            view.addSubview(content_view)
            
//            添加录音和播放组件
            let container_small = UIView(frame: CGRect(x: 5, y: 125-20, width: 180, height: 44))
            let long_image = UIImageView.init(frame: CGRect(x: 8, y: 4, width: 162, height: 36))
            long_image.image = UIImage(named: "组 1221")
            long_image.contentMode = .scaleToFill
            container_small.addSubview(long_image)
            
            let toPlaybutton = UIButton.init(frame: CGRect(x: 18, y: 10, width: 25, height: 25))
            toPlaybutton.setImage(UIImage(named: "组 1225"), for: .normal)
            toPlaybutton.addTarget(self, action: #selector(toPlayButtonClicked), for: .touchUpInside)
            toPlaybutton.tag = buttonGroup.count
            buttonGroup.append(toPlaybutton)
            buttonGroupState.append(0)
            container_small.addSubview(toPlaybutton)
            let audio_time_label = UILabel.init(frame: CGRect(x: 119, y: 17, width: 39, height: 12))
            audio_time_label.text = int_time_transform(total_time: post.audio_time!)
            audio_time_label.font = UIFont.systemFont(ofSize: 14)
            container_small.addSubview(audio_time_label)
            view.addSubview(container_small)
            
//            添加图片
            let height = 80
            let width = 100
            if post.num_of_image == 1{
                let image1 = UIImageView.init(frame: CGRect(x: 5, y: 155, width: width, height: height))
                image1.image = UIImage.init(contentsOfFile: getImageFullPath((post.image1_path)!))
                image1.layer.cornerRadius = 10
                image1.contentMode = .scaleToFill
                image1.layer.masksToBounds = true
                view.addSubview(image1)
            }
            if post.num_of_image == 2 {
                let image1 = UIImageView.init(frame: CGRect(x: 5, y: 155, width: width, height: height))
                image1.image = UIImage.init(contentsOfFile: getImageFullPath((post.image1_path)!))
                image1.layer.cornerRadius = 10
                image1.contentMode = .scaleToFill
                image1.layer.masksToBounds = true
                view.addSubview(image1)
                let image2 = UIImageView.init(frame: CGRect(x: 5+width+20, y: 155, width: width, height: height))
                image2.image = UIImage.init(contentsOfFile: getImageFullPath((post.image2_path)!))
                image2.layer.cornerRadius = 10
                image2.contentMode = .scaleToFill
                image2.layer.masksToBounds = true
                view.addSubview(image2)
            }
            //        添加评论和点赞按钮
            var bottomView = UIView.init(frame: CGRect(x: 5, y: 240, width: 366, height: 28))
            let button1 = UIButton(frame: CGRect(x:14,y:5,width:22,height: 20))
            button1.addTarget(self, action: #selector(remark_button_clicked(button:)), for: .touchUpInside)
            button1.setImage(UIImage(named: "评论"), for: .normal)
            bottomView.addSubview(button1)
                    
            let button2 = UIButton(frame: CGRect(x:101,y:5,width:22,height: 20))
            button2.setImage(UIImage(named: "收藏"), for: .normal)
            
            if cherish_button_state[numOfItem] == 1{
                button2.setImage(UIImage(named: "收 藏(1)"), for: .normal)
                let transform = button2.transform
                button2.transform = transform.scaledBy(x: 1.3, y: 1.3)
            }
//            设置button的标签以及点赞事件
            button1.tag = 2000+numOfItem
            button2.tag = 3000+numOfItem
            button2.addTarget(self, action: #selector(cherish_button_clicked(button:)), for: .touchUpInside)
            bottomView.addSubview(button2)
            //        数量标签
            let numOfReview = UILabel(frame: CGRect(x:44,y:5,width:47,height: 21))
            numOfReview.text = String(post.comment)
            numOfReview.font = UIFont.systemFont(ofSize: 14)
            numOfReview.textColor = UIColor.systemGray
            bottomView.addSubview(numOfReview)
                    
            let numOfCharish = UILabel(frame: CGRect(x:131,y:5,width:47,height: 21))
            numOfCharish.text = String(post.cherish)
            numOfCharish.font = UIFont.systemFont(ofSize: 14)
            numOfCharish.textColor = UIColor.systemGray
            bottomView.addSubview(numOfCharish)
            
            //            保存评论数量和点赞数量的状态的状态
            self.remark_num_text.append(numOfReview)
            self.cherish_num_text.append(numOfCharish)
                    
            //        礼物标签
            let sendGiftButton = UIButton(frame: CGRect(x:329,y:8,width:22,height: 20))
            sendGiftButton.contentMode = .scaleToFill
            sendGiftButton.setBackgroundImage(UIImage(named: "礼物 (1)"), for: .normal)
            sendGiftButton.tag = 1000+numOfItem
            numOfItem += 1
        
            sendGiftButton.addTarget(self, action: #selector(sendGiftButtonClicked), for: .touchUpInside)
                
            giftButtonGroup.append(sendGiftButton)
            bottomView.addSubview(sendGiftButton)
            
            view.addSubview(bottomView)
            
            self.board.addSubview(view)
        }


//        有图片+无音频
        else if (post.has_audio!) == false && (post.num_of_image)! > 0{
            let line_number = get_line_number(content: (post.content)!)
            let offset = (line_number - 1) * 20
            let view_height = 236
            let view = UIView.init(frame: CGRect(x: 8, y: Int(heightMax), width: 366, height: view_height + offset))
            heightMax += view.frame.height
            if heightMax + 291 > self.view.frame.height{
                scroll?.contentSize = CGSize(width: self.view.frame.width, height: heightMax+600)
            }else{
                scroll?.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 100)
            }
            self.board.frame = CGRect(x: board.frame.minX, y: board.frame.minY, width: self.board.frame.width, height: heightMax+40)
            let avatar = UIImageView.init(frame: CGRect(x: 10, y: 10, width: 50, height: 50))
    //        设置头像
            avatar.image = UIImage.init(contentsOfFile: getImageFullPath(post.user!.avatar!))
            avatar.contentMode = .scaleToFill
            avatar.layer.cornerRadius = avatar.frame.width/2
            avatar.layer.masksToBounds = true
            avatar.backgroundColor = UIColor.systemGray
            avatar.tag = 10000 + numOfItem
            let tap_gesture = UITapGestureRecognizer(target: self, action: #selector(view_homePage(sender:)))
            avatar.isUserInteractionEnabled = true
            avatar.addGestureRecognizer(tap_gesture)
            view.addSubview(avatar)
            
            let name_label = UILabel.init(frame: CGRect(x: 75, y: 15, width: 66, height: 20))
            name_label.text = post.user!.nickname!
            name_label.font = UIFont.systemFont(ofSize: 16)
            view.addSubview(name_label)
            
            let time_label = UILabel.init(frame: CGRect(x: 75, y: 39, width: 84, height: 21))
            time_label.text = post.time
            time_label.textColor = UIColor.systemGray
            time_label.font = UIFont.systemFont(ofSize: 14)
            view.addSubview(time_label)
            
            let huang_guan = UIImageView.init(frame: CGRect(x: 156, y: 11, width: 20, height: 20))
            huang_guan.image = UIImage(named: "王冠")
            view.addSubview(huang_guan)
            
            let label = UILabel.init(frame: CGRect(x: 183, y: 11, width: 70, height: 21))
            label.text = "说话达人"
            label.textColor = UIColor.systemOrange
            label.font = UIFont.systemFont(ofSize: 17)
            view.addSubview(label)
            
            let module_label = UILabel.init(frame: CGRect(x: 287, y: 13, width: 66, height: 17))
            module_label.text = "#"+post.module!
            module_label.font = UIFont.systemFont(ofSize: 14)
            module_label.textColor = UIColor.systemGray
            view.addSubview(module_label)
//            文字板块
            let content_view = UILabel.init(frame: CGRect(x: 5, y: 73, width: 343, height: 21 + offset))
            if line_number == 1{
                content_view.text = post.content!
                content_view.font = UIFont.systemFont(ofSize: 15)
                content_view.textColor = UIColor.systemGray
            }else {
                content_view.attributedText = content_change(content: post.content!)
            }
            content_view.numberOfLines = line_number
            //            添加双击手势控制
                        let gesture = UITapGestureRecognizer(target: self, action: #selector(go_to_detail_post_page(sender:)))
            //            设置单个手指双击触发条件
                        gesture.numberOfTapsRequired = 2
                        gesture.numberOfTouchesRequired = 1
                        content_view.addGestureRecognizer(gesture)
                        content_view.tag = 4000 + numOfItem
                        content_view.isUserInteractionEnabled = true
            view.addSubview(content_view)
            
//            添加图片
            let height = 80
            let width = 100
            if post.num_of_image == 1{
                let image1 = UIImageView.init(frame: CGRect(x: 5, y: 110+offset, width: width, height: height))
                image1.image = UIImage.init(contentsOfFile: getImageFullPath((post.image1_path)!))
                image1.layer.cornerRadius = 10
                image1.contentMode = .scaleToFill
                image1.layer.masksToBounds = true
                view.addSubview(image1)
            }
            if post.num_of_image == 2 {
                 
                let image1 = UIImageView.init(frame: CGRect(x: 5, y: 110+offset, width: width, height: height))
                image1.image = UIImage.init(contentsOfFile: getImageFullPath((post.image1_path)!))
                image1.layer.cornerRadius = 10
                image1.contentMode = .scaleToFill
                image1.layer.masksToBounds = true
                view.addSubview(image1)
                let image2 = UIImageView.init(frame: CGRect(x: 5+width+20, y: 110+offset, width: width, height: height))
                image2.image = UIImage.init(contentsOfFile: getImageFullPath((post.image2_path)!))
                image2.layer.cornerRadius = 10
                image2.contentMode = .scaleToFill
                image2.layer.masksToBounds = true
                view.addSubview(image2)
            }
            //        添加评论和点赞按钮
            var bottomView = UIView.init(frame: CGRect(x: 5, y: 196+offset, width: 366, height: 28))
            let button1 = UIButton(frame: CGRect(x:14,y:5,width:22,height: 20))
            button1.addTarget(self, action: #selector(remark_button_clicked(button:)), for: .touchUpInside)
            button1.setImage(UIImage(named: "评论"), for: .normal)
            bottomView.addSubview(button1)
                    
            let button2 = UIButton(frame: CGRect(x:101,y:5,width:22,height: 20))
            button2.setImage(UIImage(named: "收藏"), for: .normal)
            
            if cherish_button_state[numOfItem] == 1{
                button2.setImage(UIImage(named: "收 藏(1)"), for: .normal)
                let transform = button2.transform
                button2.transform = transform.scaledBy(x: 1.3, y: 1.3)
            }
            button1.tag = 2000+numOfItem
            button2.tag = 3000+numOfItem
            button2.addTarget(self, action: #selector(cherish_button_clicked(button:)), for: .touchUpInside)
            bottomView.addSubview(button2)
            //        数量标签
            let numOfReview = UILabel(frame: CGRect(x:44,y:5,width:47,height: 21))
            numOfReview.text = String(post.comment)
            numOfReview.font = UIFont.systemFont(ofSize: 14)
            numOfReview.textColor = UIColor.systemGray
            bottomView.addSubview(numOfReview)
                    
            let numOfCharish = UILabel(frame: CGRect(x:131,y:5,width:47,height: 21))
            numOfCharish.text = String(post.cherish)
            numOfCharish.font = UIFont.systemFont(ofSize: 14)
            numOfCharish.textColor = UIColor.systemGray
            bottomView.addSubview(numOfCharish)
            
            //            保存评论数量和点赞数量的状态的状态
            self.remark_num_text.append(numOfReview)
            self.cherish_num_text.append(numOfCharish)
                    
            //        礼物标签
            let sendGiftButton = UIButton(frame: CGRect(x:329,y:8,width:22,height: 20))
            sendGiftButton.contentMode = .scaleToFill
            sendGiftButton.setBackgroundImage(UIImage(named: "礼物 (1)"), for: .normal)
            sendGiftButton.tag = 1000+numOfItem
            numOfItem += 1
        
            sendGiftButton.addTarget(self, action: #selector(sendGiftButtonClicked), for: .touchUpInside)
                
            giftButtonGroup.append(sendGiftButton)
            bottomView.addSubview(sendGiftButton)
            
            view.addSubview(bottomView)
            
            self.board.addSubview(view)
        }
//        第四种情况，没有图片+没有音频 = 只有文字
        else if (post.has_audio)! == false && post.content!.count > 0 && post.num_of_image == 0{
            
            let line_number = get_line_number(content: (post.content)!)
            let offset = (line_number - 1)*20
            let view_height = 236-100+20*(line_number - 1)
            let view = UIView.init(frame: CGRect(x: 8, y: Int(heightMax), width: 366, height: view_height))
            heightMax += view.frame.height
            if heightMax + 291 > self.view.frame.height{
                scroll?.contentSize = CGSize(width: self.view.frame.width, height: heightMax+600)
            }else{
                scroll?.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 100)
            }
            self.board.frame = CGRect(x: board.frame.minX, y: board.frame.minY, width: self.board.frame.width, height: heightMax+40)
            let avatar = UIImageView.init(frame: CGRect(x: 10, y: 10, width: 50, height: 50))
    //        设置头像
            avatar.image = UIImage.init(contentsOfFile: getImageFullPath(post.user!.avatar!))
            avatar.contentMode = .scaleToFill
            avatar.layer.cornerRadius = avatar.frame.width/2
            avatar.layer.masksToBounds = true
            avatar.backgroundColor = UIColor.systemGray
            avatar.tag = 10000 + numOfItem
            let tap_gesture = UITapGestureRecognizer(target: self, action: #selector(view_homePage(sender:)))
            avatar.isUserInteractionEnabled = true
            avatar.addGestureRecognizer(tap_gesture)
            view.addSubview(avatar)
            
            let name_label = UILabel.init(frame: CGRect(x: 75, y: 15, width: 66, height: 20))
            name_label.text = post.user!.nickname!
            name_label.font = UIFont.systemFont(ofSize: 16)
            view.addSubview(name_label)
            
            let time_label = UILabel.init(frame: CGRect(x: 75, y: 39, width: 84, height: 21))
            time_label.text = post.time
            time_label.textColor = UIColor.systemGray
            time_label.font = UIFont.systemFont(ofSize: 14)
            view.addSubview(time_label)
            
            let huang_guan = UIImageView.init(frame: CGRect(x: 156, y: 11, width: 20, height: 20))
            huang_guan.image = UIImage(named: "王冠")
            view.addSubview(huang_guan)
            
            let label = UILabel.init(frame: CGRect(x: 183, y: 11, width: 70, height: 21))
            label.text = "说话达人"
            label.textColor = UIColor.systemOrange
            label.font = UIFont.systemFont(ofSize: 17)
            view.addSubview(label)
            
            let module_label = UILabel.init(frame: CGRect(x: 287, y: 13, width: 66, height: 17))
            module_label.text = "#"+post.module!
            module_label.font = UIFont.systemFont(ofSize: 14)
            module_label.textColor = UIColor.systemGray
            view.addSubview(module_label)
//            文字板块
            let content_view = UILabel.init(frame: CGRect(x: 5, y: 73, width: 343, height: 20+(line_number-1)*20))
            if line_number == 1{
                content_view.text = post.content!
                content_view.font = UIFont.systemFont(ofSize: 15)
                content_view.textColor = UIColor.systemGray
            }else {
                content_view.attributedText = content_change(content: post.content!)
            }
            content_view.numberOfLines = line_number
            //            添加双击手势控制
                        let gesture = UITapGestureRecognizer(target: self, action: #selector(go_to_detail_post_page(sender:)))
            //            设置单个手指双击触发条件
                        gesture.numberOfTapsRequired = 2
                        gesture.numberOfTouchesRequired = 1
                        content_view.addGestureRecognizer(gesture)
                        content_view.tag = 4000 + numOfItem
                        content_view.isUserInteractionEnabled = true
            view.addSubview(content_view)
            
            
            
            //        添加评论和点赞按钮
            var bottomView = UIView.init(frame: CGRect(x: 5, y: 96+offset, width: 366, height: 28))
            let button1 = UIButton(frame: CGRect(x:14,y:5,width:22,height: 20))
            button1.addTarget(self, action: #selector(remark_button_clicked(button:)), for: .touchUpInside)
            button1.setImage(UIImage(named: "评论"), for: .normal)
            bottomView.addSubview(button1)
                    
            let button2 = UIButton(frame: CGRect(x:101,y:5,width:22,height: 20))
            button2.setImage(UIImage(named: "收藏"), for: .normal)
            
            if cherish_button_state[numOfItem] == 1{
                button2.setImage(UIImage(named: "收 藏(1)"), for: .normal)
                let transform = button2.transform
                button2.transform = transform.scaledBy(x: 1.3, y: 1.3)
            }
            bottomView.addSubview(button2)
            button1.tag = 2000+numOfItem
            button2.tag = 3000+numOfItem
            button2.addTarget(self, action: #selector(cherish_button_clicked(button:)), for: .touchUpInside)
            
            //        数量标签
            let numOfReview = UILabel(frame: CGRect(x:44,y:5,width:47,height: 21))
            numOfReview.text = String(post.comment)
            numOfReview.font = UIFont.systemFont(ofSize: 14)
            numOfReview.textColor = UIColor.systemGray
            bottomView.addSubview(numOfReview)
                    
            let numOfCharish = UILabel(frame: CGRect(x:131,y:5,width:47,height: 21))
            numOfCharish.text = String(post.cherish)
            numOfCharish.font = UIFont.systemFont(ofSize: 14)
            numOfCharish.textColor = UIColor.systemGray
            bottomView.addSubview(numOfCharish)
            
            //            保存评论数量和点赞数量的状态的状态
            self.remark_num_text.append(numOfReview)
            self.cherish_num_text.append(numOfCharish)
                    
            //        礼物标签
            let sendGiftButton = UIButton(frame: CGRect(x:329,y:8,width:22,height: 20))
            sendGiftButton.contentMode = .scaleToFill
            sendGiftButton.setBackgroundImage(UIImage(named: "礼物 (1)"), for: .normal)
            sendGiftButton.tag = 1000+numOfItem
            numOfItem += 1
        
            sendGiftButton.addTarget(self, action: #selector(sendGiftButtonClicked), for: .touchUpInside)
                
            giftButtonGroup.append(sendGiftButton)
            bottomView.addSubview(sendGiftButton)
            
            view.addSubview(bottomView)
            
            self.board.addSubview(view)
        }
    }
    
//    收藏按钮被点击
    @objc func cherish_button_clicked(button: UIButton){
        let tag = button.tag - 3000
        if cherish_button_state[tag] == 1{
            button.setImage(UIImage(named: "收藏"), for: .normal)
            let transform = button.transform
            ProgressHUD.colorAnimation = .gray
            ProgressHUD.show(icon: AlertIcon.dislike)
            button.transform = transform.scaledBy(x: 10/13, y: 10/13)
            let label = cherish_num_text[tag]
            let number = Int(label.text!)
            label.text = String(number! - 1)
//            执行数据库删除
            self.modify_cherish_info(phoneNum: (appUser?.phoneNum)!, postid: list_of_post[tag].id!,command: "delete",index: tag)
            appUser?.cherish_set.remove(list_of_post[tag].id!)
            
            
        }
        else {
//            设置点赞之后的动画效果
            ProgressHUD.colorAnimation = .red
            ProgressHUD.show(icon: AlertIcon.like)
            let transform = button.transform
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
                button.transform = transform.scaledBy(x: 0.01, y: 0.01)
            }, completion: {
                (finish) in
                button.setImage(UIImage(named: "收 藏(1)"), for: .normal)
                UIView.animate(withDuration: 0.2, animations: {
                    button.transform = transform.scaledBy(x: 1.3, y: 1.3)
                    button.contentMode = .scaleToFill
                }, completion: {
                    (finish) in
                    UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
                        button.transform = transform.scaledBy(x: 2.0, y: 2.0)
                    }, completion: {
                        (finish) in
                        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
                            button.transform = transform.scaledBy(x: 1.3, y: 1.3)
                        }, completion: nil)
                    })
                })
                
            })
            
            let label = cherish_num_text[tag]
            let number = Int(label.text!)
            label.text = String(number! + 1)
//            执行数据库插入
            self.modify_cherish_info(phoneNum: (appUser?.phoneNum)!, postid: list_of_post[tag].id!, command: "insert",index: tag)
            appUser?.cherish_set.insert(list_of_post[tag].id!)
        }
        cherish_button_state[tag] = 1 - cherish_button_state[tag]
        print("onclicked: \(list_of_post[tag].id!)")
    }
    
//删除一条点赞信息
    func modify_cherish_info(phoneNum: String,postid: String,command: String,index: Int){
//        删除一条点赞信息
        if command == "delete"{
            //获取委托
            let app = UIApplication.shared.delegate as! AppDelegate
            //获取数据上下文对象
            let context = getContext()
            //声明数据的请求，声明一个实体结构
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserAllCherish")
            fetchRequest.predicate = NSPredicate(format: "phoneNum='\(phoneNum)' and postid='\(postid)'", "")

            let asyncFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { (result:NSAsynchronousFetchResult) in
                //对返回的数据做处理。
                let fetchObject = result.finalResult! as! [UserAllCherish]
                for c in fetchObject{
                    context.delete(c)
                }
                 app.saveContext()
            }
//            设置post的点赞信息减少一个
            let fetchRequest2 = NSFetchRequest<NSFetchRequestResult>(entityName: "Post")
            fetchRequest2.predicate = NSPredicate(format: "id='\(postid)'", "")

            let asyncFetchRequest2 = NSAsynchronousFetchRequest(fetchRequest: fetchRequest2) { (result:NSAsynchronousFetchResult) in
                //对返回的数据做处理。
                let fetchObject = result.finalResult! as! [Post]
                for c in fetchObject{
                    c.cherish -= 1
                }
                 app.saveContext()
            }

            do {
                try context.execute(asyncFetchRequest)
                try context.execute(asyncFetchRequest2)
                print("cherish数据删除中...")
            } catch  {
                print("error")
            }
        }
//        插入一条点赞信息
        else if command == "insert" {
            let app = UIApplication.shared.delegate as! AppDelegate
            //获取数据上下文对象
            let context = getContext()
            let Entity = NSEntityDescription.entity(forEntityName: "UserAllCherish", in: context)
            let one_cherish = NSManagedObject(entity: Entity!, insertInto: context)
            
            one_cherish.setValue(phoneNum, forKey: "phoneNum")
            one_cherish.setValue(postid, forKey: "postid")
            one_cherish.setValue(get_random_id(), forKey: "cherishid")
            one_cherish.setValue(self.list_of_post[index].phoneNum!, forKey: "to_phoneNum")
            one_cherish.setValue(false, forKey: "ischecked")
            one_cherish.setValue(get_current_time_2(), forKey: "time")
            
//            修改点赞信息，+= 1
            let fetchRequest2 = NSFetchRequest<NSFetchRequestResult>(entityName: "Post")
            fetchRequest2.predicate = NSPredicate(format: "id='\(postid)'", "")

            let asyncFetchRequest2 = NSAsynchronousFetchRequest(fetchRequest: fetchRequest2) { (result:NSAsynchronousFetchResult) in
                //对返回的数据做处理。
                let fetchObject = result.finalResult! as! [Post]
                for c in fetchObject{
                    c.cherish += 1
                }
                 app.saveContext()
            }
           
            do {
                try context.save()
                try context.execute(asyncFetchRequest2)
                print("数据成功插入...")
            }catch{ 
                let error = error as NSError
                fatalError("错误：\(error)\n\(error.userInfo)")
            }
        }
    }
    
//    跳转到添加想法页面
    @objc func addTalk(){
        let VC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "thoughts") as! UIViewController
        self.navigationController?.pushViewController(VC, animated: true)
    }
//    控制最新和最热两个按钮之间的切换
    @objc func toggle(button: UIButton){
        print("toggle:\(button.tag)")
        if button.tag == -1 {
            button1.setTitleColor(UIColor.systemGreen
                , for: .normal)
            button2.setTitleColor(UIColor.systemGray, for: .normal)
        }else{
            button1.setTitleColor(UIColor.systemGray
                , for: .normal)
            button2.setTitleColor(UIColor.systemGreen, for: .normal)
        }
    }
//    点击播放按钮处理事件
    @objc func toPlayButtonClicked(button: UIButton){
        let tag = button.tag
        if buttonGroupState[tag] == 0 {
//            点击之后开始播放录音
//            获取本条发布的信息
            let post_ = list_of_post[tag]
            let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0]
            
            let full_path = "\(docDir)/\(post_.audio_path!)"
            
            self.audio_player = audioPlay.init(path: full_path)
            audio_player?.play_audio()
            self.current_playing_button_tag = tag
            self.playing_timer = Timer.scheduledTimer(timeInterval: TimeInterval(post_.audio_time!), target: self, selector: #selector(recover_button_status), userInfo: nil, repeats: false)
            buttonGroup[tag].setImage(UIImage(named: "组 1222"), for: .normal)
        }else{
//            点击之后停止播放录音
            audio_player?.stop_audio()
            self.audio_player = nil
//            定时器失效
            self.playing_timer?.invalidate()
            self.playing_timer = nil
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
    
//    点击赠送礼物的按钮
    @objc func sendGiftButtonClicked(button: UIButton){
        let tag = button.tag-1000
        send_gift_button_index = tag
        buttomBoard.layer.masksToBounds = false
        buttomBoard.layer.shadowColor = UIColor.black.cgColor
        buttomBoard.layer.shadowOpacity = 0.5
        buttomBoard.layer.shadowOffset = CGSize(width: 5, height: -5)
        buttomBoard.layer.cornerRadius = 30
        self.scroll?.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.3, animations: {
            self.scroll!.layer.opacity = 0.5
            self.buttomBoard.frame = CGRect(x:0,y:300,width: self.buttomBoard.frame.width,height: self.buttomBoard.frame.height)
        })
    }
    
//    弹出视图回收事件
    @objc func clickOut(sender: UITapGestureRecognizer){
        self.scroll?.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.3, animations: {
            self.scroll!.layer.opacity = 1
            self.buttomBoard.frame = CGRect(x:0,y:744,width: self.buttomBoard.frame.width,height: self.buttomBoard.frame.height)
        })
        self.set_button_color(selected: 0)
        self.user_defined_num = 1
        self.clear_more_text_color()
        self.more_text.text = nil
        starBack.backgroundColor = ZHFColor.zhf_color(withRed: 182, green: 238, blue: 230)
        diamondBack.backgroundColor = UIColor.white
        self.selected_gift = 0
    }
    @objc func funDrag(sender: UIPanGestureRecognizer){
           var Point = sender.translation(in: self.view);//现对于起始点的移动位置
           Point = sender.location(in: self.view);//在整个self.view 中的位置
        addButton!.center = CGPoint(x:Point.x,y:Point.y)
           if(sender.state == .began){
               print("begin: "+String(describing: Point.x)+","+String(describing:Point.y))
           }else if(sender.state == .ended){
               print("ended: "+String(describing: Point.x)+","+String(describing:Point.y))
           }else{
               print("ing: "+String(describing: Point.x)+","+String(describing:Point.y))
           }
       }
    
//    点击确认赠送按钮，赠送礼物
    @objc func comfirmButtonClicked(){
        self.scroll?.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.3, animations: {
            self.scroll!.layer.opacity = 1
            self.buttomBoard.frame = CGRect(x:0,y:744,width: self.buttomBoard.frame.width,height: self.buttomBoard.frame.height)
        })
//        赠送礼物
        if self.selected_gift == 0{
            if Int((appUser?.star)!) < self.user_defined_num{
                alert("您的星星数量不够", current: self)
            }else{
                print("将要更改的星星数量：\(self.user_defined_num)")
    //            更改两个用户的星星数量
                modify_user_star_num(phoneNum: (appUser?.phoneNum)!, offset: -user_defined_num)
                if (self.list_of_post[self.send_gift_button_index].phoneNum)! != (appUser?.phoneNum)!{
                    appUser?.star = (appUser?.star)! - Int32(user_defined_num)
                }
                self.starNum.text = "\((appUser?.star)!)颗"
                let record = GiftRecordExtention()
                record.from_phoneNum = (appUser?.phoneNum)!
                record.to_phoneNum = list_of_post[self.send_gift_button_index].phoneNum!
                record.ischecked = false
                record.number = Int32(self.user_defined_num)
//              当前赠送的是星星
                record.starOrDiamond = 0
                
                self.insert_gift_record(record: record)
                ProgressHUD.colorAnimation = .blue
                ProgressHUD.animationType = .circleSpinFade
                self.progress_show(content: "赠送星星")
                modify_user_star_num(phoneNum: list_of_post[self.send_gift_button_index].phoneNum!, offset: user_defined_num)
                print("星星数量修改成功")
            }
        }
        else if self.selected_gift == 1{
            if Int((appUser?.diamond)!) < self.user_defined_num{
                alert("您的钻石数量不够", current: self)
            }else{
//            更改用户的钻石数量
                print("将要更改的钻石数量：\(self.user_defined_num)")
                modify_user_diamond_num(phoneNum: (appUser?.phoneNum)!, offset: -user_defined_num)
                if (self.list_of_post[self.send_gift_button_index].phoneNum)! != (appUser?.phoneNum)!{
                    appUser?.diamond = (appUser?.diamond)! - Int32(user_defined_num)
                }
                self.diamondNum.text = "\((appUser?.diamond)!)颗"
//                添加赠送礼物记录
                let record = GiftRecordExtention()
                record.from_phoneNum = (appUser?.phoneNum)!
                record.to_phoneNum = list_of_post[self.send_gift_button_index].phoneNum!
                record.ischecked = false
                record.number = Int32(self.user_defined_num)
//              当前赠送的是钻石
                record.starOrDiamond = 1
                
                self.insert_gift_record(record: record)
                
                ProgressHUD.colorAnimation = .blue
                ProgressHUD.animationType = .circleSpinFade
                self.progress_show(content: "赠送钻石")
                modify_user_diamond_num(phoneNum: list_of_post[self.send_gift_button_index].phoneNum!, offset: user_defined_num)
                print("钻石数量修改成功")
            }

            
        }
    }
    func progress_show(content: String){
        ProgressHUD.show(content, interaction: true)
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(end), userInfo: nil, repeats: false)
    }
    @objc func end(){
        ProgressHUD.dismiss()
    }
    
//    通过内容获取行高，在展示页面之可能是1和2
    func get_line_number(content: String) -> Int{
        if content.count > 19{
            return 2
        }
        return 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.starNum.text = String((appUser?.star)!)+"颗"
        self.diamondNum.text = String((appUser?.diamond)!)+"颗"
//        clearViews()
//        self.viewDidLoad()
    }
    override func viewDidDisappear(_ animated: Bool) {
        self.scroll?.isUserInteractionEnabled = true
            self.scroll!.layer.opacity = 1
            self.buttomBoard.frame = CGRect(x:0,y:744,width: self.buttomBoard.frame.width,height: self.buttomBoard.frame.height)
    }
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
//    输入事件结束
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        for item in self.num_button_group{
            item.isEnabled=true
        }
        
        if (textField.text?.isEmpty)!{
            self.is_user_defined = false
//            没有输入，默认还是送一个星星
            set_button_color(selected: 0)
            self.more_text.backgroundColor = UIColor.white
            self.user_defined_num = 1
            print("选择的数量： \(self.user_defined_num)")
            return
        }
        let num = Int(textField.text!)!
        
        self.more_text.backgroundColor = UIColor.systemOrange
        
        if self.selected_gift == 0{
            if num < (appUser?.star)!{
                self.user_defined_num = num
                print("选择的数量： \(self.user_defined_num)")
            }
            else{
                alert("星星的数量不够", current: self)
                self.more_text.text = nil
                set_button_color(selected: 0)
            }
        }else if self.selected_gift == 1{
            if num < (appUser?.diamond)!{
                self.user_defined_num = num
                print("选择的数量： \(self.user_defined_num)")
            }else{
                alert("钻石的数量不够", current: self)
                self.more_text.text = nil
                set_button_color(selected: 0)
            }
        }
        
    }
//    输入框开始输入事件
    func textFieldDidBeginEditing(_ textField: UITextField) {
        clear_all_button_color()
        for item in self.num_button_group{
            item.isEnabled=false
        }
        self.more_text.backgroundColor = UIColor.white
    }
    
    
//    消除更多按钮的颜色
    func clear_more_text_color(){
        self.more_text.backgroundColor = UIColor.white
    }
//    改变用户的星星数量
    func modify_user_star_num(phoneNum: String,offset: Int){
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = getContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "phoneNum='\(phoneNum)'", "")
        let asyncFecthRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { (result: NSAsynchronousFetchResult!) in

            let fetchObject  = result.finalResult! as! [User]
            for c in fetchObject{
                c.star = c.star + Int32(offset)
                app.saveContext()
                print("修改之后的星星： \(c.star)")
            }
        }
        // 执行异步请求调用execute
        do {
            try context.execute(asyncFecthRequest)
        } catch  {
            print("error")
        }
    }
//    改变用户的钻石数量
    func modify_user_diamond_num(phoneNum: String,offset: Int){
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = getContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "phoneNum='\(phoneNum)'", "")
        let asyncFecthRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { (result: NSAsynchronousFetchResult!) in

            let fetchObject  = result.finalResult! as! [User]
            for c in fetchObject{
                c.diamond += Int32(offset)
                app.saveContext()
                print("修改之后的钻石: \(c.diamond)")
            }
        }
        // 执行异步请求调用execute
        do {
            try context.execute(asyncFecthRequest)
        } catch  {
            print("error")
        }
    }
    
//    评论按钮被点击
    @objc func remark_button_clicked(button: UIButton){
        print("remark_button_tag: \(button.tag)")
        let index = button.tag - 2000
        let post = list_of_post[index]
        let con = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "detailpost") as! detailPostController
        con.post = post
        self.navigationController?.pushViewController(con, animated: true)
    }
    
//    插入一条送礼物记录
    func insert_gift_record(record: GiftRecordExtention){
        let app = UIApplication.shared.delegate as! AppDelegate
        //获取数据上下文对象
        let context = getContext()
        let Entity = NSEntityDescription.entity(forEntityName: "GiftRecord", in: context)
        let record_to_insert = NSManagedObject(entity: Entity!, insertInto: context)
        
        record_to_insert.setValue(record.id, forKey: "id")
        record_to_insert.setValue(record.from_phoneNum, forKey: "from_phoneNum")
        record_to_insert.setValue(record.to_phoneNum, forKey: "to_phoneNum")
        record_to_insert.setValue(record.ischecked, forKey: "ischecked")
        record_to_insert.setValue(record.starOrDiamond, forKey: "starOrDiamond")
        record_to_insert.setValue(record.number, forKey: "number")
        record_to_insert.setValue(record.time, forKey: "time")
        
        do {
            try context.save()
        }catch{
            let error = error as NSError
            fatalError("添加送礼物信息错误")
        }
    }
}

