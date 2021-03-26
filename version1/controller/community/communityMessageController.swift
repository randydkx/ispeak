//
//  communityMessageController.swift
//  ispeak
//
//  Created by mac on 2020/10/4.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit
import CoreData

class communityMessageController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating,NSFetchedResultsControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
//    未查看的点赞数量
    var num_of_like_not_view: Int = 0
//    点赞完全信息列表
    var list_of_like: [UserAllCherishEntity] = []
//    未查看的评论数量
    var num_of_remark_not_view: Int = 0
//    点赞的完全信息列表
    var list_of_remark: [RemarkEntity] = []
//    未查看的礼物数量
    var num_of_gift_not_view: Int = 0
//    未查看的礼物列表
//    var list_of_gift: [
//    点赞数量标签
    var like_label: UILabel = UILabel()
//    评论数量标签
    var remark_label: UILabel = UILabel()
//    收到的礼物数量标签
    var gift_label: UILabel = UILabel()
//    所有收到的礼物
    var list_of_gift: [GiftRecordExtention] = []
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell=tableView.dequeueReusableCell(withIdentifier: "cellID")
        if cell==nil{
            cell=UITableViewCell(style: .default, reuseIdentifier: "cellID")
        }
        if indexPath.section==0{
            cell?.accessoryType = .disclosureIndicator
            cell?.textLabel?.font=UIFont(name: "Helvetica", size: 18)
            if indexPath.row==0{
                like_label=UILabel(frame: CGRect(x: self.view.frame.width-60, y: 25, width: 20, height: 20))
                like_label.textAlignment = .center
                like_label.font=UIFont(name: "Helvetica", size: 12)
                like_label.textColor=UIColor.white
                like_label.text="20"
                like_label.backgroundColor=UIColor.red
                like_label.layer.masksToBounds=true
                like_label.layer.cornerRadius=10
                cell?.addSubview(like_label)
                cell?.textLabel?.text="             赞"
                let img=UIImageView(image: UIImage(named: "组 1263-1"))
                img.frame=CGRect(x: 30, y: 13, width: 44, height: 44)
                cell?.addSubview(img)
            }
            else if indexPath.row==1{
                remark_label=UILabel(frame: CGRect(x: self.view.frame.width-60, y: 25, width: 20, height: 20))
                remark_label.textAlignment = .center
                remark_label.font=UIFont(name: "Helvetica", size: 12)
                remark_label.textColor=UIColor.white
                remark_label.text="20"
                remark_label.backgroundColor=UIColor.red
                remark_label.layer.masksToBounds=true
                remark_label.layer.cornerRadius=10
                cell?.addSubview(remark_label)
//                cell?.textLabel?.frame.minX=(cell?.textLabel?.frame.minX)!+75
                cell?.textLabel?.text="             评论"
                let img=UIImageView(image: UIImage(named: "组 1264-1"))
                img.frame=CGRect(x: 30, y: 13, width: 44, height: 44)
                cell?.addSubview(img)
            }
            else if indexPath.row==2{
                gift_label=UILabel(frame: CGRect(x: self.view.frame.width-60, y: 25, width: 20, height: 20))
                gift_label.textAlignment = .center
                gift_label.font=UIFont(name: "Helvetica", size: 12)
                gift_label.textColor=UIColor.white
                gift_label.text="30"
                gift_label.backgroundColor=UIColor.red
                gift_label.layer.masksToBounds=true
                gift_label.layer.cornerRadius=10
                cell?.addSubview(gift_label)
//                cell?.textLabel?.frame.minX=(cell?.textLabel?.frame.minX)!+50
                cell?.textLabel?.text="             收到的礼物"
                let img=UIImageView(image: UIImage(named: "组 1265-1"))
                img.frame=CGRect(x: 30, y: 13, width: 44, height: 44)
                cell?.addSubview(img)
            }
        }
        else if indexPath.section==1{
            cell?.textLabel?.text="暂时未收到新消息"
            cell?.textLabel?.textAlignment = .center
//            cell?.textLabel?.text="               收到的第\(indexPath.row)条消息"
//
//            let img=UIImageView(image: UIImage(named: "组 1227"))
//            img.frame=CGRect(x: 30, y: 13, width: 44, height: 44)
//            img.image = img.image?.toCircle()
//            cell?.addSubview(img)
//
//            let text=UILabel(frame: CGRect(x: self.view.frame.width-60, y: 25, width: 20, height: 20))
//            text.textAlignment = .center
//            text.font=UIFont(name: "Helvetica", size: 12)
//            text.textColor=UIColor.white
//            text.text="20"
//            text.backgroundColor=UIColor.red
//            text.layer.masksToBounds=true
//            text.layer.cornerRadius=10
//            cell?.addSubview(text)
//            cell?.accessoryType = .disclosureIndicator
        }
        return cell!
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section==0 {
            return 3
        }
        else{
            return 1
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected=false
        if indexPath.section==1{
//            let con=UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "contactboard")
//            self.navigationController?.pushViewController(con, animated: true)
            alert("您还没收到过消息哦", current: self)
        }
        else{
            if indexPath.row==0{
                let con=UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "likeboard") as! LikeController
                con.list_of_like = self.list_of_like
                self.navigationController?.pushViewController(con, animated: true)
            }
            else if indexPath.row==1{
                let con=UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "commentboard") as! CommentController
                con.list_of_remark = self.list_of_remark
                self.navigationController?.pushViewController(con, animated: true)
            }
            else if indexPath.row==2{
                let con=UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "presentboard") as! PresentController
                con.list_of_gift = self.list_of_gift
                self.navigationController?.pushViewController(con, animated: true)
            }
        }
    }
    var searchController:UISearchController?
    var tableview:UITableView?
    var titleHeight: CGFloat = 44.0 //这个是titleScroolView的高，防止中途修改我这里传过来使用，仅供参考
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scrollview=UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        scrollview.contentSize=CGSize(width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(scrollview)
        
        tableview=UITableView(frame: self.view.bounds,style: .grouped)
        tableview?.delegate=self
        tableview?.dataSource=self
        tableview?.backgroundColor=UIColor.white
        tableview?.tag=1
//            tableview?.sectionHeaderHeight=70
//            tableview?.headerView(forSection: 1)?.textLabel?.text="用户消息"
//            tableview?.headerView(forSection: 1)?.textLabel?.textColor=UIColor.black
        scrollview.addSubview(tableview!)
        
        let searchResultVC = UIViewController()
        searchResultVC.view.backgroundColor = UIColor.white
        searchController = UISearchController(searchResultsController: searchResultVC)
        searchController?.delegate=self
        searchController?.searchResultsUpdater=self
        searchController?.obscuresBackgroundDuringPresentation=true
        searchController?.view.backgroundColor = UIColor (red: 0.97, green: 0.97, blue: 0.97, alpha: 1.0)
        searchController?.dimsBackgroundDuringPresentation = true
        tableview?.tableHeaderView = searchController?.searchBar
        
        // 搜索框
        let bar = searchController?.searchBar
        bar?.barStyle = .default
        bar?.tintColor = UIColor(red: 0.12, green: 0.74, blue: 0.13, alpha: 1.0)
        bar?.delegate = self
        bar?.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        
        self.setUI()
    }
    
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        searchBar.showsSearchResultsButton=true
//    }
//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        searchBar.showsSearchResultsButton=false
//    }
    func setUI(){

    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section==0 {
            let label=UILabel(frame: CGRect(x: 30, y: 0, width: 100, height: 50))
            label.textColor=UIColor.black
            label.text="        系统消息"
            return label
        }
        else {
            let label=UILabel(frame: CGRect(x: 30, y: 0, width: 100, height: 50))
            label.textColor=UIColor.black
            label.text="        用户消息"
            return label
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.searchController?.searchBar.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
//         获取所有送礼物的数据
        self.get_all_gift_not_view()
//        获取所有点赞的数据
        self.get_all_like_not_view()
//        获取所有评论的数据
        self.get_all_remark_not_view()
        
//        self.like_label.text = "\(self.num_of_like_not_view)"
//        if self.num_of_like_not_view != 0{
//            self.like_label.isHidden = false
//        }else{
//            self.like_label.isHidden = true
//        }
        
        self.tableview?.reloadData()
        
        self.navigationController?.navigationBar.isHidden=true
    }
    
    override func viewDidAppear(_ animated: Bool) {
      self.navigationController?.isNavigationBarHidden = true
  //    self.navigationController?.isToolbarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
      self.navigationController?.isNavigationBarHidden =  true
  //    self.navigationController?.isToolbarHidden = true
    }
    override func viewDidDisappear(_ animated: Bool) {
      self.navigationController?.isNavigationBarHidden =  true
  //    self.navigationController?.isToolbarHidden = true
    }
    
//    查询所有未查看的礼物消息
    func get_all_gift_not_view(){
        let context = getContext()
        self.list_of_gift.removeAll()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GiftRecord")
        fetchRequest.predicate = NSPredicate(format: "to_phoneNum=\((appUser?.phoneNum)!) and ischecked=\(false)", "")
//        异步请求的回调函数
        let asyncFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest){
            (result: NSAsynchronousFetchResult!) in
            let fetchObject = result.finalResult as! [GiftRecord]
//            设置数量
            self.num_of_gift_not_view = fetchObject.count
            if self.num_of_gift_not_view == 0{
                self.gift_label.isHidden = true
            }else{
                self.gift_label.isHidden = false
                self.gift_label.text = "\(self.num_of_gift_not_view)"
            }
            if fetchObject.count == 0{
                print("没有任何未读赠送礼物记录")
            }else{
                var count = 0
                for c in fetchObject{
                    count += 1
                    let record = GiftRecordExtention()
                    record.id = c.id!
                    record.from_phoneNum = c.from_phoneNum!
                    record.to_phoneNum = c.to_phoneNum!
                    record.ischecked = c.ischecked
                    record.number = c.number
                    record.starOrDiamond = c.starOrDiamond
                    record.time = c.time!
                    self.list_of_gift.append(record)
                }
            }
        }
        do {
            try context.execute(asyncFetchRequest)
        }catch {
            print("ERROR ==== 无法查找未阅读礼物消息")
        }
    }
    
