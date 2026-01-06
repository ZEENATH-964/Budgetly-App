import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import 'package:intl/intl.dart';

class AppUsageTracker extends WidgetsBindingObserver {
  static final AppUsageTracker _instance = AppUsageTracker._internal();
  factory AppUsageTracker() => _instance;
  AppUsageTracker._internal();

  DateTime? _sessionStartTime;
  Duration _totalUsageTime = Duration.zero;
  Timer? _timer;
  bool _isActive = true;

  // Keys for SharedPreferences
  static const String _totalTimeKey = 'total_usage_time';
  static const String _lastSavedDateKey = 'last_saved_date';
  static const String _dailyUsageKey = 'daily_usage_';
  static const String _weeklyUsageKey = 'weekly_usage_';
  static const String _monthlyUsageKey = 'monthly_usage_';

  Future<void> init() async {
    WidgetsBinding.instance.addObserver(this);
    await _loadTotalTime();
    _startSession();
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _endSession();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _isActive = true;
        _startSession();
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.inactive:
        _isActive = false;
        _endSession();
        break;
      case AppLifecycleState.hidden:
        _isActive = false;
        _endSession();
        break;
    }
  }

  void _startSession() {
    _sessionStartTime = DateTime.now();
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isActive && _sessionStartTime != null) {
        final sessionDuration = DateTime.now().difference(_sessionStartTime!);
        _saveTotalTime();
      }
    });
  }

  void _endSession() {
    if (_sessionStartTime != null) {
      final sessionDuration = DateTime.now().difference(_sessionStartTime!);
      _totalUsageTime += sessionDuration;
      _saveTotalTime();
      _sessionStartTime = null;
    }
    _timer?.cancel();
  }

  Future<void> _loadTotalTime() async {
    final prefs = await SharedPreferences.getInstance();
    final savedMilliseconds = prefs.getInt(_totalTimeKey) ?? 0;
    _totalUsageTime = Duration(milliseconds: savedMilliseconds);
  }

  Future<void> _saveTotalTime() async {
    final prefs = await SharedPreferences.getInstance();

    // Save total time
    await prefs.setInt(_totalTimeKey, _totalUsageTime.inMilliseconds);

    // Save daily usage
    final today = DateTime.now();
    final todayKey = _dailyUsageKey + _formatDate(today);
    final todayUsage = prefs.getInt(todayKey) ?? 0;
    await prefs.setInt(todayKey, todayUsage + 1000); // Add 1 second

    // Save weekly usage
    final weekKey = _weeklyUsageKey + _getWeekKey(today);
    final weekUsage = prefs.getInt(weekKey) ?? 0;
    await prefs.setInt(weekKey, weekUsage + 1000);

    // Save monthly usage
    final monthKey = _monthlyUsageKey + _getMonthKey(today);
    final monthUsage = prefs.getInt(monthKey) ?? 0;
    await prefs.setInt(monthKey, monthUsage + 1000);
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String _getWeekKey(DateTime date) {
    final weekStart = date.subtract(Duration(days: date.weekday - 1));
    return _formatDate(weekStart);
  }

  String _getMonthKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}';
  }

  Duration getCurrentSessionDuration() {
    if (_sessionStartTime != null && _isActive) {
      return DateTime.now().difference(_sessionStartTime!);
    }
    return Duration.zero;
  }

  Duration getTotalUsageTime() {
    return _totalUsageTime + getCurrentSessionDuration();
  }

  Future<Duration> getDailyUsage([DateTime? date]) async {
    final prefs = await SharedPreferences.getInstance();
    final targetDate = date ?? DateTime.now();
    final key = _dailyUsageKey + _formatDate(targetDate);
    final milliseconds = prefs.getInt(key) ?? 0;

    // Add current session if it's today
    if (_formatDate(targetDate) == _formatDate(DateTime.now())) {
      return Duration(milliseconds: milliseconds) + getCurrentSessionDuration();
    }

    return Duration(milliseconds: milliseconds);
  }

  Future<Duration> getWeeklyUsage() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();
    final weekKey = _weeklyUsageKey + _getWeekKey(today);
    final milliseconds = prefs.getInt(weekKey) ?? 0;
    return Duration(milliseconds: milliseconds) + getCurrentSessionDuration();
  }

  Future<Duration> getMonthlyUsage() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();
    final monthKey = _monthlyUsageKey + _getMonthKey(today);
    final milliseconds = prefs.getInt(monthKey) ?? 0;
    return Duration(milliseconds: milliseconds) + getCurrentSessionDuration();
  }

  Future<Map<String, Duration>> getLast7DaysUsage() async {
    final prefs = await SharedPreferences.getInstance();
    final usage = <String, Duration>{};

    for (int i = 0; i < 7; i++) {
      final date = DateTime.now().subtract(Duration(days: i));
      final key = _dailyUsageKey + _formatDate(date);
      final milliseconds = prefs.getInt(key) ?? 0;
      usage[_formatDate(date)] = Duration(milliseconds: milliseconds);
    }

    // Add current session to today
    final todayKey = _formatDate(DateTime.now());
    usage[todayKey] = usage[todayKey]! + getCurrentSessionDuration();

    return usage;
  }

  Future<void> resetUsageData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_totalTimeKey);
    _totalUsageTime = Duration.zero;
    _sessionStartTime = DateTime.now();
  }
}

