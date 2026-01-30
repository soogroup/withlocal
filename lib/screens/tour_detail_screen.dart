import 'package:flutter/material.dart';
import '../models/tour.dart';
import '../models/host_profile.dart';
import '../services/database_service.dart';
import '../models/booking.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'chat_screen.dart';

class TourDetailScreen extends StatefulWidget {
  final Tour tour;

  const TourDetailScreen({super.key, required this.tour});

  @override
  State<TourDetailScreen> createState() => _TourDetailScreenState();
}

class _TourDetailScreenState extends State<TourDetailScreen> {
  HostProfile? _hostProfile;
  bool _isLoading = true;
  int _participantCount = 1;
  bool _useCarOption = false;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _loadHostProfile();
  }

  Future<void> _loadHostProfile() async {
    final profile = await DatabaseService.getHostProfile(widget.tour.hostId);
    setState(() {
      _hostProfile = profile;
      _isLoading = false;
    });
  }

  int get _totalPrice {
    int total = widget.tour.basePrice * _participantCount;
    if (_useCarOption && widget.tour.carPriceExtra != null) {
      total += widget.tour.carPriceExtra!;
    }
    return total;
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]},',
    );
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: widget.tour.mainColor.color,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _createBooking() async {
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('날짜를 선택해주세요')),
      );
      return;
    }

    final booking = Booking(
      bookingId: const Uuid().v4(),
      tourId: widget.tour.tourId,
      guestId: 'demo_guest', // 실제로는 로그인된 사용자 ID
      tourDate: _selectedDate!,
      participantCount: _participantCount,
      useCar: _useCarOption,
      totalAmount: _totalPrice + 3000, // 보험료 포함
      insuranceStatus: true,
      status: BookingStatus.pending,
      createdAt: DateTime.now(),
    );

    await DatabaseService.createBooking(booking);

    if (!mounted) return;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('예약 완료'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('예약이 성공적으로 완료되었습니다!'),
            const SizedBox(height: 16),
            Text(
              '투어일: ${DateFormat('yyyy년 MM월 dd일').format(_selectedDate!)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('인원: $_participantCount명'),
            Text('총 금액: ${_formatPrice(_totalPrice + 3000)}원'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.verified_user, 
                    size: 16, 
                    color: Colors.green),
                  SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      '여행자 상해 보험 자동 가입 완료',
                      style: TextStyle(fontSize: 12, color: Colors.green),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                // 앱바 (이미지와 함께)
                SliverAppBar(
                  expandedHeight: 300,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      color: widget.tour.mainColor.color.withValues(alpha: 0.2),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.tour.mainColor.emoji,
                              style: const TextStyle(fontSize: 80),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                              child: Text(
                                widget.tour.mainColor.displayName,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: widget.tour.mainColor.color,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: () {},
                    ),
                  ],
                ),

                // 투어 상세 정보
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 투어 제목
                        Text(
                          widget.tour.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // 위치 & 시간
                        Row(
                          children: [
                            Icon(Icons.location_on, 
                              size: 20, 
                              color: widget.tour.mainColor.color),
                            const SizedBox(width: 4),
                            Text(
                              widget.tour.location,
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(width: 24),
                            Icon(Icons.access_time, 
                              size: 20, 
                              color: widget.tour.mainColor.color),
                            const SizedBox(width: 4),
                            Text(
                              '${widget.tour.durationMinutes}분',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // 호스트 정보
                        if (_hostProfile != null) ...[
                          const Text(
                            '호스트 정보',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundColor: widget.tour.mainColor.color,
                                    child: const Icon(
                                      Icons.person,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              _hostProfile!.grade.emoji,
                                              style: const TextStyle(fontSize: 20),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              _hostProfile!.grade.displayName,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '투어 ${_hostProfile!.totalTours}회 완료',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            const Icon(Icons.star, 
                                              size: 16, 
                                              color: Colors.amber),
                                            const SizedBox(width: 4),
                                            Text(
                                              _hostProfile!.rating.toStringAsFixed(1),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ChatScreen(
                                            tour: widget.tour,
                                            hostProfile: _hostProfile!,
                                          ),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: widget.tour.mainColor.color,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: const Text('채팅하기'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],

                        // 투어 설명
                        const Text(
                          '투어 소개',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          widget.tour.description,
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.6,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // 포함 사항
                        const Text(
                          '포함 사항',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...widget.tour.includedItems.map((item) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Icon(Icons.check_circle, 
                                size: 20, 
                                color: widget.tour.mainColor.color),
                              const SizedBox(width: 8),
                              Text(
                                item,
                                style: const TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                        )),
                        const SizedBox(height: 24),

                        // 보험 안내
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.green.shade200),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.verified_user, 
                                color: Colors.green, 
                                size: 24),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '안전 보장',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.green,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      '모든 투어에 여행자 상해 보험이 자동으로 포함됩니다',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 120), // 하단 예약 바 공간
                      ],
                    ),
                  ),
                ),
              ],
            ),
      
      // 하단 예약 바
      bottomSheet: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 인원 선택
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '참여 인원',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: _participantCount > 1
                            ? () => setState(() => _participantCount--)
                            : null,
                        icon: const Icon(Icons.remove_circle_outline),
                        color: widget.tour.mainColor.color,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '$_participantCount명',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: _participantCount < widget.tour.maxParticipants
                            ? () => setState(() => _participantCount++)
                            : null,
                        icon: const Icon(Icons.add_circle_outline),
                        color: widget.tour.mainColor.color,
                      ),
                    ],
                  ),
                ],
              ),
              
              // 차량 옵션
              if (widget.tour.carOptionAvailable) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6F00).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Checkbox(
                        value: _useCarOption,
                        onChanged: (value) => setState(() => _useCarOption = value!),
                        activeColor: const Color(0xFFFF6F00),
                      ),
                      const Icon(Icons.directions_car, 
                        color: Color(0xFFFF6F00)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '차량 픽업 서비스',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '+${_formatPrice(widget.tour.carPriceExtra!)}원',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFFFF6F00),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              
              const SizedBox(height: 16),
              
              // 날짜 선택 및 예약 버튼
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _selectDate,
                      icon: const Icon(Icons.calendar_today),
                      label: Text(
                        _selectedDate == null
                            ? '날짜 선택'
                            : DateFormat('MM/dd').format(_selectedDate!),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: widget.tour.mainColor.color),
                        foregroundColor: widget.tour.mainColor.color,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _createBooking,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.tour.mainColor.color,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            '예약하기',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${_formatPrice(_totalPrice + 3000)}원',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
