import 'package:flutter/material.dart';
import '../models/bookingsModel.dart';
import '../services/bookingsService.dart';
import 'newBookingSheet.dart';

class BookingsPage extends StatefulWidget {
  const BookingsPage({super.key});

  @override
  State<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> {
  DateTime _selectedDay = DateTime.now();
  final ScrollController _scrollController = ScrollController();
  List<Booking> _allBookings = [];
  bool _isLoading = true;
  String? _error;

  static const double hourHeight = 64.0;
  static const double startHour = 8.0;

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    try {
      final bookings = await BookingService.fetchAppointments();
      setState(() {
        _allBookings = bookings;
        _isLoading = false;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToNow());
    } catch (e) {
      setState(() {
        _error = '$e';
        _isLoading = false;
      });
    }
  }

  void _refresh() {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    _loadBookings();
  }

  void _scrollToNow() {
    final now = DateTime.now();
    final offset =
        ((now.hour + now.minute / 60.0) - startHour) * hourHeight - 100;
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        offset < 0 ? 0 : offset,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOut,
      );
    }
  }

  List<Booking> get _todaysBookings => _allBookings
      .where(
        (b) =>
            b.start.year == _selectedDay.year &&
            b.start.month == _selectedDay.month &&
            b.start.day == _selectedDay.day,
      )
      .toList();

  void _previousDay() => setState(
    () => _selectedDay = _selectedDay.subtract(const Duration(days: 1)),
  );
  void _nextDay() =>
      setState(() => _selectedDay = _selectedDay.add(const Duration(days: 1)));
  void _goToday() {
    setState(() => _selectedDay = DateTime.now());
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToNow());
  }

  String _formatHeader(DateTime d) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return '${days[d.weekday - 1]}, ${d.day} ${months[d.month - 1]} ${d.year}';
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bookings = _todaysBookings;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Salon Calendar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        builder: (_) => const NewBookingSheet(),
                      );
                      _refresh(); // refresh after new booking
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6C63FF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        '+ New Booking',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ── Nav ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _NavBtn(label: 'Today', onTap: _goToday),
                  const SizedBox(width: 8),
                  _NavBtn(label: '‹', onTap: _previousDay),
                  const SizedBox(width: 8),
                  _NavBtn(label: '›', onTap: _nextDay),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _formatHeader(_selectedDay),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6C63FF),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Day',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // ── booking count badge ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E2A),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.08)),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(
                            color: Color(0xFF6C63FF),
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          '${bookings.length} booking${bookings.length == 1 ? '' : 's'} today',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12,
                          ),
                        ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // ── Grid or error ──
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF6C63FF),
                      ),
                    )
                  : _error != null
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.redAccent,
                            size: 40,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _error!,
                            style: const TextStyle(color: Colors.white54),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: _refresh,
                            child: const Text(
                              'Retry',
                              style: TextStyle(color: Color(0xFF6C63FF)),
                            ),
                          ),
                        ],
                      ),
                    )
                  : _DayGrid(
                      bookings: bookings,
                      scrollController: _scrollController,
                      selectedDay: _selectedDay,
                      onBookingTap: (b) => _showBookingDetail(context, b),
                      hourHeight: hourHeight,
                      startHour: startHour,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBookingDetail(BuildContext context, Booking b) {
    final dateStr =
        '${b.start.day.toString().padLeft(2, '0')}-${b.start.month.toString().padLeft(2, '0')}-${b.start.year}';
    final timeStr = '${_fmtTime(b.start)} - ${_fmtTime(b.end)}';

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF13131A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'APPOINTMENT',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 11,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      b.customerName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    _StatusBadge(status: b.normalizedStatus),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E2A),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_month_outlined,
                    color: Color(0xFF6C63FF),
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TIME',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 10,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$dateStr • $timeStr',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.timer_outlined,
                              color: Colors.grey,
                              size: 13,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${b.durationMinutes} min duration',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Text(
              'SERVICE',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 10,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              b.service,
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),

            if (b.totalPrice != null) ...[
              const SizedBox(height: 16),
              Text(
                'TOTAL',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 10,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '₹${b.totalPrice}',
                style: const TextStyle(
                  color: Colors.green,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CUSTOMER',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 10,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        b.customerName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PHONE',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 10,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        b.phone.isEmpty ? '—' : b.phone,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey[700]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Reschedule',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3A1A1A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.redAccent, fontSize: 15),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _fmtTime(DateTime t) {
    final h = t.hour > 12
        ? t.hour - 12
        : t.hour == 0
        ? 12
        : t.hour;
    final m = t.minute.toString().padLeft(2, '0');
    final ampm = t.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $ampm';
  }
}

// ── keep all your existing _StatusBadge, _DayGrid, _NavBtn widgets exactly as they are ──

// ── Status Badge ─────────────────────────────────────────
class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    String label;

    switch (status) {
      case 'confirmed':
        bg = const Color(0xFF1A3A2A);
        fg = const Color(0xFF4CAF82);
        label = '● Confirmed';
        break;
      case 'pending':
        bg = const Color(0xFF3A2E1A);
        fg = const Color(0xFFFFB74D);
        label = '● Pending';
        break;
      case 'cancelled':
        bg = const Color(0xFF3A1A1A);
        fg = Colors.redAccent;
        label = '● Cancelled';
        break;
      default:
        bg = const Color(0xFF1E1E2A);
        fg = Colors.grey;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(color: fg, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }
}

// ── Day Grid ─────────────────────────────────────────────
class _DayGrid extends StatelessWidget {
  final List<Booking> bookings;
  final ScrollController scrollController;
  final DateTime selectedDay;
  final void Function(Booking) onBookingTap;
  final double hourHeight;
  final double startHour;

  const _DayGrid({
    required this.bookings,
    required this.scrollController,
    required this.selectedDay,
    required this.onBookingTap,
    required this.hourHeight,
    required this.startHour,
  });

  static const double endHour = 22.0;
  static const double timeColWidth = 68.0;

  @override
  Widget build(BuildContext context) {
    final totalHours = (endHour - startHour).toInt();
    final now = DateTime.now();
    final isToday =
        selectedDay.year == now.year &&
        selectedDay.month == now.month &&
        selectedDay.day == now.day;
    final nowOffset = isToday
        ? ((now.hour + now.minute / 60.0) - startHour) * hourHeight
        : -1.0;

    return SingleChildScrollView(
      controller: scrollController,
      child: SizedBox(
        height: totalHours * hourHeight,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── time labels ──
            SizedBox(
              width: timeColWidth,
              child: Stack(
                children: List.generate(totalHours, (i) {
                  final hour = (startHour + i).toInt();
                  final label = hour == 12
                      ? '12:00 PM'
                      : hour < 12
                      ? '$hour:00 AM'
                      : '${hour - 12}:00 PM';
                  return Positioned(
                    top: i * hourHeight + 4,
                    right: 8,
                    child: Text(
                      label,
                      style: TextStyle(color: Colors.grey[600], fontSize: 11),
                    ),
                  );
                }),
              ),
            ),

            // ── grid ──
            Expanded(
              child: Stack(
                children: [
                  // hour lines
                  Column(
                    children: List.generate(
                      totalHours,
                      (i) => Container(
                        height: hourHeight,
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: Colors.white.withOpacity(0.07),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // current time red line
                  if (nowOffset >= 0)
                    Positioned(
                      top: nowOffset,
                      left: 0,
                      right: 0,
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: Colors.redAccent,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 1.5,
                              color: Colors.redAccent,
                            ),
                          ),
                        ],
                      ),
                    ),

                  // booking blocks
                  ...bookings.map((b) {
                    final topOffset =
                        (b.start.hour + b.start.minute / 60.0 - startHour) *
                        hourHeight;
                    final blockHeight =
                        (b.end.difference(b.start).inMinutes / 60.0) *
                        hourHeight;

                    Color blockColor;
                    switch (b.status) {
                      case 'pending':
                        blockColor = const Color(0xFFE67E22);
                        break;
                      case 'cancelled':
                        blockColor = Colors.redAccent;
                        break;
                      default:
                        blockColor = const Color(0xFF4A6CF7);
                    }

                    return Positioned(
                      top: topOffset,
                      left: 4,
                      right: 4,
                      height: blockHeight < 32 ? 32 : blockHeight,
                      child: GestureDetector(
                        onTap: () => onBookingTap(b),
                        child: Container(
                          decoration: BoxDecoration(
                            color: blockColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                            border: Border(
                              left: BorderSide(color: blockColor, width: 3),
                            ),
                          ),
                          padding: const EdgeInsets.fromLTRB(10, 5, 8, 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${_fmtTime(b.start)} - ${_fmtTime(b.end)}',
                                style: TextStyle(
                                  color: blockColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              if (blockHeight > 38)
                                Text(
                                  b.customerName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              if (blockHeight > 52)
                                Text(
                                  b.service,
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 11,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _fmtTime(DateTime t) {
    final h = t.hour > 12
        ? t.hour - 12
        : t.hour == 0
        ? 12
        : t.hour;
    final m = t.minute.toString().padLeft(2, '0');
    final ampm = t.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $ampm';
  }
}

// ── Nav Button ───────────────────────────────────────────
class _NavBtn extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _NavBtn({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E2A),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 13),
        ),
      ),
    );
  }
}
