//
//  DataModelTest.swift
//  version1
//
//  Created by mac on 2020/10/25.
//  Copyright © 2020 NJUST. All rights reserved.
//

import UIKit
import CoreData

class DataModelTest: UIViewController,NSFetchedResultsControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
//        showAllUser()
//        self.delete_one_user(phoneNum: "123")
//        showAllUser()
//        showAllTrain()
//        show_all_post()
//        self.show_all_cherish_info()
//        showAllLikeRecord()
//        self.get_plist_data()
//        self.plist_write(updateIndex: 1)
//        let lastDay = NSDate.init(timeIntervalSinceNow: -24 * 60 * 60)
//        print(lastDay)
//        self.insert_module_info()
        
        
    }
    func getContext() -> NSManagedObjectContext{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
//    插入训练的12个模块以及训练的次数
    func insert_module_info(){
        for i in 1...12{
            let context = getContext()
            let Entity = NSEntityDescription.entity(forEntityName: "Module", in: context)
            let ModuleEntity = NSManagedObject(entity: Entity!, insertInto: context)
            
    //        设置更改实体的属性等
            
            ModuleEntity.setValue(i, forKey: "id")
            ModuleEntity.setValue(0, forKey: "post_count")
            do {
                try context.save()
            }catch{
                let error = error as NSError
                fatalError("错误：\(error)\n\(error.userInfo)")
            }
        }
    }
    
    func get_plist_data(){
        let plistpath = Bundle.main.path(forResource: "moduleInfo", ofType: "plist")
        let data: NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plistpath!)!
        let message = data.description
        let module1 = data["module1"] as! Int
        
    }
//    更新plist信息，让其中一个+1
    func plist_write(updateIndex: Int){
        let plist_path = Bundle.main.path(forResource: "moduleInfo", ofType: "plist")
        let data: NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plist_path!)!
        var module_raw_info: [Int] = []
        module_raw_info.append(0)
        for i in 1...12{
            module_raw_info.append(data["module\(i)"] as! Int)
        }
        print("current: \(module_raw_info[updateIndex])")
        data.setValue(module_raw_info[updateIndex] + 1, forKey: "module\(updateIndex)")
        data.write(toFile: plist_path!, atomically: true)
        print(data.description)
        
//        let dic: NSMutableDictionary = NSMutableDictionary()
//        for i in 0..<12{
//            if i == updateIndex{
//                dic.setObject(module_raw_info[i], forKey: <#T##NSCopying#>)
//            }
//        }
//        dic.setObject(1, forKey: "module1" as NSCopying)
//        dic.setObject(1, forKey: "module2" as NSCopying)
//        dic.setObject(1, forKey: "module3" as NSCopying)
//        dic.setObject(1, forKey: "module4" as NSCopying)
//        dic.setObject(1, forKey: "module5" as NSCopying)
//        dic.setObject(1, forKey: "module6" as NSCopying)
//        dic.setObject(1, forKey: "module7" as NSCopying)
//        dic.setObject(1, forKey: "module8" as NSCopying)
//        dic.setObject(1, forKey: "module9" as NSCopying)
//        dic.setObject(1, forKey: "module10" as NSCopying)
//        dic.setObject(1, forKey: "module11" as NSCopying)
//        dic.setObject(1, forKey: "module12" as NSCopying)
        
        
    }
    
//    检查用户是否存在
    func showAllUser(){
        let context = getContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
//        fetchRequest.predicate = NSPredicate(format: "", "")
//        异步请求的回调函数
        let asyncFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest){
            (result: NSAsynchronousFetchResult!) in
            let fetchObject = result.finalResult as! [User]
            if fetchObject.count == 0{
                print("没有任何User记录")
            }else{
                print("所有用户：======================================================")
                var count = 0
                for c in fetchObject{
                    count += 1
                    print("---------------------------------- \(count)")
                    print("手机号：\(c.phoneNum!)  密码：\(c.password!) 昵称： \(c.nickname!) 头像： \(c.avatar!)")
                    print()
                    print("个性签名：\(c.signature!) 星星数量： \(c.star) 钻石数量： \(c.diamond) 粉丝数量：\(c.fans) 关注数量： \(c.attention) 性别： \(c.gender) 训练次数： \(c.trainCount)")
                }
            }
        }
        do {
            try context.execute(asyncFetchRequest)
        }catch {
            print("ERROR ==== LoginController: getUserByPhoneNum: 无法执行异步查询语句")
        }
    }
    
