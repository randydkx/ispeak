//
//  SettingController.swift
//  version1
//
//  Created by 苹果 on 2020/11/14.
//  Copyright © 2020 NJUST. All rights reserved.
//

import UIKit

class SettingController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let item2 = UIBarButtonItem(image: UIImage(named: "返回2")?.reSizeImage(reSize: CGSize(width: 32, height: 32)).withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(backToPrevious))
        self.navigationItem.leftBarButtonItems = [item2]
        self.navigationController?.navigationBar.tintColor=UIColor.black
        
        self.navigationController?.navigationBar.isHidden=false
        
        
    }
    @objc func backToPrevious(){
        self.navigationController?.popViewController(animated: true)
    }
}
