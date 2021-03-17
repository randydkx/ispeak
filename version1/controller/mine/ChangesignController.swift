//
//  ChangesignController.swift
//  version1
//
//  Created by 苹果 on 2020/10/5.
//  Copyright © 2020 NJUST. All rights reserved.
//

import UIKit
import CoreData
import ProgressHUD

class ChangesignController: UIViewController,NSFetchedResultsControllerDelegate {
    
    var sign = UITextField.init()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden=true
        self.navigationController?.isToolbarHidden=true
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.backgroundColor=UIColor.clear
        
        let item2 = UIBarButtonItem(image: UIImage(named: "返回2")?.reSizeImage(reSize: CGSize(width: 32, height: 32)).withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(backToPrevious))
        self.navigationItem.leftBarButtonItems = [item2]
        self.navigationController?.navigationBar.tintColor=UIColor.black
        self.view.backgroundColor = UIColor.init(red: 239.0/255.0, green: 238.0/255.0, blue: 245.0/255.0, alpha: 1)
        
        sign=UITextField(frame: CGRect(x: 0, y: 120, width: self.view.frame.width, height: 70))
        sign.text=appUser?.signature
        var frame = sign.frame;
        frame.size.width = 20;
        let leftview = UIView.init(frame: frame)
        sign.leftViewMode = .always
        sign.leftView = leftview;
        sign.backgroundColor=UIColor.white
        sign.clearButtonMode = .always
        self.view.addSubview(sign)
    }
    @objc func backToPrevious(){
        if sign.text != appUser?.signature{
            ProgressHUD.showSuccess()
            appUser?.signature = self.sign.text
            modify_one_user_signature(phoneNum: (appUser?.phoneNum)!, signature: self.sign.text!)
        }
        self.navigationController!.popViewController(animated: true)
    }
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden=true
        self.navigationController?.isToolbarHidden=true
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.backgroundColor=UIColor.clear
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden=true
        self.navigationController?.isToolbarHidden=true
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.backgroundColor=UIColor.clear
    }
    
    func modify_one_user_signature(phoneNum: String,signature: String){
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
                c.signature = signature
                print("个性签名修改成: \(signature)")
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
