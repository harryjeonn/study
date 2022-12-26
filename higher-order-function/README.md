# [Swift] 고차함수 (1) - map, filter, reduce

구분: Swift
업로드일: 2022/12/26
작성완료: Yes

## 고차함수 ?

매개변수로 함수를 갖는 함수를 말한다.

Swift 표준 라이브러리에서는 다음과 같은 고차함수를 제공한다.

- map
- filter
- reduce

모두 컨테이너 타입(Array, Set, Dictionary 등)과 Optional 타입에서 사용할 수 있다.

### 왜 ?

함수형 프로그래밍의 장점을 간편하게 이용할 수 있기 때문이다.

- for-in 구문에 비해 코드가 간결해진다.
- 코드 재사용, 컴파일러 최적화 측면에서 성능 차이가 있다.
- 멀티스레드 환경에서 부작용을 방지한다.

## map - 변형

`map` 함수는 컨테이너 내부의 기존 데이터를 **변형**하여 새로운 컨테이너를 생성한다.

`for-in` 구문과 비슷한 동작원리이지만 `map`를 사용하게되면 클로저 상수를 통해 코드의 재사용이 용이해지고 컴파일러 최적화 측면에서 성능이 좋아진다.

- Array, Dictionary, Set, Optional 등에 사용 가능
- Sequence, Collection 프로토콜을 따르는 타입에 사용 가능

### 선언

```swift
func map<T>(_ transform: (Self.Element) throws -> T) rethrows -> [T]
```

### 예제

```swift
let numbers = [1, 2, 3, 4, 5]

var forInNumbers: [Int] = []
for number in numbers {
    forInNumbers.append(number * 2)
}

// [2, 4, 6, 8, 10]
```

`map`을 사용하지 않고 `for-in`구문을 사용하여 `numbers`의 요소를 2배로 바꿔보았다.

2배로 곱하여 요소들을 담아야 할 새로운 배열을 만들어서 사용해야한다.

```swift
let mapNumbers = numbers.map { number in
    return number * 2
}

// [2, 4, 6, 8, 10]
```

`map`을 사용하여 같은 동작을 한다면 코드가 더 깔끔해진 것을 확인할 수 있다.

초기에 빈 배열을 만들 필요가 없고, `append()` 를 수행하지 않아 시간이 절약된다.

```swift
let mapNumbers = numbers.map { $0 * 2 }

// [2, 4, 6, 8, 10]
```

위와 같이 추론을 이용하여 코드 작성이 가능하다.

## filter - 추출

컨테이너 값을 특정 조건에 맞게 걸러내는 고차함수이다.

컨테이너 내부의 값을 걸러서 새로운 컨테이너로 **추출**한다.

`filter`의 매개변수르 전달되는 함수의 반환 타입은 `Bool`이다.

`true`면 값을 포함하고 `false`면 값을 배제한다.

### 선언

```swift
func filter(_ isIncluded: (Self.Element) throws -> Bool) rethrows -> [Self.Element]
```

### 예제

```swift
numbers.filter { number in
    return number % 2 == 0
}

let filterNumbers = numbers.filter { $0 % 2 == 0 }

// [2, 4]
```

위와 같이 `numbers` 배열에서 짝수만 추출하여 새로운 컨테이너로 만든다.

```swift
let filterMapNumbers = numbers
    .filter { $0 % 2 == 0 }
    .map { $0 * 2 }

// [4, 8]
```

`map`과 함께 사용할 수 있다.

## reduce - 통합

컨테이너 내의 모든 값을 하나로 **통합**하는 고차함수이다.

상황에 따라 `reduce`를 `map`과 비슷하게 사용할 수 있다.

### 선언 1

```swift
func reduce<Result>(_ initialResult: Result, _ nextPartialResult: (Result, Element) throws -> Result) rethrows -> Result
```

클로저가 각 요소를 전달받아 연산한 후, 값을 다음 클로저 실행을 위해 반환하며 컨테이너를 순환하는 형태이다.

- `initialResult` : 초기값
- `nextPartialResult` : 클로저로 두 개의 매개변수를 받는다.
    - `Result` : `initialResult`로 받은 초기값 혹은 이전 클로저의 결과값, `reduce`의 순회가 끝났을 때 최종 결과값이다.
    - `Element` : `reduce` 메소드가 순환하는 컨테이너의 요소

### 예제

```swift
let reduceNumbers = numbers.reduce(0) { partialResult, element in
    return partialResult + element
}

// 15

let reduceNumbers2 = numbers.reduce(0) { $0 + $1 }

// 15

let reduceNumbers3 = numbers.reduce(0, +)

// 15
```

초기값 0을 가지고 numbers의 모든 값을 더한다.

모두 같은 값을 출력하는 것을 확인하고 축약이 가능하다는 것을 확인했다.

### 선언 2

```swift
func reduce<Result>(into initialResult: Result, _ updateAccumulatingResult: (inout Result, Self.Element) throws -> ()) rethrows -> Result
```

컨테이너를 순환하며 클로저가 실행되지만 클로저가 따로 결과값을 반환하지 않는 상태

`return` 없이 `inout` 매개변수를 사용해 초기값에 직접 연산을 실행한다.

- `initialResult` : 초기값
- `updateAccumulatingResult` : 클로저로 두 개의 매개변수를 갖는다.
    - `inout Result` : `initialResult`로 전달받은 초기값 또는 이전 클로저에 의해 변경된 결과값, `reduce`의 순회가 끝났을 때 최종 결과값이다.
    - `Element` : `reduce` 메소드가 순환하는 컨테이너 요소

### 예제

```swift
let reduceIntoNumbers = numbers.reduce(into: 0) { partialResult, number in
    partialResult += number
}
```

초기값 0에 `numbers`의 모든 값을 더한다.

클로저 값의 `return`없이 클로저 내부에서 직접 이전 값을 변경한다.

```swift
let names = ["harry", "lily"]

let uppercaseNames = names.reduce(into: [], {
    $0.append($1.uppercased())
})

// ["HARRY", "LILY"]

// map
names.map { $0.uppercased() } // ["HARRY", "LILY"]
```

`map`, `filter` 와 유사하게 사용 가능하다.

## 다 섞어서 사용해보기 (map, filter, reduce)

```swift
let result = numbers
    .filter { $0 % 2 == 0 } // 짝수 걸러내기
    .map { $0 * 5 } // 5 곱하기
    .reduce(0, +) // 모든 값 더하기

// 50
```
