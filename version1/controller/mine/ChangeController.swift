//
//  Change1Controller.swift
//  version1
//
//  Created by 苹果 on 2020/10/5.
//  Copyright © 2020 NJUST. All rights reserved.
//

import UIKit
import CoreData

class ChangeController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate ,UITableViewDelegate,UITableViewDataSource,CanChangeName,NSFetchedResultsControllerDelegate{
    func nameReceived(name: String) {
        self.name = name
    }
    
    var avtar:UIImageView?
    var name: String?
    var sign: String?
    var gender: String?
    
//    表格视图
    var tableview: UITableView?
    
//    选择的图片的名称+扩展名
    var image_path: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden=true
        self.navigationController?.isToolbarHidden=true
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.backgroundColor=UIColor.clear
        
        
        avtar?.image=avtar?.image?.toCircle()
        self.view.backgroundColor = UIColor.init(red: 236.0/255.0, green: 236.0/255.0, blue: 236.0/255.0, alpha: 1)
        
        let item2 = UIBarButtonItem(image: UIImage(named: "返回2")?.reSizeImage(reSize: CGSize(width: 32, height: 32)).withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(backToPrevious))
        self.navigationItem.leftBarButtonItems = [item2]
        self.navigationController?.navigationBar.tintColor=UIColor.black
        self.navigationController?.navigationBar.backgroundColor=UIColor.white
        
        if avtar?.image != nil{
            avtar?.frame=CGRect(x: 328, y: 13, width: 44, height: 44)
            avtar?.layer.cornerRadius=22
            avtar?.layer.masksToBounds=true
        }
        else{
            avtar=UIImageView(frame: CGRect(x: 320, y: 13, width: 44, height: 44))
            avtar?.layer.cornerRadius=22
            avtar?.backgroundColor = UIColor.init(red: 205.0/255.0, green: 205.0/255.0, blue: 205.0/255.0, alpha: 1)
        }
        let avtap=UITapGestureRecognizer(target: self, action: #selector(ontapav))
        avtar?.addGestureRecognizer(avtap)
        avtar?.isUserInteractionEnabled=true
        
        tableview=UITableView(frame: self.view.bounds,style: .grouped)
        tableview?.delegate=self
        tableview?.dataSource=self
        self.view.addSubview(tableview!)
        
        tableview?.reloadData()
    }
    @objc func ontapav(){
        photos()
    }
    @objc func backToPrevious(){
        self.navigationController?.popViewController(animated: true)
    }
    func photos()  {
        self.showBottomAlert()
    }
    func showBottomAlert(){
        let alertController=UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancel=UIAlertAction(title:"取消", style: .cancel, handler: nil)
        let takingPictures=UIAlertAction(title:"拍照", style: .default)
        {
            action in
            self.goCamera()

        }
        let localPhoto=UIAlertAction(title:"本地图片", style: .default)
        {
            action in
            self.goImage()

        }
        alertController.addAction(cancel)
        alertController.addAction(takingPictures)
        alertController.addAction(localPhoto)
        self.present(alertController, animated:true, completion:nil)
    }
    func goCamera(){
        let cameraPicker = UIImagePickerController()
        cameraPicker.sourceType = .photoLibrary
        //print("hehe")
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            cameraPicker.sourceType = .camera
            cameraPicker.delegate = self
            cameraPicker.allowsEditing = true
            //在需要的地方present出来
            self.present(cameraPicker, animated: true, completion: nil)
        } else {
            print("不支持拍照")
        }
    }
    func goImage(){
        let photoPicker =  UIImagePickerController()
        photoPicker.delegate = self
        photoPicker.allowsEditing = true
        photoPicker.sourceType = .photoLibrary
        //在需要的地方present出来
        self.present(photoPicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("获得照片============= \(info)")
        let image : UIImage = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        //显示设置的照片
        avtar?.image = image
//       将图片写入沙箱
        let url = get_new_file_name()
        
        let image_jpeg = image.jpegData(compressionQuality: 1.0)
        NSData(data: image_jpeg!).write(toFile: url, atomically: true)
        
        appUser?.avatar = self.image_path
        modify_user_avatar(phoneNum: (appUser?.phoneNum)!, avatar: (self.image_path)!)
        
        self.dismiss(animated: true, completion: nil)
    }
    
//    获取图片的完整路径
    func get_new_file_name() -> String{
        let uuid = CFUUIDCreateString(nil, CFUUIDCreate(nil))
        
        let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
//       在数据库中仅仅保存名称和扩展名
        self.image_path = "\(String(uuid!)).png"
        let imagePath = docDir+"/\(String(uuid!)).png"
        return imagePath
    }
    
    func modify_user_avatar(phoneNum: String,avatar: String){
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
                c.avatar = avatar
                print("头像修改成: \(avatar)")
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section==0 {
            return 4
        }
        else{
            return 1
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell=tableView.dequeueReusableCell(withIdentifier: "cellID")
        if cell==nil{
            cell=UITableViewCell(style: .default, reuseIdentifier: "cellID")
        }
        if indexPath.section==0{
            cell?.accessoryType = .disclosureIndicator
            cell?.textLabel?.font=UIFont(name: "Helvetica", size: 18)
            if indexPath.row==0{
                cell?.textLabel?.text="头像"
                avtar?.image=avtar?.image?.toCircle()
                cell?.addSubview(avtar!)
            }
            else if indexPath.row==1{
                let text=UILabel(frame: CGRect(x: self.view.frame.width-150, y: 5, width: 100, height: 60))
                text.textAlignment = .right
                text.font=UIFont(name: "Helvetica", size: 18)
                text.textColor=UIColor.gray
                text.text=appUser?.nickname
                cell?.addSubview(text)
                cell?.textLabel?.text="用户名"
            }
            else if indexPath.row==2{
                let text=UILabel(frame: CGRect(x: self.view.frame.width-150, y: 5, width: 100, height: 60))
                text.textAlignment = .right
                text.font=UIFont(name: "Helvetica", size: 18)
                text.textColor=UIColor.gray
                text.text=appUser?.gender
                cell?.addSubview(text)
                cell?.textLabel?.text="性别"
            }
            else if indexPath.row==3{
                let text=UILabel(frame: CGRect(x: self.view.frame.width-220, y: 5, width: 170, height: 60))
                text.textAlignment = .right
                text.font=UIFont(name: "Helvetica", size: 18)
                text.textColor=UIColor.gray
                text.text=appUser?.signature
                cell?.addSubview(text)
                cell?.textLabel?.text="个性签名"
            }
        }
        else if indexPath.section==1{
            cell?.textLabel?.text="退出当前帐号"
            cell?.textLabel?.textColor=UIColor.init(red: 35.0/255.0, green: 161.0/255.0, blue: 94.0/255.0, alpha: 1)
            cell?.textLabel?.font=UIFont(name: "Helvetica", size: 20)
            cell?.textLabel?.textAlignment = .center
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected=false
//        退出登陆
        if indexPath.section==1{
//            self.navigationController?.viewControllers.removeAll()
//            let login = LoginViewController()
            let con=UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginPage") as! LoginController
//            let window = UIApplication.shared.delegate?.window
//            let nav = UINavigationController(rootViewController: con)
//            window!?.rootViewController = nav
            
            
//            delete(self.navigationController?.viewControllers[0])
//            print("debg\(self.navigationController?.viewControllers[0].description)")
//            self.navigationController?.viewControllers.append(con)
            self.navigationController?.pushViewController(con, animated: true)
        }
        else{
            if indexPath.row==0{
                photos()
            }
            else if indexPath.row==1{
                let con=UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "changenameboard") as! ChangenameController
                self.navigationController?.pushViewController(con, animated: true)
            }
            else if indexPath.row==2{
                let con=UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "changesexboard")
                self.navigationController?.pushViewController(con, animated: true)
            }
            else if indexPath.row==3{
                let con=UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "changesignboard")
                self.navigationController?.pushViewController(con, animated: true)
            }
        }
    }
    
