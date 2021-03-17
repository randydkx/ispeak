//
//  AttentionExtention.swift
//  version1
//
//  Created by mac on 2020/11/11.
//  Copyright © 2020 NJUST. All rights reserved.
//

import Foundation

class AttentionExtention{
//    关注的编号
    var attentionid = get_random_id()
//    关注的发起者
    var from_phoneNum: String?
//    关注的接受者
    var to_phoneNum: String?
//    关注的时间
    var time = get_current_time_2()
    
    func show(){
        print("attentionid: \(attentionid)\nfrom_phoneNum: \(from_phoneNum)\nto_phoneNum: \(to_phoneNum)\ntime: \(time)")
    }
}
