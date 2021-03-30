//
//  ViewController.swift
//  version1
//
//  Created by 苹果 on 2020/9/19.
//  Copyright © 2020 NJUST. All rights reserved.
//

import UIKit
import Alamofire
import CoreData
import Foundation
import PopupKit


class RegisterController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate,NSFetchedResultsControllerDelegate,UITextViewDelegate, UITextFieldDelegate{

    var imageView: UIImageView?
    
    
    @IBOutlet weak var phoneormailtextfield: UITextField!
    @IBOutlet weak var nametextfield: UITextField!
    @IBOutlet weak var pswtextfield: UITextField!
    @IBOutlet weak var registerbutton: UIButton!
    @IBOutlet weak var separateline: UILabel!
//    登陆跳转控制
    
    @IBOutlet weak var toLoginButton: UIButton!
    var image_path: String? = nil
    var full_path: String?
    
    var errorCode:Bool?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.isToolbarHidden=true
        self.navigationController?.isNavigationBarHidden = true
//        self.navigationController?.navigationBar.backItem?.hidesBackButton = true
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        

        
        phoneormailtextfield.backgroundColor=UIColor.white
        phoneormailtextfield.layer.borderWidth=0
        phoneormailtextfield.adjustsFontSizeToFitWidth=false
        phoneormailtextfield.layer.frame=CGRect(x: 60, y: 340, width: 300, height: 60)
        phoneormailtextfield.layer.cornerRadius=phoneormailtextfield.layer.bounds.height/2
        phoneormailtextfield.layer.borderColor=UIColor.lightGray.cgColor
        phoneormailtextfield.layer.masksToBounds=false
        phoneormailtextfield.keyboardType = UIKeyboardType.numberPad
        
//        设置textview代理
        phoneormailtextfield.delegate = self
        pswtextfield.delegate = self
        nametextfield.delegate = self
        
        var frame = phoneormailtextfield.frame;
        frame.size.width = 20;
        let leftview = UIView.init(frame: frame)
        phoneormailtextfield.leftViewMode = .always
        phoneormailtextfield.leftView = leftview;
        
        nametextfield.backgroundColor=UIColor.white
        nametextfield.layer.borderWidth=0
        nametextfield.adjustsFontSizeToFitWidth=false
        nametextfield.layer.frame=CGRect(x: 60, y: 430, width: 300, height: 60)
        nametextfield.layer.cornerRadius=phoneormailtextfield.layer.bounds.height/2
        nametextfield.layer.borderColor=UIColor.lightGray.cgColor
        nametextfield.layer.masksToBounds=false

        let leftview2 = UIView.init(frame: frame)
        nametextfield.leftViewMode = .always
        nametextfield.leftView = leftview2;
        
        pswtextfield.backgroundColor=UIColor.white
        pswtextfield.layer.borderWidth=0
        pswtextfield.adjustsFontSizeToFitWidth=false
        pswtextfield.layer.frame=CGRect(x: 60, y: 520, width: 300, height: 60)
        pswtextfield.layer.cornerRadius=phoneormailtextfield.layer.bounds.height/2
        pswtextfield.layer.borderColor=UIColor.lightGray.cgColor
        pswtextfield.layer.masksToBounds=false
        pswtextfield.isSecureTextEntry = true

        let leftview3 = UIView.init(frame: frame)
        pswtextfield.leftViewMode = .always
        pswtextfield.leftView = leftview3;

        //创建一个imageView 将图片设置成圆形
        imageView = UIImageView(frame: CGRect(x: self.view.bounds.width/2-45, y: self.view.bounds.height/5.5, width: 90, height: 90))
        imageView?.isUserInteractionEnabled = true
        imageView?.backgroundColor = UIColor.init(red: 205.0/255.0, green: 205.0/255.0, blue: 205.0/255.0, alpha: 1)
        imageView?.layer.masksToBounds = true
        imageView?.layer.cornerRadius = 45.0
        view.addSubview(imageView!)
        
