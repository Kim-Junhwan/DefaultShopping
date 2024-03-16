# DefaultShopping
새싹 2차 Recap Assignment

## 개발  환경
- 최소버전: iOS 15
- UI 프레임워크: UIKit
- DB: Realm

## 사용 라이브러리
- UI: Snapkit
- DB: Realm Swift

## 주요 기능

### 상품 검색 및 그리드모드, 테이블 모드
<img src = "https://github.com/Kim-Junhwan/DefaultShopping/assets/58679737/63db718d-1f6b-4d8a-9f7c-f8468e627bfc" width="200" height="433">
<img src = "https://github.com/Kim-Junhwan/DefaultShopping/assets/58679737/f0ae748e-a017-4fe7-b675-bc187e39b94b" width="200" height="433">

### 상품 검색결과 정렬 및 클릭시 구매 페이지 이동
<img src = "https://github.com/Kim-Junhwan/DefaultShopping/assets/58679737/f9a0e856-a019-486d-95b3-86c38673f115" width="200" height="433">
<img src = "https://github.com/Kim-Junhwan/DefaultShopping/assets/58679737/83146df5-1a09-4cb8-a480-792911f85f9a" width="200" height="433">

### 상품 즐겨찾기
<img src = "https://github.com/Kim-Junhwan/DefaultShopping/assets/58679737/1ef39a81-7445-4a3e-b08d-812e1fb931df" width="200" height="433">

## 트러블 슈팅 및 개발 관련 설명

### 상품 목록 셀 이미지 이슈
셀에서 이미지를 비동기적으로 가지고 올때, 빠르게 스크롤 할 경우 셀의 재사용에 의해 이미지를 가지고 오기전에 다시 이미지를 가지고 오는 작업을 수행하여 다음과 같이 이미지가 계속해서 바뀌는 문제가 발생

![RPReplay_Final1710568534](https://github.com/Kim-Junhwan/DefaultShopping/assets/58679737/b4059d38-6e37-4581-8d9e-536ef13160f9)

이 문제를 해결하기 위해, UIImageView에서 url로 이미지를 가지고 오는 기능을 Datasource로 분리하고, OperationQueue와 prefeching을 이용하여 이미지를 가지고 오는 작업을 취소하는 방식으로 문제를 해결

### 네트워크 요청을 위한 네트워크 계층 구현
네트워킹에 관한 코드를 작성할 때, 상호작용하는 부분마다 네트워킹 코드를 구현할 시 같은 코드를 중복으로 작성하게 됩니다. 중복된 부분을 제거하기 위해 총 4가지 부분으로 나누어 구현했습니다.
- NetworkConfiguration: 네트워크 기본 설정을 하는 구조체입니다. API의 기본 URL, header, parameter같이 요청 시 공통으로 들어가야 하는 정보를 가지고 있습니다.
- Endpoint: 세부적인 API의 path와 해당 API에 들어가야 할 query, http Method, 응답으로 온 data를 디코딩할 타입을 가지고 있고, URLRequest를 만드는 책임을 가지고 있습니다.
- NetworkService: URLSession을 이용해 Endpoint가 만든 URLRequest로 요청합니다.
- DataTransferService: NetworkService로부터 받은 데이터의 값을 Endpoint의 디코딩 타입으로 디코딩합니다.
