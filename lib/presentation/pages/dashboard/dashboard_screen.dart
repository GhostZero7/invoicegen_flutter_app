import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';
import 'package:invoicegen_flutter_app/presentation/bloc/auth/auth_bloc.dart';
import 'package:invoicegen_flutter_app/presentation/bloc/auth/auth_state.dart';
import 'package:invoicegen_flutter_app/presentation/pages/invoices/invoice_list_screen.dart';
import 'package:invoicegen_flutter_app/presentation/pages/clients/clients_list_screen.dart';
import 'package:invoicegen_flutter_app/presentation/pages/invoices/create_invoice_screen.dart';
import 'package:invoicegen_flutter_app/presentation/pages/profile/profile_screen.dart';
import 'package:invoicegen_flutter_app/presentation/pages/business/business_list_screen.dart';
import 'package:invoicegen_flutter_app/presentation/pages/products/products_list_screen.dart';
import 'package:invoicegen_flutter_app/presentation/riverpod/invoice_provider.dart';
import 'package:invoicegen_flutter_app/presentation/riverpod/business_provider.dart';
import 'package:invoicegen_flutter_app/core/utils/page_transitions.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late TabController _tabController;
  late PageController _pageController;

  final List<Widget> _screens = [
    const HomeTab(),
    const InvoiceListScreen(),
    const ClientsListScreen(),
    const ProductsListScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    _tabController.animateTo(index);
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _tabController.animateTo(index);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return BottomBar(
      child: _buildFloatingNavigationBar(isDark),
      borderRadius: BorderRadius.circular(30),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      showIcon: false,
      width: MediaQuery.of(context).size.width - 64,
      barColor: Colors.transparent,
      start: 2,
      end: 0,
      offset: 16,
      barAlignment: Alignment.bottomCenter,
      hideOnScroll: true,
      scrollOpposite: false,
      body: (context, controller) => Scaffold(
        backgroundColor: isDark ? const Color(0xFF0A0E27) : Colors.grey[50],
        body: SafeArea(
          child: PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            physics: const BouncingScrollPhysics(),
            children: _screens,
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingNavigationBar(bool isDark) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: isDark
            ? Colors.black.withOpacity(0.8)
            : Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(0, Icons.home_rounded, 'Home', isDark),
          _navItem(1, Icons.receipt_long_rounded, 'Invoices', isDark),
          _navItem(2, Icons.people_alt_rounded, 'Clients', isDark),
          _navItem(3, Icons.inventory_2_outlined, 'Products', isDark),
          _navItem(4, Icons.person_rounded, 'Profile', isDark),
        ],
      ),
    );
  }

  Widget _navItem(int index, IconData icon, String label, bool isDark) {
    final isActive = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: isActive
            ? BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.2),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: isActive
                  ? Colors.white
                  : (isDark ? Colors.grey.shade400 : Colors.grey.shade500),
            ),
            if (!isActive) ...[
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 9,
                  color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class HomeTab extends ConsumerWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final invoiceState = ref.watch(invoiceProvider);
    final invoices = invoiceState.invoices;

    // Calculate real stats
    double totalRevenue = 0;
    double outstanding = 0;
    double overdue = 0;
    final now = DateTime.now();

    for (var inv in invoices) {
      totalRevenue += inv.totalAmount;
      if (inv.status != 'PAID') {
        outstanding += inv.totalAmount;
        if (inv.dueDate.isBefore(now)) {
          overdue += inv.totalAmount;
        }
      }
    }

    // Mock profit as 80% for now since we don't track expenses
    double netProfit = totalRevenue * 0.8;

    return RefreshIndicator(
      onRefresh: () => ref.read(invoiceProvider.notifier).fetchInvoices(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, isDark),
            const SizedBox(height: 32),
            _buildHeroCard(context, isDark),
            const SizedBox(height: 32),
            _buildSectionHeader('Business Overview', () {}, isDark),
            const SizedBox(height: 16),
            _buildStatGrid(totalRevenue, netProfit, outstanding, overdue, isDark),
            const SizedBox(height: 32),
            _buildSectionHeader('Recent Invoices', () {}, isDark),
            const SizedBox(height: 16),
            if (invoices.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Center(
                  child: Text(
                    'No invoices yet.',
                    style: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                  ),
                ),
              )
            else
              _buildRecentInvoices(invoices.take(5).toList(), isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final name = (state is AuthAuthenticated)
            ? '${state.user.firstName} ${state.user.lastName}'
            : 'User';
        return Consumer(
          builder: (context, ref, child) {
            final businessState = ref.watch(businessProvider);
            final selectedBusiness = businessState.selectedBusiness;
            
            return Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.blue.shade100,
                  child: Text(
                    name[0].toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back,',
                        style: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade600, fontSize: 13),
                      ),
                      Text(
                        name,
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black87,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (selectedBusiness != null) ...[
                        const SizedBox(height: 2),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const BusinessListScreen(),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.business,
                                size: 12,
                                color: Colors.blue.shade400,
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  selectedBusiness.businessName,
                                  style: TextStyle(
                                    color: Colors.blue.shade400,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration.underline,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              const SizedBox(width: 2),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 8,
                                color: Colors.blue.shade400,
                              ),
                            ],
                          ),
                        ),
                      ] else ...[
                        const SizedBox(height: 2),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const BusinessListScreen(),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.business_outlined,
                                size: 12,
                                color: Colors.orange.shade400,
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  'Create business profile',
                                  style: TextStyle(
                                    color: Colors.orange.shade400,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration.underline,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              const SizedBox(width: 2),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 8,
                                color: Colors.orange.shade400,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.notifications_none_rounded,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  onPressed: () {},
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildHeroCard(BuildContext context, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1F3A) : Colors.white,
        borderRadius: BorderRadius.circular(32),
        gradient: isDark ? LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1A1F3A).withOpacity(0.8),
            const Color(0xFF1A1F3A),
          ],
        ) : null,
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.2) : Colors.black.withOpacity(0.05),
            blurRadius: 20,
            spreadRadius: 1,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          const Text(
            'Create New Invoice',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Send professional invoices to your clients in seconds.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              fontSize: 15,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2563EB).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: () {
                  context.pushSmooth(
                    const CreateInvoiceScreen(),
                    direction: SlideDirection.bottomToTop,
                  );
                },
                icon: const Icon(Icons.add, color: Colors.white, size: 22),
                label: const Text(
                  'New Invoice',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onTap, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: onTap,
          child: const Text('View All', style: TextStyle(color: Colors.blue)),
        ),
      ],
    );
  }

  Widget _buildStatGrid(
    double rev,
    double profit,
    double outstanding,
    double overdue,
    bool isDark,
  ) {
    final currencyFormat = NumberFormat.currency(symbol: '\$');
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.1,
      children: [
        _statCard(
          'Total Revenue',
          currencyFormat.format(rev),
          Icons.attach_money_rounded,
          '--%',
          Colors.blue,
          isDark,
        ),
        _statCard(
          'Net Profit',
          currencyFormat.format(profit),
          Icons.pie_chart_rounded,
          '--%',
          Colors.purple,
          isDark,
        ),
        _statCard(
          'Outstanding',
          currencyFormat.format(outstanding),
          Icons.assignment_rounded,
          '--%',
          Colors.orange,
          isDark,
        ),
        _statCard(
          'Overdue',
          currencyFormat.format(overdue),
          Icons.warning_amber_rounded,
          '--%',
          Colors.red,
          isDark,
        ),
      ],
    );
  }

  Widget _statCard(
    String label,
    String value,
    IconData icon,
    String trend,
    Color color,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1F3A) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade600, fontSize: 12),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentInvoices(List<dynamic> invoices, bool isDark) {
    return Column(
      children: invoices.map((inv) {
        final dateStr = DateFormat('MMM dd').format(inv.invoiceDate);
        final amountStr = NumberFormat.currency(
          symbol: '\$',
        ).format(inv.totalAmount);
        Color statusColor = Colors.orange;
        if (inv.status == 'PAID') statusColor = Colors.green;
        if (inv.status == 'DRAFT') statusColor = Colors.grey;

        return _invoiceItem(
          inv.invoiceNumber,
          inv.invoiceNumber,
          dateStr,
          amountStr,
          inv.status,
          statusColor,
          isDark,
        );
      }).toList(),
    );
  }

  Widget _invoiceItem(
    String client,
    String id,
    String date,
    String amount,
    String status,
    Color statusColor,
    bool isDark,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1F3A) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0A0E27) : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.business_rounded,
              color: Colors.blue,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  client,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Text(
                  '$id • $date',
                  style: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