        //添加手势
        let tap = UITapGestureRecognizer(target: self, action: #selector(RegisterController.tapGesture(tap:)))
        tap.delegate = self
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        imageView!.addGestureRecognizer(tap)
        
        registerbutton.layer.cornerRadius=registerbutton.frame.height/2;
        registerbutton.layer.masksToBounds=false;
        registerbutton.layer.shadowOffset=CGSize(width: 5.0, height: 5.0);
        registerbutton.layer.shadowOpacity=0.5;
        registerbutton.layer.shadowColor=UIColor(red: 23.0/255.0, green: 150.0/255.0, blue: 77.0/255.0, alpha: 1).cgColor;
        
        var frame2 = separateline.frame;
        frame2.size.height = 1;
        separateline.layer.frame=frame2;
        
//        获取照片的完整路径
        self.full_path = self.get_new_file_name()
        print("注册时刻保存的路径：\(self.full_path)")
        
        self.toLoginButton.addTarget(self, action: #selector(toLogin), for: .touchUpInside)
    }
    
//    跳转到登陆页面
    @objc func toLogin(){
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginPage") as! LoginController
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.pushViewController(vc, animated: true)
        print("loginpage:关于viewcontrollers的描述：")
        print(self.navigationController?.viewControllers.description)
    }
    
    @objc func tapGesture(tap:UITapGestureRecognizer) {
        photos()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func toGetValidationCodePage(_ sender: UIButton) {

        if !(phoneormailtextfield.text == "" || pswtextfield.text == "" || nametextfield.text == ""){
//            创建appUser对象，封装用户信息
            
//            设置用户信息并且插入一个用户
//            登陆的时候默认给用户一些设置
            let tmpUser = UserEntity()
            tmpUser.phoneNum = self.phoneormailtextfield.text
            tmpUser.nickname = self.nametextfield.text
            tmpUser.password = self.pswtextfield.text
            tmpUser.avatar = self.image_path
            tmpUser.attention = 0
            tmpUser.fans = 0
            tmpUser.diamond = 10
            tmpUser.gender = "未知"
            tmpUser.star = 10
            tmpUser.signature = "未设置签名哦～"
            tmpUser.trainCount = 0
//            设置应用程序级别的变量
//            appUser = tmpUser
            print("头像真实保存的路径： \(tmpUser.avatar ?? "no_avatar")")
            self.insertOneUser(user: tmpUser)
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "validationCode") as! ConfirmController
            vc.phoneNum = self.phoneormailtextfield.text
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            alert("字段不能为空", current: self)
        }
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
//    从相机中拍摄图片
    func goCamera(){
        //print("lalal")
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
//    从相册中读取图片
    func goImage(){
        let photoPicker =  UIImagePickerController()
        photoPicker.delegate = self
        photoPicker.allowsEditing = true
        photoPicker.sourceType = .photoLibrary
        //在需要的地方present出来
        self.present(photoPicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        print("获得照片============= \(info)")
        let image : UIImage = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        //显示设置的照片
        imageView?.image = image
        self.dismiss(animated: true, completion: nil)
        
//        将图片保存到沙盒中
        let url = self.full_path!

        let image_jpeg = image.jpegData(compressionQuality: 1.0)
        NSData(data: image_jpeg!).write(toFile: url, atomically: true)
        
        
    }
    
//   构建新的路径，返回对应的字符串
    func get_new_file_name() -> String{
        let uuid = CFUUIDCreateString(nil, CFUUIDCreate(nil))
        
        let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
//       在数据库中仅仅保存名称和扩展名
        self.image_path = "\(String(uuid!)).png"
        let imagePath = docDir+"/\(String(uuid!)).png"
        return imagePath
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        phoneormailtextfield.endEditing(true)
        pswtextfield.endEditing(true)
        nametextfield.endEditing(true)
    }
}


//数据交互处理
extension RegisterController{
    //MARK:    获取上下文对象
    func getContext() -> NSManagedObjectContext{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
//    插入一个用户信息
    func insertOneUser(user: UserEntity){
        let context = getContext()
        let Entity = NSEntityDescription.entity(forEntityName: "User", in: context)
        let userEntity = NSManagedObject(entity: Entity!, insertInto: context)
        
//        设置更改实体的属性等
        userEntity.setValue(user.phoneNum, forKey: "phoneNum")
        userEntity.setValue(user.password, forKey: "password")
        userEntity.setValue(user.nickname, forKey: "nickname")
        userEntity.setValue(user.avatar, forKey: "avatar")
        userEntity.setValue(user.attention, forKey: "attention")
        userEntity.setValue(user.star, forKey: "star")
        userEntity.setValue(user.signature, forKey: "signature")
        userEntity.setValue(user.diamond, forKey: "diamond")
        userEntity.setValue(user.gender, forKey: "gender")
        userEntity.setValue(user.fans, forKey: "fans")
        
        do {
            try context.save()
            register_phoneNum = user.phoneNum
            register_password = user.password
        }catch{
            let error = error as NSError
            fatalError("错误：\(error)\n\(error.userInfo)")
        }
    }
    
    //    结束编辑事件
        func textFieldDidEndEditing(_ textField: UITextField) {
            self.keyboardWillHide()
        }
    //    开始编辑事件
        func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
            self.keyboardWillShow()
            return true
        }
    
    //    键盘即将出现的响应事件
        func keyboardWillShow(){
            
//            self.navigationController?.setNavigationBarHidden(true, animated: true)
            self.view.frame = CGRect(x: self.view.frame.minX, y: self.view.frame.minY-120, width: self.view.frame.width, height: self.view.frame.height)
        }
        
        func keyboardWillHide(){
            
//            self.navigationController?.setNavigationBarHidden(false, animated: true)
            self.view.frame = CGRect(x: self.view.frame.minX, y: self.view.frame.minY+120, width: self.view.frame.width, height: self.view.frame.height)
        }
    override func viewDidAppear(_ animated: Bool) {
        if self.errorCode != nil && self.errorCode == true{
            show_pop_up(content: "手机号码格式错误")
        }
    }
    //    展示弹出窗口视图
        func show_pop_up(content:String){
            let layerView = UIView()
            layerView.frame = CGRect(x: 19, y: 19, width: 200, height: 50)
            layerView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.16).cgColor
            layerView.layer.shadowOffset = CGSize(width: 10, height: 5)
            layerView.layer.shadowOpacity = 1
            layerView.layer.shadowRadius = 6
            layerView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
            layerView.layer.cornerRadius = 15
            layerView.alpha = 0.8
            
            let label = UILabel(frame: CGRect(x: 0, y: 10, width: 200, height: 30))
            label.text = content
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 16)
            label.textColor = UIColor.gray
            layerView.addSubview(label)
            
            let popup = PopupView.init(contentView: layerView, showType: .bounceInFromTop, dismissType: .bounceOutToTop, maskType: .clear, shouldDismissOnBackgroundTouch: true, shouldDismissOnContentTouch: false)
            popup.show(at: CGPoint(x: self.view.center.x, y: layerView.frame.height / 2 + 50), in: self.view, with: 1.0)
        }
}
