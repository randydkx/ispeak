//
//  TrainViewController.swift
//  ispeak
//
//  Created by mac on 2020/10/1.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit
import CoreData

extension UIImage {
    /**
     *  重设图片大小
     */
    func reSizeImage(reSize:CGSize)->UIImage {
        //UIGraphicsBeginImageContext(reSize);
        UIGraphicsBeginImageContextWithOptions(reSize,false,UIScreen.main.scale);
        self.draw(in: CGRect(x: 0, y: 0, width: reSize.width, height: reSize.height));
        let reSizeImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        return reSizeImage
//        return reSizeImage.withRenderingMode(.alwaysOriginal);
    }
    /**
     *  等比率缩放
     */
    func scaleImage(scaleSize:CGFloat)->UIImage {
        let reSize = CGSize(width: self.size.width * scaleSize, height: self.size.height * scaleSize)
        return reSizeImage(reSize: reSize)
    }
    
    func toCircle() -> UIImage {
        //取最短边长
        let shotest = min(self.size.width, self.size.height)
//        let shotest=CGFloat(20.0)
        //输出尺寸
        let outputRect = CGRect(x: 0, y: 0, width: shotest, height: shotest)
        //开始图片处理上下文（由于输出的图不会进行缩放，所以缩放因子等于屏幕的scale即可）
        UIGraphicsBeginImageContextWithOptions(outputRect.size, false, 0)
        let context = UIGraphicsGetCurrentContext()!
        //添加圆形裁剪区域
        context.addEllipse(in: outputRect)
        context.clip()
        //绘制图片
        self.draw(in: CGRect(x: (shotest-self.size.width)/2,
                              y: (shotest-self.size.height)/2,
                              width: self.size.width,
                              height: self.size.height))
        //获得处理后的图片
        let maskedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return maskedImage
    }
}

class TrainViewController:UIViewController,NSFetchedResultsControllerDelegate {

  var x:UILabel?
  
    
    var focused = 1
    
    @IBOutlet weak var scroll: UIScrollView!
    
    @IBOutlet weak var contentView: UIView!
    
//    开始和结束位置记录
    var start_x: CGFloat = 0
    var start_y: CGFloat = 0
    var end_x: CGFloat = 0
    var end_y: CGFloat = 0
//    在最上面的view
//    模块数组
    let modules: [module] = [module(),module1,module2,module3,module4,module5,module6,module7,module8,module9,module10,module11,module12]
//    被点击的模块
    var module_being_clicked: Int?
   
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var view5: UIView!
    @IBOutlet weak var view6: UIView!
    @IBOutlet weak var view7: UIView!
    @IBOutlet weak var view8: UIView!
    @IBOutlet weak var view9: UIView!
    @IBOutlet weak var view10: UIView!
    @IBOutlet weak var view11: UIView!
    @IBOutlet weak var view12: UIView!
//    十二个视图组成的数组
    var list_of_card: [UIView] = []
    
