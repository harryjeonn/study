# [Swift] Generic

구분: Swift
업로드일: 2022/11/21
작성완료: Yes

제네릭에 대해서 알아보자.

제네릭은 더 유연하고 재사용 가능한 함수와 타입의 코드를 작성하는 것을 가능하게 해준다.

## 제네릭이 풀려고 하는 문제

```swift
func swapTwoInts(_ a: inout Int, _ b: inout Int) {
    let temporaryA = a
    a = b
    b = temporaryA
}

var someInt = 3
var anotherInt = 107
swapTwoInts(&someInt, &anotherInt)
print("someInt is now \(someInt), and anotherInt is now \(anotherInt)")
```

두 Int 값을 바꾸는 함수가 있다.

두 개의 파라미터는 `inout` 파라미터이다.

<aside>
💡 `inout` 파라미터는 함수 내부에서 파라미터의 값을 변경할 수 있다.
함수를 선언할 때 & 을 사용하여 해당 값이 함수 내부에서 변경될 것임을 나타내야 한다.

</aside>

함수를 선언하면 입력한 두 Int 값이 변경된 것을 확인할 수 있다.

만약 Int형이 아니라 String 값을 변경하려면 어떻게 해야할까?

```swift
func swapTwoStrings(_ a: inout String, _ b: inout String) {
    let temporaryA = a
    a = b
    b = temporaryA
}

func swapTwoDoubles(_ a: inout Double, _ b: inout Double) {
    let temporaryA = a
    a = b
    b = temporaryA
}
```

타입이 달라지면 함수를 새로 선언해야한다.

여기서 함수 내부의 내용이 타입만 다르고 같은 내용이라는 것을 알 수 있다.

이때 제네릭을 사용하면 타입만 다르고 수행하는 기능이 동일한 것을 하나의 함수로 만들 수 있다.

## 제네릭 함수 (Generic Functions)

위 세 함수를 하나의 제네릭 함수로 만들어 보자.

함수명 뒤에 < >을 붙이고 a, b 파라미터를 T로 선언한다.

T는 타입이 어떤 타입이어야 하는지 명시하지 않지만 두 인자의 타입이 같다는 것을 알려준다.

```swift
func swapTwoValues<T>(_ a: inout T, _ b: inout T) {
    let temporaryA = a
    a = b
    b = temporaryA
    print("a is now \(a), and b is now \(b)")
}
```

Swift는 실제 실행하는 타입 T가 어떤 타입인지 보지 않는다.

`swapTwoValues` 함수가 실행되면 T에 해당하는 값을 함수에 넘긴다.

```swift
func swapTwoInts(_ a: inout Int, _ b: inout Int)
func swapTwoValues<T>(_ a: inout T, _ b: inout T)
```

제네릭으로 선언한 함수를 실행하면 기대했던 대로 동작하는 것을 확인할 수 있다.

```swift
var someInt = 3
var anotherInt = 107
swapTwoValues(&someInt, &anotherInt)
// someInt is now 107, and anotherInt is now 3

var someString = "hello"
var anotherString = "world"
swapTwoValues(&someString, &anotherString)
// someString is now "world", and anotherString is now "hello"
```

## 타입 파라미터 (Type Parameters)

위에서 사용한 플레이스홀더 T는 타입 파라미터의 예다.

타입 파라미터는 플레이스홀더 타입의 이름을 명시하고 함수명 바로 뒤에 적어주고 < >로 묶어준다.

타입 파라미터를 한번 선언하면 이 것을 함수의 타입으로 사용할 수 있다.

복수의 타입 파라미터를 사용할때는 ,로 구분해준다.

## 파라미터 이름짓기 (Naming Type Parameters)

Dictionary의 Key, Value처럼 서로 상관관계가 있는 경우 의미가 있는 이름으로 짓고, 그렇지 않은 경우 T, U, V와 같은 단일 문자로 파라미터 이름을 짓는다.

<aside>
💡 파라미터의 이름은 항상 T나 MyTypeParameter와 같이 대문자 카멜케이스를 사용한다. 대문자로 된 이름은 값이 아니라 타입을 의미한다.

</aside>

## 제네릭 타입 (Generic Type)

제네릭 함수에 추가로 Swift에서는 제네릭 타입을 정의할 수 있다.

