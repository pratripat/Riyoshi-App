import 'package:flutter/material.dart';
import '../models/dashboardModel.dart';
import '../services/dashboardServices.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late Future<DashboardData> _future;

  @override
  void initState() {
    super.initState();
    _future = DashboardService.fetchDashboard();
  }

  void _refresh() =>
      setState(() => _future = DashboardService.fetchDashboard());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: SafeArea(
        child: FutureBuilder<DashboardData>(
          future: _future,
          builder: (context, snapshot) {
            // ---- default/fallback values ----
            final d =
                snapshot.data ??
                DashboardData(
                  todayRevenue: 0,
                  todayCount: 0,
                  avgTicket: 0,
                  yesterdayRevenue: 0,
                  weekSales: 0,
                  monthSales: 0,
                  hourlyData: List.generate(9, (i) {
                    const labels = [
                      '9 AM',
                      '10 AM',
                      '11 AM',
                      '12 PM',
                      '1 PM',
                      '2 PM',
                      '3 PM',
                      '4 PM',
                      '5 PM',
                    ];
                    return HourlyData(time: labels[i], customers: 0);
                  }),
                  revenueData: [
                    'TUE',
                    'WED',
                    'THU',
                    'FRI',
                    'SAT',
                    'SUN',
                    'MON',
                  ].map((day) => RevenueData(day: day, rev: 0)).toList(),
                );

            final revenueFlow = d.revenueData
                .map((e) => e.rev.toDouble())
                .toList();
            final revenueLabels = d.revenueData
                .map((e) => e.day.toUpperCase())
                .toList();
            final trafficData = d.hourlyData
                .map((e) => e.customers.toDouble())
                .toList();
            final trafficLabels = d.hourlyData.map((e) => e.time).toList();

            return Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Dashboard',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Overview of your salon's performance.",
                        style: TextStyle(color: Colors.grey[500], fontSize: 13),
                      ),

                      const SizedBox(height: 24),

                      Row(
                        children: [
                          Expanded(
                            child: _StatCard(
                              label: 'TODAY',
                              badge: '—',
                              value: '₹${d.todayRevenue}',
                              sub: 'Revenue',
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _StatCard(
                              label: 'WEEK',
                              badge: '7d',
                              value: '₹${d.weekSales}',
                              sub: 'Revenue',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: _StatCard(
                              label: 'MONTH',
                              badge: '30d',
                              value: '₹${d.monthSales}',
                              sub: 'Revenue',
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _StatCard(
                              label: 'BOOKINGS',
                              badge: '#',
                              value: '${d.todayCount}',
                              sub: 'Today',
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      _ChartCard(
                        title: 'REVENUE FLOW',
                        subtitle: 'Weekly performance',
                        child: _BarChart(
                          values: revenueFlow,
                          labels: revenueLabels,
                          barColor: const Color(0xFF6C63FF),
                          yPrefix: '₹',
                        ),
                      ),

                      const SizedBox(height: 16),

                      _ChartCard(
                        title: 'TRAFFIC (9AM - 5PM)',
                        subtitle: 'Hourly bookings',
                        child: _BarChart(
                          values: trafficData,
                          labels: trafficLabels,
                          barColor: const Color(0xFF4A90E2),
                          yPrefix: '',
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),

                // ---- loading overlay ----
                if (snapshot.connectionState == ConnectionState.waiting)
                  Positioned(
                    top: 16,
                    right: 16,
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        color: Colors.purple[300],
                        strokeWidth: 2,
                      ),
                    ),
                  ),

                // ---- error indicator ----
                if (snapshot.hasError)
                  Positioned(
                    top: 16,
                    right: 16,
                    child: GestureDetector(
                      onTap: _refresh,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.red.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.wifi_off,
                              color: Colors.redAccent,
                              size: 12,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Retry',
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String badge;
  final String value;
  final String sub;

  const _StatCard({
    required this.label,
    required this.badge,
    required this.value,
    required this.sub,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF13131A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  badge,
                  style: const TextStyle(color: Colors.grey, fontSize: 10),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(sub, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        ],
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const _ChartCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF13131A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(color: Colors.grey[600], fontSize: 11),
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }
}

class _BarChart extends StatelessWidget {
  final List<double> values;
  final List<String> labels;
  final Color barColor;
  final String yPrefix;

  const _BarChart({
    required this.values,
    required this.labels,
    required this.barColor,
    required this.yPrefix,
  });

  @override
  @override
  Widget build(BuildContext context) {
    if (values.isEmpty) return const SizedBox();

    final maxVal = values.reduce((a, b) => a > b ? a : b);
    const chartHeight = 120.0;
    const ySteps = 4;

    final yLabels = List.generate(ySteps + 1, (i) {
      final val = (maxVal / ySteps) * i;
      return '$yPrefix${val.toStringAsFixed(0)}';
    }).reversed.toList();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // ── Y axis ──
        SizedBox(
          width: 36,
          height: chartHeight + 20,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: yLabels
                .map(
                  (l) => Text(
                    l,
                    style: TextStyle(color: Colors.grey[600], fontSize: 8),
                  ),
                )
                .toList(),
          ),
        ),

        const SizedBox(width: 6),

        // ── bars + x labels ──
        Expanded(
          child: Column(
            children: [
              SizedBox(
                height: chartHeight,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // dynamically size bars based on available width
                    final barWidth = (constraints.maxWidth / values.length) - 4;
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: values.map((v) {
                        // min height of 3 so bars always visible even at 0
                        final barH = maxVal == 0
                            ? 3.0
                            : ((v / maxVal) * chartHeight).clamp(
                                3.0,
                                chartHeight,
                              );
                        return Container(
                          width: barWidth.clamp(4.0, 24.0),
                          height: barH,
                          decoration: BoxDecoration(
                            color: maxVal == 0
                                ? barColor.withOpacity(
                                    0.3,
                                  ) // dimmed when all zero
                                : barColor.withOpacity(0.85),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              // x labels — clip to avoid overflow
              SizedBox(
                height: 16,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final itemWidth = constraints.maxWidth / labels.length;
                    return Row(
                      children: labels.map((l) {
                        return SizedBox(
                          width: itemWidth,
                          child: Text(
                            l,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 7,
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
