

import UIKit
import CoreData
import ProgressHUD

class LoginController: UIViewController,UITextFieldDelegate,NSFetchedResultsControllerDelegate{

    var imageView: UIImageView?
    
    
    @IBOutlet weak var accounttextfield: UITextField!
    @IBOutlet weak var pswtextfield: UITextField!
    @IBOutlet var separateline: UIView!
    @IBOutlet weak var loginbutton: UIButton!
    @IBOutlet weak var registerbutton: UIButton!
    var avtar:UIImageView?
//    是否是从注册界面跳转过来

    override func viewDidLoad() {
        super.viewDidLoad()
        accounttextfield.delegate = self
        pswtextfield.delegate = self
        accounttextfield.backgroundColor=UIColor.white
        pswtextfield.backgroundColor=UIColor.white
        pswtextfield.isSecureTextEntry = true
        
        self.navigationController?.navigationBar.isHidden=true;
        self.navigationController?.isToolbarHidden=true;
        
        
        var frame2 = separateline.frame;
        frame2.size.height = 1;
        separateline.layer.frame=frame2;
        
        accounttextfield.adjustsFontSizeToFitWidth=false
        accounttextfield.layer.frame=CGRect(x: 60, y: 330, width: 300, height: 60)
        accounttextfield.layer.cornerRadius=accounttextfield.layer.bounds.height/2
        accounttextfield.layer.masksToBounds=true
        accounttextfield.layer.borderColor=UIColor.lightGray.cgColor
        accounttextfield.layer.borderWidth=0
        accounttextfield.keyboardType = UIKeyboardType.numberPad
        
        var frame = accounttextfield.frame;
        frame.size.width = 20;
        let leftview = UIView.init(frame: frame)
        accounttextfield.leftViewMode = .always
        accounttextfield.leftView = leftview;
        
        pswtextfield.adjustsFontSizeToFitWidth=false
        pswtextfield.layer.frame=CGRect(x: 60, y: 440, width: 300, height: 60)
        pswtextfield.layer.cornerRadius=pswtextfield.layer.bounds.height/2
        pswtextfield.layer.masksToBounds=true
        pswtextfield.layer.borderColor=UIColor.lightGray.cgColor
        pswtextfield.layer.borderWidth=0
        pswtextfield.keyboardType = UIKeyboardType.numberPad

        let leftview2 = UIView.init(frame: frame)
        pswtextfield.leftViewMode = .always
        pswtextfield.leftView = leftview2;
        
        loginbutton.layer.cornerRadius=loginbutton.frame.height/2;
        loginbutton.layer.masksToBounds=false;
        loginbutton.layer.shadowOffset=CGSize(width: 5.0, height: 5.0);
        loginbutton.layer.shadowOpacity=0.5;
        loginbutton.layer.shadowColor=UIColor(red: 23.0/255.0, green: 150.0/255.0, blue: 77.0/255.0, alpha: 1).cgColor;
        
        registerbutton.addTarget(self, action: #selector(toregister), for: .touchUpInside)
        
        loginbutton.addTarget(self, action: #selector(check), for: .touchUpInside)
        
        if register_phoneNum != nil{
            self.accounttextfield.text = register_phoneNum
            self.pswtextfield.text = register_password
            register_phoneNum = nil
            register_password = nil
        }
    }
    
    @objc func toregister()->Void{
        let con=UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "registerboard") as UIViewController
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.pushViewController(con, animated: true)
    }
    func getContext() -> NSManagedObjectContext{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
//    结束编辑事件
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.keyboardWillHide()
    }
//    开始编辑事件
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.keyboardWillShow()
        return true
    }
//    检查用户是否存在
    @objc func check(){
        let context = getContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        if self.accounttextfield.text! == ""{
            alert("账号字段不能为空", current: self)
            return
        }
        fetchRequest.predicate = NSPredicate(format: "phoneNum=\(self.accounttextfield.text!)", "")
//        异步请求的回调函数
        let asyncFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest){
            (result: NSAsynchronousFetchResult!) in
            let fetchObject = result.finalResult as! [User]
            if fetchObject.count == 0{
                alert("账号不存在", current: self)
                print("没有记录")
            }else{
                for c in fetchObject{
                    if c.password! == self.pswtextfield.text!{
//                        可以登陆的时候，设置全局的用户
                        appUser = UserEntity()
                        appUser?.phoneNum = c.phoneNum
                        appUser?.password = c.password
                        appUser?.nickname = c.nickname
                        appUser?.avatar = c.avatar
                        appUser?.diamond = c.diamond
                        appUser?.star = c.star
                        appUser?.fans = c.fans
                        appUser?.signature = c.signature
                        appUser?.attention = c.attention
                        appUser?.gender = c.gender
                        appUser?.trainCount = c.trainCount
//                        获取用户的所有点赞记录
                        self.get_all_cherish_info(phoneNum: c.phoneNum!)
                        self.toTabController()
                    }
                    else{
                        alert("密码错误，请重新输入！", current: self)
                    }
                }
            }
        }
        do {
            try context.execute(asyncFetchRequest)
        }catch {
            print("ERROR ==== LoginController: getUserByPhoneNum: 无法执行异步查询语句")
        }
    }
    
//    搜索一个用户所有的点赞数据
    func get_all_cherish_info(phoneNum: String){
        let context = getContext()
        let entity: NSEntityDescription? = NSEntityDescription.entity(forEntityName: "UserAllCherish", in: context)
        let request = NSFetchRequest<UserAllCherish>(entityName: "UserAllCherish")
        request.fetchOffset = 0
        request.entity = entity
        request.predicate = NSPredicate.init(format: "phoneNum='\(phoneNum)'", "")
        do{
            let result:[AnyObject]? = try context.fetch(request)
            
            print("cherish_list_size： \((result?.count)!)")
            appUser?.cherish_set.removeAll()
            for info in result as! [UserAllCherish]{
                let cherish = UserAllCherishEntity()
                cherish.postid = info.postid!
                cherish.phoneNum = info.phoneNum!
                cherish.cherishid = info.cherishid!
                cherish.show()
                appUser?.cherish_set.insert(cherish.postid)
            }
        }catch{
            print("post数据获取失败")
        }
    }

    func toTabController() {
//        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabController") as! TabController
//        tabController
//        vc.tabBar.frame=CGRect(x: 0, y: 813, width: 414, height: 49)
        self.dismiss(animated: true, completion: nil)
        onlytab.dismiss(animated: true, completion: nil)
        onlytab=TabController()
        self.navigationController?.pushViewController(onlytab, animated: true)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        accounttextfield.resignFirstResponder()
        pswtextfield.resignFirstResponder()
    }
    
//    键盘即将出现的响应事件
    func keyboardWillShow(){
        self.view.frame = CGRect(x: self.view.frame.minX, y: self.view.frame.minY-100, width: self.view.frame.width, height: self.view.frame.height)
    }
    
    func keyboardWillHide(){
        self.view.frame = CGRect(x: self.view.frame.minX, y: self.view.frame.minY+100, width: self.view.frame.width, height: self.view.frame.height)
    }
}