  override func viewDidLoad() {
        super.viewDidLoad()
    self.scroll.backgroundColor = ZHFColor.zhf_color(withRed: 255, green: 255, blue: 255)
    self.contentView.backgroundColor = ZHFColor.zhf_color(withRed: 255, green: 255, blue: 255)
    
    self.navigationController?.navigationBar.backgroundColor=UIColor.clear

    
    self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 21)]

    
    let gesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(change_view(sender:)))
    gesture.edges = .right
    self.view.addGestureRecognizer(gesture)
    
    
            self.view.backgroundColor = ZHFColor.white
    
        //去掉（重设）NavigationBar上的背景图片
        let item1 = UIBarButtonItem(image: UIImage(named: "历史记录")?.reSizeImage(reSize: CGSize(width: 25, height: 10)), style: .plain, target: self, action: #selector(click1))
        let item2 = UIBarButtonItem(image: UIImage(named: "设")?.reSizeImage(reSize: CGSize(width: 25, height: 25)), style: .plain, target: self, action: #selector(tosetting))
    
//    item2.target=self
//    item2.action=#selector(tosetting)
    
        self.navigationItem.leftBarButtonItems = [item1]
        self.navigationItem.rightBarButtonItems = [item2]
        self.navigationController?.navigationBar.tintColor=UIColor.gray
    
    
    
//    生成[1,12]之间的随机整数
        self.focused = Int.randomIntNumber(range: Range(NSRange(location: 1, length: 12))!)
    //    设置卡片的堆叠效果
        let view2 = genarate_card(mod: modules[self.focused % 12 + 1], frame: CGRect(x: 0, y: 124 + 6, width: 414, height: 216))
        contentView.addSubview(view2)
        let view1 = genarate_card(mod: modules[self.focused], frame: CGRect(x: 0, y: 124, width: 414 ,height: 216))
        contentView.addSubview(view1)
        contentView.removeFromSuperview()
        view1.tag = self.focused
        view2.tag = self.focused % 12 + 1
        
        self.scroll.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height * 3)

        self.scroll.addSubview(contentView)
        
        list_of_card.append(self.view1)
        list_of_card.append(self.view2)
        list_of_card.append(view3)
        list_of_card.append(view4)
        list_of_card.append(view5)
        list_of_card.append(view6)
        list_of_card.append(view7)
        list_of_card.append(view8)
        list_of_card.append(view9)
        list_of_card.append(view10)
        list_of_card.append(view11)
        list_of_card.append(view12)
        
        var index = 100
        for view in list_of_card{
            index += 1
            view.tag = index
            view.layer.cornerRadius = 20
            view.layer.masksToBounds = true
            view.backgroundColor = UIColor.white
            let gesture = UITapGestureRecognizer(target: self, action: #selector(go_to_given_module(sender:)))
            view.addGestureRecognizer(gesture)
        }
    
        

    }
    @objc func tosetting(){
        let con = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "settingboard")
        self.navigationController?.pushViewController(con, animated: true)
    }
    