이후 섹션에서는 Stack이라는 제네릭 컬렉션 타입을 어떻게 구현하는지 알아볼 예정이다.

### Stack의 동작

![Untitled](%5BSwift%5D%20Generic%203a8ade277b0c4519a3f87bdeff8b4df5/Untitled.png)

1. 현재 스택에는 3개의 값이 있다.
2. 네 번째 값은 스택의 맨 위에 push된다.
3. 스택은 이제 가장 최근 값이 맨 위에 있는 4개의 값을 보유한다.
4. 스택의 맨 위 항목이 pop된다.
5. 값을 pop한 후 스택은 다시 3개의 값을 보유한다.

```swift
struct IntStack {
    var items: [Int] = []
    
    mutating func push(_ item: Int) {
        items.append(item)
    }
    
    mutating func pop() -> Int {
        return items.removeLast()
    }
}

// 출력
var intStack = IntStack()

intStack.push(0)
print(intStack.items) // [0]
intStack.push(1)
print(intStack.items) // [0, 1]
intStack.push(2)
print(intStack.items) // [0, 1, 2]
intStack.pop()
print(intStack.items) // [0, 1]
```

Int 타입의 Stack을 구현하면 위와 같다.

이걸 제네릭 형태로 바꿔보자.

```swift
struct Stack<Element> {
    var items: [Element] = []
    
    mutating func push(_ element: Element) {
        items.append(element)
    }
    
    mutating func pop() -> Element {
        return items.removeLast()
    }
}

// 출력
var stack = Stack<String>()

stack.push("ha")
print(stack.items) // ["ha"]
stack.push("rr")
print(stack.items) // ["ha", "rr"]
stack.push("y")
print(stack.items) // ["ha", "rr", "y"]
stack.pop()
print(stack.items) // ["ha", "rr"]
```

제네릭 형태로 변경 후 String 타입을 받도록 했다.

### 제네릭 타입의 확장 (Extending a Generic Type)

`extension`을 이용해 제네릭 타입을 확장할 수 있다.

이때 원래 선언한 파라미터 이름을 사용한다.

```swift
extension Stack {
    var topItem: Element? {
        return items.isEmpty ? nil : items[items.count - 1]
    }
}

if let topItem = stack.topItem {
    print("The top item on the stack is \(topItem).")
}
```

extension으로 접근한 topItem 프로퍼티에 접근하여 스택의 최상단 값을 확인할 수 있다.

### 타입 제한 (Type Constraints)

Swift의 Dictionary 타입은 key값을 사용한다. 이때 key값은 유일한 값이어야 하기 때무넹 `Hashable`이라는 프로토콜을 반드시 따라야 한다. 그렇지 않으면 key로 value에 접근했을 때 적절한 value를 얻지 못할 수 있다.

이 처럼 특정 타입이 반드시 어떤 프로토콜을 따라야 하는 경우가 있다. 제네릭에서도 이런 경우가 필요할 수 있다. 제네릭에서는 특정 클래스를 상속하거나 특정 프로토콜을 따르거나 합성하도록 명시할 수 있다.

### 타입 제한 문법 (Type Constraints Syntax)

```swift
func someFunction<T: SomeClass, U: SomeProtocol>(someT: T, someU: U) {
    // function body goes here
}
```

제네릭 함수를 선언할 때 파라미터 뒤에 상속 받아야하는 클래스를 선언하거나, 반드시 따라야하는 프로토콜을 명시할 수 있다.

### 타입 제한의 실 사용 (Type Constraints in Action)

```swift
func findIndex(ofString valueToFind: String, in array: [String]) -> Int? {
    for (index, value) in array.enumerated() {
        if value == valueToFind {
            return index
        }
    }
    
    return nil
}
```

다음과 같이 한 배열에서 특정 문자를 검색하는 findIndex 함수를 선언한다.

```swift
let testStrings = ["dog", "cat", "llama", "parakeet"]

if let foundIndex = findIndex(ofString: "cat", in: testStrings) {
    print("The index of cat is \(foundIndex)") // The index of cat is 1
}
```

이 함수를 실행하면 strings 배열에서 원하는 문자열의 인덱스를 찾는 것이 잘 동작함을 알 수 있다.

위 함수를 제네릭으로 구현해보자

