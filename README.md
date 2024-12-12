# NBC-PhoneBook
---

#### 포켓몬 이미지를 프로필로 활용할 수 있는 전화번호부 앱

<br/>

## 주요 기능

#### 연락처 관리
- 연락처 추가/수정/삭제
- 이름과 전화번호 저장
- 포켓몬 프로필 이미지 설정 (랜덤 선택 가능)


#### 데이터 영구 저장
- CoreData를 활용한 로컬 데이터 저장
- 앱 재실행시에도 데이터 유지

<br/>
<br/>

### UI
- 코드 기반 UI 구현 (SnapKit 활용)
- 테이블뷰를 활용한 연락처 목록 표시
- 포켓몬 이미지를 Kingfisher를 통해 효율적으로 로드

<br/>

### 기술 스택
- Swift, UIKit
- CoreData
- SnapKit
- Kingfisher

<br/>

### 아키텍처
```
NBC_PhoneBook/
├── resource/
│   └── Assets
│
├── source/
│   ├── Delegate/
│   │   ├── AppDelegate
│   │   └── SceneDelegate
│   │
│   ├── Models/
│   │   ├── API/
│   │   │   └── PokeAPI
│   │   ├── CoreData/
│   │   │   ├── NBC_PhoneBook
│   │   │   ├── PhoneNumberData+CoreDataClass
│   │   │   └── PhoneNumberData+CoreDataProperties
│   │   ├── PhoneBookManager
│   │   ├── PhoneNumber    
│   │   ├── PhoneNumberFormatter    
│   │   └── PokeData
│   │       
│   │
│   ├── ViewControllers/
│   │   ├── Protocol/
│   │   │   └── ErrorAlertPresentable
│   │   ├── MainViewController
│   │   └── PhoneBookViewController
│   │
│   └── Views/
│       └── Cells/
│           └── PhoneNumberTableViewCell
```