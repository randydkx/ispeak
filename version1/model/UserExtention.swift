//
//  extension.swift
//  version1
//
//  Created by mac on 2020/10/25.
//  Copyright © 2020 NJUST. All rights reserved.
//

import Foundation
//用户实体的表示类
class UserEntity{
    var phoneNum: String?
    var password: String?
    var nickname: String?
    var avatar: String?
//    钻石数量，星星数量，粉丝数量，关注数量，性别
    var diamond: Int32?
    var star: Int32?
//    粉丝的数量
    var fans: Int32?
//    关注的数量
    var attention: Int32?
    var gender: String?
    
    var signature: String?
//    训练次数
    var trainCount: Int32?
//    点赞的帖子集合
    var cherish_set = Set<String>()
}
