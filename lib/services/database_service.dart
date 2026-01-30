import 'package:hive_flutter/hive_flutter.dart';
import '../models/user.dart';
import '../models/host_profile.dart';
import '../models/tour.dart';
import '../models/booking.dart';
import '../models/tour_color.dart';

/// 로컬 데이터베이스 서비스
class DatabaseService {
  static const String usersBox = 'users';
  static const String hostsBox = 'hosts';
  static const String toursBox = 'tours';
  static const String bookingsBox = 'bookings';
  static const String reviewsBox = 'reviews';

  /// Hive 초기화
  static Future<void> initialize() async {
    await Hive.initFlutter();
    
    // Box 열기
    await Hive.openBox<Map>(usersBox);
    await Hive.openBox<Map>(hostsBox);
    await Hive.openBox<Map>(toursBox);
    await Hive.openBox<Map>(bookingsBox);
    await Hive.openBox<Map>(reviewsBox);
  }

  /// 샘플 데이터 생성
  static Future<void> seedSampleData() async {
    final usersHive = Hive.box<Map>(usersBox);
    final hostsHive = Hive.box<Map>(hostsBox);
    final toursHive = Hive.box<Map>(toursBox);

    // 이미 데이터가 있으면 건너뛰기
    if (toursHive.isNotEmpty) return;

    // 샘플 호스트 10명 생성
    final hosts = <HostProfile>[];
    for (int i = 0; i < 10; i++) {
      final hostId = 'host_$i';
      
      // 게스트 계정도 함께 생성
      final user = User(
        userId: hostId,
        role: UserRole.host,
        email: 'host$i@withlocal.kr',
        nameReal: _getHostName(i),
        phone: '010-${1000 + i * 111}-${2000 + i * 222}',
        prefColor: TourColor.values[i % 5],
        createdAt: DateTime.now().subtract(Duration(days: 30 - i)),
      );
      await usersHive.put(hostId, user.toJson());

      // 호스트 프로필 생성
      final host = HostProfile(
        hostId: hostId,
        grade: i < 2 ? HostGrade.master : (i < 5 ? HostGrade.expert : HostGrade.resident),
        totalTours: i < 2 ? 150 : (i < 5 ? 50 : 5),
        carInfo: i % 3 == 0 ? '현대 아반떼 (4인승)' : null,
        certifications: i % 2 == 0 ? ['관광통역안내사'] : [],
        introduction: _getHostIntroduction(i),
        rating: 4.5 + (i % 5) * 0.1,
        createdAt: DateTime.now().subtract(Duration(days: 30 - i)),
      );
      hosts.add(host);
      await hostsHive.put(hostId, host.toJson());
    }

    // 샘플 투어 30개 생성
    final tours = <Tour>[];
    for (int i = 0; i < 30; i++) {
      final hostIndex = i % 10;
      final colorIndex = i % 5;
      
      final tour = Tour(
        tourId: 'tour_$i',
        hostId: 'host_$hostIndex',
        mainColor: TourColor.values[colorIndex],
        title: _getTourTitle(colorIndex, i),
        description: _getTourDescription(colorIndex, i),
        basePrice: 30000 + (i * 5000),
        carOptionAvailable: hosts[hostIndex].carInfo != null,
        carPriceExtra: hosts[hostIndex].carInfo != null ? 20000 : null,
        location: _getTourLocation(i),
        durationMinutes: 120 + (i % 4) * 30,
        maxParticipants: 4 + (i % 3),
        imageUrls: [],
        includedItems: _getTourIncludes(colorIndex),
        createdAt: DateTime.now().subtract(Duration(days: 20 - (i ~/ 2))),
      );
      tours.add(tour);
      await toursHive.put(tour.tourId, tour.toJson());
    }
  }

  static String _getHostName(int index) {
    const names = ['김서울', '이부산', '박제주', '정강릉', '최경주', 
                   '장전주', '윤여수', '임속초', '한남해', '오춘천'];
    return names[index % names.length];
  }

