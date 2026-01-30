/// 예약 상태
enum BookingStatus {
  pending,    // 승인 대기
  confirmed,  // 확정
  completed,  // 완료
  cancelled,  // 취소
}

/// 예약 모델
class Booking {
  final String bookingId;
  final String tourId;
  final String guestId;
  final DateTime tourDate;
  final int participantCount;
  final bool useCar;
  final int totalAmount;  // 최종 결제 금액
  final bool insuranceStatus;  // 보험 가입 완료 여부
  final BookingStatus status;
  final DateTime createdAt;
  final DateTime? cancelledAt;
  final String? cancellationReason;

  Booking({
    required this.bookingId,
    required this.tourId,
    required this.guestId,
    required this.tourDate,
    required this.participantCount,
    this.useCar = false,
    required this.totalAmount,
    this.insuranceStatus = false,
    this.status = BookingStatus.pending,
    required this.createdAt,
    this.cancelledAt,
    this.cancellationReason,
  });

  /// 환불 가능 여부 및 환불율 계산
  /// 7일 전 100%, 3일 전 50%, 24시간 이내 환불 불가
  double get refundRate {
    final daysUntilTour = tourDate.difference(DateTime.now()).inDays;
    if (daysUntilTour >= 7) return 1.0;  // 100%
    if (daysUntilTour >= 3) return 0.5;  // 50%
    return 0.0;  // 환불 불가
  }

  bool get canCancel => refundRate > 0 && status != BookingStatus.cancelled;

  Map<String, dynamic> toJson() => {
        'bookingId': bookingId,
        'tourId': tourId,
        'guestId': guestId,
        'tourDate': tourDate.toIso8601String(),
        'participantCount': participantCount,
        'useCar': useCar,
        'totalAmount': totalAmount,
        'insuranceStatus': insuranceStatus,
        'status': status.name,
        'createdAt': createdAt.toIso8601String(),
        'cancelledAt': cancelledAt?.toIso8601String(),
        'cancellationReason': cancellationReason,
      };

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
        bookingId: json['bookingId'] as String,
        tourId: json['tourId'] as String,
        guestId: json['guestId'] as String,
        tourDate: DateTime.parse(json['tourDate'] as String),
        participantCount: json['participantCount'] as int,
        useCar: json['useCar'] as bool? ?? false,
        totalAmount: json['totalAmount'] as int,
        insuranceStatus: json['insuranceStatus'] as bool? ?? false,
        status: BookingStatus.values.firstWhere((e) => e.name == json['status']),
        createdAt: DateTime.parse(json['createdAt'] as String),
        cancelledAt: json['cancelledAt'] != null
            ? DateTime.parse(json['cancelledAt'] as String)
            : null,
        cancellationReason: json['cancellationReason'] as String?,
      );

  Booking copyWith({
    String? bookingId,
    String? tourId,
    String? guestId,
    DateTime? tourDate,
    int? participantCount,
    bool? useCar,
    int? totalAmount,
    bool? insuranceStatus,
    BookingStatus? status,
    DateTime? createdAt,
    DateTime? cancelledAt,
    String? cancellationReason,
  }) {
    return Booking(
      bookingId: bookingId ?? this.bookingId,
      tourId: tourId ?? this.tourId,
      guestId: guestId ?? this.guestId,
      tourDate: tourDate ?? this.tourDate,
      participantCount: participantCount ?? this.participantCount,
      useCar: useCar ?? this.useCar,
      totalAmount: totalAmount ?? this.totalAmount,
      insuranceStatus: insuranceStatus ?? this.insuranceStatus,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      cancellationReason: cancellationReason ?? this.cancellationReason,
    );
  }
}