//    修改单个用户的信息
    func modify_one_user_info(user: UserEntity){
        //获取委托
        let app = UIApplication.shared.delegate as! AppDelegate
        //获取数据上下文对象
        let context = getContext()
        //声明数据的请求，声明一个实体结构
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        //查询条件
        fetchRequest.predicate = NSPredicate(format: "phoneNum='\(user.phoneNum)'", "")
        // 异步请求由两部分组成：普通的request和completion handler
        // 返回结果在finalResult中
        let asyncFecthRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { (result: NSAsynchronousFetchResult!) in
            //对返回的数据做处理。
            let fetchObject  = result.finalResult! as! [User]
            for c in fetchObject{
                print("avatar: \(c.avatar)")
                c.avatar = user.avatar
                app.saveContext()
            }
        }
        // 执行异步请求调用execute
        do {
            try context.execute(asyncFecthRequest)
        } catch  {
            print("error")
        }
    }
    
    func delete_one_user(phoneNum: String){
        //获取委托
        let app = UIApplication.shared.delegate as! AppDelegate
        //获取数据上下文对象
        let context = getContext()
        //声明数据的请求，声明一个实体结构
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "phoneNum='\(phoneNum)'", "")
        // 异步请求由两部分组成：普通的request和completion handler
        // 返回结果在finalResult中
        let asyncFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { (result:NSAsynchronousFetchResult) in
            //对返回的数据做处理。
            let fetchObject = result.finalResult! as! [User]
            for c in fetchObject{
                //所有删除信息
                context.delete(c)
            }
             app.saveContext()
        }
          // 执行异步请求调用execute
        do {
            try context.execute(asyncFetchRequest)
        } catch  {
            print("error")
        }
    }
    
    func showAllTrain(){
        let context = getContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Train")
//        fetchRequest.predicate = NSPredicate(format: "", "")
//        异步请求的回调函数
        let asyncFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest){
            (result: NSAsynchronousFetchResult!) in
            let fetchObject = result.finalResult as! [Train]
            if fetchObject.count == 0{
                print("没有任何Train记录")
            }else{
                print("所有训练：======================================================")
                var count = 0
                for c in fetchObject{
                    count += 1
                    print("---------------------------------- \(count)")
                    print("type:\(c.type) audio: \(c.audio) time: \(c.trainTime) ratio: \(c.ratio) \nnum_of_duplicate: \(c.num_of_duplicate) num_of_stop: \(c.num_of_stop) problem: \(c.problem)\n train_length: \(c.train_length)")
                }
            }
        }
        do {
            try context.execute(asyncFetchRequest)
        }catch {
            print("ERROR ==== LoginController: getUserByPhoneNum: 无法执行异步查询语句")
        }
    }
    
    func show_all_post(){
        let context = getContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Post")
//        fetchRequest.predicate = NSPredicate(format: "", "")
//        异步请求的回调函数
        let asyncFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest){
            (result: NSAsynchronousFetchResult!) in
            let fetchObject = result.finalResult as! [Post]
            if fetchObject.count == 0{
                print("没有任何Post记录")
            }else{
                print("所有post：======================================================")
                var count = 0
                for c in fetchObject{
                    count += 1
                    print("---------------------------------- \(count)")
                    print("id: \((c.id)!)\nphoneNum: \(c.phoneNum!) \nnum_of_image: \(c.num_of_image) \nhas_audio: \(c.has_audio)\ncontent: \(c.content!)\nmodule: \(c.module!)\ntime: \(c.time!)\ncomment: \(c.comment)\ncherish: \(c.cherish)\nimage1_path: \(c.image1_path!)\nimage2_path: \(c.image2_path!)\naudio_path: \(c.audio_path!)\naudio_time: \(c.audio_time)")
                }
            }
        }
        do {
            try context.execute(asyncFetchRequest)
        }catch {
            print("ERROR ==== LoginController: getUserByPhoneNum: 无法执行异步查询语句")
        }
    }
    
    func show_all_cherish_info(){
        let context = getContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserAllCherish")
//        fetchRequest.predicate = NSPredicate(format: "", "")
//        异步请求的回调函数
        let asyncFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest){
            (result: NSAsynchronousFetchResult!) in
            let fetchObject = result.finalResult as! [UserAllCherish]
            if fetchObject.count == 0{
                print("没有任何Cherish记录")
            }else{
                print("所有Cherish：======================================================")
                var count = 0
                for c in fetchObject{
                    count += 1
                    print("---------------------------------- \(count)")
                    print("phoneNum: \(c.phoneNum!)\ncherishid \(c.cherishid!)\npostid: \(c.postid!)\n")
                }
            }
        }
        do {
            try context.execute(asyncFetchRequest)
        }catch {
            print("ERROR ==== LoginController: getUserByPhoneNum: 无法执行异步查询语句")
        }
    }
//    调出所有点赞信息
    func showAllLikeRecord(){
        let context = getContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserAllCherish")
        fetchRequest.predicate = NSPredicate(format: "to_phoneNum='123' and ischecked=\(false)", "")
//        异步请求的回调函数
        let asyncFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest){
            (result: NSAsynchronousFetchResult!) in
            let fetchObject = result.finalResult as! [UserAllCherish]
            if fetchObject.count == 0{
                print("没有任何点赞记录")
            }else{
                print("所有用户：======================================================")
                var count = 0
                for c in fetchObject{
                    count += 1
                    print(c.ischecked)
//                    let cherish = UserAllCherishEntity()
//                    cherish.cherishid = c.cherishid!
//                    cherish.ischecked = c.ischecked
//                    cherish.phoneNum = c.phoneNum!
//                    cherish.postid = c.postid!
//                    cherish.to_phoneNum = c.to_phoneNum ?? "空"
//                    cherish.show()
                }
            }
        }
        do {
            try context.execute(asyncFetchRequest)
        }catch {
            print("ERROR ==== LoginController: getUserByPhoneNum: 无法执行异步查询语句")
        }
    }
}
