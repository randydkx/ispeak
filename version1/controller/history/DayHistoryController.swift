//
//  HistoryController.swift
//  version1
//
//  Created by 苹果 on 2020/10/4.
//  Copyright © 2020 NJUST. All rights reserved.
//

import UIKit
import Charts
import CoreData

class DayHistoryController: UIViewController,NSFetchedResultsControllerDelegate {

    @IBOutlet weak var component2: UIView!
    @IBOutlet weak var component2_2: UITextView!
    var avtar:UIImageView?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.shadowImage = UIImage()
        //去掉（重设）NavigationBar上的一条线
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        //去掉（重设）NavigationBar上的背景图片
        let item1 = UIBarButtonItem(image: UIImage(named: "返回2")?.reSizeImage(reSize: CGSize(width: 32, height: 32)).withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(backToPrevious))
        let item2 = UIBarButtonItem(image: UIImage(named: "多边形 12")?.reSizeImage(reSize: CGSize(width: 22, height: 22)).withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(tonext))
        self.navigationItem.leftBarButtonItems = [item1]
        self.navigationItem.rightBarButtonItems = [item2]
        self.navigationController?.navigationBar.tintColor=UIColor.white
        
        component2?.layer.cornerRadius=component2.frame.height/12;
        
        let paraph = NSMutableParagraphStyle()
        paraph.lineSpacing = 14
        let attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16),
                          NSAttributedString.Key.paragraphStyle: paraph]
        
        component2_2?.attributedText = NSAttributedString(string: component2_2.text, attributes: attributes);
        component2_2.isEditable=false
        
        let repeatbutton2=UIButton(type: .system)
        repeatbutton2.frame=CGRect(x: 139, y: 760, width: 130, height: 56)
        repeatbutton2.tintColor=UIColor.white
        repeatbutton2.layer.cornerRadius=repeatbutton2.frame.height/2;
        repeatbutton2.layer.masksToBounds=false;
        repeatbutton2.layer.shadowOffset=CGSize(width: 5.0, height: 5.0);
        repeatbutton2.layer.shadowOpacity=0.5;
        repeatbutton2.layer.shadowColor=UIColor(red: 23.0/255.0, green: 150.0/255.0, blue: 77.0/255.0, alpha: 1).cgColor;
        repeatbutton2.setTitle("再来一遍", for: .normal)
        repeatbutton2.backgroundColor=UIColor(red: 23.0/255.0, green: 150.0/255.0, blue: 77.0/255.0, alpha: 1);
        repeatbutton2.titleLabel?.font=UIFont.init(name: "Helvetica", size: 18)
        self.view.addSubview(repeatbutton2)
        
//        为屏幕添加左滑动事件
        let gesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(change_view_left(sender:)))
        gesture.edges = .left
        self.view.addGestureRecognizer(gesture)
//        为屏幕添加右滑动事件
        let gesture2 = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(change_view_right(sender:)))
        gesture2.edges = .right
        self.view.addGestureRecognizer(gesture2)
    }
    
    @objc func change_view_left(sender: UIScreenEdgePanGestureRecognizer){
        if sender.state == .ended{
            self.backToPrevious()
        }
    }
    
    @objc func change_view_right(sender: UIScreenEdgePanGestureRecognizer){
        if sender.state == .ended{
            self.tonext()
        }
    }
    
    @objc func backToPrevious(){
        self.navigationController!.popViewController(animated: true)
    }
    @objc func tonext(){
        let con = UIStoryboard(name: "Main", bundle: nil)
        .instantiateViewController(withIdentifier: "weekhistoryboard") as UIViewController;
        self.navigationController?.pushViewController(con, animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
//        获取所有的训练数据
        self.get_all_train_data()
    }
    
//    查找出所有的训练记录
    func get_all_train_data(){
        all_train_history.removeAll()
        let context = getContext()
        let entity: NSEntityDescription? = NSEntityDescription.entity(forEntityName: "Train", in: context)
        let request = NSFetchRequest<Train>(entityName: "Train")
        
        request.fetchOffset = 0
        request.entity = entity
        request.predicate = NSPredicate(format: "user_phoneNum=\((appUser?.phoneNum)!)", "")
        
        do{
            let result:[AnyObject]? = try context.fetch(request)
    
            print("总训练的数量 ：\(result?.count)")
            for c: Train in result as! [Train]{
                let train = TrainEntity()
                train.num_of_duplicate = c.num_of_duplicate
                train.num_of_stop = c.num_of_stop
                train.content = c.content ?? ""
                train.ratio = c.ratio
                train.trainTime = c.trainTime!
                train.type = c.type!
                
//                全局的训练数据
                all_train_history.append(train)
            }
            
        }catch{
            print("to_other_home_page: User数据获取失败")
        }
        
//        设置日训练信息
        self.get_day_train_info()
    }
    
    func get_day_train_info(){
        let current_time = get_current_time()
        for train in all_train_history{
            if train.trainTime == current_time{
                day_train_history.append(train)
            }
        }
        print("日训练数量：\(day_train_history.count)")
    }
}
