import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/auth_provider.dart';
import '../providers/payment_provider.dart';
import '../providers/user_provider.dart';
import '../services/storage_service.dart';
import '../widgets/stats_card.dart';
import '../widgets/revenue_chart.dart';
import '../widgets/network_test_widget.dart';
import 'payments_screen.dart';
import 'users_screen.dart';
import 'add_payment_screen.dart';
import 'login_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardHomeTab(),
    const PaymentsScreen(),
    const AddPaymentScreen(),
    const UsersScreen(),
  ];

  final List<String> _titles = [
    'Dashboard',
    'Transactions',
    'Add Payment',
    'Users',
  ];

  @override
  void initState() {
    super.initState();
    // Use a more robust approach to avoid setState during build
    Future.microtask(() => _initializeData());
  }

  void _initializeData() async {
    final authProvider = context.read<AuthProvider>();
    if (authProvider.isAuthenticated && authProvider.user != null) {
      final paymentProvider = context.read<PaymentProvider>();
      final userProvider = context.read<UserProvider>();
      
      // Load initial data (token is already set in singleton API service)
      await paymentProvider.loadDashboardStats();
      await paymentProvider.loadPayments();
      
      if (authProvider.user!.isAdmin) {
        await userProvider.loadUsers();
      }
    }
  }

  void _logout() async {
    final authProvider = context.read<AuthProvider>();
    await authProvider.logout();
    
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (!authProvider.isAuthenticated) {
          return const LoginScreen();
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(_titles[_selectedIndex]),
            backgroundColor: Colors.blue.shade600,
            foregroundColor: Colors.white,
            elevation: 0,
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Icon(Icons.person, color: Colors.white.withOpacity(0.9)),
                    const SizedBox(width: 8),
                    Text(
                      authProvider.user?.username ?? '',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      icon: const Icon(Icons.logout),
                      onPressed: _logout,
                      tooltip: 'Logout',
                    ),
                  ],
                ),
              ),
            ],
          ),
          body: _screens[_selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.blue.shade600,
            unselectedItemColor: Colors.grey,
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.dashboard),
                label: 'Dashboard',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.payment),
                label: 'Transactions',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.add_circle),
                label: 'Add Payment',
              ),
              if (authProvider.user?.isAdmin == true)
                const BottomNavigationBarItem(
                  icon: Icon(Icons.people),
                  label: 'Users',
                ),
            ],
          ),
        );
      },
    );
  }
}

class DashboardHomeTab extends StatelessWidget {
  const DashboardHomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Consumer<PaymentProvider>(
              builder: (context, paymentProvider, child) {
                final stats = paymentProvider.dashboardStats;
                
                // Debug information
                if (paymentProvider.isLoading) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(50.0),
                      child: Column(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Loading dashboard data...'),
                        ],
                      ),
                    ),
                  );
                }
                
                if (paymentProvider.error != null) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Icon(Icons.error, color: Colors.red, size: 48),
                          SizedBox(height: 16),
                          Text('Error: ${paymentProvider.error}'),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => paymentProvider.loadDashboardStats(),
                            child: Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                
                if (stats == null) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(50.0),
                      child: Column(
                        children: [
                          Icon(Icons.warning, color: Colors.orange, size: 48),
                          SizedBox(height: 16),
                          Text('No data available'),
                        ],
                      ),
                    ),
                  );
                }

                return Column(
                  children: [
                    // Stats Cards
                    LayoutBuilder(
                      builder: (context, constraints) {
                        // Use responsive grid based on screen width
                        int crossAxisCount = constraints.maxWidth > 600 ? 2 : 1;
                        double childAspectRatio = constraints.maxWidth > 600 ? 1.5 : 4.0; // Better ratio for mobile
                        
                        return GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 12, // Reduced spacing for mobile
                          childAspectRatio: childAspectRatio,
                          children: [
                            StatsCard(
                              title: 'Transactions Today',
                              value: stats.transactionsToday.toString(),
                              icon: Icons.today,
                              color: Colors.blue,
                            ),
                            StatsCard(
                              title: 'Revenue Today',
                              value: '\$${stats.revenueToday.toStringAsFixed(2)}',
                              icon: Icons.attach_money,
                              color: Colors.green,
                            ),
                            StatsCard(
                              title: 'This Week',
                              value: stats.transactionsThisWeek.toString(),
                              icon: Icons.date_range,
                              color: Colors.orange,
                            ),
                            StatsCard(
                              title: 'Failed Today',
                              value: stats.failedTransactionsToday.toString(),
                              icon: Icons.error,
                              color: Colors.red,
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    // Network Test Widget (for debugging)
                    const NetworkTestWidget(),
                    const SizedBox(height: 24),
                    // Revenue Chart
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Revenue Trend (Last 7 Days)',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            LayoutBuilder(
                              builder: (context, constraints) {
                                // Adjust chart height based on screen size
                                double chartHeight = constraints.maxWidth > 600 ? 280 : 220;
                                return SizedBox(
                                  height: chartHeight,
                                  child: RevenueChart(revenueTrend: stats.revenueTrend),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16), // Add bottom padding
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
