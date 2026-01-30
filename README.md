# WithLocal - 로컬 투어 및 모빌리티 플랫폼

**"여행에 로컬의 컬러를 더하다"**

WithLocal은 현지인의 재능(Color)과 이동 편의성(Car), 안전(Insurance)을 결합한 초개인화 투어 플랫폼입니다.

![WithLocal App Icon](https://www.genspark.ai/api/files/s/rdPN1S3V)

## 🌟 주요 특징

### 1. 5가지 컬러 큐레이션 시스템
- 🔥 **열정 레드** - 열정적인 체험
- 🌿 **힐링 그린** - 자연/힐링
- 🎨 **문화 퍼플** - 예술/문화
- 🏄 **레저 블루** - 레저/스포츠
- 🍜 **미식 오렌지** - 미식/로컬푸드

### 2. 직관적인 5단계 플로우
1. **컬러 칩 선택** - 여행 취향을 컬러로 선택
2. **투어 리스트** - 맞춤형 투어 탐색
3. **필터 화면** - 차량 옵션 및 즉시 예약 선택
4. **투어 상세** - 호스트 정보 및 투어 설명
5. **결제 및 보험** - 자동 보험 가입 포함
6. **채팅 및 리뷰** - 호스트와 소통

### 3. 차별화 포인트
- ✅ **Door-to-Door 서비스**: 호스트 차량 옵션 공식 제공
- ✅ **자동 보험 가입**: 모든 투어에 여행자 상해보험 포함
- ✅ **호스트 등급제**: 동네주민(15%) → 반장(13%) → 전문가(11%) → 대장(9%)
- ✅ **번역 브릿지**: 파파고/구글 번역 딥링크 연동

## 🚀 기술 스택

- **Framework**: Flutter 3.35.4
- **언어**: Dart 3.9.2
- **데이터베이스**: Hive (로컬 NoSQL)
- **상태 관리**: Provider
- **네트워크**: HTTP Client
- **딥링크**: url_launcher
- **UI**: Material Design 3

## 📱 스크린샷

### 1단계: 컬러 칩 선택
여행 취향을 6가지 컬러로 선택하는 첫 화면

### 2단계: 투어 리스트
선택한 컬러에 맞는 투어를 카드 형식으로 표시

### 3단계: 필터 화면
차량 옵션(도보/전문 차량) 및 즉시 예약 선택

### 4단계: 투어 상세
투어 정보, 호스트 프로필, 포함 사항 표시

### 5단계: 결제 및 보험
예약 정보, 보험 상세, 가격 내역 확인

### 6단계: 채팅 및 리뷰
호스트 메시지 및 별점 리뷰 작성

## 🎨 디자인 시스템

### 컬러 팔레트
- **Primary**: `#00B0FF` (Bright Blue)
- **Secondary**: `#FF6F00` (Deep Orange)
- **Background**: White
- **Surface**: `#F5F5F5` (Light Gray)

### 타이포그래피
- **제목**: 28pt Bold
- **부제목**: 18-22pt Bold
- **본문**: 15-16pt Regular
- **캡션**: 13-14pt Gray

## 🛠️ 설치 및 실행

### 사전 요구사항
- Flutter 3.35.4 이상
- Dart 3.9.2 이상
- Android Studio / VS Code

### 설치
```bash
# 저장소 클론
git clone https://github.com/soogroup/withlocal.git
cd withlocal

# 의존성 설치
flutter pub get

# 웹 실행
flutter run -d chrome

# Android APK 빌드
flutter build apk --release
```

## 📦 주요 의존성

```yaml
dependencies:
  flutter:
    sdk: flutter
  hive: 2.2.3
  hive_flutter: 1.1.0
  shared_preferences: 2.5.3
  provider: 6.1.5+1
  http: 1.5.0
  url_launcher: 6.3.1
  image_picker: 1.1.2
  intl: 0.20.2
  uuid: 4.5.1
```

## 📂 프로젝트 구조

```
lib/
├── main.dart                 # 앱 진입점
├── models/                   # 데이터 모델
│   ├── tour_color.dart
│   ├── user.dart
│   ├── host_profile.dart
│   ├── tour.dart
│   ├── booking.dart
│   └── review.dart
├── services/                 # 비즈니스 로직
│   └── database_service.dart
└── screens/                  # UI 화면
    ├── color_selection_screen.dart
    ├── tour_list_screen.dart
    ├── filter_screen.dart
    ├── tour_detail_new_screen.dart
    ├── payment_screen.dart
    └── review_screen.dart
```

## 🎯 핵심 기능

### 컬러 기반 투어 탐색
사용자의 감성과 취향에 맞는 투어를 컬러로 직관적으로 선택

### 호스트 등급 시스템
- 🌱 동네주민 (수수료 15%)
- ⭐ 반장 (수수료 13%)
- 💎 전문가 (수수료 11%)
- 👑 동네대장 (수수료 9%)

### 자동 보험 시스템
모든 예약에 여행자 상해보험 자동 가입
- 진단 치료비: 최대 1,000만원
- 입원 치료비: 1일 3만원 (최대 90일)
- 간병비: 1일 3만원 (최대 30일)

### 차량 옵션
- 도보/대중교통 (기본)
- 전문 차량 픽업 서비스 (추가 옵션)

## 📊 데이터베이스 스키마

### Users (사용자)
- userId, role, email, nameReal, phone, prefColor, createdAt

### Host_Profiles (호스트)
- hostId, grade, totalTours, carInfo, certifications, rating

### Tours (투어)
- tourId, hostId, mainColor, title, description, basePrice
- carOptionAvailable, location, durationMinutes

### Bookings (예약)
- bookingId, tourId, guestId, tourDate, participantCount
- useCar, totalAmount, insuranceStatus, status

### Reviews (리뷰)
- reviewId, bookingId, selectedColor, rating, comment, tags

## 🌐 라이브 데모

웹 버전: [https://5060-inxrapuxoropd9lcaettv-583b4d74.sandbox.novita.ai](https://5060-inxrapuxoropd9lcaettv-583b4d74.sandbox.novita.ai)

## 🤝 기여하기

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 라이선스

이 프로젝트는 MIT 라이선스를 따릅니다.

## 👥 개발팀

- **Project**: WithLocal
- **Platform**: Flutter Mobile & Web App
- **Contact**: soogroup

## 🙏 감사의 말

이 프로젝트는 K-컬처 심화에 따른 심층 체험 수요와 에어비앤비가 해결하지 못한 현지 이동/보험 틈새를 공략하기 위해 기획되었습니다.

---

**"여행에 로컬의 컬러를 더하다"** - WithLocal
