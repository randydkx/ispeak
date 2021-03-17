//
//  ChangesexController.swift
//  version1
//
//  Created by 苹果 on 2020/10/5.
//  Copyright © 2020 NJUST. All rights reserved.
//

import UIKit
import CoreData
import ProgressHUD

class ChangesexController: UIViewController, UITableViewDelegate, UITableViewDataSource,NSFetchedResultsControllerDelegate {
    
    var selected: Int?
    
    var imgview:UIImageView?
    var tableview:UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden=true
        self.navigationController?.isToolbarHidden=true
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.backgroundColor=UIColor.clear
        
        
        get_one_user_gender(phoneNum: (appUser?.phoneNum)!, gender: "男")
        
        let item2 = UIBarButtonItem(image: UIImage(named: "返回2")?.reSizeImage(reSize: CGSize(width: 32, height: 32)).withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(backToPrevious))
        self.navigationItem.leftBarButtonItems = [item2]
        self.navigationController?.navigationBar.tintColor=UIColor.black
        self.view.backgroundColor = UIColor.init(red: 236.0/255.0, green: 236.0/255.0, blue: 236.0/255.0, alpha: 1)
        
        let img=UIImage(named: "选中时")
        imgview=UIImageView(image: img)
        imgview!.frame=CGRect(x: 360, y: 25, width: 20, height: 20)
        imgview!.contentMode = .scaleToFill
        
        tableview=UITableView(frame: self.view.bounds,style: .grouped)
        tableview?.delegate=self
        tableview?.dataSource=self
        tableview?.tintColor = UIColor.init(red: 35.0/255.0, green: 161.0/255.0, blue: 94.0/255.0, alpha: 1)
        self.view.addSubview(tableview!)
    }
    @objc func backToPrevious(){
        if self.selected != nil{
            ProgressHUD.showSuccess()
            if self.selected == 0{
                self.modify_one_user_gender(phoneNum: (appUser?.phoneNum)!, gender: "男")
                appUser?.gender = "男"
            }
            else{
                self.modify_one_user_gender(phoneNum: (appUser?.phoneNum)!, gender: "女")
                appUser?.gender = "女"
            }
        }
        self.navigationController!.popViewController(animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 2
        }
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            var cell=tableView.dequeueReusableCell(withIdentifier: "cellID")
            if cell==nil{
                cell=UITableViewCell(style: .default, reuseIdentifier: "cellID")
            }
            cell?.accessoryType = .none
            cell?.textLabel?.font=UIFont(name: "Helvetica", size: 18)
            if indexPath.row==0{
                cell?.textLabel?.text="   男"
            }
            else{
                cell?.textLabel?.text="   女"
            }
            return cell!
        }
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 70
        }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if indexPath.row == 0{
                print("select 0 index")
                self.selected = 0
            }
            else{
                print("select 1 index")
                self.selected = 1
            }
            tableView.cellForRow(at: indexPath)?.isSelected=false
            imgview?.removeFromSuperview()
            tableView.cellForRow(at: indexPath)?.addSubview(imgview!)
//            if indexPath.row==0{
//
////                tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
////                tableView.cellForRow(at: IndexPath.init(row: 1, section: 0))?.accessoryType = .none
//
//            }
//            else{
//                let img=UIImage(named: "选中时")
//                let imgview=UIImageView(image: img)
//                imgview.frame=CGRect(x: 200, y: 5, width: 5, height: 5)
//                imgview.contentMode = .scaleToFill
//                tableView.cellForRow(at: indexPath)?.addSubview(imgview)
//                tableView.cellForRow(at: IndexPath.init(row: 0, section: 0))?.addSubview()
////                tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
////                tableView.cellForRow(at: IndexPath.init(row: 0, section: 0))?.accessoryType = .none
//            }
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
    
    
    func modify_one_user_gender(phoneNum: String,gender: String){
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
                c.gender = gender
                print("性别修改成: \(gender)")
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
    
    func get_one_user_gender(phoneNum: String,gender: String){
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
                if c.gender == "男" {
                    self.tableview?.cellForRow(at: IndexPath(row: 0, section: 0))?.addSubview(self.imgview!)
                }
                else if c.gender == "女" {
                    self.tableview?.cellForRow(at: IndexPath(row: 1, section: 0))?.addSubview(self.imgview!)
                }


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
