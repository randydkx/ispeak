//
//  HomeController.swift
//  version1
//
//  Created by 苹果 on 2020/10/2.
//  Copyright © 2020 NJUST. All rights reserved.
//

import UIKit

class HomeController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.shadowImage = UIImage()
        //去掉（重设）NavigationBar上的一条线
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        //去掉（重设）NavigationBar上的背景图片
        
        self.title="lws";
        self.view.backgroundColor=UIColor.white;
        self.navigationController?.navigationBar.barTintColor=UIColor.yellow;
        let btn=UIButton(type: .system);
        btn.frame=CGRect(x:100,y:100,width: 280,height: 30);
        btn.setTitle("lwsbutton", for: .normal);
        btn.addTarget(self, action: #selector(push), for: .touchUpInside);
        self.view.addSubview(btn);

    }
    @objc func push(){
        let con = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "tab") as UIViewController;
        let con2 = UIStoryboard(name: "Main", bundle: nil)
        .instantiateViewController(withIdentifier: "tab") as UIViewController;
        let con3=TabController()
        let con4=TabController()
        self.navigationController?.pushViewController(con4, animated: true);
    }

}
