//
//  ConfirmController.swift
//  version1
//
//  Created by 苹果 on 2020/10/1.
//  Copyright © 2020 NJUST. All rights reserved.
//

import UIKit

class ConfirmController: UIViewController {

    @IBOutlet weak var confirmbutton: UIButton!
    @IBOutlet weak var confirmtextfield: UITextField!
    @IBOutlet weak var separateline: UILabel!
    @IBOutlet weak var verifysmallbutton2: UIButton!
    var timeout:Double=60
    var timer:Timer?
    var isclick=false

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
        self.navigationController!.popViewController(animated: true)
    }
//    跳转到登录页面
    @IBAction func toLoginPage(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginPage") as! LoginController
        self.navigationController?.pushViewController(vc, animated: true)
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
    }
}
