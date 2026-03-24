import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final double todayRevenue = 0;
  final double weekRevenue = 0;
  final double monthRevenue = 0;
  final int bookingsToday = 0;

  final List<double> revenueFlow = [0, 120, 80, 200, 60, 150, 90];
  final List<String> revenueLabels = ['TUE','WED','THU','FRI','SAT','SUN','MON'];

  final List<double> trafficData = [10, 40, 80, 120, 60, 90, 30, 50, 20];
  final List<String> trafficLabels = ['9AM','10AM','11AM','12PM','1PM','2PM','3PM','4PM','5PM'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: SafeArea(
        child: SingleChildScrollView(
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
                  Expanded(child: _StatCard(label: 'TODAY', badge: '—', value: '₹${todayRevenue.toStringAsFixed(0)}', sub: 'Revenue')),
                  const SizedBox(width: 10),
                  Expanded(child: _StatCard(label: 'WEEK', badge: '7d', value: '₹${weekRevenue.toStringAsFixed(0)}', sub: 'Revenue')),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: _StatCard(label: 'MONTH', badge: '30d', value: '₹${monthRevenue.toStringAsFixed(0)}', sub: 'Revenue')),
                  const SizedBox(width: 10),
                  Expanded(child: _StatCard(label: 'BOOKINGS', badge: '#', value: '$bookingsToday', sub: 'Today')),
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
          Text(
            sub,
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
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
  Widget build(BuildContext context) {
    final maxVal = values.reduce((a, b) => a > b ? a : b);
    const chartHeight = 120.0;
    const ySteps = 4;

    // generate y axis labels: 0, 25%, 50%, 75%, 100% of max
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
            children: yLabels.map((l) => Text(
              l,
              style: TextStyle(color: Colors.grey[600], fontSize: 8),
            )).toList(),
          ),
        ),

        const SizedBox(width: 6),

        // ── bars + x labels ──
        Expanded(
          child: Column(
            children: [
              SizedBox(
                height: chartHeight,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: values.map((v) {
                    final barH = maxVal == 0 ? 4.0 : (v / maxVal) * chartHeight;
                    return Container(
                      width: 18,
                      height: barH < 4 ? 4 : barH,
                      decoration: BoxDecoration(
                        color: barColor.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: labels.map((l) => Text(
                  l,
                  style: TextStyle(color: Colors.grey[600], fontSize: 8),
                )).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}