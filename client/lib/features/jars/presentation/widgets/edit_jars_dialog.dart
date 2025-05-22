import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mybudget/features/jars/domain/entities/jar.dart';
import 'package:mybudget/features/jars/presentation/providers/jars_provider.dart';

class EditJarsDialog extends StatefulWidget {
  final List<Jar> jars;

  const EditJarsDialog({super.key, required this.jars});

  @override
  _EditJarsDialogState createState() => _EditJarsDialogState();
}

class _EditJarsDialogState extends State<EditJarsDialog> {
  late List<Map<String, dynamic>> editedJars;

  @override
  void initState() {
    super.initState();
    editedJars =
        widget.jars
            .map(
              (jar) => {
                'id': jar.id,
                'name': jar.name,
                'percentage': jar.percentage,
                'controller': TextEditingController(
                  text: jar.percentage.toString(),
                ),
              },
            )
            .toList();
  }

  @override
  void dispose() {
    for (var jar in editedJars) {
      jar['controller'].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final jarsProvider = Provider.of<JarsProvider>(context, listen: false);

    return AlertDialog(
      title: const Text('Edit Jars'),
      content: StatefulBuilder(
        builder: (context, setDialogState) {
          double totalPercentage = editedJars
              .map((jar) => double.tryParse(jar['controller'].text) ?? 0)
              .reduce((a, b) => a + b);

          return SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...editedJars.map((jar) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            jar['name'],
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            controller: jar['controller'],
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: '%',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              setDialogState(() {});
                            },
                            validator: (value) {
                              final num = double.tryParse(value ?? '');
                              if (num == null || num < 0) {
                                return 'Invalid';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                const SizedBox(height: 16),
                Text(
                  'Total: ${totalPercentage.toStringAsFixed(2)}%',
                  style: TextStyle(
                    color: totalPercentage == 100 ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            double totalPercentage = editedJars
                .map((jar) => double.tryParse(jar['controller'].text) ?? 0)
                .reduce((a, b) => a + b);

            if (totalPercentage != 100) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Total percentage must be 100%')),
              );
              return;
            }

            for (var jar in editedJars) {
              final jarId = jar['id'] as int;
              final newPercentage = double.parse(jar['controller'].text);
              jarsProvider.updateJarPercentage(jarId, newPercentage);
            }

            Navigator.of(context).pop();
            final userId =
                Provider.of<JarsProvider>(
                  context,
                  listen: false,
                ).userId; // Giả định userId từ JarsProvider
            if (userId != null) {
              jarsProvider.fetchJars(userId);
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