```swift
func findIndex<T>(of valueToFind: T, in array: [T]) -> Int? {
    for (index, value) in array.enumerated() {
        if value == valueToFind {
            return index
        }
    }
    
    return nil
}
```

위 코드는 에러가 발생한다.

이유는 value == valueToFind 코드에서 두 값을 비교하게되는데 == 등호 메소드를 사용하기 위해서는 두 값 혹은 객체가 반드시 `Equatable` 프로토콜을 따라야 하기 때문이다. 이 문제를 해결하기 위해 T는 `Equatable` 프로토콜을 따른다고 표시한다.

```swift
func findIndex<T: Equatable>(of valueToFind: T, in array: [T]) -> Int? {
    for (index, value) in array.enumerated() {
        if value == valueToFind {
            return index
        }
    }
    
    return nil
}

let doubleIndex = findIndex(of: 9.3, in: [3.14159, 0.1, 0.25])
// doubleIndex is an optional Int with no value, because 9.3 isn't in the array
let stringIndex = findIndex(of: "Andrea", in: ["Mike", "Malcolm", "Andrea"])
// stringIndex is an optional Int containing a value of 2
```

`<T: Equatable>`로 타입 플레이스 홀더에 적어준다. 이것으로 T는 `Equatable` 프로토콜을 따른다는 것을 알려준다.

프로토콜을 따른다고 표시한 후 에러없이 빌드되고 사용할 수 있다.

---

저번 글에 이어서 제네릭에 대해서 더 알아보자

