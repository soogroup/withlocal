/// 호스트 등급 (동네주민 → 반장 → 전문가 → 대장)
enum HostGrade {
  resident(15),   // 동네주민 - 수수료 15%
  leader(13),     // 반장 - 수수료 13%
  expert(11),     // 전문가 - 수수료 11%
  master(9);      // 대장 - 수수료 9%

  final int feePercent;
  const HostGrade(this.feePercent);

  String get displayName {
    switch (this) {
      case HostGrade.resident:
        return '동네주민';
      case HostGrade.leader:
        return '반장';
      case HostGrade.expert:
        return '전문가';
      case HostGrade.master:
        return '동네대장';
    }
  }
  
  String get emoji {
    switch (this) {
      case HostGrade.resident:
        return '🌱';
      case HostGrade.leader:
        return '⭐';
      case HostGrade.expert:
        return '💎';
      case HostGrade.master:
        return '👑';
    }
  }

  /// 등급 업그레이드 필요 투어 수
  int get nextGradeRequirement {
    switch (this) {
      case HostGrade.resident:
        return 10;  // 10개 완료하면 반장
      case HostGrade.leader:
        return 30;  // 30개 완료하면 전문가
      case HostGrade.expert:
        return 100; // 100개 완료하면 대장
      case HostGrade.master:
        return 0;   // 최고 등급
    }
  }
}

/// 호스트 프로필 모델
class HostProfile {
  final String hostId;
  final HostGrade grade;
  final int totalTours;
  final String? carInfo;  // 차량 모델 및 승차 인원
  final List<String> certifications;  // 보유 자격증
  final String introduction;  // 자기소개
  final double rating;  // 평균 별점
  final DateTime createdAt;

  HostProfile({
    required this.hostId,
    this.grade = HostGrade.resident,
    this.totalTours = 0,
    this.carInfo,
    this.certifications = const [],
    this.introduction = '',
    this.rating = 5.0,
    required this.createdAt,
  });

  /// 다음 등급까지 남은 투어 수
  int get toursUntilNextGrade {
    if (grade == HostGrade.master) return 0;
    return grade.nextGradeRequirement - totalTours;
  }

  /// 등급이 업그레이드되어야 하는지 확인
  bool get shouldUpgrade {
    return toursUntilNextGrade <= 0 && grade != HostGrade.master;
  }

  Map<String, dynamic> toJson() => {
        'hostId': hostId,
        'grade': grade.name,
        'totalTours': totalTours,
        'carInfo': carInfo,
        'certifications': certifications,
        'introduction': introduction,
        'rating': rating,
        'createdAt': createdAt.toIso8601String(),
      };

  factory HostProfile.fromJson(Map<String, dynamic> json) => HostProfile(
        hostId: json['hostId'] as String,
        grade: HostGrade.values.firstWhere((e) => e.name == json['grade']),
        totalTours: json['totalTours'] as int? ?? 0,
        carInfo: json['carInfo'] as String?,
        certifications: (json['certifications'] as List?)?.cast<String>() ?? [],
        introduction: json['introduction'] as String? ?? '',
        rating: (json['rating'] as num?)?.toDouble() ?? 5.0,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  HostProfile copyWith({
    String? hostId,
    HostGrade? grade,
    int? totalTours,
    String? carInfo,
    List<String>? certifications,
    String? introduction,
    double? rating,
    DateTime? createdAt,
  }) {
    return HostProfile(
      hostId: hostId ?? this.hostId,
      grade: grade ?? this.grade,
      totalTours: totalTours ?? this.totalTours,
      carInfo: carInfo ?? this.carInfo,
      certifications: certifications ?? this.certifications,
      introduction: introduction ?? this.introduction,
      rating: rating ?? this.rating,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