//    触摸事件跳转到指定的模块
    @objc func go_to_given_module(sender: UITapGestureRecognizer){
        let view = sender.view!
        let tag = view.tag - 100
        if sender.state == .ended{
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "starttrainboard") as! StartTrainingController
            vc.focused = tag
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
//    切换视图
    @objc func change_view(sender: UIScreenEdgePanGestureRecognizer){
        if sender.state == .ended{
            self.tabBarController?.selectedIndex = 1
        }
    }
//    通过模块和位置生成卡片
    func genarate_card(mod: module,frame: CGRect) -> UIView{
        let view = UIView.init(frame: frame)
        let back = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        back.image = UIImage.init(named: "组 1290")
        view.addSubview(back)
        let title = UILabel(frame: CGRect(x: 51, y: 38, width: 150, height: 36))
        title.text = mod.title
        title.font = UIFont.boldSystemFont(ofSize: 32)
        title.textColor = UIColor.white
        view.addSubview(title)
        
        let title2 = UILabel(frame: CGRect(x: 51, y: 84, width: 180, height: 21))
        title2.text = "语音可包含以下内容"
        title2.font = UIFont.systemFont(ofSize: 17)
        title2.textColor = UIColor.white
        view.addSubview(title2)
        
        let view1 = UIView(frame: CGRect(x: 42, y: 113, width: 70, height: 34))
        let t1 = UIImageView.init(frame: CGRect(x: 8, y: 9, width: 18, height: 18))
        t1.image = UIImage(named: "组 1233")
        t1.contentMode = .scaleAspectFit
        view1.addSubview(t1)
        let m1 = UILabel(frame: CGRect(x: 27, y: 7, width: 46, height: 20))
        m1.text = mod.word1
        m1.font = UIFont.boldSystemFont(ofSize: 18)
        m1.textColor = UIColor.white
        view1.addSubview(m1)
        view.addSubview(view1)
        
        let view2 = UIView(frame: CGRect(x: 42, y: 145, width: 70, height: 34))
        let t2 = UIImageView.init(frame: CGRect(x: 8, y: 9, width: 18, height: 18))
        t2.image = UIImage(named: "组 1233")
        t2.contentMode = .scaleAspectFit
        view2.addSubview(t2)
        let m2 = UILabel(frame: CGRect(x: 27, y: 7, width: 46, height: 20))
        m2.text = mod.word2
        m2.font = UIFont.boldSystemFont(ofSize: 18)
        m2.textColor = UIColor.white
        view2.addSubview(m2)
        view.addSubview(view2)
        
        let view3 = UIView(frame: CGRect(x: 119, y: 113, width: 70, height: 34))
        let t3 = UIImageView.init(frame: CGRect(x: 8, y: 9, width: 18, height: 18))
        t3.image = UIImage(named: "组 1233")
        t3.contentMode = .scaleAspectFit
        view3.addSubview(t3)
        let m3 = UILabel(frame: CGRect(x: 27, y: 7, width: 46, height: 20))
        m3.text = mod.word3
        m3.font = UIFont.boldSystemFont(ofSize: 18)
        m3.textColor = UIColor.white
        view3.addSubview(m3)
        view.addSubview(view3)
        
        let view4 = UIView(frame: CGRect(x: 119, y: 145, width: 70, height: 34))
        let t4 = UIImageView.init(frame: CGRect(x: 8, y: 9, width: 18, height: 18))
        t4.image = UIImage(named: "组 1233")
        t4.contentMode = .scaleAspectFit
        view4.addSubview(t4)
        let m4 = UILabel(frame: CGRect(x: 27, y: 7, width: 46, height: 20))
        m4.text = mod.word4
        m4.font = UIFont.boldSystemFont(ofSize: 18)
        m4.textColor = UIColor.white
        view4.addSubview(m4)
        view.addSubview(view4)
        
        let button = UIButton(frame: CGRect(x: 240, y: 97, width: 140, height: 68))
        button.setImage(UIImage(named: "组 1287"), for: .normal)
        button.contentMode = .center
        button.addTarget(self, action: #selector(startTrainingButtonClicked(_:)), for: .touchUpInside)
        view.addSubview(button)
        
        let drag_down = UIPanGestureRecognizer(target: self, action: #selector(switch_card(sender:)))
        view.addGestureRecognizer(drag_down)

        return view
    }

    
//    卡片的切换
    @objc func switch_card(sender: UIPanGestureRecognizer){
        let tag = self.focused
        let view = self.view.viewWithTag(tag)!
        let Point = sender.location(in: self.contentView);
        if sender.state == .began{
            start_x = Point.x
            start_y = Point.y
            let transform = view.transform
            view.transform = transform.scaledBy(x: 0.95, y: 0.95)
        }
        else if sender.state == .changed{
            view.center = CGPoint(x: Point.x, y: Point.y)
            
        }
        else if sender.state == .ended{
            end_x = Point.x
            end_y = Point.y
            let valid_code = check_valid()
            if valid_code == 0{
                let transform = view.transform
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
                    view.transform = transform.scaledBy(x: 20/19, y: 20/19)
                }, completion: {
                    (finish) in
                    UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                        view.frame = CGRect(x: 0, y: 124, width: 414, height: 216)
                        
                    }, completion: {
                        (finish) in
                    })
                })
            }
            else if valid_code > 0{
                UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveEaseOut, animations: {
                    if valid_code == 1{
                        view.frame = CGRect(x: view.frame.minX, y: view.frame.minY - 100, width: view.frame.width, height: view.frame.height)
                    }
                    else if valid_code == 2{
                        view.frame = CGRect(x: view.frame.minX, y: view.frame.minY + 100, width: view.frame.width, height: view.frame.height)
                    }
                    else if valid_code == 3{
                        view.frame = CGRect(x: view.frame.minX - 420, y: view.frame.minY , width: view.frame.width, height: view.frame.height)
                    }
                    else if valid_code == 4{
                        view.frame = CGRect(x: view.frame.minX + 420, y: view.frame.minY , width: view.frame.width, height: view.frame.height)
                    }
                }, completion: {
                    (finish) in
                    print("animation out")
                    view.removeFromSuperview()
                    let back_view = self.genarate_card(mod: self.modules[(self.focused+1) % 12 + 1],frame: CGRect(x: 0, y: 124 + 6, width: 414, height: 216))
                    back_view.tag = (self.focused+1) % 12 + 1
                    
                    let nexttag = (self.focused) % 12 + 1
                    
                    let nextview = self.view.viewWithTag(nexttag)!
                    print("nexttag: \(nexttag)")
                    self.contentView.insertSubview(back_view, belowSubview: nextview)
                    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                        nextview.frame = CGRect(x: 0, y: 124, width: 414, height: 216)
                    }, completion: nil)
                    
                    self.focused = nexttag
                })
            }
        }
        
    }
    
