//
//  WeekHistoryController.swift
//  version1
//
//  Created by 苹果 on 2020/10/5.
//  Copyright © 2020 NJUST. All rights reserved.
//

import UIKit

class AllHistoryController: UIViewController {
    
    var bottom:CGFloat=270
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var text1: UITextView!
    @IBOutlet weak var text2: UITextView!
    var avtar:UIImageView?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let item1 = UIBarButtonItem(image: UIImage(named: "返回2")?.reSizeImage(reSize: CGSize(width: 32, height: 32)).withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(backToPrevious))
        self.navigationItem.leftBarButtonItems = [item1]
        
        
        scroll.addSubview(returnUIView1(theme: "我的家乡",times:2))
        scroll.addSubview(returnUIView2())
        
        scroll.addSubview(returnUIView1(theme: "自我介绍",times:1))
        scroll.addSubview(returnUIView2())
        
//        scroll.addSubview(returnUIView1(theme: "我的家乡",times:3))
//        scroll.addSubview(returnUIView2())
//        
//        scroll.addSubview(returnUIView1(theme: "我的家乡",times:4))
        
//        为屏幕添加左滑动事件
        let gesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(change_view_left(sender:)))
                        gesture.edges = .left
        self.view.addGestureRecognizer(gesture)
        
        setup()
    }
    
    func returnUIView1(theme:String,times:Int)->
        UIView{
            let view1=UIView(frame: CGRect(x: 0, y: Int(self.bottom), width: Int(self.view.frame.width), height: 175*times))
            let Theme=UITextView(frame: CGRect(x: 55, y: 7, width: 100, height: 60))
            Theme.backgroundColor=nil
            Theme.font=UIFont.init(name: "Helvetica", size: 18)
            Theme.text=theme
            Theme.isScrollEnabled=false
            Theme.isEditable=false
            let count=UITextView(frame: CGRect(x: self.view.frame.width-75, y: 7, width: 50, height: 60))
            count.isScrollEnabled=false
            count.isEditable=false
            count.backgroundColor=nil
            count.font=UIFont.init(name: "Helvetica", size: 18)
            count.text=String(times)+"次"
            
            let point=UIImage(named: "组 1233")
            let pointview=UIImageView(image: point)
            pointview.contentMode = .scaleToFill
            pointview.frame=CGRect(x:43,y: 19,width: 15,height: 15)
            
        if times==1{
            let view3=returnUIView3(up: CGFloat(175*0+50), down: CGFloat(175*(0+1)+25),datetext: "2020.11.13",contenttext: "我是罗文水，今今今年28岁，家在浙江杭州。",ratetext: "30.5%")
            view1.addSubview(view3)
        }
        else if times==2{
            let view4=returnUIView3(up: CGFloat(175*0+50), down: CGFloat(175*(0+1)+25),datetext: "2020.11.13",contenttext: "我是周苗苗，今今今年28岁，家在浙江杭州。希望能跟大家成为很很很好的朋友。",ratetext: "30.5%")
            view1.addSubview(view4)
            
            let view5=returnUIView3(up: CGFloat(175*1+50), down: CGFloat(175*(1+1)+25),datetext: "2020.11.13",contenttext: "我是陆宗泽，很很很很很很很高兴认识大家。我真的很高兴，能能能和大家成为朋友。",ratetext: "42.8%")
            view1.addSubview(view5)
        }
        else {
            for i in 0..<times{
                let view3=returnUIView3(up: CGFloat(175*i+50), down: CGFloat(175*(i+1)+25),datetext: "2020.11.13",contenttext: "我是罗文水，今今今年28岁，家家家家在浙江杭州。",ratetext: "31.5%")
                view1.addSubview(view3)
            }
        }
            
            view1.addSubview(Theme)
            view1.addSubview(count)
            view1.addSubview(pointview)
            
            self.bottom+=CGFloat(175*times+50)
            return view1
    }
    func returnUIView2()->
        UIView{
            let view2=UIView(frame: CGRect(x: 0, y: Int(self.bottom), width: Int(self.view.frame.width), height: 20))
            view2.backgroundColor=UIColor.white
            self.bottom+=20
            return view2
    }
    func returnUIView3(up:CGFloat,down:CGFloat,datetext:String,contenttext:String,ratetext:String)->
        UIView{
            let view3=UIView(frame: CGRect(x: 30, y: up, width: self.view.frame.width-60, height: down-up))
            view3.backgroundColor=UIColor.white
            view3.layer.cornerRadius=view3.frame.height/6
            view3.layer.shadowOpacity=0.5;
            view3.layer.shadowColor=UIColor.black.cgColor;
            view3.layer.shadowOffset=CGSize(width:5.0,height:5.0);
            
            let date=UITextView(frame: CGRect(x: 10, y: 5, width: 100, height: 40))
            date.text=datetext
            date.font=UIFont.init(name: "Helvetica", size: 16)
            date.backgroundColor=nil
            date.textColor=UIColor.lightGray
            date.isScrollEnabled=false
            date.isEditable=false
            view3.addSubview(date)
            
            let rate=UITextView(frame: CGRect(x: 10, y: 30, width: 100, height: 40))
            rate.text=ratetext
            rate.font=UIFont.init(name: "Helvetica", size: 18)
            rate.backgroundColor=nil
            rate.textColor=UIColor.black
            rate.isScrollEnabled=false
            rate.isEditable=false
            view3.addSubview(rate)
            
            let text=UITextView(frame: CGRect(x: 10, y: 60, width: self.view.frame.width-70, height: down-up-80))
            text.text=contenttext
            text.font=UIFont.init(name: "Helvetica", size: 14)
            text.backgroundColor=nil
            text.textColor=UIColor.gray
            text.isEditable=false
            view3.addSubview(text)
            
            let button=UIButton(type: .system)
            button.frame=CGRect(x: Int(self.view.frame.width)-200, y: 20, width: 120, height: 30)
            button.layer.cornerRadius=button.frame.height/2
            button.layer.masksToBounds=false
            button.layer.shadowOffset=CGSize(width: 5.0, height: 5.0);
            button.layer.shadowOpacity=0.5
            button.layer.shadowColor=UIColor(red: 23.0/255.0, green: 150.0/255.0, blue: 77.0/255.0, alpha: 1).cgColor
            button.backgroundColor=UIColor(red: 23.0/255.0, green: 150.0/255.0, blue: 77.0/255.0, alpha: 1)
            button.setTitle("继续训练", for: .normal)
            button.tintColor=UIColor.white
            view3.addSubview(button)
        button.addTarget(self, action: #selector(poptoroot), for: .touchUpInside)
            return view3
    }
    @objc func poptoroot(){
        self.navigationController?.popToRootViewController(animated: true)
    }
    func setup()->
        Void{
            text1.font = UIFont(name: "Helvetica-Bold",size: 22)
            text2.font = UIFont(name: "Helvetica-Bold",size: 24)
            text1.isScrollEnabled=false
            text1.isEditable=false
            text2.isScrollEnabled=false
            text2.isEditable=false
            self.scroll.frame=self.view.frame
            self.scroll.contentSize=CGSize(width: self.view.frame.width, height: self.bottom)
    }
    @objc func backToPrevious(){
        self.navigationController!.popViewController(animated: true)
    }
    
    @objc func change_view_left(sender: UIScreenEdgePanGestureRecognizer){
        if sender.state == .ended{
            self.backToPrevious()
        }
    }
}
