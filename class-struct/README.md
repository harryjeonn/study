# [Swift] Class와 Struct의 차이

구분: Swift
업로드일: 2022/11/09
작성완료: Yes

면접을 보러가면 클래스와 구조체의 차이점을 아냐는 질문을 많이 받는다.

분명 이전에 클래스와 구조체 정리를 한 적이 있다. 하지만 그럴 때 항상 클래스는 참조타입이고 구조체는 값 타입이다. 라고 대답을 한다.

면접 당시에는 이보다 더 명확하고 간결한 설명이 어디있나 생각하여 대답했으나 내가 면접관이였다면 너무 부실하고 원하는 대답이 저게 아닐텐데.. 라는 생각이 들었다.

그래서 더 자세히 알아보려고한다.

## Class와 Struct의 공통점

값을 저장할 프로퍼티를 선언할 수 있다.

함수적 기능을 하는 메서드를 선언할 수 있다.

내부 값에 `.`를 사용하여 접근할 수 있다.

생성자를 사용해 초기 상태를 설정할 수 있다.

extension을 사용하여 기능을 확장할 수 있다.

protocol을 채택하여 기능을 설정할 수 있다.

## Class와 Struct의 차이점

### Class

참조 타입이다.

ARC로 메모리를 관리한다.

같은 클래스 인스턴스를 여러 개의 변수에 할당한 뒤 값을 변경시키면 할당한 모든 변수에 영향을 준다.

상속이 가능하다.

타입 캐스팅을 통해 런타임에서 클래스 인스턴스의 타입을 확인할 수 있다.

deinit을 사용하여 클래스 인스턴스의 메모리 할당을 해제할 수 있다. (인스턴스가 소멸될 때 deinit 메소드가 호출된다.)

### Struct

값 타입이다.

구조체 변수를 새로운 변수에 할당할 때 마다 새로운 구조체가 할당된다.

같은 구조체를 여러 개의 변수에 할당한 뒤 값을 변경시키더라도 다른 변수에 영향을 주지 않는다.(값 타입)

### 예제 코드

```swift
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

print(someClass1.count) // 3

var someStruct1 = SomeStruct()
var someStruct2 = someStruct1
var someStruct3 = someStruct1

someStruct3.count = 3

print(someStruct1.count) // 0
```

클래스는 참조타입이라 같은 클래스 객체를 할당한 변수의 값을 변경시키면 참조된 객체의 값이 변경된다.

구조체는 값 타입이기 때문에 같은 구조체 객체를 할당하더라도 매번 새로운 메모리가 할당되어 다른 구조체 변수에 영향을 주지 않는다.

### Class의 ARC

```swift
print("ARC Test")
var arcTest1: SomeClass? = SomeClass()
print(CFGetRetainCount(arcTest1)) // 2 (변수에 할당하면 기본 값이 2)

var arcTest2 = arcTest1
print(CFGetRetainCount(arcTest1)) // 3 (1이 추가되어 3)

arcTest1 = nil
// print(CFGetRetainCount(arcTest1)) // 2 이미 인스턴스를 해제한 arcTest1은 호출할 수 없음
print(CFGetRetainCount(arcTest2)) // 2

arcTest2 = nil

// 할당 해제 (deinit 실행)
```

`arcTest1` 변수에 클래스를 할당하고 해제해도 deinit이 실행되지 않는다.

`arcTest2` 변수가 참조하고 있기 때문이다.

`arcTest2` 변수도 참조 해제를 해야 deinit이 실행된다.

이래서 retain cycle이 발생하기도 한다.

### Class의 Retain Cycle

```swift
class StrongRefClassA {
    var classB: StrongRefClassB?
    deinit {
        print("ClassA 할당 해제")
    }
}

class StrongRefClassB {
    var classA: StrongRefClassA?
    deinit {
        print("ClassB 할당 해제")
    }
}

var classA: StrongRefClassA? = StrongRefClassA()
var classB: StrongRefClassB? = StrongRefClassB()

print(CFGetRetainCount(classA)) // reference count = 2(기본값)
print(CFGetRetainCount(classB)) // reference count = 2(기본값)

classA?.classB = classB
classB?.classA = classA

print(CFGetRetainCount(classA)) // reference count = 3
print(CFGetRetainCount(classB)) // reference count = 3

classA = nil
print(CFGetRetainCount(classB?.classA)) // reference count = 2(기본값)
classB = nil // <- 더 이상 classA, classB의 데이터에 접근 할 수 없지만 deinit 실행되지 않았음 -> 메모리 누수 발생
```

위 코드는 더 이상 `classA`, `classB`에 접근할 방법이 없는데 참조 카운트가 0이 되지 않아 deinit이 실행되지 않았다. 이렇게 되면 메모리 누수가 발생하게 된다. 이는 `weak`, `unowned` 참조를 사용하면 해결할 수 있다.

