# [Swift] Protocol

구분: Swift
작성완료: Yes

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

## 위임 (Delegation)

위임은 클래스 혹은 구조체 인스턴스에 특정 행위에 대한 책임을 넘길 수 있게 해주는 디자인 패턴 중 하나이다.

```swift
protocol DiceGame {
    var dice: Dice { get }
    func play()
}

protocol DiceGameDelegate: AnyObject {
    func gameDidStart(_ game: DiceGame)
    func game(_ game: DiceGame, didStartNewTurnWithDiceRoll diceRoll: Int)
    func gameDidEnd(_ game: DiceGame)
}
```

`DiceGame` 프로토콜을 선언하고 `DiceGameDelegate`에 선언해서 실제 `DiceGame`의 행위와 관련된 구현을 `DiceGameDelegate`를 따르는 인스턴스에 위임한다. `DiceGameDelegate`를 `AnyObject`로 선언하면 클래스만 이 프로토콜을 따를 수 있게 만들 수 있다.

```swift
class SnakesAndLadders: DiceGame {
    let finalSquare = 25
    let dice = Dice(sides: 6, generator: LinearCongruentialGenerator())
    var square = 0
    var board: [Int]
    init() {
        board = Array(repeating: 0, count: finalSquare + 1)
        board[03] = +08; board[06] = +11; board[09] = +09; board[10] = +02
        board[14] = -10; board[19] = -11; board[22] = -02; board[24] = -08
    }
    weak var delegate: DiceGameDelegate?
    func play() {
        square = 0
        delegate?.gameDidStart(self)
        gameLoop: while square != finalSquare {
            let diceRoll = dice.roll()
            delegate?.game(self, didStartNewTurnWithDiceRoll: diceRoll)
            switch square + diceRoll {
            case finalSquare:
                break gameLoop
            case let newSquare where newSquare > finalSquare:
                continue gameLoop
            default:
                square += diceRoll
                square += board[square]
            }
        }
        delegate?.gameDidEnd(self)
    }
}
```

`SnakesAndLadders`는 `DiceGame`을 따르고 `DiceGameDelegate`를 따르는 `delegate`를 갖는다. 게임을 실행(`play()`)했을 때 `delegate?.gameDidStart(self)`, `delegate?.game(self, didStartNewTurnWithDiceRoll: diceRoll)`, `delegate?.gameDidEnd(self)` 를 실행한다. `delegate`는 게임을 진행시키는데 반드시 필요한건 아니라서 optional로 정의되어 있다.

```swift
class DiceGameTracker: DiceGameDelegate {
    var numberOfTurns = 0
    func gameDidStart(_ game: DiceGame) {
        numberOfTurns = 0
        if game is SnakesAndLadders {
            print("Started a new game of Snakes and Ladders")
        }
        print("The game is using a \(game.dice.sides)-sided dice")
    }
    func game(_ game: DiceGame, didStartNewTurnWithDiceRoll diceRoll: Int) {
        numberOfTurns += 1
        print("Rolled a \(diceRoll)")
    }
    func gameDidEnd(_ game: DiceGame) {
        print("The game lasted for \(numberOfTurns) turns")
    }
}

let tracker = DiceGameTracker()
let game = SnakesAndLadders()
game.delegate = tracker
game.play()
// Started a new game of Snakes and Ladders
// The game is using a 6-sided dice
// Rolled a 3
// Rolled a 5
// Rolled a 4
// Rolled a 5
// The game lasted for 4 turns
```

실제 DiceGameDelegate를 상속하는 delegate DiceGameTracker를 구현한 예다.

DiceGameTracker를 이용해 게임을 진행시킨다. 게임의 tracking 관련된 작업은 이 DiceGameTracker가 위임받아 그곳에서 실행된다.

## 익스텐션을 이용해 프로토콜 따르게 하기 (Adding Protocols Conformance with an Extension)

이미 존재하는 타입에 새 프로토콜을 따르게 하기 위해 `extension`을 사용할 수 있다. 원래 값에 접근 권한이 없어도 `extension`을 사용해 기능을 확장할 수 있다.

```swift
protocol TextRepresentable {
    var textualDescription: String { get }
}

extension Dice: TextRepresentable {
    var textualDescription: String {
        return "A \(sides)-sided dice"
    }
}

let d12 = Dice(sides: 12, generator: LinearCongruentialGenerator())
print(d12.textualDescription)
// Prints "A 12-sided dice"
```

`extension`을 이용해 `Dice`를 `TextRepresentable` 프로토콜을 따르도록 구현했다.

`d12.textualDescription` 와 같이 `Dice`에 추가한 `extension`을 자동으로 그대로 사용할 수 있다.

## 조건적으로 프로토콜을 따르기 (Conditionally Conforming to a Protocol)

특정 조건을 만족시킬 때만 프로토콜을 따르도록 제한할 수 있다. `where`절을 사용해 정의한다.