class AppUsageStatsPage extends StatefulWidget {
  @override
  _AppUsageStatsPageState createState() => _AppUsageStatsPageState();
}

class _AppUsageStatsPageState extends State<AppUsageStatsPage> {
  final AppUsageTracker _tracker = AppUsageTracker();
  Duration _totalTime = Duration.zero;
  Duration _todayTime = Duration.zero;
  Duration _weekTime = Duration.zero;
  Duration _monthTime = Duration.zero;
  Map<String, Duration> _weeklyData = {};

  @override
  void initState() {
    super.initState();
    _loadUsageData();
    // Refresh every second
    Future.delayed(Duration.zero, () {
      if (mounted) {
        setState(() {});
      }
    });
  }

  Future<void> _loadUsageData() async {
    _totalTime = _tracker.getTotalUsageTime();
    _todayTime = await _tracker.getDailyUsage();
    _weekTime = await _tracker.getWeeklyUsage();
    _monthTime = await _tracker.getMonthlyUsage();
    _weeklyData = await _tracker.getLast7DaysUsage();

    if (mounted) {
      setState(() {});
    }
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
              Color(0xFF0008B4),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'App Usage Statistics',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Total Usage Card
                        _buildUsageCard(
                          title: 'Total App Usage',
                          duration: _totalTime,
                          icon: Icons.access_time,
                          color: const Color(0xFF667eea),
                          isMain: true,
                        ),
                        const SizedBox(height: 20),

                        // Usage Grid
                        Row(
                          children: [
                            Expanded(
                              child: _buildUsageCard(
                                title: 'Today',
                                duration: _todayTime,
                                icon: Icons.today,
                                color: const Color(0xFF30CB76),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildUsageCard(
                                title: 'This Week',
                                duration: _weekTime,
                                icon: Icons.date_range,
                                color: const Color(0xFFF31717),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildUsageCard(
                          title: 'This Month',
                          duration: _monthTime,
                          icon: Icons.calendar_month,
                          color: const Color(0xFF764ba2),
                        ),

                        const SizedBox(height: 32),

                        // Weekly Chart
                        const Text(
                          'Last 7 Days',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          height: 200,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: _buildWeeklyChart(),
                        ),

                        const SizedBox(height: 32),

                        // Reset Button
                        Center(
                          child: TextButton.icon(
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Reset Usage Data?'),
                                  content: const Text(
                                    'This will clear all usage statistics. This action cannot be undone.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text('Cancel'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                      ),
                                      child: const Text('Reset'),
                                    ),
                                  ],
                                ),
                              );

                              if (confirm == true) {
                                await _tracker.resetUsageData();
                                _loadUsageData();
                              }
                            },
                            icon: const Icon(Icons.refresh, color: Colors.red),
                            label: const Text(
                              'Reset Statistics',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildUsageCard({
    required String title,
    required Duration duration,
    required IconData icon,
    required Color color,
    bool isMain = false,
  }) {
    return Container(
      padding: EdgeInsets.all(isMain ? 24 : 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.8), color],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: isMain ? 24 : 20,
                ),
              ),
              if (isMain) ...[
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ],
          ),
          if (!isMain) ...[
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
          const SizedBox(height: 8),
          Text(
            _formatDuration(duration),
            style: TextStyle(
              color: Colors.white,
              fontSize: isMain ? 32 : 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyChart() {
    final sortedDays = _weeklyData.keys.toList()..sort();
    final values = sortedDays
        .map((day) => _weeklyData[day]!.inMinutes.toDouble())
        .toList();

    if (values.isEmpty) return const Center(child: Text('No data'));

    final maxValue = values.reduce((a, b) => a > b ? a : b);

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxValue > 0 ? maxValue * 1.2 : 10,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            // tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final dayStr = sortedDays[group.x.toInt()];
              final date = DateTime.parse(dayStr);
              final dayName = DateFormat('EEE').format(date);
              final duration = _weeklyData[dayStr]!;
              return BarTooltipItem(
                '$dayName\n${_formatDuration(duration)}',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= sortedDays.length) {
                  return const Text('');
                }
                final dayStr = sortedDays[value.toInt()];
                final date = DateTime.parse(dayStr);
                final dayName = DateFormat('E').format(date).substring(0, 1);
                return Text(
                  dayName,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                );
              },
              reservedSize: 30,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value == 0) return const Text('');
                return Text(
                  '${value.toInt()}m',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                );
              },
              reservedSize: 40,
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border(
            bottom: BorderSide(color: Colors.grey[300]!),
            left: BorderSide(color: Colors.grey[300]!),
          ),
        ),
        barGroups: List.generate(
          sortedDays.length,
          (index) => BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: values[index],
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF667eea),
                    const Color(0xFF764ba2),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
                width: 16,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                ),
              ),
            ],
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxValue > 0 ? maxValue / 4 : 2.5,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey[200]!,
              strokeWidth: 1,
            );
          },
        ),
      ),
    );
  }
}