//    检测收拾移动是否合法
    func check_valid() -> Int{
//        向上滑动
        if end_y - start_y < -50 && end_x - start_x > -100 && end_x - start_x < 100{
            return 1
        }
//        向下滑动
        if end_y - start_y > 50 && end_x - start_x > -100 && end_x - start_x < 100{
            return 2
        }
//        向左滑动
        if end_x - start_x < -100 && end_y - start_y > -100 && end_y - start_y < 100{
            return 3
        }
//        向右滑动
        if end_x - start_x > 100 && end_y - start_y > -100 && end_y - start_y < 100{
            return 4
        }
        return 0
    }
  
    override func viewWillAppear(_ animated: Bool){
//        self.scroll!.contentSize = CGSize(width: self.view.frame.width ,height: self.view.frame.height*3)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.isNavigationBarHidden = false
      self.navigationController?.navigationBar.shadowImage = UIImage()
      //去掉（重设）NavigationBar上的一条线
      self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
      //去掉（重设）NavigationBar上的背景图片
      self.navigationController?.navigationBar.tintColor=UIColor.gray
        
//        搜索并更新数据库内容
        self.update_post_count_info()
    }
//    更新训练次数信息
    func update_post_count_info(){
        let context = getContext()
        for i in 1...12{
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Module")
            fetchRequest.predicate = NSPredicate(format: "id=\(i)", "")
    //        异步请求的回调函数
            let asyncFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest){
                (result: NSAsynchronousFetchResult!) in
                let fetchObject = result.finalResult as! [Module]
//                最初没有插入过模块训练数据，在这个app产生中之执行一次
                if fetchObject.count == 0{
                    self.insert_module_info(i: i)
                    let label = self.list_of_card[i - 1].viewWithTag(100) as! UILabel
                    label.text = String(Int(0))
                }
                    for c in fetchObject{
                        let label = self.list_of_card[i - 1].viewWithTag(100) as! UILabel
                        label.text = String(Int(c.post_count))
                    }
            }
            do {
                try context.execute(asyncFetchRequest)
            }catch {
                print("ERROR ==== LoginController: getUserByPhoneNum: 无法执行异步查询语句")
            }
        }
        
    }
//    初始化训练数据
    func insert_module_info(i: Int){
            let context = getContext()
            let Entity = NSEntityDescription.entity(forEntityName: "Module", in: context)
            let ModuleEntity = NSManagedObject(entity: Entity!, insertInto: context)
            
    //        设置更改实体的属性等
            
            ModuleEntity.setValue(i, forKey: "id")
            ModuleEntity.setValue(0, forKey: "post_count")
            do {
                try context.save()
            }catch{
                let error = error as NSError
                fatalError("错误：\(error)\n\(error.userInfo)")
            }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
//        self.scroll!.contentSize = CGSize(width: self.view.frame.width ,height: self.view.frame.height * 3)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.isNavigationBarHidden = false
      self.navigationController?.navigationBar.shadowImage = UIImage()
      //去掉（重设）NavigationBar上的一条线
      self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
      //去掉（重设）NavigationBar上的背景图片
      self.navigationController?.navigationBar.tintColor=UIColor.gray
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.isNavigationBarHidden = false
    }
    override func viewDidDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = false
    }
    

    @objc func startTrainingButtonClicked(_ sender: UIButton) {
        print("start training")
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "starttrainboard") as! StartTrainingController
        vc.focused = self.focused
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func click1(){
        let con = UIStoryboard(name: "Main", bundle: nil)
        .instantiateViewController(withIdentifier: "weekhistoryboard") as UIViewController;
        self.navigationController?.pushViewController(con, animated: true)
    }
    @objc func click2(){
        print("click")
    }
    
}
