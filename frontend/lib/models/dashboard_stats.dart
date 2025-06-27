class DashboardStats {
  final int transactionsToday;
  final int transactionsThisWeek;
  final double revenueToday;
  final double revenueThisWeek;
  final int failedTransactionsToday;
  final List<RevenueTrend> revenueTrend;

  DashboardStats({
    required this.transactionsToday,
    required this.transactionsThisWeek,
    required this.revenueToday,
    required this.revenueThisWeek,
    required this.failedTransactionsToday,
    required this.revenueTrend,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      transactionsToday: json['transactionsToday'] ?? 0,
      transactionsThisWeek: json['transactionsThisWeek'] ?? 0,
      revenueToday: (json['revenueToday'] ?? 0).toDouble(),
      revenueThisWeek: (json['revenueThisWeek'] ?? 0).toDouble(),
      failedTransactionsToday: json['failedTransactionsToday'] ?? 0,
      revenueTrend: (json['revenueTrend'] as List<dynamic>?)
              ?.map((item) => RevenueTrend.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class RevenueTrend {
  final String date;
  final double revenue;
  final int count;

  RevenueTrend({
    required this.date,
    required this.revenue,
    required this.count,
  });

  factory RevenueTrend.fromJson(Map<String, dynamic> json) {
    return RevenueTrend(
      date: json['_id'] ?? '',
      revenue: (json['revenue'] ?? 0).toDouble(),
      count: json['count'] ?? 0,
    );
  }
}
