# [Swift] Protocol (1)

구분: Swift
작성완료: No

프로토콜은 특정 기능 수행에 필수적인 요소를 정의한 청사진이다. 프로토콜을 만족시키는 타입을 프로토콜을 따른다고 한다. 프로토콜에 필수 구현을 추가하거나 추가적인 기능을 더하기 위해 프로토콜을 확장(extend)하는 것이 가능하다.

## 프로토콜 문법 (Protocol Syntax)

```swift
protocol SomeProtocol {
    // protocol definition goes here
}
```

프로토콜의 정의는 클래스, 구조체, 열거형 등과 유사하다.

```swift
struct SomeStructure: FirstProtocol, AnotherProtocol {
    // structure definition goes here
}
```

프로토콜을 따르는 타입을 정의하기 위해서는 타입 이름 뒤에 `콜론(:)`을 붙이고 따를 프로토콜 이름을 적는다. 만약 따르는 프로토콜이 여러 개라면 `콤마(,)`로 구분해준다.

```swift
class SomeClass: SomeSuperClass, FirstProtocol, AnotherProtocol {
    // class definition goes here
}
```

서브클래스인 경우 슈퍼클래스를 프로토콜 앞에 적어준다.

## 프로퍼티 요구사항 (Property Requirements)

```swift
protocol SomeProtocol {
    var mustBeSettable: Int { get set }
    var doesNotNeedToBeSettable: Int { get }
}
```

프로토콜에서는 프로퍼티가 저장된 프로퍼티인지 계산된 프로퍼티인지 명시하지 않는다. 하지만 프로퍼티의 이름과 타입 그리고 `gettable`, `settable`인지는 명시한다. 필수 프로퍼티는 항상 `var`로 선언해야 한다.

```swift
protocol AnotherProtocol {
    static var somTypePropery: Int { get set }
}
```

타입 프로퍼티는 `static` 키워드를 적어 선언한다.

```swift
protocol FullyNamed {
    var fullName: String { get }
}
```

하나의 프로퍼티를 갖는 프로토콜을 선언한다.

```swift
struct Person: FullyNamed {
    var fullName: String
}

let harry = Person(fullName: "Harry Jeon")
```

이 프로토콜을 따르는 구조체를 선언한다. `fullName` 프로퍼티는 저장된 프로퍼티로 사용될 수 있다.

```swift
class Starship: FullyNamed {
    var prefix: String?
    var name: String
    
    init(name: String, prefix: String? = nil) {
        self.name = name
        self.prefix = prefix
    }
    
    var fullName: String {
        return (prefix != nil ? prefix! + " " : "") + name
    }
    
    let ncc1701 = Starship(name: "Enterprise", prefix: "USS")
}
```

위와 같이 계산된 프로퍼티로도 사용될 수 있다.

## 메소드 요구사항 (Method Requirements)

```swift
protocol SomeProtocol {
    static func somTypeMethod()
}
```

프로토콜에서는 필수 인스턴스 메소드와 타입 메소드를 명시할 수 있다. 하지만 메소드 파라미터의 기본 값은 프로토콜 안에서 사용할 수 없다.

```swift
protocol RandomNumberGenerator {
    func random() -> Double
}
```

필수 메소드 지정 시 함수명과 반환값을 지정할 수 있고, 구현에 사용하는 괄호는 적지 않아도 된다.

```swift
class LinearCongruentialGenerator: RandomNumberGenerator {
    var lastRandom = 42.0
    let m = 139968.0
    let a = 3877.0
    let c = 29573.0
    
    func random() -> Double {
        lastRandom = ((lastRandom * a + c).truncatingRemainder(dividingBy: m))
        return lastRandom / m
    }
}

let generator = LinearCongruentialGenerator()
print("Here's a random number: \(generator.random())")
// Here's a random number: 0.3746499199817101
print("And another one: \(generator.random())")
// And another one: 0.729023776863283
```

위 코드는 따르는 프로토콜의 필수 메소드 `random()`을 구현한 클래스이다.

