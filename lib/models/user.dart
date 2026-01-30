import 'tour_color.dart';

/// 사용자 역할
enum UserRole {
  guest,  // 게스트 (여행자)
  host,   // 호스트 (현지 전문가)
}

/// 사용자 모델
class User {
  final String userId;
  final UserRole role;
  final String email;
  final String nameReal;
  final String? idNumberEnc;  // 보험용 주민번호/여권번호 (암호화)
  final String phone;
  final TourColor? prefColor;  // 선호 컬러
  final DateTime createdAt;

  User({
    required this.userId,
    required this.role,
    required this.email,
    required this.nameReal,
    this.idNumberEnc,
    required this.phone,
    this.prefColor,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'role': role.name,
        'email': email,
        'nameReal': nameReal,
        'idNumberEnc': idNumberEnc,
        'phone': phone,
        'prefColor': prefColor?.name,
        'createdAt': createdAt.toIso8601String(),
      };

  factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json['userId'] as String,
        role: UserRole.values.firstWhere((e) => e.name == json['role']),
        email: json['email'] as String,
        nameReal: json['nameReal'] as String,
        idNumberEnc: json['idNumberEnc'] as String?,
        phone: json['phone'] as String,
        prefColor: json['prefColor'] != null
            ? TourColor.values.firstWhere((e) => e.name == json['prefColor'])
            : null,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  User copyWith({
    String? userId,
    UserRole? role,
    String? email,
    String? nameReal,
    String? idNumberEnc,
    String? phone,
    TourColor? prefColor,
    DateTime? createdAt,
  }) {
    return User(
      userId: userId ?? this.userId,
      role: role ?? this.role,
      email: email ?? this.email,
      nameReal: nameReal ?? this.nameReal,
      idNumberEnc: idNumberEnc ?? this.idNumberEnc,
      phone: phone ?? this.phone,
      prefColor: prefColor ?? this.prefColor,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
