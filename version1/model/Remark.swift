//
//  remark.swift
//  version1
//
//  Created by mac on 2020/11/6.
//  Copyright © 2020 NJUST. All rights reserved.
//

import Foundation

class RemarkEntity{
//    评论编号
    var remarkid: String = ""
//    被评价的帖子
    var postid: String = ""
//    评价内容
    var content: String = ""
//    评价的时间
    var time: String = ""
//    评价者的电话，唯一的标示
    var from_phoneNum: String = ""
//    被评价者的电话，唯一的标示
    var to_phoneNum: String = ""
//    评价者的完全信息，扩展
    var user: UserEntity?
//    评论是否被查看
    var ischecked: Bool = false
//    被点赞的帖子
    var post: PostEntity?
    
    func show(){
        print("remarkid: \(self.remarkid)\npostid: \(postid)\ncontent: \(content)\ntime: \(time)\nfrom_phoneNum: \(self.from_phoneNum)\nto_phoneNum: \(to_phoneNum)\n")
    }
}