////
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if indexPath.section==0{
//            cell.accessoryType = .disclosureIndicator
//            cell.textLabel?.font=UIFont(name: "Helvetica", size: 18)
//            if indexPath.row==0{
//                cell.textLabel?.text="头像"
//                cell.addSubview(avtar!)
//            }
//            else if indexPath.row==1{
//                let text=UILabel(frame: CGRect(x: self.view.frame.width-100, y: 5, width: 160, height: 60))
//                text.font=UIFont(name: "Helvetica", size: 18)
//                text.textColor=UIColor.gray
//                text.text=appUser?.nickname
//                cell.addSubview(text)
//                cell.textLabel?.text="用户名"
//            }
//            else if indexPath.row==2{
//                let text=UILabel(frame: CGRect(x: self.view.frame.width-100, y: 5, width: 160, height: 60))
//                text.font=UIFont(name: "Helvetica", size: 18)
//                text.textColor=UIColor.gray
//                text.text=appUser?.gender
//                cell.addSubview(text)
//                cell.textLabel?.text="性别"
//            }
//            else if indexPath.row==3{
//                let text=UILabel(frame: CGRect(x: self.view.frame.width-170, y: 5, width: 160, height: 60))
//                text.font=UIFont(name: "Helvetica", size: 18)
//                text.textColor=UIColor.gray
//                text.text=appUser?.signature
//                cell.addSubview(text)
//                cell.textLabel?.text="个性签名"
//            }
//        }
//        else if indexPath.section==1{
//            cell.textLabel?.text="退出当前帐号"
//            cell.textLabel?.textColor=UIColor.init(red: 35.0/255.0, green: 161.0/255.0, blue: 94.0/255.0, alpha: 1)
//            cell.textLabel?.font=UIFont(name: "Helvetica", size: 20)
//            cell.textLabel?.textAlignment = .center
//        }
//        print("indexPath: \(indexPath.row)")
//    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden=true
        self.navigationController?.isToolbarHidden=true
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.backgroundColor=UIColor.clear
//        self.view.layoutIfNeeded()
        self.viewDidLoad()
        self.tableview?.reloadData()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden=true
        self.navigationController?.isToolbarHidden=true
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.backgroundColor=UIColor.clear
//        self.view.layoutIfNeeded()
        self.tableview?.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
}
