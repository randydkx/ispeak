//
//  CellTypeOne.swift
//  version1
//
//  Created by Wenshui Luo on 2021/3/22.
//  Copyright © 2021 NJUST. All rights reserved.
//

import UIKit

class Cell_One: UITableViewCell {
    
    let height = 180
    let head = 100
    let front = 16
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    init(style:UITableViewCell.CellStyle,like:UserAllCherishEntity,reuseIdentifier:String) {
        let post = like.post!
        let from_user = like.from_user!
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.init(red: 239.0/255.0, green: 238.0/255.0, blue: 245.0/255.0, alpha: 1)
        
        let lineNum = self.get_line_number(content: post.content!)
        var offset = (lineNum - 1) * 20
        
        let from_user_avatar = UIImageView.init(frame: CGRect(x: 10+front, y: 10, width: 50, height: 50))
//        设置点赞者的头像
        from_user_avatar.image = UIImage.init(contentsOfFile: getImageFullPath(from_user.avatar!))
        from_user_avatar.backgroundColor = UIColor.systemGray
        from_user_avatar.contentMode = .scaleToFill
        from_user_avatar.layer.cornerRadius = from_user_avatar.frame.width/2
        from_user_avatar.layer.masksToBounds = true
        self.addSubview(from_user_avatar)
        
        //        名称
        let name_label_1 = UILabel.init(frame: CGRect(x: 75 + front, y: 15, width: 66, height: 20))
        name_label_1.text = from_user.nickname!
        name_label_1.font = UIFont.systemFont(ofSize: 16)
        self.addSubview(name_label_1)
                
        //        时间标签
        let time_labe_l = UILabel.init(frame: CGRect(x: 75 + front, y: 39, width: 84, height: 21))
        time_labe_l.text = like.time
        time_labe_l.textColor = UIColor.systemGray
        time_labe_l.font = UIFont.systemFont(ofSize: 14)
        self.addSubview(time_labe_l)
        
        let staticLikeText = UILabel.init(frame: CGRect(x: 16 + front, y: 70, width: 300, height: 20))
        staticLikeText.font = UIFont.systemFont(ofSize: 18)
        staticLikeText.textColor = UIColor.systemGray
        staticLikeText.text = "赞了这条帖子"
        self.addSubview(staticLikeText)
        
        let layerView = UIView()
        layerView.frame = CGRect(x: 16 , y: 0 + head, width: 414 - 32, height: height)
        // fill
        layerView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        layerView.layer.cornerRadius = 20;
        layerView.alpha = 1
        self.addSubview(layerView)
        
        let avatar = UIImageView.init(frame: CGRect(x: 10, y: 10, width: 50, height: 50))
//        设置头像
        avatar.image = UIImage.init(contentsOfFile: getImageFullPath(post.user!.avatar!))
        avatar.backgroundColor = UIColor.systemGray
        avatar.contentMode = .scaleToFill
        avatar.layer.cornerRadius = avatar.frame.width/2
        avatar.layer.masksToBounds = true
        
        layerView.addSubview(avatar)
        
//        名称
        let name_label = UILabel.init(frame: CGRect(x: 75, y: 15, width: 66, height: 20))
        name_label.text = post.user!.nickname!
        name_label.font = UIFont.systemFont(ofSize: 16)
        layerView.addSubview(name_label)
        
//        时间标签
        let time_label = UILabel.init(frame: CGRect(x: 75, y: 39, width: 84, height: 21))
        time_label.text = post.time
        time_label.textColor = UIColor.systemGray
        time_label.font = UIFont.systemFont(ofSize: 14)
        layerView.addSubview(time_label)
        
        let padding_1 = 10
//        皇冠标签
        let huang_guan = UIImageView.init(frame: CGRect(x: 156, y: 11 + padding_1, width: 20, height: 20))
        huang_guan.image = UIImage(named: "王冠")
        layerView.addSubview(huang_guan)
        
//         说话达人标签
        let label = UILabel.init(frame: CGRect(x: 183, y: 11 + padding_1, width: 70, height: 21))
        label.text = "说话达人"
        label.textColor = UIColor.systemOrange
        label.font = UIFont.systemFont(ofSize: 17)
        layerView.addSubview(label)
        
//        模块名称
        let module_label = UILabel.init(frame: CGRect(x: 287, y: 13 + padding_1, width: 66, height: 17))
        module_label.text = "#"+post.module!
        module_label.font = UIFont.systemFont(ofSize: 14)
        module_label.textColor = UIColor.systemGray
        layerView.addSubview(module_label)
        
        let content_view = UILabel.init(frame: CGRect(x: 15, y: 73, width: 343, height: 21 + offset))
        if lineNum == 1{
            content_view.text = post.content!
            content_view.font = UIFont.systemFont(ofSize: 15)
            content_view.textColor = UIColor.systemGray
        }else {
            content_view.attributedText = content_change(content: post.content!)
        }
        content_view.numberOfLines = lineNum
        
        layerView.addSubview(content_view)
        
        if lineNum == 1{
            offset += 10
        }
        
        let container_small = UIView(frame: CGRect(x: 5, y: 95 + offset, width: 180, height: 44))
        let long_image = UIImageView.init(frame: CGRect(x: 8, y: 4, width: 162, height: 36))
        long_image.image = UIImage(named: "组 1221")
        long_image.contentMode = .scaleToFill
        container_small.addSubview(long_image)
        
        let toPlaybutton = UIButton.init(frame: CGRect(x: 18, y: 10, width: 25, height: 25))
        toPlaybutton.setImage(UIImage(named: "组 1225"), for: .normal)
        container_small.addSubview(toPlaybutton)
        let audio_time_label = UILabel.init(frame: CGRect(x: 119, y: 17, width: 39, height: 12))
        audio_time_label.text = int_time_transform(total_time: post.audio_time!)
        audio_time_label.font = UIFont.systemFont(ofSize: 14)
        container_small.addSubview(audio_time_label)
        layerView.addSubview(container_small)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //    通过内容获取行高，在展示页面之可能是1和2
        func get_line_number(content: String) -> Int{
            if content.count > 19{
                return 2
            }
            return 1
        }
    //    文本内容变化
        func content_change(content: String) -> NSMutableAttributedString{
    //        获得最大33个字的前缀
            let subString = content.prefix(33)
            let start = subString.count + 3
            let length = 2
            let content_extend = subString + "...全文"
            let ans = NSMutableAttributedString(string: String(content_extend), attributes: nil)
    //        设置字体
            ans.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 15), range: NSRange(location: 0, length: content_extend.count))
    //        设置最后面显示的文字的颜色是绿色
            ans.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init(red: 52.0/255.0, green: 175.0/255.0, blue: 128.0/255.0, alpha: 1), range: NSRange(location: start, length: length))
    //        其余文字的颜色是灰色
            ans.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemGray, range: NSRange(location: 0, length: subString.count))
            
            return ans
        }
}
