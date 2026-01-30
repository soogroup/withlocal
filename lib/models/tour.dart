import 'tour_color.dart';

/// 투어 상품 모델
class Tour {
  final String tourId;
  final String hostId;
  final TourColor mainColor;
  final String title;
  final String description;
  final int basePrice;  // 기본 인당 가격 (원)
  final bool carOptionAvailable;  // 차량 지원 여부
  final int? carPriceExtra;  // 차량 선택 시 추가 비용
  final String location;  // 투어 위치
  final int durationMinutes;  // 투어 소요 시간 (분)
  final int maxParticipants;  // 최대 참여 인원
  final List<String> imageUrls;  // 투어 이미지
  final List<String> includedItems;  // 포함 사항
  final DateTime createdAt;
  final bool isActive;  // 활성 상태

  Tour({
    required this.tourId,
    required this.hostId,
    required this.mainColor,
    required this.title,
    required this.description,
    required this.basePrice,
    this.carOptionAvailable = false,
    this.carPriceExtra,
    required this.location,
    required this.durationMinutes,
    this.maxParticipants = 4,
    this.imageUrls = const [],
    this.includedItems = const [],
    required this.createdAt,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() => {
        'tourId': tourId,
        'hostId': hostId,
        'mainColor': mainColor.name,
        'title': title,
        'description': description,
        'basePrice': basePrice,
        'carOptionAvailable': carOptionAvailable,
        'carPriceExtra': carPriceExtra,
        'location': location,
        'durationMinutes': durationMinutes,
        'maxParticipants': maxParticipants,
        'imageUrls': imageUrls,
        'includedItems': includedItems,
        'createdAt': createdAt.toIso8601String(),
        'isActive': isActive,
      };

  factory Tour.fromJson(Map<String, dynamic> json) => Tour(
        tourId: json['tourId'] as String,
        hostId: json['hostId'] as String,
        mainColor: TourColor.values.firstWhere((e) => e.name == json['mainColor']),
        title: json['title'] as String,
        description: json['description'] as String,
        basePrice: json['basePrice'] as int,
        carOptionAvailable: json['carOptionAvailable'] as bool? ?? false,
        carPriceExtra: json['carPriceExtra'] as int?,
        location: json['location'] as String,
        durationMinutes: json['durationMinutes'] as int,
        maxParticipants: json['maxParticipants'] as int? ?? 4,
        imageUrls: (json['imageUrls'] as List?)?.cast<String>() ?? [],
        includedItems: (json['includedItems'] as List?)?.cast<String>() ?? [],
        createdAt: DateTime.parse(json['createdAt'] as String),
        isActive: json['isActive'] as bool? ?? true,
      );

  Tour copyWith({
    String? tourId,
    String? hostId,
    TourColor? mainColor,
    String? title,
    String? description,
    int? basePrice,
    bool? carOptionAvailable,
    int? carPriceExtra,
    String? location,
    int? durationMinutes,
    int? maxParticipants,
    List<String>? imageUrls,
    List<String>? includedItems,
    DateTime? createdAt,
    bool? isActive,
  }) {
    return Tour(
      tourId: tourId ?? this.tourId,
      hostId: hostId ?? this.hostId,
      mainColor: mainColor ?? this.mainColor,
      title: title ?? this.title,
      description: description ?? this.description,
      basePrice: basePrice ?? this.basePrice,
      carOptionAvailable: carOptionAvailable ?? this.carOptionAvailable,
      carPriceExtra: carPriceExtra ?? this.carPriceExtra,
      location: location ?? this.location,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      maxParticipants: maxParticipants ?? this.maxParticipants,
      imageUrls: imageUrls ?? this.imageUrls,
      includedItems: includedItems ?? this.includedItems,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }
}