//    查询所有的未读评论信息
    func get_all_remark_not_view(){
        self.list_of_remark.removeAll()
        let context = getContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Remark")
//        to_phoneNum=\((appUser?.phoneNum)!) and
        fetchRequest.predicate = NSPredicate(format: "to_phoneNum=\((appUser?.phoneNum)!) and ischecked=\(false)", "")
//        异步请求的回调函数
        let asyncFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest){
            (result: NSAsynchronousFetchResult!) in
            let fetchObject = result.finalResult as! [Remark]
            self.num_of_remark_not_view = fetchObject.count
            if self.num_of_remark_not_view == 0{
                self.remark_label.isHidden = true
            }else{
                self.remark_label.isHidden = false
                self.remark_label.text = "\(self.num_of_remark_not_view)"
            }
            if fetchObject.count == 0{
                print("没有任何未读评论记录")
            }else{
                var count = 0
                for c in fetchObject{
                    count += 1
                    let remark = RemarkEntity()
                    remark.content = c.content!
                    remark.from_phoneNum = c.from_phoneNum!
                    remark.ischecked = c.ischecked
                    remark.postid = c.postid!
                    remark.remarkid = c.remarkid!
                    remark.time = c.time!
                    remark.to_phoneNum = c.to_phoneNum!
                    remark.user = appUser!
                    
                    self.list_of_remark.append(remark)
                }
            }
        }
        do {
            try context.execute(asyncFetchRequest)
        }catch {
            print("ERROR ==== 无法查找未阅读评论消息")
        }
    }
    
//    查询所有未读点赞信息
    func get_all_like_not_view(){
        self.list_of_like.removeAll()
        let context = getContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserAllCherish")
        fetchRequest.predicate = NSPredicate(format: "to_phoneNum=\((appUser?.phoneNum)!) and ischecked=\(false)", "")
//        异步请求的回调函数
        let asyncFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest){
            (result: NSAsynchronousFetchResult!) in
            let fetchObject = result.finalResult as! [UserAllCherish]
//            设置未读点赞数量
            self.num_of_like_not_view = fetchObject.count
            if self.num_of_like_not_view == 0{
                self.like_label.isHidden = true
            }else{
                self.like_label.isHidden = false
                self.like_label.text = "\(self.num_of_like_not_view)"
            }
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
    }
}
