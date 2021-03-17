






import UIKit
import CoreData
import ProgressHUD

//练习分享界面

class shareTrainController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate,NSFetchedResultsControllerDelegate{

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var cancel: UIButton!
    @IBOutlet weak var goAhead: UIButton!
    @IBOutlet weak var addImageButton: UIButton!
    
    var recorderState: Bool = false
    var initx: CGFloat = 20
    var inity: CGFloat = 224
    var containerSize: CGFloat = 93
//    两张图片保存的完整路径
    var image1_full_path: String?
    var image2_full_path: String?
//    音频的完全路径
    var audio_full_path: String?
//    添加的两张图片
    
    
    @IBOutlet weak var imageadded: UIButton!
    @IBOutlet weak var imageadded2: UIButton!
    
//    一次发帖记录
    var post = PostEntity()
//    音频的完全路径
    var audio_path: String = ""
//    记录时间的录音时长定时器
    var audio_timer: Timer?
//    录音总时长
    var total_audio_time: Int = 0
//    发布的帖子所属的模块
    var module_to_send: String?
//    自我介绍按钮
    @IBOutlet weak var description_button: UIButton!
    
//    我的家乡按钮
    @IBOutlet weak var home_button: UIButton!
    
//    家庭成员按钮
    @IBOutlet weak var family_member_button: UIButton!
//    未来规划按钮
    @IBOutlet weak var future_plan_button: UIButton!
//    旅游规划按钮
    @IBOutlet weak var tourist_plan_button: UIButton!
//    职业规划按钮
    @IBOutlet weak var position_plan: UIButton!
//    学校生活
    @IBOutlet weak var school_life: UIButton!
//    我的朋友按钮
    @IBOutlet weak var my_friend: UIButton!
//    生活娱乐按钮
    @IBOutlet weak var lift_enter: UIButton!
//    运动健康
    @IBOutlet weak var sport_health: UIButton!
//    困难克服
    @IBOutlet weak var problem_solving: UIButton!
//    阅读推荐
    @IBOutlet weak var reading_reco: UIButton!
    
    
//    锁定的按钮,由前面视图传递过来并且由当前视图进行反馈
    var focused_button: Int = 0
//    六个按钮构成的按钮组
    var button_group: [UIButton] = []
//    录音播放器
    var audioPlayer: audioPlay?
//    播放定时器
    var timer: Timer?
//    选择的button在视图中显示
    @IBOutlet weak var global_button: UIButton!
//    判断当前是否处于hidden状态
    var global_button_is_hidden: Bool = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationController?.navigationBar.isHidden=true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.tintColor=UIColor.green
        
