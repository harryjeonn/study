# [Swift] Frame, Bounds

면접 질문 중 Frame과 Bounds의 차이점에 대해서 질문을 받았다.

답변 도중 면접관님이 `SuperView의 Bounds 값을 바꾸면 SubView의 Frame값은 어떻게 되나요?` 라고 질문을 주셨다.

SuperView에서 Bounds를 바꾸면 SubView가 움직이는 것으로 알고 있었기 때문에 움직인 값 만큼 변한다고 생각하고 답변을 했다.

그 결과는 직접 한번 해보면서 조금 더 알아보면 좋겠다는 말씀을 해주셨다.

그래서 면접 후 간단하게 테스트를 해볼겸 다시 정리한다.

## Frame

**SuperView의 좌표시스템**안에서 View의 위치와 크기를 나타낸다.

### Frame 변경

![frame_bounds_01](https://user-images.githubusercontent.com/77602040/212862117-96d3785c-78e0-4d40-9f8e-20836bb78a69.png)

![frame_bounds_02](https://user-images.githubusercontent.com/77602040/212862159-4e8974b4-75d5-4c5a-b7cb-d414b52cf424.png)

FirstView의 frame을 바꿔주니 RootView의 좌표시스템 안에서 위치가 변경되는 것을 볼 수 있다.

현재 RootView의 origin은 0,0 이고, FirstView는 그 0,0 기준으로 좌표를 잡아서 그려진다.

## Bounds

View의 위치와 크기를 **자신만의 좌표시스템안**에서 나타낸다.

<img width="611" alt="frame_bounds_03" src="https://user-images.githubusercontent.com/77602040/212862226-35938cb2-1828-41df-aad9-a4d48d804d82.png">

Frame 설명할 때와 같은 화면인데 FirstView와 SecondView의 Bounds 좌표 값이 0이다.

Bounds는 상위 뷰와 아무런 상관이 없고 **자신만의 좌표시스템**을 가지는 것이 특징이다.

Bounds의 origin은 기본 값으로 0,0 값을 가진다.

### Bounds 변경

여기서 FirstView의 Bounds 값을 변경해보자

<img width="621" alt="frame_bounds_04" src="https://user-images.githubusercontent.com/77602040/212862267-2b0cc1cb-3951-4a6e-9d88-5fed29ca8a15.png">

바꾼건 FirstView의 Bounds인데 SecondView가 위로 올라갔다?

SecondView의 위치가 변한것이 아닌 FirstView의 위치가 변한 것이다.

자신만의 좌표시스템, Bounds가 변했다는 것은 해당 위치에서 View를 다시 그리라는 의미가 된다.

SecondView는 가만히 있었지만 FirstView가 x축으로 50, y축으로 200 만큼 움직여서 다시 그려졌기 때문에 올라간 것처럼 보이는 것이다.

여기서 처음에 했던 질문을 한번 다시 생각해보면서 확인해보자.

FirstView의 Bounds값을 변경했을 때 SecondView의 Frame 값은 어떻게 되는가?

SecondView는 가만히 있었기 때문에 SecondView의 값은 변경되지 않는다.

FirstView의 Bounds 값만 변한다. 라고 생각할 수 있다.

한번 확인해보자!

<img width="621" alt="frame_bounds_05" src="https://user-images.githubusercontent.com/77602040/212862980-5b571870-167e-4bf8-b839-2b6234b164c6.png">

Change를 기준으로 위가 변하기 전 밑이 변한 후의 값이다.

FirstView의 Bounds를 제외한 모든 좌표 값들이 변하지 않았다.

## 언제 Frame을, Bounds를 사용할까?

### Frame

View의 위치나 크기를 설정하는 경우

### Bounds

View 내부에 그림을 그릴 때

transfomation 후 View의 크기를 알고싶을 때

하위 View를 정렬하는 것과 같이 내부적으로 변경할 때

ScrollView에서 스크롤할 때 (스크롤 동작이 ScrollView의 Bounds를 변경하여 화면을 이동시킴)

![frame_bounds_06](https://user-images.githubusercontent.com/77602040/212863026-129eeeba-f174-4d72-bedd-a6a503355bf8.png)

Frame은 SuperView를 기준으로 좌표시스템을 갖기 때문에 위치와 크기, 그중에 위치를 그리는데 사용하고

Bounds는 자신만의 좌표시스템을 갖기 때문에 View 자체의 영역을 나타내고 크기가 포인트이다.

[개발자 소들이](https://babbab2.tistory.com/46) 님 블로그에 좋은 예시를 보여주는 사진이 있길래 가져왔다.

## 🧐

단순히 Frame은 SuperView, Bounds는 자기 자신을 기준으로 좌표시스템을 가진다고 생각했다.

이번에 면접을 보고 난 후 조금 더 자세히 알아보면서 원리를 알게되었다.

알고 구현할 수 있는 정도가 아닌 원리에 대해 깊게 공부하고 알게되는 것, 중요한 것 같다.
