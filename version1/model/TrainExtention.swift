//
//  TrainExtention.swift
//  version1
//
//  Created by mac on 2020/10/26.
//  Copyright © 2020 NJUST. All rights reserved.
//

import Foundation

//单次训练扩展类
class TrainEntity{
    var trainid: String = get_random_id()
//   训练类型 -- 自我介绍等
    var type: String?
//    音频的 存储 位置
    var audio: String = ""
//  训练时间
    var trainTime: String?
//    口吃率
    var ratio: Double?
//    重复次数
    var num_of_duplicate: Int32?
//    停顿次数
    var num_of_stop: Int32?
//    问题分析
    var problem: String?
//    用户的电话
    var user_phoneNum: String?
//    训练时长
    var train_length: Int32?
//    训练的内容
    var content: String = "无"
    
    func show(){
        print("type: \(String(describing: self.type)) audio: \(self.audio) train_time: \(String(describing: self.trainTime)) ratio: \(String(describing: self.ratio))\nnum_of_duplicate: \(String(describing: self.num_of_duplicate)) num_of_stop: \(String(describing: self.num_of_stop)) problem: \(String(describing: self.problem)) user_phoneNum: \(String(describing: self.user_phoneNum)) train_length: \(String(describing: self.train_length))")
    }
}
