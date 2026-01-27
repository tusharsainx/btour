import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../core/constants/app_constants.dart';

// Payment status enum
enum PaymentStatus { success, failure, pending }

class PaymentService {
  // late Razorpay _razorpay;
  Function(String)? _onSuccess;
  Function(String)? _onFailure;

  PaymentService() {
    /* Razorpay disabled for mock
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    */
  }

  void initialize({
    required Function(String) onSuccess,
    required Function(String) onFailure,
  }) {
    _onSuccess = onSuccess;
    _onFailure = onFailure;
  }

  void openCheckout({
    required double amount,
    required String name,
    required String description,
    required String contact,
    required String email,
    required String orderId, // Can be empty if not using order API
  }) async {
    // Mock Payment Flow
    debugPrint('Opening mock checkout for $name - $amount');

    // Simulate delay
    await Future.delayed(const Duration(seconds: 2));

    // Simulate Success
    _onSuccess?.call(
      'mock_payment_id_${DateTime.now().millisecondsSinceEpoch}',
    );

    /* Razorpay implementation disabled for mock mode
    var options = {
      'key': AppConstants.razorpayKey,
      'amount': (amount * 100).toInt(), // in paise
      'name': name,
      'description': description,
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': contact, 'email': email},
      'external': {
        'wallets': ['paytm'],
      },
    };

    if (orderId.isNotEmpty) {
      options['order_id'] = orderId;
    }

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
      _onFailure?.call(e.toString());
    }
    */
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    debugPrint('Payment Success: ${response.paymentId}');
    _onSuccess?.call(response.paymentId ?? 'success_no_id');
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    debugPrint('Payment Error: ${response.code} - ${response.message}');
    _onFailure?.call(response.message ?? 'Unknown error');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    debugPrint('External Wallet: ${response.walletName}');
    // Treat as success or handle separately
    _onSuccess?.call('wallet_${response.walletName}');
  }

  void dispose() {
    // _razorpay.clear();
  }
}

final paymentServiceProvider = Provider<PaymentService>((ref) {
  final service = PaymentService();
  ref.onDispose(() => service.dispose());
  return service;
});
