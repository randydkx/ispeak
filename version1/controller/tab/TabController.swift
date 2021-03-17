//
//  TabController.swift
//  ispeak
//
//  Created by mac on 2020/10/4.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit

class TabController: UITabBarController {
    var avtar:UIImageView?
    var selectedID: NSInteger = 0{
        didSet{
            self.selectedIndex = selectedID
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBar.isHidden = true
    }
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBar.isHidden = false
//        self.navigationController?.isNavigationBarHidden = false
//        self.tabBar.frame=CGRect(x: 0, y: 813, width: 414, height: 49)
    }
    override func viewDidAppear(_ animated: Bool) {
        
//        if self.tabBar.frame.minY != 813 {
//            print("kaishi minX:\(self.tabBar.frame.minX) minY:\(self.tabBar.frame.minY)")
//            print("kaishi width:\(self.tabBar.frame.width) height:\(self.tabBar.frame.height)")
//        }
        
//        self.tabBar.frame=CGRect(x: 0, y: 813, width: 414, height: 49)
        
//        if self.tabBar.frame.minY != 813 {
//            print("jieshu minX:\(self.tabBar.frame.minX) minY:\(self.tabBar.frame.minY)")
//            print("jieshu width:\(self.tabBar.frame.width) height:\(self.tabBar.frame.height)")
//        }
    }
//    override func viewWillDisappear(_ animated: Bool) {
//        self.tabBar.removeFromSuperview()
//    }
//    override func viewDidDisappear(_ animated: Bool) {
//        self.tabBar.removeFromSuperview()
//    }
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
//        self.edgesForExtendedLayout = UIRectEdge.all
//        self.automaticallyAdjustsScrollViewInsets=false
        
//        self.tabBar.removeFromSuperview()

//        self.tabBar.frame=CGRect(x: 0, y: 813, width: 414, height: 49)
        
        
//        let timer=Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updatetime), userInfo: nil, repeats: true)
        
        self.navigationController?.isToolbarHidden=true
        self.view.backgroundColor = ZHFColor.white
        //设置局部tabBar 颜色
        tabBar.tintColor =  ZHFColor.systemGreen
        tabBar.isTranslucent = false
//        tabBar.layer.backgroundColor=UIColor.blue.cgColor
        
        //1. 获取json 文件路径
        guard let jsonPath = Bundle.main.path(forResource: "tabbar.json", ofType: nil) else {
//            ZHFLog(message: "没有获取到对应的文件路径")
            return
        }
        //2. 读取json文件的内容
        guard let jsonData = NSData.init(contentsOfFile: jsonPath) else {
//            ZHFLog(message: "没有获取到json文件的内容")
            return
        }

        guard let AnyObject = try? JSONSerialization.jsonObject(with: jsonData as Data, options: .mutableContainers) else
        {
            return
        }
        guard let dicArray = AnyObject as? [[String : AnyObject]] else {
            return
        }
        //4.遍历字典获取对应的信息
      for dict in dicArray {
          //4.1获取对应的控制器
          guard let vcName: String = dict["vcName"] as? String else{
              continue
          }
          //4.2获取对应的title
          guard let title: String = dict["title"] as? String else{
              continue
          }
          //4.3获取对应的imagename
          guard let imageName: String = dict["imageName"] as? String else{
              continue
          }
          //4.4 添加
          addChildViewController(childVCName: vcName, title: title, imagename: imageName)
      }
    }
//添加三个视图
    private func addChildViewController(childVCName: String,title : String, imagename : String) {
        if childVCName == "communityVC" {
            let comVC: communityController = communityController()
            comVC.title = title
            comVC.tabBarItem.image = UIImage.init(named: "社区")!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            comVC.tabBarItem.selectedImage = UIImage.init(named: "社区3")!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            comVC.tabBarItem.imageInsets = UIEdgeInsets.init(top: 397, left: 0, bottom: 397, right: 0)
            comVC.avtar=UIImageView(image: self.avtar?.image)
            
            let childNav = UINavigationController(rootViewController: comVC)
//            childNav.view.frame.size=CGSize(width: 414, height: 896)
          addChild(childNav)
        }
        if childVCName == "trainVC" {
          let trainVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "trainboard") as! TrainViewController
              trainVC.title = title
              trainVC.tabBarItem.image = UIImage.init(named: "发音")!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
              trainVC.tabBarItem.selectedImage = UIImage.init(named: "发音3")!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
              trainVC.tabBarItem.imageInsets = UIEdgeInsets.init(top: 397, left: 0, bottom: 397, right: 0)
//            trainVC.avtar=UIImageView(image: self.avtar?.image)
              let childNav = UINavigationController(rootViewController: trainVC)
          addChild(childNav)
        
        }
        if childVCName == "mineVC" {
          let mineVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mineboard") as! MyspaceController
            mineVC.title = title
            mineVC.tabBarItem.image = UIImage.init(named: "我的")!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            mineVC.tabBarItem.selectedImage = UIImage.init(named: "我的3-1")!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            mineVC.tabBarItem.imageInsets = UIEdgeInsets.init(top: 397, left: 0, bottom: 397, right: 0)
            mineVC.avtar=UIImageView(image: self.avtar?.image)
                      let childNav = UINavigationController(rootViewController: mineVC)
            childNav.navigationController?.navigationBar.isHidden=true
          addChild(childNav)
        }
    }
//    @objc func updatetime(){
//        self.tabBar.frame=CGRect(x: 0, y: 813, width: 414, height: 49)
////        if self.tabBar.frame.minY != 813{
////            print("minX:\(self.tabBar.frame.minX) minY:\(self.tabBar.frame.minY)")
////            print("width:\(self.tabBar.frame.width) height:\(self.tabBar.frame.height)")
////        }
//        //print(self.view.frame)
//    }
}

