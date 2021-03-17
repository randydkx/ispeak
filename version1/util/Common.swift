import Foundation
import UIKit
import CoreData
import ProgressHUD

//设备物理尺寸
let ScreenHeight = UIScreen.main.bounds.size.height
let ScreenWidth = UIScreen.main.bounds.size.width
let isIphoneX: Bool = ScreenHeight == 812 || ScreenHeight == 896 ?true:false
//let navH: CGFloat = isIphoneX ? 89.0:64.0  //是否是刘海屏的导航高
//let barH: CGFloat = isIphoneX ? 80.0:50.0  //是否是刘海屏的 tabBar 的高
let navH: CGFloat = 89.0  //是否是刘海屏的导航高
let barH: CGFloat = 80.0  //是否是刘海屏的 tabBar 的高
/*通知名称*/
let refreshMainOneAngle = "refreshMainOneAngle" //刷新MainOne角标
let refreshMainTwoAngle = "refreshMainTwoAngle" //刷新MainTwo角标
let refreshMainThreeAngle = "refreshMainThreeAngle" //刷新MainThree角标
let refreshMainFourAngle = "refreshMainFourAngle" //刷新MainFour角标
//记录登录用户
var appUser: UserEntity?
//上次训练的口吃率
var last_train_ratio: String = "0.0%"
//注册界面保存的临时变量
var register_phoneNum: String?
var register_password: String?

var onlytab=TabController()
var isFirst=false

//全局的训练记录
var all_train_history: [TrainEntity] = []
var day_train_history: [TrainEntity] = []
var week_train_history: [TrainEntity] = []

//警告框封装
func alert(_ alertContent: String,current: UIViewController){
    let alert = UIAlertController(title: "提示", message: alertContent, preferredStyle: .alert)
    let confirm = UIAlertAction(title: "确定", style: .default, handler: nil)
    alert.addAction(confirm)
    current.present(alert, animated: true,completion: nil)
}



//扩展UIColor
extension UIColor{
    class func colorWithHex(hexStr:String) -> UIColor{
        return UIColor.colorWithHex(hexStr: hexStr, alpha: 1)
    }
}

extension UIColor{
    class func colorWithHex(hexStr:String, alpha:Float) -> UIColor{
        var cStr = hexStr.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased() as NSString;
        
        if(cStr.length < 6){
            return UIColor.clear;
        }
        
        if(cStr.hasPrefix("0x")) {
            cStr = cStr.substring(from: 2) as NSString
        }
        
        if(cStr.hasPrefix("#")){
            cStr = cStr.substring(from: 1) as NSString
        }
        
        if(cStr.length != 6){
            return UIColor.clear;
        }
        
        let rStr = (cStr as NSString).substring(to: 2)
        let gStr = ((cStr as NSString).substring(from: 2) as NSString).substring(to: 2)
        let bStr = ((cStr as NSString).substring(from: 4) as NSString).substring(to: 2)
        
        var r : UInt32 = 0x0
        var g : UInt32 = 0x0
        var b : UInt32 = 0x0
        
        Scanner.init(string: rStr).scanHexInt32(&r);
        Scanner.init(string: gStr).scanHexInt32(&g);
        Scanner.init(string: bStr).scanHexInt32(&b);
        
        return UIColor.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: CGFloat(alpha));
    }
}

func getImageFullPath(_ string: String) -> String{
    let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    
    return "\(docDir)/\(string)"
}

func getContext() -> NSManagedObjectContext{
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    return appDelegate.persistentContainer.viewContext
}


//获取当前的时间
func get_current_time() -> String{
    let date = Date()
    let calendar = Calendar.current
    let dateComponents = calendar.dateComponents(in: TimeZone.current, from: date)
    let current_time = "\(dateComponents.year!).\(dateComponents.month!).\(dateComponents.day!)"
    print("当前时间： "+current_time)
    return current_time
}
func get_current_time_2() -> String{
    let date = Date()
    let calendar = Calendar.current
    let dateComponents = calendar.dateComponents(in: TimeZone.current, from: date)
    let current_time = "\(dateComponents.year!)-\(dateComponents.month!)-\(dateComponents.day!)"
    print("当前时间： "+current_time)
    return current_time
}

func get_day_before(of_day_num: Int) -> String{
    let date = Date.init(timeIntervalSinceNow: TimeInterval(-24 * 60 * 60 * of_day_num))
    let calendar = Calendar.current
    let dateComponents = calendar.dateComponents(in: TimeZone.current, from: date)
    let expected_time = "\(dateComponents.year!).\(dateComponents.month!).\(dateComponents.day!)"
    print("时间： " + expected_time)
    
    return expected_time
}

func int_time_transform(total_time: Int) -> String{
    var _time: String = ""
    if total_time < 60{
        if total_time < 10{
            _time = "00:0\(total_time)"
        }
        else{
            _time = "00:\(total_time)"
        }
    }
    else {
        let min = total_time / 60
        let second = total_time % 60
        if second < 10{
            _time = "0\(min):0\(second)"
        }
        else{
            _time = "0\(min):\(second)"
        }
    }
    return _time
}

func get_audio_full_path(path: String) -> String{
    let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0]
    return "\(docDir)/\(path)"
}
//获取一个随机的id
func get_random_id() -> String{
    let uuid = CFUUIDCreateString(nil, CFUUIDCreate(nil))
    return String(uuid!)
}


//扩展整数，获取随机整数
public extension Int {
    /*这是一个内置函数
     lower : 内置为 0，可根据自己要获取的随机数进行修改。
     upper : 内置为 UInt32.max 的最大值，这里防止转化越界，造成的崩溃。
     返回的结果： [lower,upper) 之间的半开半闭区间的数。
     */
    public static func randomIntNumber(lower: Int = 0,upper: Int = Int(UInt32.max)) -> Int {
        return lower + Int(arc4random_uniform(UInt32(upper - lower)))
    }
    /**
     生成某个区间的随机数
     */
    public static func randomIntNumber(range: Range<Int>) -> Int {
        return randomIntNumber(lower: range.lowerBound, upper: range.upperBound)
    }
}
