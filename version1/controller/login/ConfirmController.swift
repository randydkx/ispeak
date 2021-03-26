//
//  ConfirmController.swift
//  version1
//
//  Created by 苹果 on 2020/10/1.
//  Copyright © 2020 NJUST. All rights reserved.
//

import UIKit
import PopupKit

class ConfirmController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var confirmbutton: UIButton!
    @IBOutlet weak var confirmtextfield: UITextField!
    @IBOutlet weak var separateline: UILabel!
    @IBOutlet weak var verifysmallbutton2: UIButton!
    var timeout:Double=60
    var timer:Timer?
    var isclick=false
//    验证码
    var verifycode:String?
    
    @IBOutlet weak var label: UILabel!
    
    
    var phoneNum:String?
    

    var avtar:UIImageView?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isToolbarHidden=true
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        let item2 = UIBarButtonItem(image: UIImage(named: "返回2")?.reSizeImage(reSize: CGSize(width: 32, height: 32)).withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(backToPrevious))
        self.navigationItem.leftBarButtonItems = [item2]
        self.navigationController?.navigationBar.tintColor=UIColor.white;
        
         let stringToShow = "点击发送验证码至\(self.phoneNum!)"
        print(stringToShow)
//        label.textColor = UIColor.gray
        var mutableString = NSMutableAttributedString(string: stringToShow, attributes: nil)
        mutableString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray], range: NSRange(location: 0, length: 8))
        mutableString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.green], range: NSRange(location: 8, length: stringToShow.count - 8))
        self.label.attributedText = mutableString
        
        
//        avtar?.frame=CGRect(x: 0, y: 0, width: 200, height: 200)
//        self.view.addSubview(avtar!)
        
        confirmbutton.layer.cornerRadius=confirmbutton.frame.height/2;
        confirmbutton.layer.masksToBounds=false;
        confirmbutton.layer.shadowOffset=CGSize(width: 5.0, height: 5.0);
        confirmbutton.layer.shadowOpacity=0.5;
        confirmbutton.layer.shadowColor=UIColor(red: 23.0/255.0, green: 150.0/255.0, blue: 77.0/255.0, alpha: 1).cgColor;
        
        confirmtextfield.adjustsFontSizeToFitWidth=false
        confirmtextfield.backgroundColor=UIColor.white
        confirmtextfield.layer.cornerRadius=confirmtextfield.layer.bounds.height/2
        confirmtextfield.layer.masksToBounds=true
        confirmtextfield.layer.borderColor=UIColor.lightGray.cgColor
        confirmtextfield.layer.borderWidth=0
        
        confirmtextfield.delegate = self
        
        var frame = confirmtextfield.frame;
        frame.size.width = 20;
        let leftview = UIView.init(frame: frame)
        confirmtextfield.leftViewMode = .always
        confirmtextfield.leftView = leftview;
        
        var frame2 = separateline.frame;
        frame2.size.height = 1;
        separateline.layer.frame=frame2;
        
        verifysmallbutton2.layer.cornerRadius=verifysmallbutton2.frame.height/2.0
        verifysmallbutton2.layer.masksToBounds=true
        verifysmallbutton2.addTarget(self, action: #selector(click), for: .touchUpInside)
        
        verifysmallbutton2.setTitle("  获取验证码  ", for: .normal)
        
        timer=Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updatetime), userInfo: nil, repeats: true)
        
        confirmbutton.isEnabled=false
        confirmbutton.layer.opacity=0.6
        
    }
    @objc func backToPrevious(){
        let all = self.navigationController?.viewControllers
        let controller = all![all!.count - 2] as! RegisterController
        controller.errorCode = true
        self.navigationController!.popViewController(animated: true)
    }
//    跳转到登录页面
    @IBAction func toLoginPage(_ sender: UIButton) {
        SMSSDK.commitVerificationCode(self.verifycode, phoneNumber: self.phoneNum, zone: "86", result: {
            (error) in
            if error == nil{
                print("验证成功")
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginPage") as! LoginController
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                self.show_pop_up(content: "验证码错误")
                print("错误：\(error)")
            }
        })
        
    }
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        confirmtextfield.endEditing(true)
    }
    @objc func updatetime(){
        if isclick==true{
            
            if timeout<0{
                verifysmallbutton2.setTitle("发送验证码", for: .normal)
                isclick=false
                verifysmallbutton2.isEnabled=true
            }
            else{
                timeout-=1.0
                let x:Int=Int(ceil(timeout))
                verifysmallbutton2.setTitle("\(x)秒后重发", for: .normal)
            }
        }
        return
    }
    @objc func click(){
        timeout=60
        isclick=true
        confirmbutton.isEnabled=true
        confirmbutton.layer.opacity=1
        let x:Int=Int(ceil(timeout))
        verifysmallbutton2.setTitle("\(x)秒后重发", for: .normal)
        verifysmallbutton2.isEnabled=false
        
        let stringToShow = "验证码已经发送至\(self.phoneNum!)"
       print(stringToShow)
//        label.textColor = UIColor.gray
       var mutableString = NSMutableAttributedString(string: stringToShow, attributes: nil)
       mutableString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray], range: NSRange(location: 0, length: 8))
       mutableString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.green], range: NSRange(location: 8, length: stringToShow.count - 8))
       self.label.attributedText = mutableString
        
        SMSSDK.getVerificationCode(by: .SMS, phoneNumber: self.phoneNum, zone: "86", template: nil, result: {
            (error) in
            if (error == nil){
                print("no error")
            }else{
                print(error)
                self.backToPrevious()
            }
        })
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.verifycode = textField.text
        print(self.verifycode)
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
