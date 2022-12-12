# [Swift] 열거형 (Enumerations)

구분: Swift
업로드일: 2022/12/07
작성완료: Yes

열거형은 관련된 값으로 이루어진 그룹을 공통의 타입으로 선언해 안전성을 보장하는 방법으로 코드를 다룰 수 있게 해준다. C나 Objective-C가 Integer 값들로 열거형을 구성한 것에 반해 Swift에서는 case값이 String, Character, Integer, Floting 값들을 사용할 수 있다. 열거형은 1급 클래스 형이어서 계산된 프로퍼티를 제공하거나 초기화를 지정하거나, 초기 선언을 확장해 사용할 수 있다.

## 열거형 문법 (Enumeration Syntax)

```swift
enum SomeEnumeration {
    // enumeration definition goes here
}
```

`enum` 키워드를 사용해 열거형을 정의한다.

```swift
enum CompassPoint {
    case north
    case south
    case east
    case west
}
```

네 가지 방향을 갖는 `CompassPoint` 열거형 선언이다.

C나 Objective-C와는 다르게 Swift에서의 열거형은 생성될 때 각 case 별로 기본 integer값을 할당하지 않는다. 위 `CompassPoint`를 보면 north, south, east, west는 각각 암시적으로 0, 1, 2, 3 값을 갖지 않는다. 대신 Swift에서 열거형의 각 case는 `CompassPoint`로 선언된 온전한 값이다.

```swift
enum Planet {
    case mercury, venus, earth, mars, jupiter, saturn, uranus, neptune
}
```

여러 case를 콤마(,)로 구분해서 적을 수 있다.

각 열거형 정의는 완전 새로운 타입을 정의한다.

Swift의 다른 타입과 마찬가지로 타입의 이름은 대문자로 시작해야한다.

```swift
var directionToHead = CompassPoint.west

directionToHead = .east
```

`directionToHead`의 타입은 초기화 될 때 타입추론이 돼서 `CompassPoint` 타입을 갖게 된다.

`directionToHead`의 타입이 `CompassPoint`로 한번 정의되면 다음에 값을 할당할 때 타입을 생략한 점 문법(dot syntax)를 이용해 값을 할당하는 축약형 문법을 사용할 수 있다.

## Switch 구문에서 열거형 값 매칭하기 (Matching Enumeration Values with a Switch Statement)

```swift
switch directionToHead {
case .north:
    print("Lots of planets have a north")
case .south:
    print("Watch out for penguins")
case .east:
    print("Where the sun rises")
case .west:
    print("Where the skies are blue")
}
```

각 열거형 값을 `Switch` 문에서 매칭할 수 있다.

switch문은 반드시 열거형의 모든 경우(cases)를 완전히 포함해야 한다. 만약 위에서 `case .west`가 생략되었다면 코드는 컴파일되지 않는다. 만약 열거형의 모든 cases의 처리를 기술하는게 적당하지 않다면 아래 예제 처럼 default case를 제공함으로써 처리되지 않는 case를 피할 수 있다.

```swift
let somePlanet = Planet.earth
switch somePlanet {
case .earth:
    print("Mostly harmless")
default:
    print("Not a safe place for humans")
}
```

## 관련 값 (Associated Values)

열거형의 각 case에 custom type의 추가적인 정보를 저장할 수 있다.

