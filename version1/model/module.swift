//
//  module.swift
//  version1
//
//  Created by mac on 2020/10/31.
//  Copyright © 2020 NJUST. All rights reserved.
//

import Foundation

class module{
    var title: String = ""
    var word1: String = ""
    var word2: String = ""
    var word3: String = ""
    var word4: String = ""
    var image: String = ""
//通过该模块发表帖子的人数
    var post_count: Int = 0
    
    init(title: String,word1: String,word2: String,word3: String,word4: String,image:String) {
        self.title = title
        self.word1 = word1
        self.word2 = word2
        self.word3 = word3
        self.word4 = word4
        self.image = image
    }
    init(){
        
    }
}
let module1 = module.init(title: "自我介绍", word1: "姓名", word2: "兴趣", word3: "爱好", word4: "经历",image: "bruce-mars-8YG31Xn4dSw-unsplash")
let module2 = module.init(title: "我的家乡", word1: "位置", word2: "习俗", word3: "景色", word4: "历史",image: "scott-webb-1ddol8rgUH8-unsplash")
let module3 = module.init(title: "未来规划", word1: "梦想", word2: "兴趣", word3: "关注", word4: "原因",image: "xps-TxXuh_hAFd8-unsplash")
let module4 = module.init(title: "家庭成员", word1: "人数", word2: "关系", word3: "经历", word4: "喜好",image: "chewy-DR6wPYR2DRc-unsplash")
let module5 = module.init(title: "旅行计划", word1: "位置", word2: "习俗", word3: "景点", word4: "体验",image: "balloons-594629_1920")
let module6 = module.init(title: "职业规划", word1: "工作", word2: "技能", word3: "地区", word4: "前景",image: "xps-bXfQLglc81U-unsplash")
let module7 = module.init(title: "学校生活", word1: "位置", word2: "课程", word3: "活动", word4: "同学",image: "ivan-aleksic-PDRFeeDniCk-unsplash")
let module8 = module.init(title: "我的朋友", word1: "关系", word2: "认识", word3: "经历", word4: "聚会",image: "chewy-AQ8XIIRDuWc-unsplash (1)")
let module9 = module.init(title: "生活娱乐", word1: "类型", word2: "方式", word3: "场地", word4: "习惯",image: "melnychuk-nataliya-ISEwrhhvgCo-unsplash")
let module10 = module.init(title: "运动健康", word1: "类型", word2: "频率", word3: "时长", word4: "变化",image: "bruce-mars-gJtDg6WfMlQ-unsplash")
let module11 = module.init(title: "困难克服", word1: "经历", word2: "恋爱", word3: "成长", word4: "收获",image: "nii-dITKTy1HviM-unsplash")
let module12 = module.init(title: "阅读推荐", word1: "书名", word2: "作者", word3: "内容", word4: "感悟",image: "element5-digital-OyCl7Y4y0Bk-unsplash")
let modules = [module(),module1,module2,module3,module4,module5,module6,module7,module8,module9,module10,module11,module12]
