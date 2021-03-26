//
//  LikeController.swift
//  version1
//
//  Created by 苹果 on 2020/11/2.
//  Copyright © 2020 NJUST. All rights reserved.
//

import UIKit
import CoreData

class LikeController: UIViewController{
    
//    所有的点赞构成的列表
    var list_of_like: [UserAllCherishEntity] = []
//    列表视图
    var tableView:UITableView!
//    表格刷新框架
    var exampleModel:ExampleModel?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden=false
        self.navigationController?.isToolbarHidden=true
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.backgroundColor=UIColor.clear
//        self.navigationItem.title="赞"
        let tit=UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        tit.text="赞"
        tit.textAlignment = .center
        tit.font=UIFont.systemFont(ofSize: 20)
        self.navigationItem.titleView=tit
//        self.navigationController?.navigationBar
        
        
        let item2 = UIBarButtonItem(image: UIImage(named: "返回2")?.reSizeImage(reSize: CGSize(width: 32, height: 32)).withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(backToPrevious))
        self.navigationItem.leftBarButtonItems = [item2]
        self.navigationController?.navigationBar.tintColor=UIColor.black
        self.view.backgroundColor = UIColor.init(red: 239.0/255.0, green: 238.0/255.0, blue: 245.0/255.0, alpha: 1)
        
        
//        创建表格视图
        self.tableView = UITableView.init(frame: CGRect(x: 0, y: self.view.frame.minY + (self.navigationController?.navigationBar.frame.height)! + 50, width: self.view.frame.width, height: self.view.frame.height - (self.tabBarController?.tabBar.frame.height)! - 50))
        
        self.tableView.tableFooterView = UIView.init(frame: CGRect.zero)
        self.view.addSubview(self.tableView)
        self.exampleModel = ExampleModel.init(title: "默认", headerType: .normal, footerType: .finish)
        self.handleTableView()
        
        
    }
    
    deinit {
        debugPrint(#function,self.classForCoder)
    }
    
//    返回上一个页面，返回的同时将所以的点赞都设置成已经读过
    @objc func backToPrevious(){
        self.navigationController!.popViewController(animated: true)
        self.set_all_read()
    }
}

extension LikeController:NSFetchedResultsControllerDelegate{
//    获得所有没有查看过的点赞数据
    func get_all_like_not_view(){
        self.list_of_like.removeAll()
        let context = getContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserAllCherish")
        fetchRequest.predicate = NSPredicate(format: "to_phoneNum=\((appUser?.phoneNum)!) and ischecked=\(false)", "")
//        异步请求的回调函数
        let asyncFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest){
            (result: NSAsynchronousFetchResult!) in
            let fetchObject = result.finalResult as! [UserAllCherish]
            if fetchObject.count == 0{
                print("没有任何未读点赞记录")
            }else{
                var count = 0
                for c in fetchObject{
                    count += 1
                    
                    let cherish = UserAllCherishEntity()
                    cherish.cherishid = c.cherishid!
                    cherish.ischecked = c.ischecked
                    cherish.phoneNum = c.phoneNum!
                    cherish.postid = c.postid!
                    cherish.to_phoneNum = c.to_phoneNum!
                    cherish.time = c.time!
                    cherish.show()
                    
                    self.list_of_like.append(cherish)
                }
            }
        }
        do {
            try context.execute(asyncFetchRequest)
        }catch {
            print("ERROR ==== 无法查找未阅读点赞消息")
        }
//        将likelist中的数据全部补全
        self.impliment_like_list()
    }
    
    //    查找所有的like信息
        func impliment_like_list(){
            for cherish in self.list_of_like{
//                let phoneNum = cherish.phoneNum
                let context = getContext()
                
    //            同步获取user信息，查找指定的user
                let entity: NSEntityDescription? = NSEntityDescription.entity(forEntityName: "User", in: context)
                let request = NSFetchRequest<User>(entityName: "User")
                request.predicate = NSPredicate(format: "phoneNum=\(cherish.phoneNum)", "")
    //            request.fetchLimit = 1
                request.fetchOffset = 0
                request.entity = entity
                do{
                    let result:[AnyObject]? = try context.fetch(request)
                    
                    for c: User in result as! [User]{
                        let user = UserEntity()
                        user.avatar = c.avatar!
                        user.nickname = c.nickname!
                        cherish.from_user = user
                    }
                }catch{
                    print("ERROR: ")
                }
    //            同步获取Post信息
                let entity2: NSEntityDescription? = NSEntityDescription.entity(forEntityName: "Post", in: context)
                let request2 = NSFetchRequest<Post>(entityName: "Post")
                request2.predicate = NSPredicate(format: "id='\(cherish.postid)'", "")
                request2.fetchOffset = 0
                request2.entity = entity2
                do{
                    let result:[AnyObject]? = try context.fetch(request2)
                    
                    for c in result as! [Post]{
                        let post = PostEntity()
                        post.audio_path = (c.audio_path)!
                        post.audio_time = Int(c.audio_time)
                        post.cherish = Int(c.cherish)
                        post.content = (c.content)!
                        post.comment = Int(c.comment)
                        post.has_audio = c.has_audio
                        post.id = (c.id)!
                        post.image1_path = (c.image1_path)!
                        post.image2_path = (c.image2_path)!
                        post.module = (c.module)!
                        post.time = c.time!
                        post.phoneNum = (c.phoneNum)!
                        post.num_of_image = Int(c.num_of_image)
                        post.user=appUser!
                        cherish.post = post
                    }
                }catch{
                    print("error")
                }
    //            点赞列表的长度
                print("setupUI>>>>>>>>>>>>>>>>>>>>>\(list_of_like.count)")
            }
        }
    
