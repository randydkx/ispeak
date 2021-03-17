

import UIKit
import SnapKit
//import UUIDShortener

class lwsController: UIViewController {
    let label1 = UILabel()
    let label2 = UILabel()
    
    @IBOutlet weak var button: UIButton!
    var player:  audioPlay?
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        label1.backgroundColor = UIColor.blue
        label2.backgroundColor = UIColor.red
        self.view.addSubview(label1)
        self.view.addSubview(label2)
        
        label1.snp.makeConstraints({
            (maker) in
            maker.height.equalTo(100)
            maker.width.equalTo(200)
            maker.top.equalTo(self.view.snp.top).offset(50)
            maker.leading.equalTo(self.view).offset(20)
        })
        
        label2.snp.makeConstraints({
            (maker) in
            maker.height.equalTo(100)
            maker.width.equalTo(200)
            maker.top.equalTo(label1.snp.bottom).offset(50)
            maker.leading.equalTo(self.view).offset(20)
        })
        
        button.addTarget(self, action: #selector(test), for: .touchUpInside)
        
//        let testString: [String] =
//        ["我我我  叫李丽丽，今年28，年龄28岁，家在山东在今后的很很很很长一段时间，内，我将  跟大家成为同事，同时非常希希希希望我我我我跟大家能成为很好的朋友。"]
//            ["大家好，我是陆宗泽,希望能和大家成为朋友","大家好，我是陆宗宗","大大大大家好","大家家家家好"]
//        ["我        "]
//        var radio: String = ""
//        for item in testString {
//            let alg = Algorithm(input: item)
//            let score = alg.Score()
//            radio.append("\(score) ")
//        }
//        label.text=radio
//        let dic = Dict.init(input: "和大家成为朋友")
//        dic.getRecommend()
//        let uuid = CFUUIDCreateString(nil, CFUUIDCreate(nil))
//        print(String(uuid!))
        
//        图片文件的地址
//        let string = "95EDFFBF-88E8-4F30-B1C3-2D4A7EEF23DE.png"
//
//        let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
//
//        let url = "\(docDir)/\(string)"
//        let url = "/var/mobile/Containers/Data/Application/4913F351-D297-41B9-BCD0-07E2730148C8/Documents/95EDFFBF-88E8-4F30-B1C3-2D4A7EEF23DE.png"
//        print(url)
//        let image = UIImage.init(contentsOfFile: url)
//        imageView.image = image
        
        
//        测试时间

//        get_current_time()
//        let path = "Optional(6DC5147F-3B54-43B5-88E3-5F73DC775AF8).aac"
//         player = audioPlay.init(path: get_audio_full_path(path: path))
////        print(player?.path)
//        button.addTarget(self, action: #selector(start), for: .touchUpInside)
        
//        for _ in 0..<100{
//            print(Int.randomIntNumber(range: Range(NSRange(location: 1, length: 6))!))
//        }
    }
    @objc func start(){
        
        player?.play_audio()
    }
    @objc func test(){
        UIView.animate(withDuration: 1.0, animations: {
            self.label1.snp.updateConstraints({
                (maker) in
                maker.height.equalTo(300)
            })
        }, completion: nil)
    }
}