  static String _getHostIntroduction(int index) {
    const intros = [
      '서울 토박이로 숨은 맛집과 핫플레이스를 소개합니다!',
      '부산 바다를 사랑하는 현지인이 안내하는 특별한 여행',
      '제주 자연을 온몸으로 느낄 수 있는 힐링 투어',
      '강릉의 바다와 커피, 그리고 낭만을 함께 나눠요',
      '경주 천년 역사를 재미있게 풀어드립니다',
      '전주 한옥마을의 진짜 매력을 보여드려요',
      '여수 밤바다의 아름다움을 함께 감상해요',
      '속초 해산물 맛집 투어의 전문가입니다',
      '남해 바닷가 드라이브 코스를 안내합니다',
      '춘천 호수와 닭갈비의 조화를 경험하세요',
    ];
    return intros[index % intros.length];
  }

  static String _getTourTitle(int colorIndex, int tourIndex) {
    final titles = {
      0: [ // Red
        '홍대 밤 문화 체험 투어',
        '이태원 글로벌 핫플 탐방',
        '강남 K-팝 성지순례',
      ],
      1: [ // Green
        '북한산 힐링 트레킹',
        '한강공원 자전거 라이딩',
        '남산 서울타워 산책',
      ],
      2: [ // Purple
        '경복궁 야간 투어',
        '인사동 전통문화 체험',
        '북촌 한옥마을 산책',
      ],
      3: [ // Blue
        '한강 수상스키 체험',
        '서핑 입문 레슨',
        '패러글라이딩 체험',
      ],
      4: [ // Orange
        '광장시장 먹방 투어',
        '망원동 핫플 맛집 탐방',
        '성수동 카페 투어',
      ],
    };
    return titles[colorIndex]![tourIndex % 3];
  }

  static String _getTourDescription(int colorIndex, int tourIndex) {
    final descriptions = {
      0: '열정적인 서울의 밤 문화를 경험하고, 현지인만 아는 숨은 명소를 방문합니다.',
      1: '자연 속에서 힐링하며 도심 속 녹지 공간의 매력을 발견합니다.',
      2: '한국의 전통 문화와 역사를 깊이 있게 체험하는 시간입니다.',
      3: '스릴 넘치는 레저 활동으로 잊지 못할 추억을 만들어보세요.',
      4: '현지인이 사랑하는 진짜 맛집을 찾아 떠나는 미식 여행입니다.',
    };
    return descriptions[colorIndex]!;
  }

  static String _getTourLocation(int index) {
    const locations = [
      '홍대입구', '이태원', '강남역', '북한산', '여의도',
      '경복궁', '인사동', '북촌', '양양', '제주도',
    ];
    return locations[index % locations.length];
  }

  static List<String> _getTourIncludes(int colorIndex) {
    final includes = {
      0: ['현지 가이드', '클럽 입장권', '웰컴 드링크'],
      1: ['전문 가이드', '안전 장비', '생수 제공'],
      2: ['문화해설사', '입장료', '전통차 체험'],
      3: ['전문 강사', '장비 대여', '보험 포함'],
      4: ['미식 가이드', '시식 5곳', '음료 제공'],
    };
    return includes[colorIndex]!;
  }

  // CRUD 메서드들
  static Future<List<Tour>> getAllTours() async {
    final box = Hive.box<Map>(toursBox);
    return box.values
        .map((json) => Tour.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }

  static Future<List<Tour>> getToursByColor(TourColor color) async {
    final tours = await getAllTours();
    return tours.where((tour) => tour.mainColor == color).toList();
  }

  static Future<List<Tour>> getToursWithCar() async {
    final tours = await getAllTours();
    return tours.where((tour) => tour.carOptionAvailable).toList();
  }

  static Future<Tour?> getTourById(String tourId) async {
    final box = Hive.box<Map>(toursBox);
    final json = box.get(tourId);
    return json != null ? Tour.fromJson(Map<String, dynamic>.from(json)) : null;
  }

  static Future<HostProfile?> getHostProfile(String hostId) async {
    final box = Hive.box<Map>(hostsBox);
    final json = box.get(hostId);
    return json != null ? HostProfile.fromJson(Map<String, dynamic>.from(json)) : null;
  }

  static Future<void> createBooking(Booking booking) async {
    final box = Hive.box<Map>(bookingsBox);
    await box.put(booking.bookingId, booking.toJson());
  }

  static Future<List<Booking>> getUserBookings(String userId) async {
    final box = Hive.box<Map>(bookingsBox);
    return box.values
        .map((json) => Booking.fromJson(Map<String, dynamic>.from(json)))
        .where((booking) => booking.guestId == userId)
        .toList();
  }
}
