import 'package:flutter/material.dart';
import 'package:invoicegen_flutter_app/core/network/connection_service.dart';
import 'package:invoicegen_flutter_app/injection_container.dart';

class SplashScreen extends StatefulWidget {
  final String message;

  const SplashScreen({
    super.key,
    this.message = 'Loading...',
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String _statusMessage = '';
  bool _connectionChecked = false;

  @override
  void initState() {
    super.initState();
    _checkConnection();
  }

  Future<void> _checkConnection() async {
    setState(() {
      _statusMessage = 'Checking backend connection...';
    });

    try {
      final connectionService = getIt<ConnectionService>();
      final status = await connectionService.testConnection();
      
      if (mounted) {
        setState(() {
          _connectionChecked = true;
          _statusMessage = status.isConnected 
              ? '✓ Backend connected' 
              : '✗ Backend not reachable';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _connectionChecked = true;
          _statusMessage = '✗ Connection check failed';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.receipt_long,
              size: 80,
              color: Colors.blue,
            ),
            const SizedBox(height: 24),
            Text(
              'InvoiceGen',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.message,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (_statusMessage.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                _statusMessage,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: _connectionChecked
                      ? (_statusMessage.contains('✓') ? Colors.green : Colors.orange)
                      : Colors.grey,
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

