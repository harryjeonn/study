import Foundation

//func swapTwoInts(_ a: inout Int, _ b: inout Int) {
//    let temporaryA = a
//    a = b
//    b = temporaryA
//}
//
//var someInt = 3
//var anotherInt = 107
//swapTwoInts(&someInt, &anotherInt)
//print("someInt is now \(someInt), and anotherInt is now \(anotherInt)")
//
//func swapTwoValues<T>(_ a: inout T, _ b: inout T) {
//    let temporaryA = a
//    a = b
//    b = temporaryA
//    print("a is now \(a), and b is now \(b)")
//}
//
//swapTwoValues(&someInt, &anotherInt)
//// someInt is now 107, and anotherInt is now 3
//
//var someString = "hello"
//var anotherString = "world"
//swapTwoValues(&someString, &anotherString)
//// someString is now "world", and anotherString is now "hello"
//
//struct IntStack {
//    var items: [Int] = []
//
//    mutating func push(_ item: Int) {
//        items.append(item)
//    }
//
//    mutating func pop() -> Int {
//        return items.removeLast()
//    }
//}
//
//var intStack = IntStack()
//
//intStack.push(0)
//print(intStack.items) // [0]
//intStack.push(1)
//print(intStack.items) // [0, 1]
//intStack.push(2)
//print(intStack.items) // [0, 1, 2]
//intStack.pop()
//print(intStack.items) // [0, 1]
//
//struct Stack<Element> {
//    var items: [Element] = []
//    
//    mutating func push(_ element: Element) {
//        items.append(element)
//    }
//    
//    mutating func pop() -> Element {
//        return items.removeLast()
//    }
//}
//
//var stack = Stack<String>()
//
//stack.push("ha")
//print(stack.items) // ["ha"]
//stack.push("rr")
//print(stack.items) // ["ha", "rr"]
//stack.push("y")
//print(stack.items) // ["ha", "rr", "y"]
//stack.pop()
//print(stack.items) // ["ha", "rr"]
//
//extension Stack {
//    var topItem: Element? {
//        return items.isEmpty ? nil : items[items.count - 1]
//    }
//}
//
//if let topItem = stack.topItem {
//    print("The top item on the stack is \(topItem).")
//}
//
//class SomeClass {
//    
//}
//
//protocol SomeProtocol {
//    
//}
//
//func someFunction<T: SomeClass, U: SomeProtocol>(someT: T, someU: U) {
//    // function body goes here
//}

//func findIndex(ofString valueToFind: String, in array: [String]) -> Int? {
//    for (index, value) in array.enumerated() {
//        if value == valueToFind {
//            return index
//        }
//    }
//
//    return nil
//}
//
//let testStrings = ["dog", "cat", "llama", "parakeet"]

//if let foundIndex = findIndex(ofString: "cat", in: testStrings) {
//    print("The index of cat is \(foundIndex)")
//}

//func findIndex<T: Equatable>(of valueToFind: T, in array: [T]) -> Int? {
//    for (index, value) in array.enumerated() {
//        if value == valueToFind {
//            return index
//        }
//    }
//
//    return nil
//}
//
//let doubleIndex = findIndex(of: 9.3, in: [3.14159, 0.1, 0.25])
//// doubleIndex is an optional Int with no value, because 9.3 isn't in the array
//let stringIndex = findIndex(of: "Andrea", in: ["Mike", "Malcolm", "Andrea"])
//// stringIndex is an optional Int containing a value of 2

protocol Container {
    associatedtype Item
    mutating func append(_ item: Item)
    var count: Int { get }
    subscript(i: Int) -> Item { get }
}

struct IntStack: Container {
    var items = [Int]()

    mutating func push(_ item: Int) {
        items.append(item)
    }

    mutating func pop() -> Int {
        return items.removeLast()
    }

    typealias Item = Int

    mutating func append(_ item: Int) {
        self.push(item)
    }

    var count: Int {
        return items.count
    }

    subscript(i: Int) -> Int {
        return items[i]
    }
}

struct Stack<Element>: Container {
    var items = [Element]()

    mutating func push(_ item: Element) {
        items.append(item)
    }

    mutating func pop() -> Element {
        return items.removeLast()
    }

    typealias Item = Element

    mutating func append(_ item: Element) {
        self.push(item)
    }

    var count: Int {
        return items.count
    }

    subscript(i: Int) -> Element {
        return items[i]
    }
}

extension Array: Container {}

protocol SuffixableContainer: Container {
    associatedtype Suffix: SuffixableContainer where Suffix.Item == Item
    func suffix(_ size: Int) -> Suffix
}

extension Stack: SuffixableContainer {
    func suffix(_ size: Int) -> Stack {
        var result = Stack()
        for index in (count-size)..<count {
            result.append(self[index])
        }
        return result
    }
    // Inferred that Suffix is Stack.
}
var stackOfInts = Stack<Int>()
stackOfInts.append(10)
stackOfInts.append(20)
stackOfInts.append(30)
let suffix = stackOfInts.suffix(2)
print(suffix)
// suffix contains 20 and 30

extension IntStack: SuffixableContainer {
    func suffix(_ size: Int) -> Stack<Int> {
        var result = Stack<Int>()
        for index in (count-size)..<count {
            result.append(self[index])
        }
        return result
    }
    // Inferred that Suffix is Stack<Int>.
}

func allItemsMatch<C1: Container, C2: Container>(_ someContainer: C1, _ anotherContainer: C2) -> Bool where C1.Item == C2.Item, C1.Item: Equatable {

        // Check that both containers contain the same number of items.
        if someContainer.count != anotherContainer.count {
            return false
        }

        // Check each pair of items to see if they're equivalent.
        for i in 0..<someContainer.count {
            if someContainer[i] != anotherContainer[i] {
                return false
            }
        }

        // All items match, so return true.
        return true
}

var stackOfStrings = Stack<String>()
stackOfStrings.push("uno")
stackOfStrings.push("dos")
stackOfStrings.push("tres")

var arrayOfStrings = ["uno", "dos", "tres"]

if allItemsMatch(stackOfStrings, arrayOfStrings) {
    print("All items match.")
} else {
    print("Not all items match.")
}
// Prints "All items match."

extension Stack where Element: Equatable {
    func isTop(_ item: Element) -> Bool {
        guard let topItem = items.last else {
            return false
        }
        return topItem == item
    }
}

extension Container where Item: Equatable {
    func startsWith(_ item: Item) -> Bool {
        return count >= 1 && self[0] == item
    }
}

if [9, 9, 9].startsWith(42) {
    print("Starts with 42.")
} else {
    print("Starts with something else.")
}
// Prints "Starts with something else."

extension Container where Item == Double {
    func average() -> Double {
        var sum = 0.0
        for index in 0..<count {
            sum += self[index]
        }
        return sum / Double(count)
    }
}
print([1260.0, 1200.0, 98.6, 37.0].average())
// Prints "648.9"

