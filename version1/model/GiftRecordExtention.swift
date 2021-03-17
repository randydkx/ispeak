//
//  GiftRecordExtention.swift
//  version1
//
//  Created by mac on 2020/11/9.
//  Copyright © 2020 NJUST. All rights reserved.
//

import Foundation

class GiftRecordExtention{
//    1.赠送礼物的编号
    var id: String = get_random_id()
//    2.发起者
    var from_phoneNum: String = ""
//    3.被赠送者
    var to_phoneNum: String = ""
//    4.是否已读
    var ischecked: Bool = false
//    5.是星星还是钻石
    var starOrDiamond: Int32?
//    6.数量
    var number: Int32?
//    7.赠送的时间
    var time = get_current_time_2()
    
//    发起赠送的用户
    var from_user: UserEntity?
//    针对的帖子
    var post: PostEntity?
    
    func show(){
        print("id: \(id)\nfrom_phoneNum: \(from_phoneNum)\nto_phoneNum: \(to_phoneNum)\nischecked: \(ischecked)\nstarOrDiamond: \(starOrDiamond!)\nnumber: \(number!)\ntime: \(time)")
    }
}
