import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mybudget/features/auth/presentation/providers/auth_provider.dart';
import 'package:mybudget/features/jars/presentation/providers/jars_provider.dart';
import 'package:mybudget/features/jars/presentation/widgets/jar_item.dart';

class JarsTab extends StatefulWidget {
  const JarsTab({super.key});

  @override
  State<JarsTab> createState() => _JarsTabState();
}

class _JarsTabState extends State<JarsTab> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final jarsProvider = Provider.of<JarsProvider>(context, listen: false);
    if (authProvider.user?.id != null) {
      jarsProvider.fetchJars(authProvider.user!.id.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final jarsProvider = Provider.of<JarsProvider>(context);

    return Scaffold(
      body:
          jarsProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : jarsProvider.errorMessage != null
              ? Center(child: Text(jarsProvider.errorMessage!))
              : ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: jarsProvider.jars.length,
                itemBuilder: (context, index) {
                  return JarItem(jar: jarsProvider.jars[index]);
                },
              ),
    );
  }
}
