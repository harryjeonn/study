# [RxSwift] 곰튀김님의 RxSwift 강의

구분: RxSwift
업로드일: 2022/12/12
작성완료: Yes

## RxSwift ?

RxSwift는 비동기적으로 생기는 데이터를 completion 같은 클로저를 통해 전달하는게 아닌 return 값으로 전달하기 위해서 만들어진 유틸리티이다.

### completion을 사용한 비동기 처리 방식

```swift
private func downloadJson(_ url: String, _ completion: @escaping (String?) -> Void) {
    DispatchQueue.global().async {
        let url = URL(string: url)!
        let data = try! Data(contentsOf: url)
        let json = String(data: data, encoding: .utf8)
        DispatchQueue.main.async {
            completion(json)
        }
    }
}

@IBAction func onLoad() {
    
    // completion을 사용한 비동기 처리 방식
    editView.text = ""
    self.setVisibleWithAnimation(self.activityIndicator, true)
    downloadJson(MEMBER_LIST_URL) { json in
        self.editView.text = json
        self.setVisibleWithAnimation(self.activityIndicator, false)
    }
}
```

escaping을 사용하는 이유는 함수가 끝나고 나서 나중에 실행되기 때문에 escaping을 사용한다.

completion이 optional일 경우에는 escaping이 dafault이다.

completion을 사용하면서 비슷한 동작이 여러번 반복될 경우 콜백지옥을 볼 수 있다.

```swift
// 콜백 지옥 예시
@IBAction func onLoad() {
    editView.text = ""
    self.setVisibleWithAnimation(self.activityIndicator, true)
    downloadJson(MEMBER_LIST_URL) { json in
        self.editView.text = json
        self.setVisibleWithAnimation(self.activityIndicator, false)
	    downloadJson(MEMBER_LIST_URL) { json in
	        self.editView.text = json
	        self.setVisibleWithAnimation(self.activityIndicator, false)
		    downloadJson(MEMBER_LIST_URL) { json in
		        self.editView.text = json
		        self.setVisibleWithAnimation(self.activityIndicator, false)
			    downloadJson(MEMBER_LIST_URL) { json in
			        self.editView.text = json
			        self.setVisibleWithAnimation(self.activityIndicator, false)
			    }
		    }
			}
    }
}
```

위 처럼 completion이 아닌 return으로 사용하면 좋겠다 싶어서 나온게 **RxSwift**!

RxSwift를 사용하여 바꿔보자.

### RxSwift를 사용한 비동기 처리 방식

```swift
private func downloadJson(_ url: String) -> Observable<String?> {
	return Observable.create { f in
        DispatchQueue.global().async {
            let url = URL(string: url)!
            let data = try! Data(contentsOf: url)
            let json = String(data: data, encoding: .utf8)

            DispatchQueue.main.async {
                f.onNext(json)
            }
        }

        return Disposables.create()
    }
}

@IBAction func onLoad() {
    downloadJson(MEMBER_LIST_URL)
        .subscribe { event in
            switch event {
            case .next(let json):
                self.editView.text = json
                self.setVisibleWithAnimation(self.activityIndicator, false)
            case .completed, .error(_):
                break
            }
        }
}
```

Observable은 나중에 생기는 데이터

subscribe은 나중에 데이터가 오면 이라고 예시를 들어 강의를 진행하셨다.

Observable을 리턴하는 함수를 만들고 그 함수를 호출하는 부분에서 subcribe으로 구독하고있다.

### URLSession과 함께 사용

```swift
private func downloadJson(_ url: String) -> Observable<String?> {
    return Observable.create { emitter in
        let url = URL(string: url)!
        let task = URLSession.shared.dataTask(with: url) { (data, _, err) in
            guard err == nil else {
                emitter.onError(err!)
                return
            }
            
            if let data = data,
               let json = String(data: data, encoding: .utf8) {
                emitter.onNext(json)
            }
            
            emitter.onCompleted()
        }
        
        task.resume()
        
        return Disposables.create() { // Dispose가 되었을 때 실행 되는 블럭
            task.cancel()
        }
    }
}

@IBAction func onLoad() {
    editView.text = ""
    self.setVisibleWithAnimation(self.activityIndicator, true)
    
    downloadJson(MEMBER_LIST_URL)
        .subscribe { event in
            switch event {
            case .next(let json):
                DispatchQueue.main.async {
                    self.editView.text = json
                    self.setVisibleWithAnimation(self.activityIndicator, false)
                }
            case .completed, .error(_):
                break
            }
        }
}
```

URLSession을 이용해 통신을하고 Error가 나면 onError를 값을 잘 불러왔다면 onNext를 동작이 끝났다면 onCompleted를 사용한다.

### Observable의 생명주기

