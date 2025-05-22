import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mybudget/features/auth/presentation/providers/auth_provider.dart';
import 'package:mybudget/features/jars/domain/entities/jar.dart';
import 'package:mybudget/features/jars/presentation/providers/jars_provider.dart';

class JarsSettingTab extends StatefulWidget {
  const JarsSettingTab({super.key});

  @override
  _JarsSettingTabState createState() => _JarsSettingTabState();
}

class _JarsSettingTabState extends State<JarsSettingTab> {
  bool isEditing = false;
  bool isSaving = false;
  List<Map<String, dynamic>> editedJars = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final jarsProvider = Provider.of<JarsProvider>(context, listen: false);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userId = authProvider.user?.id.toString();
      if (userId != null && jarsProvider.jars.isEmpty) {
        jarsProvider.fetchJars(userId);
      }
    });
  }

  Future<void> toggleEditMode(JarsProvider jarsProvider) async {
    if (isEditing) {
      setState(() {
        isEditing = false;
        isSaving = true; // Hiển thị loading khi lưu
      });

      // Lưu các thay đổi khi thoát chế độ chỉnh sửa
      for (var jar in editedJars) {
        final jarId = jar['id'] as int;
        final newPercentage = jar['percentage'] as double;
        print('Saving jar $jarId with percentage $newPercentage');
        await jarsProvider.updateJarPercentage(jarId, newPercentage);
      }
      // Làm mới danh sách
      final userId =
          Provider.of<AuthProvider>(context, listen: false).user?.id.toString();
      if (userId != null) {
        print('Fetching jars for user $userId');
        await jarsProvider.fetchJars(userId);
      }

      setState(() {
        isSaving = false; // Ẩn loading
      });

      // Hiển thị thông báo nếu có lỗi
      if (jarsProvider.errorMessage != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(jarsProvider.errorMessage!)));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Changes saved successfully')),
        );
      }
      editedJars.clear();
    } else {
      setState(() {
        isEditing = true;
        // Khởi tạo danh sách jars để chỉnh sửa
        editedJars = List.from(
          jarsProvider.jars.map(
            (jar) => {
              'id': jar.id,
              'name': jar.name,
              'percentage': jar.percentage,
            },
          ),
        );
      });
    }
  }

  void adjustPercentage(int index, bool increase) {
    if (!isEditing) return; // Ngăn gọi khi không trong chế độ chỉnh sửa
    setState(() {
      final currentPercentage = editedJars[index]['percentage'] as double;
      final newPercentage =
          increase ? currentPercentage + 1 : currentPercentage - 1;

      // Không cho phép giảm dưới 0
      if (newPercentage < 0) return;

      // Kiểm tra tổng trước khi tăng
      final totalPercentage = editedJars.asMap().entries.fold<double>(0, (
        sum,
        entry,
      ) {
        if (entry.key == index) {
          return sum + newPercentage;
        }
        return sum + (entry.value['percentage'] as double);
      });

      if (totalPercentage > 100) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Total percentage cannot exceed 100%')),
        );
        return;
      }

      editedJars[index]['percentage'] = newPercentage;
      print(
        'Adjusted percentage for jar $index to $newPercentage, total: $totalPercentage%',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final jarsProvider = Provider.of<JarsProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jars Settings'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      'assets/icons/jar_icon.png',
                      height: 80,
                      width: 80,
                      errorBuilder: (context, error, stackTrace) {
                        print('Error loading jar_icon.png: $error');
                        return const Icon(
                          Icons.error,
                          size: 80,
                          color: Colors.red,
                        );
                      },
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Total Jar Value',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        Text(
                          isEditing
                              ? '${editedJars.map((jar) => jar['percentage'] as double).reduce((a, b) => a + b).toStringAsFixed(2)}%'
                              : jarsProvider.jars.isEmpty
                              ? '0.00%'
                              : '${jarsProvider.jars.map((jar) => jar.percentage).reduce((a, b) => a + b).toStringAsFixed(2)}%',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color:
                                (isEditing &&
                                        editedJars
                                                .map(
                                                  (jar) =>
                                                      jar['percentage']
                                                          as double,
                                                )
                                                .reduce((a, b) => a + b) >
                                            100)
                                    ? Colors.red
                                    : Colors.teal,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed:
                          isSaving
                              ? null
                              : () {
                                if (jarsProvider.jars.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('No jars to edit'),
                                    ),
                                  );
                                  return;
                                }
                                toggleEditMode(jarsProvider);
                              },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal[100],
                        foregroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(isEditing ? 'Save' : 'Edit Jars'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child:
                      jarsProvider.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : jarsProvider.errorMessage != null
                          ? Center(child: Text(jarsProvider.errorMessage!))
                          : jarsProvider.jars.isEmpty
                          ? const Center(child: Text('No jars available'))
                          : ListView.builder(
                            itemCount:
                                isEditing
                                    ? editedJars.length
                                    : jarsProvider.jars.length,
                            itemBuilder: (context, index) {
                              final mapJar =
                                  isEditing ? editedJars[index] : null;
                              final entityJar =
                                  !isEditing ? jarsProvider.jars[index] : null;

                              final name =
                                  mapJar != null
                                      ? mapJar['name'] as String
                                      : entityJar!.name;
                              final percentage =
                                  mapJar != null
                                      ? mapJar['percentage'] as double
                                      : entityJar!.percentage;

                              return Card(
                                margin: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                color: Colors.white.withOpacity(0.9),
                                child: ListTile(
                                  leading: Image.asset(
                                    'assets/icons/jar_icon.png',
                                    height: 40,
                                    width: 40,
                                    errorBuilder: (context, error, stackTrace) {
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
                                    name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.teal,
                                    ),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (isEditing) ...[
                                        IconButton(
                                          icon: const Icon(
                                            Icons.remove,
                                            color: Colors.teal,
                                          ),
                                          onPressed:
                                              () => adjustPercentage(
                                                index,
                                                false,
                                              ),
                                        ),
                                        Text(
                                          '${percentage.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.teal,
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.add,
                                            color: Colors.teal,
                                          ),
                                          onPressed:
                                              () =>
                                                  adjustPercentage(index, true),
                                        ),
                                      ] else
                                        Text(
                                          '${percentage.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.teal,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                ),
              ],
            ),
          ),
          if (isSaving)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