![barcode](https://user-images.githubusercontent.com/77602040/207065218-d5d8e934-36c0-42ac-9cbd-aa896cb2a794.png)

![qrcode](https://user-images.githubusercontent.com/77602040/207065238-117ce780-6141-4197-adfe-fb4fa67eafdc.png)

예를 들어 바코드가 위와 같이 4가지로 구분된 숫자로 이루어진 종류가 있거나, 2953개의 문자로 구성된 QR코드 형태로 이루어진 두 가지 종류가 있다면 이 바코드를 아래와 같은 열거형으로 정의할 수 있다.

```swift
enum Barcode {
	case upc(Int, Int, Int, Int)
	case qrCode(String)
} 
```

관련 값을 이용하면 위와 같은 형이지만 다른 형태의 값을 갖는 case를 만들 수 있다.

```swift
var productBarcode = Barcode.upc(8, 85909, 51226, 3)

productBarcode = .qrCode("ABCDEFGHIJKLMNOP")
```

관련 값은 `switch case`문에서 사용할 때 상수 혹은 변수로 선언할 수 있다.

```swift
// case 안의 관련 값 상수로 선언
switch productBarcode {
case .upc(let numberSystem, let manufacturer, let product, let check):
    print("UPC: \(numberSystem), \(manufacturer), \(product), \(check).")
case .qrCode(let productCode):
    print("QR code: \(productCode).")
}
// Prints "QR code: ABCDEFGHIJKLMNOP."

// 공통된 let을 앞으로 빼내 간결하게 기술한 코드
switch productBarcode {
case let .upc(numberSystem, manufacturer, product, check):
    print("UPC : \(numberSystem), \(manufacturer), \(product), \(check).")
case let .qrCode(productCode):
    print("QR code: \(productCode).")
}
// Prints "QR code: ABCDEFGHIJKLMNOP."
```

case 안의 관련 값이 전부 상수이거나 변수이면 공통된 값을 case 뒤에 선언해서 보다 간결하게 기술할 수 있다.

## Raw 값 (Raw Values)

C나 Objective-C 같이 case에 raw 값을 지정할 수 있다.

```swift
enum ASCIIControlCharacter: Character {
    case tab = "\t"
    case lineFeed = "\n"
    case carriageReturn = "\r"
}
```

Character 타입의 raw값으로 정의했지만 String, Character, Integer, Float 등의 타입을 사용할 수도 있다. 단 각 raw값은 열거형 선언에서 유일한 값으로 중복되어서는 안된다.

## 암시적으로 할당된 Raw 값 (Implicitly Assigned Raw Values)

열거형을 다루면서 raw값으로 Integer나 String 값을 사용할 수 있는데 각 case별로 명시적으로 raw값을 할당할 필요는 없다. 만약 raw값을 할당하지 않으면 Swift에서 자동으로 값을 할당해준다.

```swift
enum Planet: Int {
    case mercury = 1, venus, earth, mars, jupiter, saturn, uranus, neptune
}

enum CompassPoint: String {
    case north, south, east, west
}
```

위 경우는 mercury에 1을 raw 값으로 명시적으로 할당했고 venus는 암시적으로 2 그리고 이후 값은 1 증가 된 값을 자동으로 raw 값으로 갖게 된다. 만약 String을 raw값으로 사용했다면 case 텍스트가 raw값으로 자동으로 할당된다.

```swift
let earthsOrder = Planet.earth.rawValue
// earthsOrder is 3

let sunsetDirection = CompassPoint.west.rawValue
// sunsetDirection is "west"
```

CompassPoint.south는 암시적으로 “south”를 raw값으로 갖는다.

raw값은 rawValue 프로퍼티를 사용해 접근할 수 있다.

## Raw 값을 이용한 초기화 (Initializing from a Raw Value)

raw값을 이용해 열거형 변수를 초기화 할 수 있다.

```swift
let possiblePlanet = Planet(rawValue: 7)
// possiblePlanet is of type Planet? and equals Planet.uranus
```

위 예제는 raw값 7을 갖는 값을 열거형 변수의 초기 값으로 지정한다. 그 값은 Uranus이다.

```swift
let positionToFind = 11
if let somePlanet = Planet(rawValue: positionToFind) {
    switch somePlanet {
    case .earth:
        print("Mostly harmless")
    default:
        print("Not a safe place for humans")
    }
} else {
    print("There isn't a planet at position \(positionToFind)")
}
// Prints "There isn't a planet at position 11"
```

만약 열거형에 지정된 raw값이 없는 값으로 초기자를 지정하면 그 값은 nil이 된다.

## 재귀 열거자 (Recursive Enumerations)

재귀 열거자는 다른 열거 인스턴스를 관계 값으로 갖는 열거형이다. 재귀 열거자 case는 앞에 indirect 키워드를 붙여 표시한다.

```swift
enum ArithmeticExpression {
    case number(Int)
    indirect case addition(ArithmeticExpression, ArithmeticExpression)
    indirect case multiplication(ArithmeticExpression, ArithmeticExpression)
}
```

만약 관계 값을 갖는 모든 열거형 case에 indirect 표시를 하고 싶으면 enum 키워드 앞에 indirect 표시를 하면 된다.

```swift
indirect enum ArithmeticExpression {
    case number(Int)
    case addition(ArithmeticExpression, ArithmeticExpression)
    case multiplication(ArithmeticExpression, ArithmeticExpression)
}
```

아래 예제는 (5 + 4) * 2를 재귀 열거자로 표현한 것이다.

```swift
let five = ArithmeticExpression.number(5)
let four = ArithmeticExpression.number(4)
let sum = ArithmeticExpression.addition(five, four)
let product = ArithmeticExpression.multiplication(sum, ArithmeticExpression.number(2))
```

다음은 위 재귀 열거자를 처리하는 함수이다.

```swift
func evaluate(_ expression: ArithmeticExpression) -> Int {
    switch expression {
    case let .number(value):
        return value
    case let .addition(left, right):
        return evaluate(left) + evaluate(right)
    case let .multiplication(left, right):
        return evaluate(left) * evaluate(right)
    }
}

print(evaluate(product))
// Prints "18"
```
