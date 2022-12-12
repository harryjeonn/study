import Foundation

class SomeClass {
    var count = 0
    
    deinit {
        print("할당 해제")
    }
}

struct SomeStruct {
    var count = 0
}

var someClass1 = SomeClass()
var someClass2 = someClass1
var someClass3 = someClass1

someClass3.count = 3

print(someClass1.count)

var someStruct1 = SomeStruct()
var someStruct2 = someStruct1
var someStruct3 = someStruct1

someStruct3.count = 3

print(someStruct1.count)

print("ARC Test")
var arcTest1: SomeClass? = SomeClass()
print(CFGetRetainCount(arcTest1)) // 2

var arcTest2 = arcTest1
print(CFGetRetainCount(arcTest1)) // 3

arcTest1 = nil
// print(CFGetRetainCount(arcTest1)) // 2 이미 인스턴스를 해제한 arcTest1은 호출할 수 없음
print(CFGetRetainCount(arcTest2)) // 2

arcTest2 = nil
