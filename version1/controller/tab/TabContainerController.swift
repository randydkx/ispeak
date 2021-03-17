//
//  TabContainerController.swift
//  version1
//
//  Created by 苹果 on 2020/11/3.
//  Copyright © 2020 NJUST. All rights reserved.
//

import UIKit

class TabContainerController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabController") as! TabController
//        vc.tabBar.frame=CGRect(x: 0, y: 813, width: 414, height: 49)
        self.view.addSubview(vc.view)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
