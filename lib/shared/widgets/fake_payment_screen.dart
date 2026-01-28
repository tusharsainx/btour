import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

/// Payment method enum
enum PaymentMethod { upi, card, netbanking, wallet }

/// Fake Razorpay payment screen
class FakePaymentScreen extends ConsumerStatefulWidget {
  final double amount;
  final String title;
  final String description;
  final Function(String paymentId) onSuccess;
  final Function(String error) onFailure;

  const FakePaymentScreen({
    super.key,
    required this.amount,
    required this.title,
    required this.description,
    required this.onSuccess,
    required this.onFailure,
  });

  @override
  ConsumerState<FakePaymentScreen> createState() => _FakePaymentScreenState();
}

class _FakePaymentScreenState extends ConsumerState<FakePaymentScreen> {
  PaymentMethod _selectedMethod = PaymentMethod.upi;
  final _upiController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _cardExpiryController = TextEditingController();
  final _cardCvvController = TextEditingController();
  bool _isProcessing = false;

  @override
  void dispose() {
    _upiController.dispose();
    _cardNumberController.dispose();
    _cardExpiryController.dispose();
    _cardCvvController.dispose();
    super.dispose();
  }

  Future<void> _processPayment() async {
    setState(() => _isProcessing = true);

    // Simulate payment processing
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() => _isProcessing = false);

      // Generate mock payment ID
      final paymentId = 'pay_${DateTime.now().millisecondsSinceEpoch}';

      widget.onSuccess(paymentId);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF072654),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () {
            widget.onFailure('Payment cancelled by user');
            Navigator.of(context).pop();
          },
        ),
        title: Row(
          children: [
            // Razorpay-like logo
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'R',
                style: TextStyle(
                  color: Color(0xFF072654),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Razorpay',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                const Icon(Icons.lock, color: Colors.green, size: 16),
                const SizedBox(width: 4),
                Text(
                  'Secured',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Amount header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: const Color(0xFF072654),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  '₹${widget.amount.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Payment methods
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Payment Methods',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // UPI
                  _buildPaymentOption(
                    method: PaymentMethod.upi,
                    icon: Icons.qr_code,
                    title: 'UPI',
                    subtitle: 'Pay using UPI ID or scan QR',
                    color: Colors.green,
                  ),
                  const SizedBox(height: 12),
                  // Card
                  _buildPaymentOption(
                    method: PaymentMethod.card,
                    icon: Icons.credit_card,
                    title: 'Card',
                    subtitle: 'Visa, MasterCard, Rupay & more',
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 12),
                  // Net Banking
                  _buildPaymentOption(
                    method: PaymentMethod.netbanking,
                    icon: Icons.account_balance,
                    title: 'Net Banking',
                    subtitle: 'All major banks supported',
                    color: Colors.purple,
                  ),
                  const SizedBox(height: 12),
                  // Wallet
                  _buildPaymentOption(
                    method: PaymentMethod.wallet,
                    icon: Icons.account_balance_wallet,
                    title: 'Wallet',
                    subtitle: 'PayTM, PhonePe, Amazon Pay',
                    color: Colors.orange,
                  ),
                  const SizedBox(height: 24),
                  // Payment form based on selected method
                  _buildPaymentForm(),
                ],
              ),
            ),
          ),
          // Pay button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isProcessing ? null : _processPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF528FF0),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: _isProcessing
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'Pay ₹${widget.amount.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption({
    required PaymentMethod method,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    final isSelected = _selectedMethod == method;
    return InkWell(
      onTap: () => setState(() => _selectedMethod = method),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.1) : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? color : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: color)
            else
              Icon(Icons.radio_button_unchecked, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentForm() {
    switch (_selectedMethod) {
      case PaymentMethod.upi:
        return _buildUpiForm();
      case PaymentMethod.card:
        return _buildCardForm();
      case PaymentMethod.netbanking:
        return _buildNetBankingForm();
      case PaymentMethod.wallet:
        return _buildWalletForm();
    }
  }

  Widget _buildUpiForm() {
    return FadeIn(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Enter UPI ID',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _upiController,
            decoration: InputDecoration(
              hintText: 'yourname@upi',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              prefixIcon: const Icon(Icons.account_circle_outlined),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildUpiApp('Google Pay', '🔵'),
              _buildUpiApp('PhonePe', '🟣'),
              _buildUpiApp('Paytm', '🔷'),
              _buildUpiApp('BHIM', '🟢'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUpiApp(String name, String emoji) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Center(
            child: Text(emoji, style: const TextStyle(fontSize: 28)),
          ),
        ),
        const SizedBox(height: 4),
        Text(name, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildCardForm() {
    return FadeIn(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Card Details',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _cardNumberController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(16),
            ],
            decoration: InputDecoration(
              hintText: 'Card Number',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              prefixIcon: const Icon(Icons.credit_card),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _cardExpiryController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [LengthLimitingTextInputFormatter(5)],
                  decoration: InputDecoration(
                    hintText: 'MM/YY',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _cardCvvController,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(3),
                  ],
                  decoration: InputDecoration(
                    hintText: 'CVV',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNetBankingForm() {
    return FadeIn(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Bank',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildBankChip('SBI'),
              _buildBankChip('HDFC'),
              _buildBankChip('ICICI'),
              _buildBankChip('Axis'),
              _buildBankChip('Kotak'),
              _buildBankChip('PNB'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBankChip(String name) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Text(
        name,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
      ),
    );
  }

  Widget _buildWalletForm() {
    return FadeIn(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Wallet',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),
          _buildWalletOption('Paytm', '💙', Colors.blue),
          const SizedBox(height: 8),
          _buildWalletOption('PhonePe', '💜', Colors.purple),
          const SizedBox(height: 8),
          _buildWalletOption('Amazon Pay', '🧡', Colors.orange),
        ],
      ),
    );
  }

  Widget _buildWalletOption(String name, String emoji, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
            ),
          ),
          Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
        ],
      ),
    );
  }
}

/// Show the fake payment screen
Future<void> showFakePaymentScreen({
  required BuildContext context,
  required double amount,
  required String title,
  required String description,
  required Function(String paymentId) onSuccess,
  required Function(String error) onFailure,
}) {
  return Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => FakePaymentScreen(
        amount: amount,
        title: title,
        description: description,
        onSuccess: onSuccess,
        onFailure: onFailure,
      ),
    ),
  );
}
