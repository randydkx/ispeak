//
//  post.swift
//  version1
//
//  Created by mac on 2020/10/29.
//  Copyright © 2020 NJUST. All rights reserved.
//

import Foundation

class PostEntity{
//    发帖ID
    var id: String?
//    电话,用来唯一表示一个用户
    var phoneNum: String?
//    用户 数据库查询之后直接设置
    var user: UserEntity?
//    图片的数量
    var num_of_image: Int?
//    是否有录音
    var has_audio: Bool?
//    法帖内容
    var content: String?
//    所属板块
    var module: String?
//    发帖时间
    var time: String = ""
// 评论数量
    var comment: Int = 0
//    收藏数量
    var cherish: Int = 0
//    照片1
    var image1_path: String?
//    照片2
    var image2_path: String?
//    录音位置
    var audio_path: String?
//    录音时长
    var audio_time: Int?
//    构造发帖
    init(){
        
    }
    init(phoneNum: String?,num_of_image: Int?,has_audio: Bool?,content: String?,module: String?,image1_path:String?,image2_path: String?,audio_path: String?,audio_time: Int?) {
//        self.avatar = avatar
//        self.name = name
        self.phoneNum = phoneNum
        self.num_of_image = num_of_image
        self.has_audio = has_audio
        self.content = content
        self.module = module
        self.image1_path = image1_path
        self.image2_path = image2_path
        self.time = get_current_time_2()
        self.cherish = 0
        self.comment = 0
        self.audio_path = audio_path
        self.audio_time = audio_time
    }
    
    func show(){
        print("id: \(id!)\nphoneNum: \(phoneNum!) \nnum_of_image: \(num_of_image!) \nhas_audio: \(has_audio!)\ncontent: \(content!)\nmodule: \(module!)\ntime: \(time)\ncomment: \(comment)\ncherish: \(cherish)\nimage1_path: \(image1_path!)\nimage2_path: \(image2_path!)\naudio_path: \(audio_path!)\naudio_time: \(audio_time!)")
    }
}
