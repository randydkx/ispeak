//
//  HomeController.swift
//  version1
//
//  Created by 苹果 on 2020/10/2.
//  Copyright © 2020 NJUST. All rights reserved.
//

import UIKit
import KYWaterWaveView

class HomeController: UIViewController {
    
    var wave:KYWaterWaveView?
    var wave2:KYWaterWaveView?

    override func viewDidLoad() {
        super.viewDidLoad()

//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        //去掉（重设）NavigationBar上的一条线
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        //去掉（重设）NavigationBar上的背景图片
//
//        self.title="lws";
//        self.view.backgroundColor=UIColor.white;
//        self.navigationController?.navigationBar.barTintColor=UIColor.yellow;
//        let btn=UIButton(type: .system);
//        btn.frame=CGRect(x:100,y:100,width: 280,height: 30);
//        btn.setTitle("lwsbutton", for: .normal);
//        btn.addTarget(self, action: #selector(push), for: .touchUpInside);
//        self.view.addSubview(btn);
        
        wave = KYWaterWaveView.init(frame: CGRect(x: 0, y: 100, width: self.view.frame.width, height: 200))
        wave?.wave()
        wave?.waveColor = .red
        wave?.layer.opacity = 0.5
        wave?.waveAmplitude = 20
        wave2 = KYWaterWaveView.init(frame: CGRect(x: 0, y: 50, width: self.view.frame.width, height: 200))
        wave2?.wave()
        wave2?.waveColor = UIColor.systemGreen
        wave2?.layer.opacity = 0.3
        wave2?.waveAmplitude = 15
        self.view.addSubview(wave2!)
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