[https://harryjeon.tistory.com/53](https://harryjeon.tistory.com/53)

## 연관 타입 (Associated Types)

연관 타입은 프로토콜의 일부분으로 타입에 플레이스홀더 이름을 부여한다.

다시말해 특정 타입을 동적으로 지정해 사용할 수 있다.

### 연관 타입의 실 사용 (Associated Types in Action)

```swift
protocol Container {
    associatedtype Item
    mutating func append(_ item: Item)
    var count: Int { get }
    subscript(i: Int) -> Item { get }
}
```

위와 같이 `associatedtype`을 사용할 수 있다.

이렇게 지정하면 `Item`은 어떤 타입도 될 수 있다.

```swift
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
```

위 코드에서는 Item을 Int형으로 선언해 사용했다.

Element형으로 지정하여 바꿔보자.

```swift
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
```

### 존재 하는 타입에 연관 타입을 확장 (Extending an Existing Type to Specify an Associated Type)

```swift
extension Array: Container {}
```

위와 같이 기존의 타입 Array에 extension을 사용하여 특정 연관타입을 추가할 수 있다.

이것이 가능한 이유는 Array타입은 Container에 선언된 `append`, `count`, `subscript`가 모두 정의되어 있기 때문이다.

### 프로토콜에 연관 타입의 제한 사용하기 (Using a Protocol in Its Associated Type’s Constraints)

연관 타입을 적용할 수 있는 타입에 조건을 걸어 제한을 둘 수 있다. 조건을 붙일 때는 `where`구문을 사용한다. 이 조건에는 특정 타입인지, 특정 프로토콜을 따르는지 등의 여부를 알 수 있다.

```swift
protocol SuffixableContainer: Container {
    associatedtype Suffix: SuffixableContainer where Suffix.Item == Item
    func suffix(_ size: Int) -> Suffix
}
```

위 코드는 Suffix가 SuffixableContainer 프로토콜을 따르고 Item타입이 반드시 Container의 Item타입이어야 한다는 조건을 추가한 것이다.

위에서 Stack의 연관 타입 Suffix 또한 Stack이다. Stack의 suffix의 실행으로 또 다른 Stack을 반환하게 된다. 

그래서 IntStack에 Stack을 사용해 SuffixableContainer을 따르는 extension을 선언할 수도 있다.

```swift
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
```

### 제네릭의 where절 (Generic Where Clauses)

제네릭에서도 where절을 사용할 수 있다.

```swift
func allItemsMatch<C1: Container, C2: Container>
    (_ someContainer: C1, _ anotherContainer: C2) -> Bool
    where C1.Item == C2.Item, C1.Item: Equatable {

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
```

Container C1과 C2를 비교하여 모든 값이 같을 때 true를 반환하는 코드이다.

위에서 Container가 달라도 상관없다. 단지 각 Container의 같은 인덱스의 모든 값이 같다면 true를 얻게 된다.

```swift
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
```

같은 값을 가지고 있지만 하나는 Stack, 하나는 Array Container이다.

Container가 다르지만 값이 같기 때문에 true를 반환한다.

### Where절을 포함하는 제네릭의 익스텐션 (Extensions with a Generic Where Clause)

제네릭의 extension을 추가할 때 where을 사용할 수 있다.

```swift
extension Stack where Element: Equatable {
    func isTop(_ item: Element) -> Bool {
        guard let topItem = items.last else {
            return false
        }
        return topItem == item
    }
}
```

위 코드는 제네릭(Stack)에 extension으로 isTop 함수를 추가하면서 이 함수가 추가되는 Stack은 반드시 Equatable 프로토콜을 따라야한다고 제한을 부여한 코드이다.

```swift
if stackOfStrings.isTop("tres") {
    print("Top element is tres.")
} else {
    print("Top element is something else.")
}
// Prints "Top element is tres."
```

String은 Equatable 프로토콜을 따르기때문에 true에 해당하는 분기가 실행된다.

Equatable 프로토콜을 따르지 않는다면 어떻게 될지 한번 만들어보자

```swift
struct NotEquatable { }
var notEquatableStack = Stack<NotEquatable>()
let notEquatableValue = NotEquatable()
notEquatableStack.push(notEquatableValue)
notEquatableStack.isTop(notEquatableValue) // Error
```

Equatable을 따르지 않는 Stack에서 isTop함수를 실행하면 에러가 발생한다.

```swift
extension Container where Item: Equatable {
    func startsWith(_ item: Item) -> Bool {
        return count >= 1 && self[0] == item
    }
}
```

위 코드는 Container의 Item이 Equatable을 따라야 한다고 제한을 부여한 코드이다.

startsWith 함수의 인자인 Item은 Container의 특정 아이템이 입력한 Item으로 시작하는지 비교하기 위해서는 Container의 첫 아이템이 입력한 Item과 같은지 비교해야 하기 때문에 Equatable프로토콜을 따라야 한다.

```swift
if [9, 9, 9].startsWith(42) {
    print("Starts with 42.")
} else {
    print("Starts with something else.")
}
// Prints "Starts with something else."
```

Container 프로토콜을 따르는 Array에서 startsWith 함수를 실행한다.

Int 값인 42는 Equatable 프로토콜을 따르므로 startsWith 함수가 실행되고 42는 배열의 첫 번째 값인 9과 같지 않기 때문에 같지 않다는 분기가 실행된다.

```swift
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
```

where 절에서 특정 프로토콜을 따르는 것 뿐만 아니라 특정 값 타입인지 비교하는 구분을 사용할 수도 있다.

위는 Item이 Double형인지 비교한 코드이다.

Container의 Item [1260.0, 1200.0, 98.6, 37.0]이 Double형이기 때문에 익스텐션에서 구현된 average()를 사용할 수 있습니다.

### 제네릭의 연관 타입에 where절 적용 (Associated Types with a Generic Where Clause)

연관 타입에도 where절을 적용할 수 있다.

```swift
protocol Container {
    associatedtype Item
    mutating func append(_ item: Item)
    var count: Int { get }
    subscript(i: Int) -> Item { get }

    associatedtype Iterator: IteratorProtocol where Iterator.Element == Item
    func makeIterator() -> Iterator
}
```

연관 타입 Iterator에 Iterator의 Element가 Item과 같아야 한다는 조건을 건 예다.

```swift
protocol ComparableContainer: Container where Item: Comparable { }
```

다른 프로토콜을 상속하는 프로토콜에도 where절로 조건을 부여할 수 있다.

### 제네릭의 서브스크립트 (Generic Subcript)

제네릭의 서브스크립트에도 조건을 걸 수 있다.

```swift
extension Container {
    subscript<Indices: Sequence>(indices: Indices) -> [Item]
        where Indices.Iterator.Element == Int {
            var result = [Item]()
            for index in indices {
                result.append(self[index])
            }
            return result
    }
}
```

위 예제는 Indices.Iterator.Element가 Int 형이어야 한다는 조건을 건 예입니다.