1. Create → Observable 생성
2. Subscribe → 구독
3. onNext → 값 전달
4. onCompleted / onError → error로 전달되거나 completed가 되면 끝
5. Disposed

## Operator

기본적인 사용법을 알아봤으니 이제 귀찮은걸 덜어주는 유용한 기능들을 보자.

### Just

```swift
func downloadString() -> Observable<String?> {
	return Observable.create { f in
		f.onNext("Hello Harry")
		f.onCompleted()
    return Disposables.create()
	}
}
```

위에서 배운 내용대로 “Hello Harry” 라는 문자열을 Observable을 사용하여 값을 보내려면 위 처럼 코드를 작성해야한다.

Observable을 만들고, onNext로 값을 보내고, onCompleted로 완료하고 Disposables를 생성하여 리턴해야한다.

손이 많이가고 복잡하다.

```swift
func downloadString() -> Observable<String?> {
	return Observable.just("Hello Harry")
}
```

`just`를 사용하면 4줄의 코드를 한줄로 변경할 수 있다.

데이터 하나를 보낼 때 `just`를 사용하면 간편하게 사용할 수 있다.

### From

그렇다면 데이터 여러 개를 보내고 싶을때는 어떻게 할까?

```swift
func downloadString() -> Observable<[String?]> {
	return Observable.just(["Hello", "Harry"])
}
```

위 처럼 just로 배열을 보내도 된다.

배열 요소 하나씩 보내고 싶다면 from을 사용한다.

```swift
func downloadString() -> Observable<String?> {
	return Observable.from(["Hello", "Harry"])
}
```

### Subscribe

```swift
downloadJson(MEMBER_LIST_URL)
    .subscribe { event in
        switch event {
        case .next(let t):
            print(t)
        case .completed, .error(_):
            break
        }
    }
```

단순히 print만 하는 코드인데 next, completed, error 처리를 다 해줘야해서 번거롭다.

이럴때 subscribe도 간단하게 작성할 수 있다.

```swift
downloadJson(MEMBER_LIST_URL)
    .subscribe(onNext: { print($0) })
```

onNext일 때 print한다 라고 한 줄로 작성할 수 있다.

```swift
downloadJson(MEMBER_LIST_URL)
    .subscribe(onNext: { print($0) },
							 onCompleted: { print("completed") },
							 onError: { err in print(err) })
```

위 처럼 사용할 수 있고, 내가 사용할 부분만 사용할 수 있다.

```swift
downloadJson(MEMBER_LIST_URL)
    .observeOn(MainScheduler.instance) // operator
    .subscribe(onNext: { json in
        self.editView.text = json
        self.setVisibleWithAnimation(self.activityIndicator, false)
    })
```

처음 예제에서 사용했던 subscribe을 바꿀 수 있다.

또 Main Thread로 변경해줘야 했던 부분을 observeOn(MainScheduler.instance)로 간단하게 사용할 수 있다.

데이터가 Observable에서 subscribe로 이동하는 중간에 데이터를 바꾸는 것을 **operator**라고 한다.

## Operator

### Map

```swift
downloadJson(MEMBER_LIST_URL)
    .map { $0?.count ?? 0 }
    .map { "\($0)" }
    .observeOn(MainScheduler.instance)
    .subscribe(onNext: { json in
        self.editView.text = json
        self.setVisibleWithAnimation(self.activityIndicator, false)
    })
```

위 처럼 사용하면 데이터(json)의 count를 아래로 흘려보내고

editView.text에 넣기 위해 String으로 변환해서 아래로 흘려보낸다.

### Filter

```swift
downloadJson(MEMBER_LIST_URL)
    .map { $0?.count ?? 0 }
		.filter { $0 > 0 }
    .map { "\($0)" }
    .observeOn(MainScheduler.instance)
    .subscribe(onNext: { json in
        self.editView.text = json
        self.setVisibleWithAnimation(self.activityIndicator, false)
    })
```

filter를 추가해 count가 0보다 크면 아래로 진행한다.

### 마블 다이어그램 (Marble Diagram)

