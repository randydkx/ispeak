
import UIKit
 
class voiceViewController: UIViewController,IFlyRecognizerViewDelegate {
    func onResult(_ resultArray: [Any]!, isLast: Bool) {
        var resultStr : String = ""
        if resultArray != nil {
            let resultDic : Dictionary<String, String> = resultArray[0] as! Dictionary<String, String>
            print("====resultDic: \(resultDic)")
            for key in resultDic.keys {
                resultStr += key
            }
        }
        
        if resultText != "" {
            if (resultText as NSString).substring(with: NSMakeRange( resultText.count - 1, 1)) != "," {
                resultText += ","
            }
        }
        
        resultText += resultStr
        textView.text = resultText
        
        if isRecongnizer {
            iflyRecognizerView.start()
        } else {
            iflyRecognizerView.cancel()
            if resultText != "" {
                resultText = (resultText as NSString).substring(with: NSMakeRange( 0, resultText.count)) + "。"
                textView.text = resultText
            }
        }
    }
    
    func onCompleted(_ error: IFlySpeechError!) {
        return
    }
    
 
    var iflyRecognizerView:IFlyRecognizerView!
    
    var isRecongnizer = false
    var resultText = ""
    var textView = UITextView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        var initString:String!
        initString = "appid=5f2b618a"
        IFlySpeechUtility.createUtility(initString)
        
        self.iflyRecognizerView = IFlyRecognizerView.init(center: self.view.center)as IFlyRecognizerView
        self.iflyRecognizerView.delegate = self
        self.iflyRecognizerView.setParameter("iat", forKey: IFlySpeechConstant.ifly_DOMAIN())
        self.iflyRecognizerView.setParameter("1000", forKey: IFlySpeechConstant.sample_RATE())
        // | result_type   | 返回结果的数据格式 plain,只支持plain
        self.iflyRecognizerView.setParameter("plain", forKey: IFlySpeechConstant.result_TYPE())
        
        
        textView.frame = CGRect(x: 50, y: 200, width: 200, height: 100)
        textView.backgroundColor = UIColor.gray
        textView.textColor = UIColor.white
        textView.text = "lllllll"
        self.view.addSubview(textView)
        
        let btn:UIButton = UIButton(frame:CGRect(x:100,y:100,width:100,height:100))
        btn.backgroundColor = UIColor.red
        btn.setTitle("语音识别", for: .normal)
        btn.addTarget(self, action: #selector(startVoiceBtn), for: .touchUpInside)
        self.view.addSubview(btn)
 
    }
    
    @objc func startVoiceBtn() {
        print("开始识别")
        iflyRecognizerView.start()
        
    }
    
    func onError(error: IFlySpeechError!) {
        print("识别出错：\(error.errorCode)")
    }
}