//    设置所有的列表数据都已经被读过
    func set_all_read(){
        let app = UIApplication.shared.delegate as! AppDelegate
        
        let context = getContext()
        for like in self.list_of_like{
            let cherishid = like.cherishid
            let fetchRequest2 = NSFetchRequest<NSFetchRequestResult>(entityName: "UserAllCherish")
            fetchRequest2.predicate = NSPredicate(format: "cherishid='\(cherishid)'", "")

            let asyncFetchRequest2 = NSAsynchronousFetchRequest(fetchRequest: fetchRequest2) { (result:NSAsynchronousFetchResult) in
                //对返回的数据做处理。
                let fetchObject = result.finalResult! as! [UserAllCherish]
                for c in fetchObject{
                    c.ischecked = true
                }
                 app.saveContext()
            }
           
            do {
                try context.save()
                try context.execute(asyncFetchRequest2)
            }catch{
                let error = error as NSError
                fatalError("错误：\(error)\n\(error.userInfo)")
            }
            print("一条点赞状态： 未查看=>已查看")
        }
    }
}

//tableview相关的扩展
extension LikeController: UITableViewDelegate, UITableViewDataSource {
//    控制数据源的数量
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list_of_like.count
    }
    
    
//    控制每个数据源处的数据
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "reusedCell"
        let index = indexPath.row
//        重新更新数据的时候使用
        if index == 0{
            self.impliment_like_list()
        }
        print("表格当前的索引：\(index)")
        var cell:Cell_One? = tableView.dequeueReusableCell(withIdentifier: identifier) as? Cell_One
        if cell == nil {
            
             cell = Cell_One.init(style: .default,like:self.list_of_like[index], reuseIdentifier: "reusedCell")
        }
        return cell!
    }
    
//    设置高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180+100+10
    }
    
//    取消选中的阴影状态
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

//刷新数据
extension LikeController {
//    设置tableview的代理和数据源等
    func handleTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        guard let model = self.exampleModel else { return }
        print("model exists")
        self.handleTableHeader(headerType: model.headerType)
        self.handleTableFooter(footerType: model.footerType)
    }
    
//    刷新头部数据
    @objc func loadHeaderData() {
        print("头部-刷新中。。。。")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.tableView.myh_header?.endRefreshing { [weak self] () in
                print("头部-自动结束刷新了")
                self?.tableView.reloadData()
                self?.tableView.myh_footer?.isHidden = false
                self?.tableView.myh_footer?.resetNoMoreData()
            }
        }
    }
    
    @objc func loadMoreData() {
        print("尾部-刷新中。。。。")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.tableView.myh_footer?.endRefreshing { [weak self] () in
                print("尾部-自动结束刷新了")
                guard let strongSelf = self else { return }
//                先更新数据源，然后刷新数据
                self?.get_all_like_not_view()
                strongSelf.tableView.reloadData()
            }
        }
    }
//    只能向下拖动一次进行加载数据
    @objc func loadOnceData() {
        print("尾部-刷新中。。。。")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.tableView.myh_footer?.endRefreshing { [weak self] () in
                print("尾部-自动结束刷新了")
                guard let strongSelf = self else { return }
                strongSelf.tableView.reloadData()
                strongSelf.tableView.myh_footer?.isHidden = true
            }
        }
    }
    @objc func loadLastData() {
        print("尾部-刷新中。。。。")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.tableView.myh_footer?.endRefreshing { [weak self] () in
                print("尾部-自动结束刷新了")
                guard let strongSelf = self else { return }
                strongSelf.tableView.reloadData()
                strongSelf.tableView.myh_footer?.isHidden = false
                strongSelf.tableView.myh_footer?.endRefreshingWithNoMoreData()
            }
        }
    }
}