[ReactiveX - Operators](https://reactivex.io/documentation/operators.html)

ReactiveX 공식 사이트에 들어가면 많은 Operator들을 볼 수 있다.

위 사이트에서 Just에 대한 설명을 한번 봐보자.

<img width="764" alt="marble_just" src="https://user-images.githubusercontent.com/77602040/207626409-4ebca33b-fa85-48b1-85d3-31d91bf1d085.png">

위 사진이 Just의 마블 다이어그램이다.

구슬 → Data

중앙 박스 → Operator

하단 화살표 → Observable

하단 화살표 안 세로 막대 → Completed

Data를 Operator(Just)에 넣으면 Observable이 방출되고  Completed가 된다.

From도 한번 보자.

<img width="756" alt="marble_from" src="https://user-images.githubusercontent.com/77602040/207626553-fc2419de-92d2-46d3-936b-b9bba5bb3fa1.png">


Array Data의 각 요소를 Operator(From)에 넣으면 순서대로 하나씩 Observable이 방출되고 모든 요소가 방출되고 나서 Completed가 된다.

Map도 보자.

<img width="747" alt="marble_map" src="https://user-images.githubusercontent.com/77602040/207626572-5d973d0b-c20e-4fb4-bf4c-8beabccec28e.png">

Map은 위에도 Observable, 아래도 Observable이다.

위 데이터가 오면 map에서 지정한 연산을 수행하고 바뀐 Observable을 방출한다.

ObserveOn은 스레드를 관리하는 Operator였다. 한번 보자.

<img width="740" alt="marble_observe_on_01" src="https://user-images.githubusercontent.com/77602040/207626666-8bb4439c-39a7-49b3-8920-533de258ed99.png">

위에서 본 다른 Operator들과 비슷하지만 색상이 다르다.

여기서 색상은 스레드를 나타낸다.

ObserveOn 하고 스레드를 바꾸면 그 밑에부터 스레드가 바뀐다는 의미이다.

<img width="495" alt="marble_observe_on_02" src="https://user-images.githubusercontent.com/77602040/207626704-340dca6f-7cbb-4bb5-982c-e990eee44461.png">

ObserveOn으로 스레드를 변경하고 Map이나 다른 Operator를 사용해도 스레드는 변하지 않는다.

단, subscribeOn을 사용하면 맨 처음 시작할 때 스레드를 지정해준다.

ObserveOn은 다음 줄부터 스레드를 변경하고 subscribeOn은 처음의 스레드를 변경한다.

곰튀김님이 아무거나 지정한 Operator

<img width="743" alt="marble_last" src="https://user-images.githubusercontent.com/77602040/207626744-fa78cb10-04d8-4cf2-81b2-139d28cc2789.png">

위 마블 다이어그램을 보면 Observable들이 지나가다가 completed 되는 시점에 마지막 Observable을 방출하는 것을 알 수 있다.

나도 아무거나 골라서 한번 봐보자.

last의 반대 first를 선택했다.

<img width="746" alt="marble_first" src="https://user-images.githubusercontent.com/77602040/207626778-c39c43b5-c913-4b46-a6e1-1dbc4c447912.png">

이름만봐도 기능이 짐작이 가지만 마블 다이어그램을 가져왔다.

첫 번째 Observable이 지나갈 때 방출되고 completed를 하는 것을 알 수 있다.

ReactiveX에 많은 Operator들이 있지만 마블 다이어그램을 보고 동작을 이해할 수 있다면 다 이해할 수 있다.

Operator는  여러 가지로 종류가 나뉜다.

1. 데이터 생성
2. 데이터 변형
3. 데이터 필터링
4. 여러가지 옵저버들을 묶어서 처리 (join, merge, zip 등)
5. 에러 핸들링
6. 유틸리티 등등

## Stream의 분리 병합

### Merge

<img width="745" alt="marble_merge" src="https://user-images.githubusercontent.com/77602040/207626812-a2bb0ca4-6872-42ed-891f-e11dba796fff.png">

merge의 마블 다이어그램을 먼저 보자.

merge는 여러개의 Observable을 하나로 합치는 것이다.

그래서 merge는 Observable의 데이터 타입이 같아야한다.

### Zip

<img width="748" alt="marble_zip" src="https://user-images.githubusercontent.com/77602040/207626840-86b34c2f-155d-4168-a7e7-3658533975fa.png">

zip은 두 개의 Observable에서 데이터를 순서대로 하나의 쌍으로 만들어준다.

데이터 타입이 달라도 상관없다.

만들 쌍이 없다면 그냥 completed된다.

```swift
let jsonOb = downloadJson(MEMBER_LIST_URL)
let helloOb = Observable.just("Hello Harry")

Observable
    .zip(jsonOb, helloOb) { $1 + "\n" + $0 }
    .observeOn(MainScheduler.instance)
    .subscribe(onNext: { json in
        self.editView.text = json
        self.setVisibleWithAnimation(self.activityIndicator, false)
    })

// Hello Harry
// json ~~~~
```

### CombineLatest

<img width="748" alt="marble_combine_latest" src="https://user-images.githubusercontent.com/77602040/207626855-641dddb7-4399-4ace-b1fa-5f8d0589d57e.png">

zip과 비슷하지만 zip은 쌍이 없으면 값이 방출되지 않지만 combineLatest는 가장 최근 데이터와 쌍을 만들어서 방출된다.

Operator에는 생성에 관련된 것도 있고, 데이터를 전달하는 과정에서 변형하거나 스레드 관리를 할 수있고, subscribe에서도 사용할 수 있었다.

이 처럼 RxSwift를 사용하면서 편리하게 데이터와 동작을 만질 수 있도록 도와주는 것을 Operator라고 한다.

## DisposeBag

다운로드를 받는 중 화면에서 나가거나 중지하는 동작이 필요할 때 편리하게 사용하도록 만들어 둔 suger

```swift
var disposeBag = DisposeBag() // disposable들을 모아두는 가방

Observable
	.zip(jsonOb, helloOb) { $1 + "\n" + $0 }
	.observeOn(MainScheduler.instance)
	.subscribe(onNext: { json in
	    self.editView.text = json
	    self.setVisibleWithAnimation(self.activityIndicator, false)
	}).disposed(by: disposeBag) // .disposed(by: )로 가방에 담는다.
```

## Subject

만들 때 부터 어떤 데이터를 내보낼지 정해져있다.

Observable처럼 값을 받을 수도 있지만 (subscribe)

외부에서 값을 통제할 수도 있다. (onNext)

### AsyncSubject

<img width="726" alt="async_subject" src="https://user-images.githubusercontent.com/77602040/207626924-bc14a447-2bd0-45ec-9394-70ae4b70111a.png">

completed 되는 시점에 subscribe한 애들한테 가장 마지막 값을 보내준다.

### BehaviorSubject

<img width="727" alt="behavior_subject" src="https://user-images.githubusercontent.com/77602040/207626967-f79609ca-562b-453a-abad-01f1ba1adb78.png">

초기값을 가지고 있어서 subscribe할 때 초기값을 보내준다. 그 후 추가로 생기는 subscribe은 가장 최근의 값을 초기값으로 보내준다.

### PublishSubject

<img width="724" alt="publish_subject" src="https://user-images.githubusercontent.com/77602040/207627003-082014e2-2013-4ef1-9785-1b7af17e2fbb.png">

초기값 없이 subscribe 후 값이 들어오면 그대로 보내준다.

추가로 생기는 subscribe도 같다.

### ReplaySubject

<img width="723" alt="replay_subject" src="https://user-images.githubusercontent.com/77602040/207627052-42024d1a-90c4-4470-b58c-989f98a1a8b2.png">


첫 번째 subscribe은 PublishSubject와 같지만 두 번째 subscribe부터는 이전에 있었던 값들을 한번에 보내준다.

가장 많이 쓰는 Subject는 Publish와 Behavior이다.

## RxCocoa

RxCocoa는 RxSwift 요소들을 UIKit View들에게 extension으로 적용해놓은 것이다.

```swift
// UILabel
label.rx.text // Binder 타입 bind 시킬 수 있다.
```

UI와 관련된 작업을 처리하기 때문에 항상 Main Thread에서 동작해야한다.

```swift
viewModel.itemsCount
            .map { "\($0)" }
            .observeOn(MainScheduler.instance)
            .bind(to: itemCountLabel.rx.text)
            .disposed(by: disposeBag)
```

observeOn으로 MainScheduler로 설정해줘야한다.

```swift
viewModel.itemsCount
            .map { "\($0)" }
            .catchErrorJustReturn("")
            .observeOn(MainScheduler.instance)
            .bind(to: itemCountLabel.rx.text)
            .disposed(by: disposeBag)
```

UI와 관련된 것이기 때문에 에러처리가 필요하다.

catchErrorJustReturn으로 에러가 발생하면 빈 문자열을 보내게 하는 것도 가능하다.

observeOn과 catchErrorJustReturn의 처리는 항상 필요하다.

```swift
viewModel.itemsCount
            .map { "\($0)" }
            .asDriver(onErrorJustReturn: "")
            .drive(itemCountLabel.rx.text)
            .disposed(by: disposeBag)
```

항상 UI Thread(Main Thread)에서 동작하는 Driver로 처리할 수 있다.

## Relay

Relay는 에러가나도 끊어지지 않는 Subject이다.

Reley는 onNext대신 accept를 사용한다.

```swift
// Subject
self.menuObservable.onNext($0)

// Relay
self.menuObservable.accept($0)
```

## MVVM

화면에 어떤 내용을 그려야할지 ViewModel에서 가지고 처리하고 View에서는 아무런 처리를 하지 않고 화면에 가지고있는 것과 이벤트만 넘겨준다.

모든 동작과 데이터 처리는 ViewModel에서 진행한다.

## Reference

[시즌2 모임 종합편 입니다.](https://www.youtube.com/watch?v=iHKBNYMWd5I&list=PL03rJBlpwTaBrhux_C8RmtWDI_kZSLvdQ)
