//
//  communityArticlePageController.swift
//  ispeak
//
//  Created by mac on 2020/10/3.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit

class communityArticlePageController: UIViewController {

  @IBOutlet weak var scrollView: UIScrollView!
//    var scrollView: UIScrollView?
  @IBOutlet weak var navigation: UINavigationItem!
  @IBOutlet weak var backgroundImageView: UIImageView!
  
  @IBOutlet weak var textView: UITextView!
//  @IBOutlet weak var buttonView: UIButton!
    var button1 = UIButton(frame: CGRect(x:30,y:750,width:109,height:68))
    
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    self.navigationController?.navigationBar.tintColor=UIColor.white
    self.navigationController?.toolbar.barTintColor = UIColor.black
    
    self.navigationController?.navigationBar.isHidden=false
    scrollView.contentSize=CGSize(width: self.view.frame.width,height: self.view.frame.height*1.05)
    let background: UIImage=UIImage(named: "矩形 1252")!
    let paraph = NSMutableParagraphStyle()
    paraph.lineSpacing = 9
    let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15), NSAttributedString.Key.paragraphStyle: paraph]
    backgroundImageView.image=background
    backgroundImageView.contentMode = .scaleToFill
    textView.isScrollEnabled=true
    textView.isEditable = false
    let text: String = "每天清晨一件事，面对镜子进行练习说话，看看是不是有效果，或者...\n第一，认识问题是解决问题的前提，好比是去看病，医生会先给你做检查，他得知道你的病是怎么回事儿，才能知道该怎么给你治啊。同样，正确认识口吃，是矫正好口吃的前提。所以，建议你先不要着急治口吃，而要想搞明白口吃到底是怎么回事儿，他是怎么形成的。在口吃矫正中，认知疗法非常重要。\n第二，练练胸腹式呼吸，对矫正口吃很有帮助。\n第三，如果你说话有急、快、猛、重、乱的现象，我建议你通过发音训练，养成一种轻、柔、缓、慢、有节奏的说话习惯，这种说话习惯能大大降低口吃的发生频率。"
    textView.attributedText = NSAttributedString(string: text, attributes: attributes)
    
        
        button1.setBackgroundImage(UIImage(named: "矩形 1204"), for: .normal)
        button1.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 6, right: 0)
        button1.contentMode = .scaleToFill
        button1.setTitle("关注", for: .normal)
        self.view.addSubview(button1)
    button1.addTarget(self, action: #selector(click), for: .touchUpInside)
    
    
    //        为屏幕添加左滑动事件
            let gesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(change_view_left(sender:)))
                    gesture.edges = .left
            self.view.addGestureRecognizer(gesture)
    }
    @objc func click(){
        if button1.titleLabel?.text=="关注"{
            button1.setTitle("已关注", for: .normal)
            button1.layer.opacity=0.8
        }
        else{
            button1.setTitle("关注", for: .normal)
            button1.layer.opacity=1
        }
    }
    
    @objc func change_view_left(sender: UIScreenEdgePanGestureRecognizer){
        if sender.state == .ended{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden=false
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden=false
        self.tabBarController?.tabBar.isHidden = true
    }
}
