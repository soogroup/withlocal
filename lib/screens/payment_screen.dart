import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/tour.dart';
import '../models/host_profile.dart';
import '../models/booking.dart';
import '../services/database_service.dart';
import 'package:uuid/uuid.dart';
import 'review_screen.dart';

/// 5단계: 결제 및 보험 확인 화면
class PaymentScreen extends StatefulWidget {
  final Tour tour;
  final DateTime selectedDate;
  final HostProfile hostProfile;

  const PaymentScreen({
    super.key,
    required this.tour,
    required this.selectedDate,
    required this.hostProfile,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _participantCount = 2;

  int get _tourPrice => widget.tour.basePrice * _participantCount;
  int get _insurancePrice => 3000 * _participantCount;
  int get _totalPrice => _tourPrice + _insurancePrice;

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]},',
    );
  }

  Future<void> _completeBooking() async {
    final booking = Booking(
      bookingId: const Uuid().v4(),
      tourId: widget.tour.tourId,
      guestId: 'demo_guest',
      tourDate: widget.selectedDate,
      participantCount: _participantCount,
      useCar: false,
      totalAmount: _totalPrice,
      insuranceStatus: true,
      status: BookingStatus.confirmed,
      createdAt: DateTime.now(),
    );

    await DatabaseService.createBooking(booking);

    if (!mounted) return;

    // 리뷰 화면으로 이동
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ReviewScreen(
          tour: widget.tour,
          hostProfile: widget.hostProfile,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WithLocal'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      '예약 확인 및 결제',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // 예약 정보
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '호스트',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${widget.hostProfile.grade.emoji} ${widget.hostProfile.grade.displayName}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Divider(),
                          const SizedBox(height: 16),
                          const Text(
                            '투어일',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            DateFormat('yyyy.MM.dd').format(widget.selectedDate),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Divider(),
                          const SizedBox(height: 16),
                          const Text(
                            '인원',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              IconButton(
                                onPressed: _participantCount > 1
                                    ? () => setState(() => _participantCount--)
                                    : null,
                                icon: const Icon(Icons.remove_circle_outline),
                                color: const Color(0xFF00B0FF),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
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
                                color: const Color(0xFF00B0FF),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // 보험 정보
                    const Text(
                      '보험 정보',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.verified_user, 
                                color: Colors.green, 
                                size: 24),
                              SizedBox(width: 8),
                              Text(
                                '여행자 상해보험 가입 (1인당)',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _buildInsuranceRow('보장 항목', '입원 치료비'),
                          _buildInsuranceRow('진단 치료비', '최대 1,000만원'),
                          _buildInsuranceRow('입원 치료비', '1일 3만원 (최대 90일)'),
                          _buildInsuranceRow('간병비', '1일 3만원 (최대 30일)'),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // 가격 상세
                    const Text(
                      '금액 결제',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          _buildPriceRow(
                            '투어 가격',
                            '${_formatPrice(_tourPrice)}원',
                            false,
                          ),
                          const SizedBox(height: 12),
                          _buildPriceRow(
                            '보험료 (${_participantCount}인)',
                            '${_formatPrice(_insurancePrice)}원',
                            false,
                          ),
                          const SizedBox(height: 16),
                          const Divider(),
                          const SizedBox(height: 16),
                          _buildPriceRow(
                            '결제 금액',
                            '${_formatPrice(_totalPrice)}원',
                            true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // 하단 버튼
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _completeBooking,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00B0FF),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      '결제하기',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsuranceRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String price, bool isTotal) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          price,
          style: TextStyle(
            fontSize: isTotal ? 20 : 16,
            fontWeight: FontWeight.bold,
            color: isTotal ? const Color(0xFFFF6F00) : Colors.black,
          ),
        ),
      ],
    );
  }
}
