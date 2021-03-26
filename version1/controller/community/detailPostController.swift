//
//  detailPostController.swift
//  version1
//
//  Created by mac on 2020/11/6.
//  Copyright © 2020 NJUST. All rights reserved.
//

import UIKit
import CoreData
import ProgressHUD

class detailPostController: UIViewController,UITextFieldDelegate,UIScrollViewDelegate,NSFetchedResultsControllerDelegate {
    
    var post = PostEntity()
    
    @IBOutlet weak var scroll: UIScrollView!
    //    组件背后的背景
    @IBOutlet weak var back: UIView!
//    帖子基本信息
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var name_label: UILabel!
    @IBOutlet weak var time_label: UILabel!
    @IBOutlet weak var module_label: UILabel!
    @IBOutlet weak var post_content: UILabel!
//    播放
    @IBOutlet weak var toPlayButton: UIButton!
//    录音时间
    @IBOutlet weak var audio_time: UILabel!
//    评论按钮
    @IBOutlet weak var remark_button: UIButton!
//    评论数量
    @IBOutlet weak var remark_label: UILabel!
//    点赞按钮
    @IBOutlet weak var cherish_button: UIButton!
//    点赞数量
    @IBOutlet weak var cherish_label: UILabel!
//    送礼物按钮
    @IBOutlet weak var sendGiftButton: UIButton!
//    评论数量
    @IBOutlet weak var remark_label_2: UILabel!
//    编辑评论框
    @IBOutlet weak var send_message: UITextField!
//    发送评论按钮
    @IBOutlet weak var send_button: UIButton!
//    键盘高度
    var margin: CGFloat = 0
//    键盘是否弹出
    var is_keyboard_pop_out: Bool = false

    
    
//    当前scrollview中已经填充的高度
    var heightMax: CGFloat = 5
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
//    建立UI界面
    func setupUI(){
//        更改导航栏
        self.navigationController?.navigationBar.isHidden=false
        let tit=UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        tit.text="动态详情"
        tit.textAlignment = .center
        tit.font=UIFont.systemFont(ofSize: 20)
        self.navigationItem.titleView=tit
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        let item = UIBarButtonItem(image: UIImage(named: "返回2")?.reSizeImage(reSize: CGSize(width: 32, height: 32)).withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(backToPrevious))
        self.navigationItem.leftBarButtonItems = [item]
        self.navigationController?.navigationBar.tintColor=UIColor.black
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.backgroundColor=UIColor.clear
        
        self.scroll.delegate = self
        
//        设置帖子的主体内容
        avatar.backgroundColor = UIColor.systemGray
        avatar.layer.cornerRadius = avatar.frame.width / 2
        avatar.layer.masksToBounds = true
        avatar.contentMode = .scaleToFill
        avatar.image = UIImage(contentsOfFile: getImageFullPath((self.post.user?.avatar)!))
        name_label.text = (self.post.user?.nickname)!
        time_label.text = self.post.time
        module_label.text = "#"+(self.post.module)!
        audio_time.text = int_time_transform(total_time: (self.post.audio_time)!)
        post_content.text = post.content
        let post_line = line_number(content: post.content!)
        print("line_number: \(post_line)")
        post_content.numberOfLines = post_line
        post_content.frame = CGRect(x: self.post_content.frame.minX, y: self.post_content.frame.minY, width: self.post_content.frame.width, height: CGFloat(29 + (post_line - 1) * 20))
        
        heightMax = post_content.frame.maxY
        
        if post.num_of_image! >= 1{
            let image1 = UIImageView(frame: CGRect(x: 10, y: self.heightMax, width: 397, height: 397 * 0.8))
            image1.image = UIImage(named: getImageFullPath(self.post.image1_path!))
            image1.layer.cornerRadius = 20
            image1.layer.masksToBounds = true
            self.heightMax += image1.frame.height + 10
            self.scroll.addSubview(image1)
        }
        if post.num_of_image! >= 2{
            let image1 = UIImageView(frame: CGRect(x: 10, y: self.heightMax, width: 397, height: 397 * 0.8))
            image1.image = UIImage(named: getImageFullPath(self.post.image2_path!))
            image1.layer.cornerRadius = 20
            image1.layer.masksToBounds = true
            self.heightMax += image1.frame.height + 10
            self.scroll.addSubview(image1)
        }
//        设置背景板的位置
        back.frame = CGRect(x: self.back.frame.minX, y: heightMax, width: back.frame.width, height: back.frame.height)
        self.heightMax = back.frame.maxY + 30
        
        print("back_frame: \(self.heightMax)")
        
        self.cherish_label.text = "\(post.cherish)"
        self.remark_label.text = "\(post.comment)"
        self.remark_label_2.text = "评论： \(post.comment)"
        
        
        print("添加评论之前的heightmax： \(self.heightMax)")
        
        self.get_all_remark()
        
//       底部发送评论框
        self.send_message.layer.cornerRadius = send_message.layer.bounds.height / 2
        self.send_message.layer.masksToBounds = true
        self.send_message.delegate = self
        self.send_message.layer.borderWidth = 0
        self.send_message.layer.borderColor = UIColor.init(red: 236.0 / 255.0, green: 236.0 / 255.0, blue: 236.0 / 255.0, alpha: 1).cgColor
        self.send_message.placeholder = "                           请输入评论内容"
        self.send_message.backgroundColor = UIColor.init(red: 236.0 / 255.0, green: 236.0 / 255.0, blue: 236.0 / 255.0, alpha: 1)
        send_message.keyboardType = .default
        
        
        send_button.addTarget(self, action: #selector(send), for: .touchUpInside)
        
//        键盘弹出检测
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(handle_keyboard(node:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
    }
//    处理键盘通知
    @objc func handle_keyboard(node: Notification){
        if  !self.is_keyboard_pop_out {
            print(node.userInfo ?? "")
            let duration = node.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
            let endFrame = (node.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            let y = endFrame.origin.y
                    
            //3计算工具栏距离底部的间距
            self.margin = UIScreen.main.bounds.height - y
            
            //4.执行动画
            UIView.animate(withDuration: duration) {
                self.view.frame = CGRect(x: self.view.frame.minX, y: self.view.frame.minY - self.margin + 52, width: self.view.frame.width, height: self.view.frame.height)
                self.view.layoutIfNeeded()
            }
            self.is_keyboard_pop_out = true
        }
        
    }
//    跳转到之前的viewcontroller
    @objc func backToPrevious(){
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
//   发送消息
    @objc func send(){
        send_message.resignFirstResponder()
        self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.layoutIfNeeded()
        self.is_keyboard_pop_out = false
        self.send_message.backgroundColor = UIColor.init(red: 236.0 / 255.0, green: 236.0 / 255.0, blue: 236.0 / 255.0, alpha: 1)
        if !(self.send_message.text == nil || self.send_message.text == ""){
            print(self.send_message.text)
//            构造评论
            let remark = RemarkEntity()
            remark.remarkid = get_random_id()
            remark.content = self.send_message.text!
            remark.user = appUser!
            remark.time = get_current_time_2()
            remark.from_phoneNum = (appUser?.phoneNum)!
            remark.to_phoneNum = (post.phoneNum)!
            remark.postid = (self.post.id)!
            remark.ischecked = false
            
            remark.show()
            
            createRemark(remark: remark)
            self.send_message.text = nil
            ProgressHUD.showSuccess()
            self.insert_remark(remark: remark)
            post.comment += 1
            self.remark_label.text = "\(post.comment)"
            self.remark_label_2.text = "评论： \(post.comment)"
        }else {
            alert("请输入评论内容", current: self)
        }
    }
//    开始播放录音
    @objc func toPlayButtonClicked(){
        
    }
//    计算行数
    func line_number(content: String) -> Int{
        let count = Double(content.count)
        return Int(ceil(Double(count / 22.0)))
    }
    
//    构造一条评论
    func createRemark(remark: RemarkEntity){
        let line = line_number(content: remark.content)
        let offset = CGFloat((line - 1) * 20)
        print("rermark: height : \(self.heightMax)")
        let view = UIView(frame: CGRect(x: 8, y: heightMax, width: 398, height: 91 + offset))
        heightMax += view.frame.height
//        设置评论者头像
        let avatarView = UIImageView(frame: CGRect(x: 8, y: 8, width: 40, height: 40))
        avatarView.image = UIImage(contentsOfFile: getImageFullPath((remark.user?.avatar)!))
        avatarView.layer.cornerRadius = avatarView.frame.width / 2
        avatarView.layer.masksToBounds = true
        avatarView.backgroundColor = UIColor.systemGray
        view.addSubview(avatarView)
//        评论者姓名
        let name_label = UILabel(frame: CGRect(x: 56, y: 8, width: 228, height: 21))
        name_label.font = UIFont.systemFont(ofSize: 14)
        name_label.textColor = UIColor.black
        name_label.text = (remark.user?.nickname)!
        view.addSubview(name_label)
//        评论时间
        let time_label = UILabel(frame: CGRect(x: 56, y: 29, width: 71, height: 21))
        time_label.text = remark.time
        time_label.font = UIFont.systemFont(ofSize: 13)
        time_label.textColor = UIColor.systemGray
        view.addSubview(time_label)
//        评论内容
        let remark_view = UILabel(frame: CGRect(x: 56, y: 50, width: 326, height: 30 + offset))
        remark_view.textColor = UIColor.systemGray
        remark_view.font = UIFont.systemFont(ofSize: 14)
        remark_view.numberOfLines = line
        remark_view.text = remark.content
        view.addSubview(remark_view)
        
        self.scroll.addSubview(view)
        print("heightmax: \(self.heightMax)")
        if heightMax + 100 < self.view.frame.height{
            self.scroll.contentSize = CGSize(width: self.scroll.frame.width, height: self.view.frame.height * 0.9)
        }else{
            self.scroll.contentSize = CGSize(width: self.scroll.frame.width, height: heightMax + 100)
        }

    }
    
    func get_all_remark(){
        let context = getContext()
        let entity: NSEntityDescription? = NSEntityDescription.entity(forEntityName: "Remark", in: context)
        let request = NSFetchRequest<Remark>(entityName: "Remark")
//        查询当前发帖的所有评论
        request.predicate = NSPredicate(format: "postid='\(self.post.id!)'", "")
        request.fetchOffset = 0
        request.entity = entity
        do{
            let result:[AnyObject]? = try context.fetch(request)
            
            print("Remark总数： \((result?.count)!)")
            if result?.count == 0{
                if heightMax < self.view.frame.height * 0.9{
                    self.scroll.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height * 0.9)
                }else {
                    self.scroll.contentSize = CGSize(width: self.view.frame.width, height: heightMax + 100)
                }
            }
            var index = 0
            for c: Remark in result as! [Remark]{
                let remark = RemarkEntity()
                remark.content = c.content!
                remark.time = c.time!
                remark.user = UserEntity()
                let entity2: NSEntityDescription? = NSEntityDescription.entity(forEntityName: "User", in: context)
                let request2 = NSFetchRequest<User>(entityName: "User")
                request2.predicate = NSPredicate(format: "phoneNum=\(c.to_phoneNum!)", "")
                request.fetchOffset = 0
                request.entity = entity2
                do {
                    let result: [AnyObject]? = try context.fetch(request2)
                    for c in result as! [User]{
                        remark.user?.avatar = c.avatar!
                        remark.user?.nickname = c.nickname!
                    }
                }
//                remark.show()
                self.createRemark(remark: remark)
                index += 1
            }
            
        }catch{
            print("post数据获取失败")
        }
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.send_message.backgroundColor = UIColor.init(red: 240.0 / 255.0, green: 240.0 / 255.0, blue: 240.0 / 255.0, alpha: 1)
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if self.is_keyboard_pop_out{
            
            send_message.resignFirstResponder()
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            self.view.layoutIfNeeded()
            self.is_keyboard_pop_out = false
            self.send_message.backgroundColor = UIColor.init(red: 236.0 / 255.0, green: 236.0 / 255.0, blue: 236.0 / 255.0, alpha: 1)
        }
    }
//    插入一条评论
    func insert_remark(remark: RemarkEntity){
        let context = getContext()
        let Entity = NSEntityDescription.entity(forEntityName: "Remark", in: context)
        let remarkEntity = NSManagedObject(entity: Entity!, insertInto: context)
        
//        设置更改实体的属性等
        remarkEntity.setValue(remark.remarkid, forKey: "remarkid")
        remarkEntity.setValue(remark.content, forKey: "content")
        remarkEntity.setValue(remark.from_phoneNum, forKey: "from_phoneNum")
        remarkEntity.setValue(remark.to_phoneNum, forKey: "to_phoneNum")
        remarkEntity.setValue(remark.postid, forKey: "postid")
        remarkEntity.setValue(remark.time, forKey: "time")
        remarkEntity.setValue(remark.ischecked, forKey: "ischecked")
    
        do {
            try context.save()
            self.modify_post_comment(postid: remark.postid)
        }catch{
            let error = error as NSError
            fatalError("插入评论出错：\(error)\n\(error.userInfo)")
        }
    }
//    改变帖子的点赞数量
    func modify_post_comment(postid: String){
        //获取委托
        let app = UIApplication.shared.delegate as! AppDelegate
        //获取数据上下文对象
        let context = getContext()
        //声明数据的请求，声明一个实体结构
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Post")
        //查询条件
        fetchRequest.predicate = NSPredicate(format: "id='\(postid)'", "")
        let asyncFecthRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { (result: NSAsynchronousFetchResult!) in
            //对返回的数据做处理。
            let fetchObject  = result.finalResult! as! [Post]
            for c in fetchObject{
                c.comment += 1
                app.saveContext()
            }
        }
        // 执行异步请求调用execute
        do {
            try context.execute(asyncFecthRequest)
            print("修改评论数量成功")
        } catch  {
            print("error")
        }
    }
    override func viewDidAppear(_ animated: Bool) {
      self.navigationController?.isNavigationBarHidden = false
  //    self.navigationController?.isToolbarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
      self.navigationController?.isNavigationBarHidden =  false
  //    self.navigationController?.isToolbarHidden = true
    }
    override func viewDidDisappear(_ animated: Bool) {
      self.navigationController?.isNavigationBarHidden =  false
  //    self.navigationController?.isToolbarHidden = true
    }
}
