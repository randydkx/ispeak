import Foundation

class Algorithm{
    var input: String = ""
    var target: String = ""
    var threthold_1: Float = 0.12
    var threthold_2: Float = 0.85
    var finalRatio: String = ""
    var scoreDouble: Double = 0.0
    var message: [String: String] = [String:String]()
    var listOfDuplicated: [Character] = []
    var listOfNotSmooth: [Character] = []
    var problemMap: [Character: String] = [Character: String]()
    var obstacleOfDuplicated: [Character] = []
    var obstacleOfNotSmooth: [Character] = []
    var problem: String = String("")
    var numOfDuplicated: Int = 0
    var numOfStop: Int = 0
//    var voicePosition: [Character: String] = ["b":"双唇音","p":"双唇音","m":"双唇音",]
    init(input: String) {
        print("==============================================")
        self.input = input
        preprocess()
    }
    func isIncludeChineseIn(string: String) -> Bool {
        
        for (_, value) in string.enumerated() {

            if ("\u{4E00}" <= value  && value <= "\u{9FA5}") {
                return true
            }
        }
        
        return false
    }
    func preprocess(){
        
        var m: Int = input.count
        print("source: \n\(self.input)")
        for i in 0..<m{
            if !(input[input.index(input.startIndex,offsetBy: i)] == Character(" ")){
                self.target.append(input[input.index(input.startIndex,offsetBy: i)])
            }else{
//                停顿数量增加
                self.numOfStop += 1
                if i != 0 {
                    let c = input[input.index(input.startIndex,offsetBy: i-1)]
                    if c != " "{
                        listOfNotSmooth.append(c)
                    }
                }
            }
        }
//        print("delete all the whiteSpace:\n\(self.target)")
        
//        var size1: Int = input.count
//        for i in 0..<size1{
//            let c = input[input.index(input.startIndex,offsetBy: i)]
//            let str = String(c)
//            if !isIncludeChineseIn(string: str){
//                print("str:\(str)")
//                print("+++++++++++++++++++++++++++++++++++++++")
//                if i < size1-1{
//                    for j in i...size1-2{
//                        input.insert(input[input.index(input.startIndex,offsetBy: i+1)], at: input.index(input.startIndex, offsetBy: i))
//                    }
//                    size1 -= 1
//                }
//            }
//        }
//
        
        var i = 1
        var size = target.count
        while i < size{
            if target[target.index(target.startIndex,offsetBy: i)] == target[target.index(target.startIndex,offsetBy: i-1)]{
                if i-4 >= 0 {
                    let nsString: NSString = NSString(utf8String: self.target)!
                    let slice: String = nsString.substring(with: NSRange(location: i-4, length: 3))
                    if !slice.contains("我是") && !slice.contains("我叫") && !slice.contains("是") && !slice.contains("叫"){
                        let target_i = target[target.index(target.startIndex,offsetBy: i)]
                        if (listOfDuplicated.count > 0) && (target_i != listOfDuplicated[listOfDuplicated.count - 1]) {
                            listOfDuplicated.append(target_i)
                        }else if listOfDuplicated.count == 0{
                            listOfDuplicated.append(target_i)
                        }
//                        发现重复的而且还不是名字的字，重复数量增加一个
                        self.numOfDuplicated += 1
                        target.remove(at: target.index(target.startIndex,offsetBy: i))
                        size -= 1
                        continue
                    }else{
                        i+=1
                    }
                }else{
//                    发现重复的，而且不可鞥是名字中的字，这时候重复的数量也要增加一个
                    self.numOfDuplicated += 1
                    let target_i = target[target.index(target.startIndex,offsetBy: i)]
                    if (listOfDuplicated.count > 0) && (target_i != listOfDuplicated[listOfDuplicated.count - 1]) {
                        print("(\(target_i),\(listOfDuplicated[listOfDuplicated.count-1]))")
                        listOfDuplicated.append(target_i)
                    }else if listOfDuplicated.count == 0{
                        listOfDuplicated.append(target_i)
                    }
                    target.remove(at: target.index(target.startIndex,offsetBy: i))
                    size -= 1
                }
            }else{
                i+=1
            }
        }
        print("preprocessed:\n\(self.target)")
    }
//    最长公共子串长度
    func lcs() -> Int{
        let m: Int = input.count
        let n: Int = target.count
        var dp = [[Int]](repeating: [Int](repeating: 0, count: 200), count: 200)
        for i in 1...m{
            for j in 1...n{
                if input[input.index(input.startIndex,offsetBy: i-1)] == target[target.index(target.startIndex,offsetBy: j-1)]{
                    dp[i][j] = dp[i-1][j-1]+1
                    dp[i][j] = max(dp[i][j],max(dp[i-1][j],dp[i][j-1]))
                }else{
                    dp[i][j] = max(dp[i-1][j],dp[i][j-1])
                }
            }
        }
        
        return dp[m][n]
    }
//    编辑距离
    func ld() -> Int{
        let m: Int = input.count
        let n: Int = target.count
        print("m: \(m) n: \(n)")
        if m == 0{
            return n
        }
        if n == 0{
            return m
        }
        var matrix = [[Int]](repeating: [Int](repeating: 0, count: 200), count: 200)
        
        for i in 0..<m{
            matrix[i][0]=i
        }
        for j in 0..<n{
            matrix[0][j]=j
        }
        for i in 1..<m{
            for j in 1..<n{
                let input_i = self.input[input.index(input.startIndex,offsetBy: i)]
                let target_j = self.target[target.index(target.startIndex,offsetBy: j)]
                let t: Int =  input_i == target_j ? 0 : 1
                matrix[i][j] = min(matrix[i-1][j-1]+t,min(matrix[i-1][j] + 1,matrix[i][j-1] + 1))
             }
        }
        
        return matrix[m-1][n-1]
    }
//    开始口吃的位置
    func delta() -> Int{
        let m: Int = input.count
        let n: Int = target.count
        var startPoint: Int = 0
        for i in 0..<min(n,m){
            if self.input[input.index(input.startIndex,offsetBy: i)] == self.target[target.index(target.startIndex,offsetBy: i)]{
                startPoint += 1
            }else{
                break
            }
        }
        if startPoint < m/4{
            startPoint = 3*m/4
        }else if startPoint < 3*m/4{
            startPoint = 3*m/4
        }else {
            startPoint = m
        }
        
        return startPoint
    }
    func getStringByList(charList: [Character]) ->String {
        if charList.count == 1{
            return String(charList[0])
        }
        var result = ""
        for i in 0..<charList.count-1{
            result.append(String(charList[i])+"、")
        }
        result.append(String(charList[charList.count-1]))
        return result
    }
//    list去重函数
    func dropDuplicatedValue(inlist: [Character]) -> [Character]{
        var list = inlist
        var size = list.count
        var i = 0
        while i < size{
            let char = list[i]
            for j in i+1 ..< size{
                if list[j] == char{
                    list.remove(at: j)
                    size -= 1
                }
            }
            i += 1
        }
        
        return list
    }
//    分析口吃者存在的发音问题
    func problemDetection(){
        listOfDuplicated = self.dropDuplicatedValue(inlist: listOfDuplicated)
        listOfNotSmooth = self.dropDuplicatedValue(inlist: listOfNotSmooth)
        for char in listOfNotSmooth{
            let str = String(char)
            let pinyin = str.transformToPinYin()
            obstacleOfNotSmooth.append(pinyin.first!)
//            print("发音拖长检测：\(pinyin.first!)")
        }
        for char in listOfDuplicated{
            let str = String(char)
            let pinyin = str.transformToPinYin()
            obstacleOfDuplicated.append(pinyin.first!)
//            print("发音受阻检测：\(pinyin.first!)")
        }
        if listOfNotSmooth.count > 0{
            self.message.updateValue(self.getStringByList(charList: obstacleOfNotSmooth), forKey: "音节拖长")
        }
        if listOfDuplicated.count > 0{
            self.message.updateValue(self.getStringByList(charList: obstacleOfDuplicated), forKey: "发音受阻")
        }
    }
    func problemRecoder(){
        var flag = false
        self.problem=""
        if self.message.keys.contains("音节拖长"){
            self.problem.append(self.message["音节拖长"]!+"发音存在拖长现象")
            flag=true
        }
        if flag && self.message.keys.contains("发音受阻"){
            self.problem.append("\n"+self.message["发音受阻"]!+"发音存在受阻塞现象")
        }else if !flag && self.message.keys.contains("发音受阻"){
            self.problem.append(self.message["发音受阻"]!+"发音存在受阻塞现象")
        }
        if self.problem.count == 0{
            self.problem = "发音不存在问题！"
        }
        print(self.problem)
    }
//    评分
    func Score() -> String{
        if self.input.count != 0 {
            let LCS = Float(lcs())
            let LD = Float(ld())
            let DELTA = Float(delta())
            let LENGTH = Float(input.count)
            var score = 1-LCS/(LD+LCS)*(DELTA/LENGTH)
            if(score < self.threthold_1){
                score = 0
            }
            if(score > self.threthold_2){
                score = 1.0
            }
            self.scoreDouble = Double(score)
            score = Float(score*1000).rounded()
            self.finalRatio = String("\(score/10)%")
            print("lcs: \(LCS)\nld: \(LD)\nDELTA: \(DELTA)\nlength: \(LENGTH)\nscore: --------->  \(score/10)")
            print("listOfNotSmooth: "+listOfNotSmooth+"\tsize: \(listOfNotSmooth.count)")
            print("listOfDuplicated: "+listOfDuplicated+"\tsize: \(listOfDuplicated.count)")
            print("重复的次数： \(self.numOfDuplicated)\n停顿的次数： \(self.numOfStop)")
        }
        self.problemDetection()
        self.problemRecoder()
        if self.input.count == 0{
            self.finalRatio = String("0.0%")
        }
        return self.finalRatio
    }
}


extension String{
//    转换字符串并且删除空格
    func transformToPinYin() -> String{
        let mutableString = NSMutableString(string: self)
        CFStringTransform(mutableString,nil,kCFStringTransformToLatin,false)
        CFStringTransform(mutableString, nil, kCFStringTransformStripDiacritics, false)
        let string = String(mutableString)
        return string.replacingOccurrences(of: " ", with: "")
    }
}


extension Double {
///四舍五入 到小数点后某一位
    func roundTo(places: Int) -> Double {
    let divisor = pow(10.0, Double(places))
    return (self * divisor).rounded() / divisor
    }
}
