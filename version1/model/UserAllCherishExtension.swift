//
//  UserAllCherishExtension.swift
//  version1
//
//  Created by mac on 2020/10/31.
//  Copyright © 2020 NJUST. All rights reserved.
//

import Foundation

class UserAllCherishEntity{
//    一条点赞的编号
    var cherishid: String = ""
//    点赞者的电话
    var phoneNum: String = ""
//    被点赞者的电话
    var to_phoneNum: String = ""
//    被点赞的帖子编号
    var postid: String = ""
//    点赞是否被查看
    var ischecked: Bool = false
//    点赞的用户
    var from_user: UserEntity?
//    点赞的帖子
    var post: PostEntity?
//    点赞的时间
    var time: String = get_current_time_2()
    
    func show(){
        print("cherishid: \(self.cherishid)\nfrom_phoneNum: \(self.phoneNum)\nto_phoneNum: \(to_phoneNum)\npostid \(postid)\nis_checked: \(self.ischecked)")
    }
}
