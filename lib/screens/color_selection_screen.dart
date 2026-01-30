import 'package:flutter/material.dart';
import '../models/tour_color.dart';
import 'tour_list_screen.dart';

/// 1단계: 컬러 칩 선택 화면
class ColorSelectionScreen extends StatelessWidget {
  const ColorSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WithLocal'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                '여행 취향을 컬러로\n선택하세요',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 40),
              
              // 2x3 그리드 컬러 버튼
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.2,
                  children: [
                    _buildColorButton(
                      context,
                      '열정적\n(레드)',
                      TourColor.red,
                      const Color(0xFFE53935),
                    ),
                    _buildColorButton(
                      context,
                      '차분한\n(블루)',
                      TourColor.blue,
                      const Color(0xFF1E88E5),
                    ),
                    _buildColorButton(
                      context,
                      '모험적인\n(오렌지)',
                      TourColor.orange,
                      const Color(0xFFFF6F00),
                    ),
                    _buildColorButton(
                      context,
                      '아늑한\n(퍼플)',
                      TourColor.purple,
                      const Color(0xFF8E24AA),
                    ),
                    _buildColorButton(
                      context,
                      '미식\n(노랑)',
                      TourColor.orange,
                      const Color(0xFFFFA000),
                    ),
                    _buildColorButton(
                      context,
                      '자연\n(그린)',
                      TourColor.green,
                      const Color(0xFF43A047),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // 내 취향 찾기 버튼
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TourListScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00B0FF),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    '내 취향 찾기',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildColorButton(
    BuildContext context,
    String label,
    TourColor tourColor,
    Color color,
  ) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TourListScreen(selectedColor: tourColor),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