```swift
extension Array: TextRepresentable where Element: TextRepresentable {
    var textualDescription: String {
        let itemsAsText = self.map { $0.textualDescription }
        return "[" + itemsAsText.joined(separator: ", ") + "]"
    }
}
let myDice = [d6, d12]
print(myDice.textualDescription)
// Prints "[A 6-sided dice, A 12-sided dice]"
```

`TextRepresentable`을 따르는 `Array` 중 `Array`의 각 원소가 `TextRepresentable`인 경우에만 따르는 프로토콜을 정의한다.

## 익스텐션을 이용해 프로토콜 채용 선언하기 (Declaring Protocol Adoption with an Extension)

어떤 프로토콜을 충족에 필요한 모든 조건을 만족하지만 아직 그 프로토콜을 따른다는 선언을 하지 않았다면 그 선언을 빈 extension으로 선언할 수 있다. 아래 코드는 프로토콜을 따른다는 선언은 extension에 하고 실제 프로토콜을 따르기 위한 구현은 구조체 원본에 구현한 예다.

```swift
struct Hamster {
    var name: String
    var textualDescription: String {
        return "A hamster named \(name)"
    }
}
extension Hamster: TextRepresentable {}

let harryTheHamster = Hamster(name: "Harry")
let somethingTextRepresentable: TextRepresentable = harryTheHamster
print(somethingTextRepresentable.textualDescription)
// Prints "A hamster named Harry"
```

## 프로토콜 타입 컬렉션 (Collections of Protocol Types)

프로토콜을 `Array`, `Dictionary` 등 `Collection` 타입에 넣기위한 타입으로 사용할 수 있다.

```swift
let things: [TextRepresentable] = [game, d12, harryTheHamster]

for thing in things {
    print(thing.textualDescription)
}
// A game of Snakes and Ladders with 25 squares
// A 12-sided dice
// A hamster named Simon
```

`Array`의 모든 객체는 `TextRepresentable`을 따르므로 `textualDescription` 프로퍼티를 갖는다.

## 프로토콜 상속 (Protocol Inheritance)

```swift
protocol InheritingProtocol: SomeProtocol, AnotherProtocol {
    // protocol definition goes here
}
```

클래스를 상속하듯이 프로토콜도 상속할 수 있다.

```swift
protocol PrettyTextRepresentable: TextRepresentable {
    var prettyTextualDescription: String { get }
}
```

`TextRepresentable` 프로토콜을 상속받아 `PrettyTextRepresentable`을 구현한다.

```swift
extension SnakesAndLadders: PrettyTextRepresentable {
    var prettyTextualDescription: String {
        var output = textualDescription + ":\n"
        for index in 1...finalSquare {
            switch board[index] {
            case let ladder where ladder > 0:
                output += "▲ "
            case let snake where snake < 0:
                output += "▼ "
            default:
                output += "○ "
            }
        }
        return output
    }
}

print(game.prettyTextualDescription)
// A game of Snakes and Ladders with 25 squares:
// ○ ○ ▲ ○ ○ ▲ ○ ○ ▲ ▲ ○ ○ ○ ▼ ○ ○ ○ ○ ▼ ○ ○ ▼ ○ ▼ ○
```

square가 0보다 큰지, 작은지 혹은 0인지에 대해 각각 알맞은 기호를 반환한다.

## 클래스 전용 프로토콜 (Class-Only Protocols)

```swift
protocol SomeClassOnlyProtocol: AnyObject, SomeInheritedProtocol {
    // class-only protocol definition goes here
}
```

클래스 타입에서만 사용 가능한 프로토콜을 선언하기 위해서는 `AnyObject`를 추가한다.

## 프로토콜 합성 (Protocol Composition)

동시에 여러 프로토콜을 따르는 타입을 선언할 수 있다.

```swift
protocol Named {
    var name: String { get }
}
protocol Aged {
    var age: Int { get }
}
struct Person: Named, Aged {
    var name: String
    var age: Int
}
func wishHappyBirthday(to celebrator: Named & Aged) {
    print("Happy birthday, \(celebrator.name), you're \(celebrator.age)!")
}
let birthdayPerson = Person(name: "Harry", age: 26)
wishHappyBirthday(to: birthdayPerson)
// Prints "Happy birthday, Harry, you're 26!"
```

`wishHappyBirthday` 메소드의 `celebrator` 파라미터는 `Named` 프로토콜과 `Aged` 프로토콜을 동시에 따르는 타입으로 선언하기 위해 `&` 를 사용했다.

## 프로토콜 순응 확인 (Checking for Protocol Conformance)

어떤 타입이 특정 프로토콜을 따르는지 확인할 수 있다.

