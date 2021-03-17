
import Foundation


class recommend{
    var distance: Double = 0.0
    var vector: [Int] = []
    var sentence: String = ""
    init(vector: [Int]) {
        self.distance = 0.0
        self.vector = vector
    }
}
func cmp(recommend1: recommend,recommend2: recommend) -> Bool{
    return recommend1.distance < recommend2.distance
}
class Dict{
    var input: String = ""
    var dictionary: [String] = []
//    语料库的长度
    let count: Int = 100
//    语料库种语句的最长长度
    let maxlength: Int = 40
//    推荐列表
    var recommends: [recommend] = []
    var sentences: [String] = repository().list
//    句子向量
    var inputVector: [Int] = []
    var vector: [[Int]] = [[Int]](repeating: [Int](repeating: 0, count: 10), count: 30)
//    构建语料库、初始化向量、推荐list构建
    init(input: String) {
        self.input = input
        self.inputVector = self.sentenceToVector(sentence: input)
        print("inputVector: \(inputVector)")
        for s in sentences{
            dictionary.append(s)
        }
        vector = [[Int]](repeating: [Int](repeating: 0, count: dictionary.count), count: 26)
        for i in 0..<dictionary.count{
            vector[i] = self.sentenceToVector(sentence: dictionary[i])
            let rec = recommend(vector: self.vector[i])
            rec.sentence = dictionary[i]
            recommends.append(rec)
        }
    }
    func sentenceToVector(sentence: String) -> [Int]{
        var ret = [Int](repeating: 0, count: 26)
        for i in 0..<sentence.count{
            let char = sentence[sentence.index(sentence.startIndex,offsetBy: i)]
            let str = String(char)
            let first: Character = str.transformToPinYin().first!
            var dim: Int = 0
            for code in String(first).unicodeScalars{
                dim = Int(code.value)
            }
            dim -= 97
            if dim >= 0 && dim <= 25 && ret[dim] == 0 {
                ret[dim] = 1
            }
        }
        print(ret)
        return ret
    }
//    计算向量之间的距离
    func distance(vector1: [Int],vector2: [Int]) -> Double{
        var ans: Double = 0.0
        for i in 0..<vector1.count{
            let l = Double(vector1[i])
            let r = Double(vector2[i])
            ans += (l-r)*(l-r)
        }
        return ans
    }
    func getRecommend(){
        for i in 0..<recommends.count{
            recommends[i].distance = self.distance(vector1: inputVector, vector2: recommends[i].vector)
        }
        recommends.sort(by: cmp)
        for i in 0..<recommends.count{
            print(recommends[i].distance)
        }
        print(recommends[0].sentence)
        print(recommends[1].sentence)
    }
}
