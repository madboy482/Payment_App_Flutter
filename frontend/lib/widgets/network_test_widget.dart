import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../services/api_service.dart';

class NetworkTestWidget extends StatefulWidget {
  const NetworkTestWidget({super.key});

  @override
  State<NetworkTestWidget> createState() => _NetworkTestWidgetState();
}

class _NetworkTestWidgetState extends State<NetworkTestWidget> {
  String _testResult = 'Tap to test network connectivity';
  bool _isLoading = false;

  Future<void> _testNetworkConnectivity() async {
    setState(() {
      _isLoading = true;
      _testResult = 'Testing connectivity...';
    });

    try {
      final baseUrl = ApiService.baseUrl;
      print('Testing connectivity to: $baseUrl');
      
      // Test basic connectivity
      final response = await http.get(
        Uri.parse('$baseUrl/payments/stats'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      setState(() {
        _testResult = '''
✅ SUCCESS!
Status: ${response.statusCode}
URL: $baseUrl
Response Length: ${response.body.length} chars
Network: Connected
        ''';
      });
    } catch (e) {
      setState(() {
        _testResult = '''
❌ FAILED!
URL: ${ApiService.baseUrl}
Error: $e
        ''';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Network Connectivity Test',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _testNetworkConnectivity,
              child: _isLoading 
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Test Network'),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _testResult,
                style: const TextStyle(fontFamily: 'monospace'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
