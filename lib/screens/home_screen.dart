import 'package:flutter/material.dart';
import '../models/tour.dart';
import '../models/tour_color.dart';

import '../services/database_service.dart';
import 'tour_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TourColor? _selectedColor;
  bool _showOnlyCarTours = false;
  List<Tour> _tours = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTours();
  }

  Future<void> _loadTours() async {
    setState(() => _isLoading = true);
    
    try {
      List<Tour> tours;
      
      if (_selectedColor != null) {
        tours = await DatabaseService.getToursByColor(_selectedColor!);
      } else {
        tours = await DatabaseService.getAllTours();
      }
      
      if (_showOnlyCarTours) {
        tours = tours.where((t) => t.carOptionAvailable).toList();
      }
      
      setState(() {
        _tours = tours;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('WithLocal', 
              style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFFFA000), // Warm Yellow
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                '로컬 투어',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // 컬러 칩 필터
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '어떤 경험을 원하시나요?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      _buildColorChip(null, '전체', Icons.apps),
                      const SizedBox(width: 12),
                      ...TourColor.values.map((color) => Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: _buildColorChip(
                          color,
                          color.displayName,
                          null,
                        ),
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // 차량 옵션 토글
          Container(
            color: Colors.grey.shade50,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                const Icon(Icons.directions_car, size: 20, color: Color(0xFFFF6F00)),
                const SizedBox(width: 8),
                const Text(
                  '차량 지원 투어만 보기',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                Switch(
                  value: _showOnlyCarTours,
                  onChanged: (value) {
                    setState(() => _showOnlyCarTours = value);
                    _loadTours();
                  },
                  activeTrackColor: const Color(0xFFFF6F00),
                ),
              ],
            ),
          ),

          // 투어 리스트
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _tours.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off, 
                              size: 64, 
                              color: Colors.grey.shade300),
                            const SizedBox(height: 16),
                            Text(
                              '해당 조건의 투어가 없습니다',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _tours.length,
                        itemBuilder: (context, index) {
                          return _buildTourCard(_tours[index]);
                        },
                      ),
          ),
        ],
      ),
      
      // 플로팅 버튼
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // 내 예약 화면으로 이동
        },
        icon: const Icon(Icons.bookmark),
        label: const Text('내 예약'),
      ),
    );
  }

  Widget _buildColorChip(TourColor? color, String label, IconData? icon) {
    final isSelected = _selectedColor == color;
    
    return GestureDetector(
      onTap: () {
        setState(() => _selectedColor = color);
        _loadTours();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected 
              ? (color?.color ?? const Color(0xFFFF6F00))
              : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: color?.color ?? const Color(0xFFFF6F00),
            width: 2,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: (color?.color ?? const Color(0xFFFF6F00)).withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ] : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              Icon(
                icon,
                size: 20,
                color: isSelected ? Colors.white : (color?.color ?? const Color(0xFFFF6F00)),
              )
            else
              Text(
                color!.emoji,
                style: const TextStyle(fontSize: 20),
              ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTourCard(Tour tour) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TourDetailScreen(tour: tour),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 투어 이미지 (placeholder)
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: tour.mainColor.color.withValues(alpha: 0.2),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          tour.mainColor.emoji,
                          style: const TextStyle(fontSize: 64),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          tour.mainColor.displayName,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: tour.mainColor.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (tour.carOptionAvailable)
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.directions_car, 
                              size: 16, 
                              color: Color(0xFFFF6F00)),
                            SizedBox(width: 4),
                            Text(
                              '차량 지원',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFF6F00),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            
            // 투어 정보
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tour.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        tour.location,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.access_time, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        '${tour.durationMinutes}분',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${tour.basePrice.toString().replaceAllMapped(
                          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
                          (match) => '${match[1]},',
                        )}원 /인',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF6F00),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TourDetailScreen(tour: tour),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: tour.mainColor.color,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                        ),
                        child: const Text('자세히 보기'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
