import 'package:flutter/material.dart';

/// WithLocal의 5가지 투어 컬러 카테고리
enum TourColor {
  red,      // 열정적인 체험
  green,    // 자연/힐링
  purple,   // 예술/문화
  blue,     // 레저/스포츠
  orange;   // 미식/로컬푸드

  String get displayName {
    switch (this) {
      case TourColor.red:
        return '열정 레드';
      case TourColor.green:
        return '힐링 그린';
      case TourColor.purple:
        return '문화 퍼플';
      case TourColor.blue:
        return '레저 블루';
      case TourColor.orange:
        return '미식 오렌지';
    }
  }

  Color get color {
    switch (this) {
      case TourColor.red:
        return const Color(0xFFE53935);
      case TourColor.green:
        return const Color(0xFF43A047);
      case TourColor.purple:
        return const Color(0xFF8E24AA);
      case TourColor.blue:
        return const Color(0xFF1E88E5);
      case TourColor.orange:
        return const Color(0xFFFF6F00);
    }
  }

  String get emoji {
    switch (this) {
      case TourColor.red:
        return '🔥';
      case TourColor.green:
        return '🌿';
      case TourColor.purple:
        return '🎨';
      case TourColor.blue:
        return '🏄';
      case TourColor.orange:
        return '🍜';
    }
  }
}
