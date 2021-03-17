//
//  communityRecommendController.swift
//  ispeak
//
//  Created by mac on 2020/10/4.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class communityRecommendController: UIViewController {
  var scroll: UIScrollView?
  
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var topImageView: UIImageView!
    var topImage: UIImage!
    var titleHeight: CGFloat = 44.0
    var containerH: CGFloat = 205
    var containerW: CGFloat = 414
    var bottomWhite: CGFloat = 100
  
    @IBOutlet weak var firstname: UILabel!
    @IBOutlet weak var labelText: UILabel!
    var avatar: UIImage?
    var totalCount: Int = 0
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var staticImageView: UIImageView!
    @IBOutlet weak var staticImageView2: UIImageView!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    var heightMax: CGFloat = 340
    var lineH: CGFloat = 1
    var totalContainerCount = 0
    var buttonGroup: [UIButton] = []
    var countOfButtons: Int = 0
    var buttonStatus: [Int] = []
    
    var player:[AVPlayer]=[]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden =  true
        self.navigationController?.isToolbarHidden = true
        self.setUI()
    }
    func setUI(){
        firstname.textColor=UIColor.init(red: 102.0/255.0, green: 102.0/255.0, blue: 102.0/255.0, alpha: 1.0)
        
        scroll = UIScrollView(frame: CGRect(x:0,y:0,width:self.view.frame.width,height: 720))
        scroll?.backgroundColor = UIColor.white
        scroll?.contentSize = CGSize(width: self.view.frame.width,height: 1200)
        self.view.addSubview(scroll!)
        topLabel.text="口吃者应该这样学发音"
        scroll?.addSubview(topLabel!)
      
        topImage = UIImage(named: "7-1")
        topImageView?.image = topImage!
        topImageView?.layer.masksToBounds=true
        topImageView?.layer.cornerRadius = 30
        topImageView?.contentMode = .scaleAspectFill
        scroll?.addSubview(topImageView!)
      
      avatar = UIImage(named: "组 1260")
      
      avatarImageView.image=UIImage(named: "组 1260")
      scroll?.addSubview(avatarImageView)
      labelText.text="爱哭的猫"
      scroll?.addSubview(labelText)
      
      staticImageView.image=UIImage(named: "浏览")
      scroll?.addSubview(staticImageView)
      
      staticImageView2.image = UIImage(named: "收藏")
      scroll?.addSubview(staticImageView2)

      label1.text = "3"
      scroll?.addSubview(label1)
      
      label2.text = "2"
      scroll?.addSubview(label2)
        let touch = UILongPressGestureRecognizer(target: self, action: #selector(toArticlepage(sender:)))
        topImageView.isUserInteractionEnabled = true
        topImageView.addGestureRecognizer(touch)
        
        scroll?.addSubview(createLine())
        scroll?.addSubview(createContainer(title: "如何面对口吃这件事", imageName: "组 1260", nameText: "爱哭的猫", image2Name: "technique1"))
        
        scroll?.addSubview(createLine())
        scroll?.addSubview(createContainer(title: "高效练习说话方法", imageName: "1", nameText: "尘世孤行", image2Name: "technique6"))
        
        scroll?.addSubview(createLine())
        scroll?.addSubview(createContainer(title: "让口吃不再是一种恐惧", imageName: "4", nameText: "路人甲", image2Name: "technique4"))
    }
    
    func createContainer(title: String,imageName: String,nameText: String,image2Name: String) -> UIView{
        var container = UIView(frame: CGRect(x:0,y:heightMax,width:414,height:205))
        totalContainerCount+=1
        heightMax += containerH
          let titleLabel = UILabel(frame: CGRect(x:18,y:13,width:220,height:37))
          titleLabel.font = UIFont.systemFont(ofSize: 19)
          titleLabel.text = title
          container.addSubview(titleLabel)
          let image1 = UIImageView(image:UIImage(named: imageName))
          image1.frame = CGRect(x:28,y:54,width:30,height:30)
          image1.contentMode = .scaleToFill
        image1.layer.cornerRadius = image1.frame.height/2
        image1.layer.masksToBounds = true
          container.addSubview(image1)
          let name = UILabel(frame: CGRect(x:69,y:61,width:124,height:16))
          name.text=nameText
          name.font = UIFont.systemFont(ofSize: 16)
          name.textColor = UIColor.init(red: 102.0/255.0, green: 102.0/255.0, blue: 102.0/255.0, alpha: 1.0)
          container.addSubview(name)
          let paracontent = UITextView(frame: CGRect(x:22,y:92,width:215,height:91))
    //      let attr = [NSAttributedString.Key.]
          paracontent.isEditable=false
        paracontent.font=UIFont.systemFont(ofSize: 15.0)
        paracontent.textColor=UIColor.init(red: 102.0/255.0, green: 102.0/255.0, blue: 102.0/255.0, alpha: 1.0)
          paracontent.text = "每天清晨一件事，面对镜子进行练习说话，看看是不是有效果，或者..."
          container.addSubview(paracontent)
          let tmpView1 = UIImageView.init(frame: CGRect(x:28,y:167,width:21,height:21))
          tmpView1.image = UIImage(named: "浏览")
          tmpView1.contentMode = .scaleToFill
          container.addSubview(tmpView1)
          let text1 = UILabel(frame: CGRect(x:57,y:169,width:43,height: 19))
          text1.font = UIFont.systemFont(ofSize: 13)
          text1.text = "6"
          text1.textColor = UIColor.systemGray
          container.addSubview(text1)
          let tmpView2 = UIImageView.init(frame: CGRect(x:118,y:170,width:21,height:18))
          tmpView2.image = UIImage(named: "收藏")
          tmpView2.contentMode = .scaleToFill
          container.addSubview(tmpView2)
          let text2 = UILabel(frame: CGRect(x:147,y:169,width:43,height: 19))
          text2.font = UIFont.systemFont(ofSize: 13)
          text2.text = "13"
          text2.textColor = UIColor.systemGray
          container.addSubview(text2)
        
        let path=Bundle.main.path(forResource: image2Name, ofType: "mp4")
        let url = URL(fileURLWithPath: path!)
        let player2 = AVPlayer(url: url)
        player2.volume=1
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player2
        playerViewController.videoGravity = .resizeAspect
        playerViewController.view.frame = CGRect(x:255,y:64,width: 151,height:124)
        playerViewController.allowsPictureInPicturePlayback=true
        playerViewController.view.layer.cornerRadius = 20
        playerViewController.view.layer.masksToBounds = true
        playerViewController.view.contentMode = .scaleToFill
        playerViewController.videoGravity = AVLayerVideoGravity.resizeAspectFill
        playerViewController.player?.volume=1.0
        container.addSubview(playerViewController.view)
        self.addChild(playerViewController)
        
//          let imageInContainer = UIImageView(image: UIImage(named: image2Name))
//          imageInContainer.frame=CGRect(x:255,y:64,width: 151,height:124)
//          imageInContainer.contentMode = .scaleToFill
//        imageInContainer.layer.cornerRadius = 20
//        imageInContainer.layer.masksToBounds = true
//          container.addSubview(imageInContainer)
        
//        let toPlayButton = UIButton(frame: CGRect(x:305,y:101,width:50,height: 50))
//          toPlayButton.setBackgroundImage(UIImage(named: "组 1231"), for: .normal)
//          container.addSubview(toPlayButton)
//          toPlayButton.addTarget(self, action: #selector(toPlayButonClicked), for: .touchUpInside)
//          buttonStatus.append(0)
//          countOfButtons+=1
//          toPlayButton.tag = countOfButtons-1
//          buttonGroup.append(toPlayButton)
//          scroll?.addSubview(container)
//          self.scroll?.contentSize = CGSize(width:ScreenWidth,height:heightMax+bottomWhite)
        
          return container
  }
  func createLine() -> UIView{
    let line = UIView(frame: CGRect(x:0,y:heightMax,width:self.view.frame.width*0.9,height: lineH))
         line.backgroundColor = ZHFColor.zhf_color(withRed: 232, green: 233, blue: 232)
         line.center = CGPoint(x:self.view.frame.width/2,y: heightMax+lineH/2)
    line.layer.cornerRadius=lineH/2
         return line
  }
  override func viewDidAppear(_ animated: Bool) {
    self.navigationController?.isNavigationBarHidden = true
//    self.navigationController?.isToolbarHidden = true
  }
  override func viewWillAppear(_ animated: Bool) {
    self.navigationController?.isNavigationBarHidden =  true
//    self.navigationController?.isToolbarHidden = true
  }
  override func viewWillDisappear(_ animated: Bool) {
    self.navigationController?.isNavigationBarHidden =  false
//    self.navigationController?.isToolbarHidden = true
  }
  override func viewDidDisappear(_ animated: Bool) {
    self.navigationController?.isNavigationBarHidden =  false
//    self.navigationController?.isToolbarHidden = true
  }
    
    @objc func toArticlepage(sender: UILongPressGestureRecognizer){
//        totalCount+=1
//        if totalCount % 2 == 0{
        if sender.state == .ended{
            print("to_article_page--------------------------")
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "article") as! UIViewController
            self.navigationController?.pushViewController(vc,animated: true)
        }
            
//        }
    }
    @objc func toPlayButonClicked(button: UIButton){
        let tag = button.tag
        if buttonStatus[tag]==0 {
            button.setBackgroundImage(UIImage(named: "组 1232"), for: .normal)

        }else {
            button.setBackgroundImage(UIImage(named: "组 1231"), for: .normal)
        }
        buttonStatus[tag] = 1-buttonStatus[tag]
    }
}
