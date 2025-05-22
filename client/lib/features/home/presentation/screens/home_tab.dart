import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mybudget/features/auth/presentation/providers/auth_provider.dart';
import 'package:mybudget/features/jars/domain/entities/jar.dart';
import 'package:mybudget/features/jars/presentation/providers/jars_provider.dart';
import 'package:mybudget/features/home/presentation/providers/home_provider.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final homeProvider = Provider.of<HomeProvider>(context, listen: false);
      final jarsProvider = Provider.of<JarsProvider>(context, listen: false);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userId = authProvider.user?.id.toString();
      if (userId != null) {
        homeProvider.fetchFinancials(userId);
        jarsProvider.fetchJars(userId);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('User not logged in')));
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<HomeProvider, JarsProvider>(
      builder: (context, homeProvider, jarsProvider, child) {
        final authProvider = Provider.of<AuthProvider>(context);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Home'),
            backgroundColor: Theme.of(context).primaryColor,
            actions: [
              IconButton(
                icon: const Icon(Icons.person),
                onPressed: () {
                  // Điều hướng đến màn hình profile (nếu có)
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                homeProvider.isLoading || jarsProvider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : homeProvider.errorMessage != null ||
                        jarsProvider.errorMessage != null
                    ? Center(
                      child: Text(
                        homeProvider.errorMessage ??
                            jarsProvider.errorMessage ??
                            'Error loading data',
                      ),
                    )
                    : RefreshIndicator(
                      onRefresh: () async {
                        final userId = authProvider.user?.id.toString();
                        if (userId != null) {
                          await homeProvider.fetchFinancials(userId);
                          await jarsProvider.fetchJars(userId);
                        }
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Total Balance',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      '₫${homeProvider.financialSummary.totalBalance.toStringAsFixed(1)}',
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: CircularProgressIndicator(
                                    value:
                                        homeProvider.financialSummary.income > 0
                                            ? homeProvider
                                                    .financialSummary
                                                    .totalBalance /
                                                homeProvider
                                                    .financialSummary
                                                    .income
                                            : 0.0,
                                    backgroundColor: Colors.grey[300],
                                    color: Colors.teal,
                                    strokeWidth: 6,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  const Text(
                                    'Income',
                                    style: TextStyle(color: Colors.teal),
                                  ),
                                  Text(
                                    '₫${homeProvider.financialSummary.income.toStringAsFixed(1)}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.teal,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  const Text(
                                    'Expense',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  Text(
                                    '₫${homeProvider.financialSummary.expense.toStringAsFixed(1)}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child:
                                jarsProvider.jars.isEmpty
                                    ? const Center(
                                      child: Text('No jars available'),
                                    )
                                    : ListView.builder(
                                      itemCount: jarsProvider.jars.length,
                                      itemBuilder: (context, index) {
                                        final jar = jarsProvider.jars[index];
                                        final amount = (homeProvider
                                                    .financialSummary
                                                    .income *
                                                jar.percentage /
                                                100)
                                            .toStringAsFixed(1);
                                        return Card(
                                          margin: const EdgeInsets.symmetric(
                                            vertical: 8.0,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          color: Colors.white.withOpacity(0.9),
                                          child: ListTile(
                                            leading: Image.asset(
                                              'assets/icons/jar_icon.png',
                                              height: 40,
                                              width: 40,
                                              errorBuilder: (
                                                context,
                                                error,
                                                stackTrace,
                                              ) {
                                                print(
                                                  'Error loading jar_icon.png: $error',
                                                );
                                                return const Icon(
                                                  Icons.error,
                                                  size: 40,
                                                  color: Colors.red,
                                                );
                                              },
                                            ),
                                            title: Text(
                                              jar.name,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.teal,
                                              ),
                                            ),
                                            subtitle: Text(
                                              '${(jar.percentage).toStringAsFixed(0)}% of your Income',
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            trailing: Text(
                                              '₫$amount',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.teal,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                          ),
                        ],
                      ),
                    ),
          ),
        );
      },
    );
  }
}
