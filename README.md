# 야곰 마켓 [Refactoring]

> 야곰아카데미 `오픈마켓`를 리팩토링한 프로젝트 입니다. 기존 프로젝트는 [`ios-open-market 저장소`](https://github.com/wongbingg/ios-open-market/tree/step4) 에서 확인할 수 있습니다.

## 📄 소개
- 야곰아카데미 오픈마켓 서버와 통신을 통해 상품을 조회,수정,게시,삭제할 수 있는 앱 입니다.
- `번개장터` iOS 앱 UI를 참고하여 프로젝트를 진행했습니다.

## 🔑 핵심기술
- **`아키텍쳐`**
    - MVVM
    - Coordinator
- **`디자인패턴`**
    - 빌더패턴
    - 책임연쇄패턴
- **`코드베이스 UI`**
    - 오토레이아웃
- **`네트워킹`**
    - URLSession
- **`비동기처리`**
    - Async/await
- **`라이브러리`**
    - Firebase

## 프로젝트 구조

### Domain Layer

<details>
    <summary>Entity</summary>
    
<br>
    
- `ProductCell`: 컬렉션뷰에서 셀이 보여줄 상품정보
- `ChattingCell`: 채팅리스트에서 셀이 보여줄 채팅정보
- `ProductDetail`: 상세보기 화면에서 보여줄 상품정보
- `LoginInfo`: 로그인 정보
- `UserProfile`: Firestore에 저장되는 유저정보
- `Message`: Firestore에 저장되는 메세지
- `UserUID`: Firestore에 저장되는 UserUID
    
</details>

<details>
    <summary>UseCase</summary>
        
<br>
  
- `AddNextProductPageUseCase`: 홈뷰 페이지네이션 UseCase
- `EditProductUseCase`: 상품수정 UseCase 
- `RegisterProductUseCase`: 상품등록 UseCase
- `DeleteProductUseCase`: 상품삭제 UseCase 
- `FetchProductDetailUseCase`: 상세 데이터요청 UseCase 
- `LoginUseCase`: 로그인 실행 UseCase
- `CreateUserUseCase`: 계정등록 UseCase 
- `SearchQueryUseCase`: 검색 keyword에 대한 결과 리스트 요청 UseCase 
- `SearchUserProfileUseCase`: 나의 유저정보 요청 UseCase
- `SearchOthersUIDUseCase`: 상대방 유저정보 요청 UseCase
- `SearchChattingUseCase`: 채팅목록 요청 UseCase
- `RecordVendorNameUseCase`: VendorName 등록 UseCase
- `HandleLikedProductUseCase`: 좋아요 목록관리(추가/삭제) UseCase
- `HandleChattingUseCase`: 채팅 목록관리(추가/삭제) UseCase
- `SendMessageUseCase`: 메세지 전송 UseCase
    
</details>

   

### Presentation Layer


<details>
    <summary>Scene</summary>
    
<br>
    
> 각 scene은 FlowCoordinator와 하나 이상의 view를 가집니다. 
- `LoginScene` : 로그인 화면
- `HomeScene` : 홈탭 화면
- `SearchScene` : 서치탭 화면
- `ChatScene` : 채팅탭 화면
- `MyPageScene` : 마이페이지 화면
- `ModalView` : 모달뷰 (RegisterView, ImageViewerView)
    
</details>





### Data Layer

<details>
    <summary>Repository</summary>
    
<br>
    
- `ProductsRepository`
    - fetchList : 상품 리스트 요청
    - fetchDetail : 상품 상세정보 요청
    - edit : 상품 상세정보를 수정
    - delete : 상품을 삭제 
- `ProductQueryRepository`
    - fetch : 서치 keyword에 해당하는 검색결과 요청
    
</details>


<details>
    <summary>Service</summary>
    
<br>
    
- `FirebaseAuthService`
    - createUser: 사용자 계정등록
    - logIn: 사용자 계정으로 로그인
- `FirestoreService`
    - create : 새로운 entity 생성
    - read : 파라미터에 해당하는 entity 요청
    - update : 파라미터에 해당하는 entity를 수정
    - delete : 파라미터에 해당하는 entity를 삭제
    
</details>





## 📱 실행화면

<table>
    <tr>
        <td valign="top" width="30%" align="center" border="1">
            <strong>홈 화면</strong>
        </td>
        <td valign="top" width="30%" align="center">
            <strong>상품찾기 화면</strong>
        </td>
        <td valign="top" width="30%" align="center" border="1">
            <strong>상품등록 화면</strong>
        </td>
    </tr>
    <tr>
        <td valign="top" width="30%">
            <img src="https://i.imgur.com/nLhJP5n.gif"/>
        </td>
        <td valign="top" width="30%">
            <img src="https://i.imgur.com/79iOA4A.gif"/>
        </td>
        <td valign="top" width="30%">
            <img src="https://i.imgur.com/3Juwkkn.gif">
        </td>
    </tr>
</table>

<table>
    <tr>
        <td valign="top" width="30%" align="center" border="1">
            <strong>상품 수정화면</strong>
        </td>
        <td valign="top" width="30%" align="center">
            <strong>마이페이지 화면</strong>
        </td>
        <td valign="top" width="30%" align="center" border="1">
            <strong>채팅 화면</strong>
        </td>
    </tr>
    <tr>
        <td valign="top" width="30%">
            <img src="https://i.imgur.com/adszzF6.gif"/>
        </td>
        <td valign="top" width="30%">
            <img src="https://i.imgur.com/dYfiPHA.gif"/>
        </td>
        <td valign="top" width="30%">
            <img src="https://i.imgur.com/n7Z1nrK.gif"/>
        </td>
    </tr>
</table>






## 🔭 시각 자료

### - 의존성 주입
![](https://i.imgur.com/DGSaa7d.png)


## ⚙️ 새롭게 적용한 기술

### ✅ Unit Test

#### ☑️ MockURLSession Test

```
API 문서에 주어진 7개의 기능에 대한 단위테스트를 진행하였습니다. 하지만, 테스트 시간이 오래걸리고
특히 POST 테스트의 경우 실제 서버의 프로덕트를 오염시키는 단점이 있었습니다. 
```

```
API 객체가 요청에 대한 오류 처리를 잘 하는지 확인하기 위해 MockURLSession을 생성하여
테스트를 진행했습니다. 
```

#### ☑️ UseCase Test
```
FirestoreServiceMock 과 FirebaseAuthServiceMock, ProductsRepositoryMock 객체
를 만들어 각 UseCase에 대한 테스트를 진행했습니다.
```

#### ☑️ ViewModel Test
```
각 UseCase를 추상화해 UseCaseMock을 만들어 ViewModel 테스트를 진행했습니다.
```


### ✅ TabBarController
```
기능을 탭으로 나누기 위해 TabBarController 를 사용하여 화면을 구성했습니다.
```


### ✅ SearchBar

#### ☑️ 화면구성

<details>
    <summary>
        펼쳐보기
    </summary>

<table>
    <tr>
        <td valign="top" align="center" border="1">
            <strong>SearchController 사용</strong>
        </td>
        <td valign="top" align="center" border="1">
            <strong>SearchBar 사용</strong>
        </td>
    </tr>
    <tr>
        <td valign="top">
            <img src="https://i.imgur.com/THSyMe8.png" width="200">
        </td>
        <td valign="top">
            <img src="https://i.imgur.com/OvqDnbU.png" width="200">
        </td>
    </tr>
</table>

- 두가지 UI중 오른쪽으로 구현을 하고자 했지만, SearchController에 있는 `searchResultsController` 의 역할을 어떻게 대체 해줄지 고민이 되었습니다.
    
    ```swift
    검색결과를 보여줄 "ResultView"를 만들어 searchResultsController 
    처럼 동작하도록 뷰를 갈아끼워 주었습니다.
    ```
    
    
</details>

### ✅ URLCache


#### ☑️ 네트워킹을 통해 이미지를 받아오기
```
onDisk 와 onMemory 방식 둘다 가능한 URLCache를 이용하여 캐싱작업을 했습니다.
```

### ✅ Custom Modal
```
상품 상세보기 에서 사진을 탭했을 때, Custom Modal 로 ImageViewer를 띄워주었습니다.
```

## 🛠 Trouble Shooting

### ⚠️ 이미지 사이즈 조절

<details>
    <summary>
        펼쳐보기
    </summary>

- 기존에 사용했던 `jpegData(compressionQuality:)`의 경우 
    ```swift
    왠만한 사진은 사이즈가 300kb 미만으로 압축이 되었지만
    사이즈가 많이 큰 사진의 경우 압축에 한계가 있었습니다.
    ```
    
- 새로운 방법 resize() 와 downSample()
    ```swift
    이미지 비율조절을 통해 사이즈를 줄일 수 있는 resize() 와  
    downSample() 메서드를 구현했습니다. 다만 문제점은 
    jpegData() 를 이용했을 때보다 화질저하가 많이 일어난다는 점이었습니다.
    그래서 먼저 jpegData() 메서드를 통해 사진을 압축하도록 한 뒤,
    사이즈가 만족되지 못하면, resize(), downSample() 메서드가 이용되도록
    "책임연쇄패턴" 을 사용 했습니다.
    ```

</details>

### ⚠️ 빠른 스크롤시, 셀 이미지 업데이트가 밀렸다가 한꺼번에 실행되는 현상

<details>
    <summary>
        펼쳐보기
    </summary>

<table>
    <tr>
        <td valign="top" align="center" border="1">
            <strong>오류 화면</strong>
        </td>
        <td valign="top" align="center" border="1">
            <strong>개선 화면</strong>
        </td>
        <td valign="top" align="center" border="1">
            <strong>최종 개선 화면</strong>
        </td>
    </tr>
    <tr>
        <td valign="top">
            <img src="https://i.imgur.com/QWRmpZU.gif" width="200">
        </td>
        <td valign="top">
            <img src="https://user-images.githubusercontent.com/95671495/209077765-4e26aa2d-b530-4598-ad33-3e5bcbea2495.gif" width="200">
        </td>
        <td valign="top">
            <img src="https://i.imgur.com/eN7d8db.gif" width="200">
        </td>
    </tr>
</table>


    
- 빠르게 스크롤작업을 할 때 사진을 받아오는 작업이 쌓여서 한꺼번에 실행이 되었습니다.
            
#### 해결방법
- 이미지를 받아오는 비동기 메서드가 이미지를 받아왔을 때
- cellForRowAt에서 받아온 indexPath와 재사용되고있는 셀의 index가 같을 때만 이미지를 할당하도록 제약을 주었습니다.
-  쌓여있던 네트워킹 작업들을 취소해주고자OperationQueue를 이용해서 작업을 수행하고, 셀의 prepareForReuse() 메서드 내에서 OperationQueue.cancelAllOperations() 메서드를 실행시켜 주었습니다. 하지만 효과는 보지 못했습니다
    
#### 최종 해결방법
- async-await 으로 리팩토링 후, 이미지 요청을 Task에 담아준 뒤, prepareForReuse 메서드를 재정의 하여 안에서 task.cancel() 을 처리 해주었습니다. 이미지 요청을 담은 Task 안에서 실제 이미지 요청 전, Task.checkCancellation() 메서드를 통해 취소되었으면 이미지 요청을 진행하지 않고 오류를 반환하도록 했습니다. 이렇게 처리하니 모든 요청을 기다리지 않아도 되어 셀 이미지 업데이트 속도가 대폭 향상 되었습니다.
    
    
    
</details>

### ⚠️ TabBarController에서 Modal뷰 띄우기

<details>
    <summary>
        펼쳐보기
    </summary>

- TabBarControllerDelegate를 이용하여 선택된 탭의 viewController 타입을 확인한 후, modal로 띄워주도록 처리하였습니다.
    
</details>

### ⚠️ ImageView 위에 버튼을 올리면 인식하지 않는 문제

<details>
    <summary>
        펼쳐보기
    </summary>

- UIImageView에 addSubview() 를 통해 버튼을 추가한 경우
    ```swift
    버튼에 addTarget을 통해 액션을 지정 해주었음에도
    버튼 탭을 인식하지 못했습니다.
    ```
- CustomView를 만들어 그 안에 imageView와 button을 넣어준 경우
    ```swift
    imageView의 자식뷰로 넣지 않고 둘 다 UIView에
    동등한 관계로 버튼을 넣어주니 버튼 탭 인식을 했습니다. 
    ```

</details>

### ⚠️ ViewDidAppear() 와 ViewDidLayoutSubviews()의 차이점

<details>
    <summary>
        펼쳐보기
    </summary>

<table>
    <tr>
        <td valign="top" align="center" border="1">
            <strong>오류 화면</strong>
        </td>
        <td valign="top" align="center" border="1">
            <strong>개선 화면</strong>
        </td>
    </tr>
    <tr>
        <td valign="top">
            <img src="https://user-images.githubusercontent.com/95671495/209078715-ea6430ff-eb14-48bc-9f3a-2f42e1d70889.gif" width="200">
        </td>
        <td valign="top">
            <img src="https://user-images.githubusercontent.com/95671495/209078776-ca8bdb7a-2eb4-4300-9f75-5aaa93b0467a.gif" width="200">
        </td>
    </tr>
</table>
    
- DetailView의 페이지 인덱스 레이블 (사진 우측하단) 업데이트가 viewDidLoad()에서 설정되지 않아 ViewDidAppear()에서 설정 해주었습니다.
    ```swift
    왼쪽 gif 같이 한박자 늦게 페이지 인덱스 레이블이 띄워졌습니다
    
    "해결"
    viewDidLayoutSubviews() 에서 실행시켜 주니 해결 되었습니다.
    ```
    
<table>
    <tr>
        <td valign="top" align="center" border="1">
            <strong>오류 화면</strong>
        </td>
        <td valign="top" align="center" border="1">
            <strong>개선 화면</strong>
        </td>
    </tr>
    <tr>
        <td valign="top">
            <img src="https://i.imgur.com/Tnqqe30.gif" width="200">
        </td>
        <td valign="top">
            <img src="https://i.imgur.com/hjyJiCv.gif" width="200">
        </td>
    </tr>
</table>
    
- 스크롤뷰의 contentOffset이 viewDidLoad()에서 조정되지 않아 viewDidAppear() 에서 조정 해주었습니다.
    ```swift
    하지만 원하는대로 ScrollView 의 contentOffset이 지정되지 
    않고 위와같이 한박자 늦는 문제가 생겼습니다.
    
    "해결"
    viewDidLayoutSubviews()에서 contentOffset 을 조정해주니 
    잘 적용 되었습니다.
    ```

- 공통적인 문제점은 목표한 동작이 한 타이밍 느리게 동작하는 것처럼 보이는 것이었습니다. 뷰가 띄워진 뒤에야 목표한 동작이 이루어졌습니다. 
- 해결점은 viewDidLayoutSubviews() 였습니다
</details>

## 🔗 참고자료

#### 공식문서
- [UITabBarController](https://developer.apple.com/documentation/uikit/uitabbarcontroller)
- [UISearchBar](https://developer.apple.com/documentation/uikit/uisearchbar)
- [UISearchBarDelegate](https://developer.apple.com/documentation/uikit/uisearchbardelegate/)
- [URLCache](https://developer.apple.com/documentation/foundation/urlcache/)
- [UITabBarControllerDelegate](https://developer.apple.com/documentation/uikit/uitabbarcontrollerdelegate/)
#### 블로그
- [SearchBar 참고 블로그](https://zeddios.tistory.com/1196)