`truncatingRemainder(dividingBy:)` 메소드는 소수점이 있는 `Double`, `Float`의 나머지 값을 구하는 메소드다.

## 변경 가능한 메소드 요구사항 (Mutating Method Requirements)

`mutating` 키워드를 사용해 인스턴스에서 변경 가능하다는 것을 표시할 수 있다. 이 `mutating` 키워드는 값 타입에만 사용한다.

```swift
protocol Togglable {
    mutating func toggle()
}

enum OnOffSwitch: Togglable {
    case off, on
    mutating func toggle() {
        switch self {
        case .off:
            self = .on
        case .on:
            self = .off
        }
    }
}

var lightSwitch = OnOffSwitch.off
print(lightSwitch) // off
lightSwitch.toggle()
print(lightSwitch) // on
```

`mutating` 메소드를 선언한 프로토콜의 예다.

이 프로토콜을 따르는 값 타입에서 `toggle()` 메소드를 변경해 사용할 수 있다.

## 초기화 요구사항 (Initializer Requirements)

```swift
protocol SomeProtocol {
    init(someParameter: Int)
}
```

프로토콜에서 필수로 구현해야하는 이니셜라이저를 지정할 수 있다.

## 클래스에서 프로토콜 필수 이니셜라이저의 구현 (Class Implementation of Protocol Initializer Requirements)

```swift
class SomeClass: SomeProtocol {
    required init(someParameter: Int) {
        // initializer implementation goes here
    }
}

final class SomeClass: SomeProtocol {
		init(someParameter: Int) {
        // initializer implementation goes here
    }
}
```

프로토콜에서 특정 이니셜라이저가 필요하다고 명시했기 때문에 구현에서 해당 이니셜라이저에 `required` 키워드를 붙여줘야 한다.

클래스 타입에서 `final`로 선언된 것에는 `required`를 표시하지 않아도 된다. `final`로 선언되면 서브클래싱이 되지 않기 때문이다.

```swift
protocol SomeProtocol {
    init()
}

class SomeSuperClass {
    init() {
        // initializer implementation goes here
    }
}

class SomeSubClass: SomeSuperClass, SomeProtocol {
    // "required" from SomeProtocol conformance; "override" from SomeSuperClass
    required override init() {
        // initializer implementation goes here
    }
}
```

특정 프로토콜의 필수 이니셜라이저를 구현하고, 슈퍼클래스의 이니셜라이저를 서브클래싱하는 경우 이니셜라이즈 앞에 `required` 키워드와 `override` 키워드를 적어준다.

## 타입으로써의 프로토콜 (Protocols as Types)

프로토콜도 하나의 타입으로 사용된다. 그렇기 때문에 다음과 같이 타입 사용이 허용되는 모든 곳에 프로토콜을 사용할 수 있다.

- 함수, 메소드, 이니셜라이저의 파라미터 타입 혹은 리턴 타입
- 상수, 변수, 프로퍼티의 타입
- 컨테이너인 배열, 사전 등의 아이템 타입

```swift
class Dice {
    let sides: Int
    let generator: RandomNumberGenerator
    
    init(sides: Int, generator: RandomNumberGenerator) {
        self.sides = sides
        self.generator = generator
    }
    
    func roll() -> Int {
        return Int(generator.random() * Double(sides)) + 1
    }
}
```

프로토콜을 타입으로 사용한 예다.

`RandomNumberGenerator`를 `generator` 상수의 타입으로 그리고 이니셜라이저의 파라미터 타입으로 사용했다.

```swift
var d6 = Dice(sides: 6, generator: LinearCongruentialGenerator())
for _ in 1...5 {
    print("Random dice roll is \(d6.roll())")
}
// Random dice roll is 3
// Random dice roll is 5
// Random dice roll is 4
// Random dice roll is 5
// Random dice roll is 4
```

위에서 선언한 `Dice`를 초기화할 때 `generator` 파라미터 부분에 `RandomNumberGenerator` 프로토콜을 따르는 인스턴스를 넣는다.