        textView.text = "你的想法..."
        textView.textColor = UIColor.lightGray
        textView.delegate = self
        cancel.addTarget(self, action: #selector(cancelButtonClicked), for: .touchUpInside)
        goAhead.addTarget(self, action: #selector(addButtonClicked), for: .touchUpInside)
        addImageButton.addTarget(self, action: #selector(addImageButtonClicked), for: .touchUpInside)
        

        self.button_group = [description_button,home_button,future_plan_button,family_member_button,tourist_plan_button,position_plan,school_life,my_friend,lift_enter,sport_health,problem_solving,reading_reco]
        
        //        当前按钮的下标和传过来的参数相差一个
                self.focused_button -= 1
//        设置十二个按钮的状态
        var index = 0
        for button in self.button_group{
            button.layer.cornerRadius = button.frame.height/2
            button.layer.borderWidth = 2
            button.layer.borderColor = CGColor.init(red: 217/255, green: 217/255, blue: 217/255, alpha: 1)
            button.tag = index
            if index == self.focused_button{
                button.backgroundColor = UIColor.black
                button.setTitleColor(UIColor.white, for: .normal)
            }
            index += 1
        }
        
        
        self.post.num_of_image = 0
//        设置随机的标志
        self.post.id = get_random_id()
//        设置所属的头像
//        获得两张图片的保存位置,并且设置post中的相关字段
        self.get_new_file_name(flag: 1)
        self.get_new_file_name(flag: 2)
        
//        设置音频的文件名称（音频名称加上扩展名）
        self.post.audio_path = self.audio_path
//        配置播放器的路径
        self.audioPlayer = audioPlay.init(path: get_audio_full_path(path: self.audio_path))
        
        let container_small = UIView(frame: CGRect(x: 204, y: 124, width: 180, height: 44))
        let long_image = UIImageView.init(frame: CGRect(x: 8, y: 4, width: 162, height: 36))
        long_image.image = UIImage(named: "组 1221")
        long_image.contentMode = .scaleToFill
        container_small.addSubview(long_image)
        
        let toPlaybutton = UIButton.init(frame: CGRect(x: 18, y: 10, width: 25, height: 25))
        toPlaybutton.tag = 10
        toPlaybutton.setImage(UIImage(named: "组 1225"), for: .normal)
        toPlaybutton.addTarget(self, action: #selector(toPlayButtonClicked), for: .touchUpInside)
        
        container_small.addSubview(toPlaybutton)
        let audio_time_label = UILabel.init(frame: CGRect(x: 119, y: 17, width: 39, height: 12))
        audio_time_label.text = int_time_transform(total_time: post.audio_time!)
        audio_time_label.font = UIFont.systemFont(ofSize: 14)
        container_small.addSubview(audio_time_label)
        
        self.view.addSubview(container_small)
        

        print("focused_button: \(self.focused_button)")
        global_button.setTitle(modules[self.focused_button + 1].title, for: .normal)
        global_button.setTitleColor(UIColor.systemGreen, for: .normal)
        global_button.layer.cornerRadius = global_button.frame.height/2
        global_button.layer.borderWidth = 2
        global_button.layer.borderColor = CGColor.init(red: 5.0/255.0, green: 144.0/255.0, blue: 61.0/255.0, alpha: 1)
        global_button.addTarget(self, action: #selector(clear_global_button), for: .touchUpInside)
        
        
    }
//    当前选中按钮被用户点击，消失
    @objc func clear_global_button(){
        self.global_button.isHidden = true
        self.global_button_is_hidden = true
        clear_all_button_color()
    }
    func clear_all_button_color(){
        for i in 0..<12{
            let tmp = button_group[i]
            tmp.backgroundColor = UIColor.clear
            tmp.setTitleColor(UIColor.systemGray, for: .normal)
        }
    }
     func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textAlignment = .natural
            textView.textColor = UIColor.black
        }
    }
    
//    点击了播放按钮，播放刚刚传过来的录音
    @objc func toPlayButtonClicked(){
        self.audioPlayer?.play_audio()
        let button = self.view.viewWithTag(10) as! UIButton
        button.setImage(UIImage(named: "组 1222"), for: .normal)
        self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(self.total_audio_time), target: self, selector: #selector(audio_ended), userInfo: nil, repeats: false)
    }
    
//    录音播放结束事件
    @objc func audio_ended(){
        self.timer?.invalidate()
        self.timer = nil
        self.audioPlayer?.stop_audio()
        let button = self.view.viewWithTag(10) as! UIButton
        button.setImage(UIImage(named: "组 1225"), for: .normal)
    }
    
    @IBAction func button_clicked(_ button: UIButton) {
        let tag = button.tag
        self.global_button.setTitle("#" + modules[tag + 1].title + " x", for: .normal)
        global_button.isHidden = false
        self.global_button_is_hidden = false
        for i in 0..<12{
            let tmp = button_group[i]
            if tmp.tag != tag{
                tmp.backgroundColor = UIColor.clear
                tmp.setTitleColor(UIColor.systemGray, for: .normal)
            }else{
                tmp.backgroundColor = UIColor.black
                tmp.setTitleColor(UIColor.white, for: .normal)
            }
        }
        self.focused_button = tag
        print("button_focused_change: \(self.focused_button)")
    }
//    textview结束编辑的回调函数
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "你的想法..."
            textView.textColor = UIColor.lightGray
        }
        else {
//            如果书写了内容就保存内容
            self.post.content = textView.text
        }
    }
//    获取新的图片文件名
    func get_new_file_name(flag: Int){
        let uuid = CFUUIDCreateString(nil, CFUUIDCreate(nil))
        
        let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
//       在数据库中仅仅保存名称和扩展名
//        设置图片1或者图片2在沙箱中的保存位置
        if flag == 1{
            self.post.image1_path = "\(String(uuid!)).png"
            self.image1_full_path = docDir+"/\(String(uuid!)).png"
        }
        else if flag == 2{
            self.post.image2_path = "\(String(uuid!)).png"
            self.image2_full_path = docDir+"/\(String(uuid!)).png"
        }
    }
    @objc func cancelButtonClicked(){
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    func progress_show(content: String){
        ProgressHUD.show(content, interaction: true)
        Timer.scheduledTimer(timeInterval: 0.8, target: self, selector: #selector(end), userInfo: nil, repeats: false)
    }
    @objc func end(){
        ProgressHUD.dismiss()
        self.post.time = get_current_time_2()
        if self.post.content == nil || self.post.content == ""{
            self.post.content = "我发表了一条帖子，快来看看吧"
        }
        self.post.comment = 0
        self.post.cherish = 0
//        self.post.audio_time = self.total_audio_time
        self.post.phoneNum = appUser?.phoneNum
        if total_audio_time == 0{
            self.post.has_audio = false
        }else{
            self.post.has_audio = true
        }
        self.post.user = UserEntity()
        self.post.user?.phoneNum = appUser?.phoneNum
        self.post.module = modules[self.focused_button + 1].title
        
//    添加记录
        self.insert_ont_post(post: self.post)
        self.dismiss(animated: true, completion: nil)
        self.tabBarController?.selectedIndex = 1
        self.navigationController?.popToRootViewController(animated: true)
    }
//    发表动态按钮被点击
    @objc func addButtonClicked(){
        if self.global_button_is_hidden == false{
            self.progress_show(content: "发表中...")
        }else{
            alert("请选择将要发帖的模块", current: self)
        }
    }

    
//    更新录音时长
    @objc func update_audio_time(){
        self.total_audio_time += 1
    }
    
    func createNewImage() -> UIImageView{
        return UIImageView.init()
    }
    @objc func addImageButtonClicked(){
        photos()
    }
    func photos()  {
        self.showBottomAlert()
    }
    func showBottomAlert(){
        let alertController=UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancel=UIAlertAction(title:"取消", style: .cancel, handler: nil)
        let takingPictures=UIAlertAction(title:"拍照", style: .default)
        {
            action in
            self.goCamera()
        }
        let localPhoto=UIAlertAction(title:"本地图片", style: .default)
        {
            action in
            self.goImage()

        }
        alertController.addAction(cancel)
        alertController.addAction(takingPictures)
        alertController.addAction(localPhoto)
        self.present(alertController, animated:true, completion:nil)
    }
    func goCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let  cameraPicker = UIImagePickerController()
            cameraPicker.delegate = self
            cameraPicker.allowsEditing = true
            cameraPicker.sourceType = .camera
            //在需要的地方present出来
            self.present(cameraPicker, animated: true, completion: nil)
        } else {
            print("不支持拍照")
        }
    }
    func goImage(){
        let photoPicker =  UIImagePickerController()
        photoPicker.delegate = self
        photoPicker.allowsEditing = true
        photoPicker.sourceType = .photoLibrary
        //在需要的地方present出来
        self.present(photoPicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        print("获得照片============= \(info)")
        let image : UIImage = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        imageadded.layer.cornerRadius = 20
        imageadded.layer.masksToBounds=true
        imageadded2.layer.cornerRadius = 20
        imageadded2.layer.masksToBounds=true
        if self.post.num_of_image == 0{
            self.post.num_of_image = 1
            imageadded?.setBackgroundImage(image, for: .normal)
            //        将图片保存到沙盒中
            let url = self.image1_full_path!

            let image_jpeg = image.jpegData(compressionQuality: 1.0)
            NSData(data: image_jpeg!).write(toFile: url, atomically: true)
            print("图片1成功写入")
        }
        else if self.post.num_of_image == 1{
            self.post.num_of_image = 2
            imageadded2?.setBackgroundImage(image, for: .normal)
            let url = self.image2_full_path!

            let image_jpeg = image.jpegData(compressionQuality: 1.0)
            NSData(data: image_jpeg!).write(toFile: url, atomically: true)
            print("图片2成功写入")
        }
        else {
            alert("最多只能上传两张照片哦", current: self)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section==0 {
            return 4
        }
        else{
            return 1
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.tintColor=UIColor.green
    }
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.tintColor=UIColor.green
    }
//    消失之前
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
//   消失之后
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textView.endEditing(true)
    }
//      textview改变的回调函数，用户在未离开输入框时也能保存输入信息
    func textViewDidChange(_ textView: UITextView) {
        self.post.content = textView.text
    }
    
//    在数据库中插入一条发帖记录
    func insert_ont_post(post:PostEntity){
        let context = getContext()
        let Entity = NSEntityDescription.entity(forEntityName: "Post", in: context)
        let post_to_insert = NSManagedObject(entity: Entity!, insertInto: context)
        
        post_to_insert.setValue((post.id)!, forKey: "id")
        post_to_insert.setValue(post.phoneNum!, forKey: "phoneNum")
        post_to_insert.setValue(post.audio_path!, forKey: "audio_path")
        post_to_insert.setValue(post.num_of_image, forKey: "num_of_image")
        post_to_insert.setValue(post.image1_path!, forKey: "image1_path")
        post_to_insert.setValue(post.image2_path!, forKey: "image2_path")
        post_to_insert.setValue(post.audio_time!, forKey: "audio_time")
        post_to_insert.setValue(post.cherish, forKey: "cherish")
        post_to_insert.setValue(post.comment, forKey: "comment")
        post_to_insert.setValue(post.content!, forKey: "content")
        post_to_insert.setValue(post.has_audio!, forKey: "has_audio")
        post_to_insert.setValue(post.time, forKey: "time")
        post_to_insert.setValue(post.module!, forKey: "module")
        
        do {
            try context.save()
            print("一条post记录成功插入")
            print("============================================")
            post.show()
        }catch{
            let error = error as NSError
            fatalError("错误：\(error)\n\(error.userInfo)")
        }
    }
}

