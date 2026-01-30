import 'package:flutter/material.dart';
import '../models/tour.dart';
import '../models/tour_color.dart';
import '../services/database_service.dart';
import 'filter_screen.dart';
import 'tour_detail_new_screen.dart';

/// 2단계: 투어 리스트 화면
class TourListScreen extends StatefulWidget {
  final TourColor? selectedColor;

  const TourListScreen({super.key, this.selectedColor});

  @override
  State<TourListScreen> createState() => _TourListScreenState();
}

class _TourListScreenState extends State<TourListScreen> {
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
      
      if (widget.selectedColor != null) {
        tours = await DatabaseService.getToursByColor(widget.selectedColor!);
      } else {
        tours = await DatabaseService.getAllTours();
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
        title: const Text('WithLocal'),
        actions: [
          TextButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FilterScreen(),
                ),
              );
              
              if (result != null && result is Map) {
                // 필터 적용 후 리로드
                _loadTours();
              }
            },
            child: const Text(
              '필터 ▼',
              style: TextStyle(
                color: Color(0xFF00B0FF),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
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
      
      // 하단 네비게이션
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF00B0FF),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '검색',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border),
            label: '저장',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: '프로필',
          ),
        ],
      ),
    );
  }

  Widget _buildTourCard(Tour tour) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TourDetailNewScreen(tour: tour),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 투어 이미지
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    tour.mainColor.color.withValues(alpha: 0.7),
                    tour.mainColor.color.withValues(alpha: 0.3),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      tour.mainColor.emoji,
                      style: const TextStyle(fontSize: 72),
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
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.directions_car, 
                              size: 16, 
                              color: Color(0xFFFF6F00)),
                            SizedBox(width: 4),
                            Text(
                              '차량',
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
                  // 타이틀
                  Text(
                    tour.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // 가격
                  Text(
                    '${tour.basePrice.toString().replaceAllMapped(
                      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
                      (match) => '${match[1]},',
                    )}원',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF6F00),
                    ),
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