- `is` 연산자를 이용하면 어떤 타입이 특정 프로토콜을 따르는지 확인할 수 있다. 특정 프로토콜을 따르면 true을 그렇지 않으면 false을 반환한다.
- `as?` 는 특정 프로토콜을 따르는 경우 그 옵셔널 타입의 프로토콜 타입으로 다운캐스트 하게되고 따르지 않으면 nil을 반환한다.
- `as!` 는 강제로 특정 프로토콜을 따르도록 정의한다. 만약 다운캐스트에 실패하면 에러가 발생한다.

```swift
protocol HasArea {
    var area: Double { get }
}

class Circle: HasArea {
    let pi = 3.1415927
    var radius: Double
    var area: Double { return pi * radius * radius }
    init(radius: Double) { self.radius = radius }
}
class Country: HasArea {
    var area: Double
    init(area: Double) { self.area = area }
}

class Animal {
    var legs: Int
    init(legs: Int) { self.legs = legs }
}

let objects: [AnyObject] = [
    Circle(radius: 2.0),
    Country(area: 243_610),
    Animal(legs: 4)
]

for object in objects {
    if let objectWithArea = object as? HasArea {
        print("Area is \(objectWithArea.area)")
    } else {
        print("Something that doesn't have an area")
    }
}
// Area is 12.5663708
// Area is 243610.0
// Something that doesn't have an area
```

area 값을 필요로 하는 `HasArea` 프로토콜을 선언했다.

`HasArea` 프로토콜을 따르고 있는 `Circle`, `Country` 클래스를 선언한다.

그리고 `HasArea` 프로토콜을 따르지 않는 `Animal` 클래스도 선언했다.

클래스들을 배열에 넣고 배열을 순회하며 `as? HasArea` 구문을 사용해 `HasArea` 프로토콜을 따르는지 확인한다.

`HasArea`를 따르는 클래스인 `Circle`, `Country` 클래스는 area값이 반환되고 그렇지 않은 `Animal` 클래스는 else 절로 실행된다. 

## 선택적 프로토콜 요구조건 (Optional Protocol Requirements)

프로토콜을 선언하면서 필수 구현이 아닌 선택적 구현 조건을 정의할 수 있다.

`@objc` 키워드를 프로토콜 앞에 붙이고 개별 함수 혹은 프로퍼티에는 `@objc`와 `optional` 키워드를 붙인다.

`@objc` 프로토콜은 클래스 타입에서만 따를 수 있고 구조체나 열거형에서는 사용할 수 없다.

```swift
@objc protocol CounterDataSource {
    @objc optional func increment(forCount count: Int) -> Int
    @objc optional var fixedIncrement: Int { get }
}

class Counter {
    var count = 0
    var dataSource: CounterDataSource?
    func increment() {
        if let amount = dataSource?.increment?(forCount: count) {
            count += amount
        } else if let amount = dataSource?.fixedIncrement {
            count += amount
        }
    }
}

class ThreeSource: NSObject, CounterDataSource {
    let fixedIncrement = 3
}

var counter = Counter()
counter.dataSource = ThreeSource()
for _ in 1...4 {
    counter.increment()
    print(counter.count)
}
// 3
// 6
// 9
// 12
```

`Counter` 클래스에서는 `increment` 함수만 구현했고, `ThreeSource` 클래스에서는 `fixedIncrement`만 구현이 가능하다.

그리고 `counter`객체를 만들어 `ThreeSource`객체를 사용해 값을 할당하면 `Counter`의 `count`를 증가 시킬 수 있다.

## 프로토콜 익스텐션 (Protocol Extensions)

`extension`을 이용해 프로토콜을 확장할 수 있다.

```swift
extension RandomNumberGenerator {
    func randomBool() -> Bool {
        return random() > 0.5
    }
}

let generator = LinearCongruentialGenerator()
print("Here's a random number: \(generator.random())")
// Prints "Here's a random number: 0.3746499199817101"
print("And here's a random Boolean: \(generator.randomBool())")
// Prints "And here's a random Boolean: true"
```

`RandomNumberGenerator` 프로토콜을 확장해 `randomBool()`을 구현했다.

`generator`에서 `random()`과 `randomBool()` 모두 사용 가능하다.

`extension`을 이용해 구현을 추가할 수는 있어도 다른 프로토콜로 확장/상속할 수 없다. 그렇게 하려면 `extension`이 아닌 프로토콜 자체에 구현해야한다.

### 기본 구현 제공 (Providing Default Implementations)

`extension`을 기본 구현을 제공하는데 사용할 수 있다. 특정 프로토콜을 따르는 타입 중에서 그 프로토콜의 요구사항에 대해 자체적으로 구현한게 있으면 그것을 사용하고 아니면 기본 구현을 사용하게 된다.

즉, 프로토콜에서는 선언만 할 수 있는데익스텐션을 이용해 기본 구현을 제공할 수 있다.

```swift
extension PrettyTextRepresentable  {
    var prettyTextualDescription: String {
        return textualDescription
    }
}
```