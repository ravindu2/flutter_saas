import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_saas/model/conversion_model.dart';
import 'package:flutter_saas/services/stor_convercions_firestore.dart';

class UserHistory extends StatelessWidget {
  const UserHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ConversionModel>>(
      stream: StorConvercionsFirestore().getUserConversion(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text("Error: ${snapshot.error}"),
          );
        }

        final List<ConversionModel>? userConversion = snapshot.data;

        if (userConversion == null || userConversion.isEmpty) {
          return const Center(
            child: Text("No conversions found."),
          );
        }

        return ListView.builder(
          itemCount: userConversion.length,
          itemBuilder: (context, index) {
            final ConversionModel conversion = userConversion[index];
            final String? conversionData =
                conversion.conversionData; // Local variable

            print("Displaying conversion: $conversionData");

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (conversion.imageUrl != null &&
                        conversion.imageUrl!.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          conversion.imageUrl!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 200,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.broken_image,
                              size: 100,
                            );
                          },
                        ),
                      )
                    else
                      const Text("No image available"),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            conversionData != null && conversionData.isNotEmpty
                                ? (conversionData.length > 200
                                    ? "${conversionData.substring(0, 200)}..." // Interpolation used here
                                    : conversionData)
                                : "No conversion data available",
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            if (conversionData != null) {
                              Clipboard.setData(
                                ClipboardData(text: conversionData),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Text copied to clipboard"),
                                ),
                              );
                            }
                          },
                          icon: const Icon(
                            Icons.copy,
                            color: Colors.blue,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Converted on: ${conversion.conversionDate?.toLocal().toString().split(' ')[0] ?? 'Unknown date'}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