//刷新数据的类型
extension LikeController {
//    处理不同的头部刷新类型
    func handleTableHeader(headerType: ExampleModel.HeaderType) {
        switch headerType {
        case .state:
            let header = MYHRefreshStateHeader.init(refreshingBlock: { [weak self] () in
                self?.loadHeaderData()
            })
            self.tableView.myh_header = header
            break
        case .normal:
            self.tableView.myh_header = MYHRefreshNormalHeader.init(target: self, refreshingAction: #selector(self.loadHeaderData))
            break
        case .gif:
            /// 这个建议继承，重写prepare方法
            let header = MYHRefreshDIYAutoGifHeader.init(refreshingBlock: { [weak self] () in
                self?.loadHeaderData()
            })
            self.tableView.myh_header = header
            break
        case .hiddenTime:
            let header = MYHRefreshNormalHeader.init(refreshingBlock: { [weak self] () in
                self?.loadHeaderData()
            })
            header.lastUpdatedTimeLabel.isHidden = true
            header.isAutomaticallyChangeAlpha = true
            self.tableView.myh_header = header
            break
        case .hiddenStateTime:
            let header = MYHRefreshNormalHeader.init(refreshingBlock: { [weak self] () in
                self?.loadHeaderData()
            })
            header.lastUpdatedTimeLabel.isHidden = true
            header.stateLabel.isHidden = true
            self.tableView.myh_header = header
            break
        case .customTitle:
            let header = MYHRefreshNormalHeader.init(refreshingBlock: { [weak self] () in
                self?.loadHeaderData()
            })
            header.setTitle("自定义-下拉刷新", state: .idle)
            header.setTitle("自定义-释放就能刷新", state: .pulling)
            header.setTitle("自定义-加载中", state: .refreshing)
            header.stateLabel.textColor = UIColor.red
            self.tableView.myh_header = header
            break
        case .customUI:
            self.tableView.myh_header = MYHRefreshDIYUIHeader.init(refreshingBlock: { [weak self] () in
                self?.loadHeaderData()
            })
            break
        }
    }
    
    func handleTableFooter(footerType: ExampleModel.FooterType) {
        switch footerType {
        
        case .autoState:
            let footer = MYHRefreshAutoNormalFooter.init(refreshingBlock: { [weak self] () in
                self?.loadMoreData()
            })
            self.tableView.myh_footer = footer
            break
        case .gif:
            self.tableView.myh_footer = MYHRefreshDIYAutoGifFooter.init(refreshingBlock: { [weak self] () in
                self?.loadMoreData()
            })
            break
        case .hiddenTitle:
            let footer = MYHRefreshDIYAutoGifFooter.init(refreshingBlock: { [weak self] () in
                self?.loadMoreData()
            })
            footer.isRefreshingTitleHidden = true
            self.tableView.myh_footer = footer
            break
        case .finish:
            self.tableView.myh_footer = MYHRefreshAutoNormalFooter.init { [weak self] () in
                self?.loadLastData()
            }
            break
        case .enableAutoLoad:
            let footer = MYHRefreshAutoNormalFooter.init { [weak self] () in
                self?.loadMoreData()
            }
            footer.isAutomaticallyRefresh = false
            self.tableView.myh_footer = footer
            break
        case .customTitle:
            let footer = MYHRefreshAutoNormalFooter.init(refreshingBlock: { [weak self] () in
                self?.loadMoreData()
            })
            footer.setTitle("自定义-上拉就能刷新", state: .idle)
            footer.setTitle("自定义-加载中", state: .refreshing)
            footer.setTitle("自定义-没有数据了", state: .noMoreData)
            footer.stateLabel.textColor = UIColor.red
            self.tableView.myh_footer = footer
            break
        case .hiddenWhenLoad:
            self.tableView.myh_footer = MYHRefreshAutoNormalFooter.init { [weak self] () in
                self?.loadOnceData()
            }
            break
        case .auto1:
            self.tableView.myh_footer = MYHRefreshBackNormalFooter.init(target: self, refreshingAction: #selector(self.loadMoreData), arrowType: .black)
            self.tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 30, right: 0)
            self.tableView.myh_footer?.ignoredScrollViewContentInsetBottom = 30
            break
        case .auto2:
            self.tableView.myh_footer = MYHRefreshDIYBackGifFooter.init(refreshingBlock: { [weak self] () in
                self?.loadMoreData()
            })
            self.tableView.myh_footer?.isAutomaticallyChangeAlpha = true
            break
        case .diy1:
            self.tableView.myh_footer = MYHRefreshDIYAutoFooter.init(target: self, refreshingAction: #selector(self.loadMoreData))
            break
        case .diy2:
            self.tableView.myh_footer = MYHRefreshDIYBackFooter.init(target: self, refreshingAction: #selector(self.loadMoreData))
            break
        }
    }
}

extension LikeController{
    override func viewDidAppear(_ animated: Bool) {
//        self.impliment_like_list()
//        print("viewdidAppear:\(self.list_of_like.count)")
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
//        self.get_all_like_not_view()
    }
    

    override func viewWillDisappear(_ animated: Bool) {
      self.navigationController?.isNavigationBarHidden =  true
    }
    override func viewDidDisappear(_ animated: Bool) {
      self.navigationController?.isNavigationBarHidden =  true
    }
}