```swift
class StrongRefClassA {
    weak var classB: StrongRefClassB?
    deinit {
        print("ClassA 할당 해제")
    }
}

class StrongRefClassB {
    weak var classA: StrongRefClassA?
    deinit {
        print("ClassB 할당 해제")
    }
}

var classA: StrongRefClassA? = StrongRefClassA()
var classB: StrongRefClassB? = StrongRefClassB()

print(CFGetRetainCount(classA)) // reference count = 2(기본값)
print(CFGetRetainCount(classB)) // reference count = 2(기본값)

classA?.classB = classB
classB?.classA = classA

print(CFGetRetainCount(classA)) // reference count = 2(기본값)
print(CFGetRetainCount(classB)) // reference count = 2(기본값) -> 약한 참조를 사용했기 때문에 참조카운트 증가하지 않음

classA = nil // deinit 실행됨
classB = nil // deinit 실행됨 -> 인스턴스가 모두 메모리 해제됨 -> 메모리 누수 발생하지 않음!
```

위 처럼 `weak` 참조를 사용하면 retain cycle을 방지할 수 있다.

이런 특징들 때문에 클래스와 구조체는 메모리에 저장되는 위치가 다르다.

구조체는 언제 생기고 사라지는지 컴파일 단계에서 알 수 있기 때문에 `stack` 공간에 할당되고,

클래스는 참조가 어디서 어떻게 될 지 모르기 때문에 `heap` 공간에 할당된다.

### Stack 할당

Stack은 LIFO(Last In First Out) 형태의 자료구조로 가장 마지막에 들어간 객체가 가장 먼저 나오게 되는 자료구조이다. 자료구조 특성 상 하나의 명령어로 메모리를 할당, 해제할 수 있다. 또 컴파일 단계에서 언제 생성되고 언제 해제되는지 알 수 있는 구조체와 같은 값들이 스택에 저장된다.

스레드들은 각각 독립적인 Stack 공간을 가지고 있기 때문에 상호 배제를 위한 자원이 필요하지 않다. 즉, 스레드로부터 안전하다.

지역변수와 매개변수 등이 저장되는 영역

이 영역에 할당된 변수는 함수 호출이 완료되면 사라진다.

컴파일 시 크기 결정

ValueType이 할당된다.

### Heap 할당

Heap은 컴파일 단계에서 생성과 해제를 알 수 없는 참조 타입의 객체들이 할당된다.

Heap은 메모리 할당과 해제가 하나의 명령어로 처리되지 않기 때문에 Stack보다 관리가 어렵다.

Stack은 pop, push라는 하나의 명령어로 할당, 해제가 이루어졌지만 Heap은 참조 계산도 해줘야 하므로 Stack보다 복잡하다.

스레드가 공유하는 메모리 공간이기 때문에 스레드로부터 안전하지 않다. 이를 관리해주기 위한 lock과 같은 자원도 필요하게되고 이는 곧 오버헤드로 이어진다.

클래스 안에 구조체..? 구조체 안에 클래스..?

위 경우는 2가지 경우로 나뉜다.

값 타입을 포함하는 참조 타입

- 클래스 안에 구조체
- 참조 타입이 할당 해제 되기 전에 값 타입도 할당 해제되지 않게 하기 위해서 값 타입도 Heap에 저장.
- Swift에서는 클로저 내부에서 사용하는 값 타입도 위의 경우에 해당된다.

참조 타입을 포함하는 값 타입

- 구조체 안에 클래스
- 값 타입은 Heap에 할당되지 않지만 내부에 참조 타입이 있기 때문에 참조 카운트를 처리해줘야 한다.

## 그래서 뭘 어떻게 써야하냐?

### 구조체를 사용해야 할 때

단순한 데이터 값을 보유할 때

작은 값을 갖는 데이터를 처리할 때

캡슐화한 값을 참조하는 것보다 복사하는 것이 합당할 때

구조체에 저장된 프로퍼티가 값 타입이며, 참조하는 것보다 복사하는것이 합당할 때

다른 타입으로부터 상속받거나, 자신을 상속할 필요가 없을 때

추가로 Objective-C와 상호 운용성을 원할 때는 클래스를 사용해야한다.

## 🧐

예전에 봤을 때와는 달리 지금은 뭔가 더 복잡해졌다. 내가 아는게 더 많아져서 보이는게 많아졌다고 생각하고 싶다. 참조냐 값이냐 이런 것도 중요하지만 그로인해 어떤 메모리를 사용해야하고 거기에 얽혀있는 많은 내용이 있다고 생각이 들었다. 좋은 개발자가 되려면 더 좋은 선택을 해야하고 그러려면 더 많이 알아야하는구나 라는걸 깨닫게 되는 순간이였다.

## Reference

[[Swift] Class와 Struct의 차이점?](https://icksw.tistory.com/256)

[iOS :: Swift 메모리의 Stack과 Heap 영역 톺아보기](https://shark-sea.kr/entry/iOS-Swift-%EB%A9%94%EB%AA%A8%EB%A6%AC%EC%9D%98-Stack%EA%B3%BC-Heap-%EC%98%81%EC%97%AD-%ED%86%BA%EC%95%84%EB%B3%B4%EA%B8%B0)

[(Swift) Class 와 Struct 의 차이 , 용도와 선택 방법](https://infinitt.tistory.com/392)