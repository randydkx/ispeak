//
//  communityController.swift
//  ispeak
//
//  Created by mac on 2020/10/4.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit

class communityController: ZHFSegmentVC {
    var avtar:UIImageView?
    var timer:Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.edgesForExtendedLayout = UIRectEdge.top
//        timer=Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updatetime), userInfo: nil, repeats: true)
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        self.view.backgroundColor = ZHFColor.white
        self.titleScrollViewH = 50 //默认是44 这个属性的位置不能和isHave_Navgation颠倒
        self.isHave_Navgation = true//如果没有导航栏记得设置这个属性（默认是有的）
        self.isHave_Tabbar = true//如果有tabBar记得设置这个属性（默认是没有的）
        self.navigationController?.title = "社区"
        let label = UILabel(frame: CGRect.init(x:0 ,y: 45,width: 414,height: 44))
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 21)]
        label.attributedText = NSAttributedString(string: "社区", attributes: attributes)
        label.textAlignment = .center
        self.view.addSubview(label)
        print("当前进入社区控制器")
        
        self.btnW = 138 //默认是100
        self.selectId = 1  //选中位置  默认是0
        self.titleScale = 1.2 //字体缩放倍数，默认是1.3, 设置成1不缩放
        self.titleColor = ZHFColor.black
        self.titleSelectedColor = ZHFColor.init(red: 33.0/255, green: 155.0/255, blue: 87.0/255, alpha: 1)
        //默认是可以通过手势左右滚动 防止子控制器里有ScroolView造成手势冲突，改成false将不能滚动
//                self.isScroll = true
        //添加子控制器
        setupAllChildViewController()
        //设置title
        setupAllTitle()
        //设置titleBtn下划线 （如果没有注释掉即可）
        setTitleBtnBottomLine()
        //设置角标 （如果没有注释掉即可)

        //根据子控制器个数设置角标(设置角标一定要在设置title之后，0表示没有，1表示有)默认没有
        refreshTwoAngle()
        setAngle()
        
                
    }
    func clearViews() {
        for v in self.view.subviews as [UIView] {
            v.removeFromSuperview()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
           //这个通知用来刷新角标
//        self.view.frame.size=CGSize(width: 414, height: 896)
        
           NotificationCenter.default.addObserver(self, selector: #selector(self.refreshTwoAngle), name: NSNotification.Name(rawValue: refreshMainTwoAngle), object: nil)
           self.tabBarController?.tabBar.isHidden = false
           self.navigationController?.isNavigationBarHidden = true
       }
       override func viewDidAppear(_ animated: Bool) {
//        self.view.frame.size=CGSize(width: 414, height: 896)
        
           self.tabBarController?.tabBar.isHidden = false
           self.navigationController?.isNavigationBarHidden = true
       }
       override func viewWillDisappear(_ animated: Bool) {
           self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.isNavigationBarHidden = false
       }
       override func viewDidDisappear(_ animated: Bool) {
           self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = false
       }
  
        
       func setupAllChildViewController(){
        let VC1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "recommend") as! communityRecommendController
        let VC2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "talk") as! communityTalkController
        let VC3: communityMessageController = communityMessageController()
        VC1.title = "推荐"
        VC2.title = "圆谈"
        VC3.title = "消息"
        VC1.titleHeight = self.titleScrollViewH
        VC2.titleHeight = self.titleScrollViewH
        VC3.titleHeight = self.titleScrollViewH
        
        addChild(VC1)
        addChild(VC2)
        addChild(VC3)
       }
       @objc func refreshTwoAngle(){
           //一般情况是网络请求
           //更改角标数组更改角标 为了更直观表达我这里使角标刷新不规律
           let pointMarr = NSMutableArray.init()
           for _ in 0 ..< 3 {
               pointMarr.add(Int(arc4random_uniform(2)))
           }
           self.pointArr = pointMarr as! [Int]
       }
}
