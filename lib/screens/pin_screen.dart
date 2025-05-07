import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../constants/app_constants.dart';

class PinScreen extends StatefulWidget {
  final bool isSetup;
  final VoidCallback onPinVerified;

  const PinScreen({
    Key? key,
    required this.isSetup,
    required this.onPinVerified,
  }) : super(key: key);

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  final _pinController = TextEditingController();
  String _errorMessage = '';
  bool _isLoading = false;

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _handlePinSubmit() async {
    final pin = _pinController.text;
    if (pin.length != AppConstants.pinLength || !RegExp(r'^\d{4}$').hasMatch(pin)) {
      setState(() {
        _errorMessage = AppConstants.pinValidationMessage;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      if (widget.isSetup) {
        await context.read<AuthProvider>().setPin(pin);
        widget.onPinVerified();
      } else {
        final isValid = await context.read<AuthProvider>().verifyPin(pin);
        if (isValid) {
          widget.onPinVerified();
        } else {
          setState(() {
            _errorMessage = AppConstants.pinInvalidMessage;
          });
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleResetPin() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppConstants.resetPinLabel),
        content: const Text(AppConstants.forgotPinWarningMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(AppConstants.cancelAction),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text(AppConstants.resetAction),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        // Reset PIN and clear notes
        await context.read<AuthProvider>().resetPin();
        
        if (mounted) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(AppConstants.pinResetSuccessMessage),
              backgroundColor: Colors.green,
              duration: Duration(seconds: AppConstants.snackbarDurationShort),
            ),
          );

          // Navigate to PIN setup screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => PinScreen(
                isSetup: true,
                onPinVerified: widget.onPinVerified,
              ),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${AppConstants.errorMessage}$e'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: AppConstants.snackbarDurationLong),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isSetup ? AppConstants.setPinLabel : AppConstants.enterPinLabel),
        actions: [
          if (!widget.isSetup)
            TextButton(
              onPressed: _handleResetPin,
              child: const Text(AppConstants.forgotPinAction),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.contentPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.isSetup
                  ? AppConstants.setUpPinLabel
                  : AppConstants.enterPinLabel,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.spacingLarge),
            TextField(
              controller: _pinController,
              keyboardType: TextInputType.number,
              maxLength: AppConstants.pinLength,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: AppConstants.pinLabel,
                border: OutlineInputBorder(),
              ),
            ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: AppConstants.spacingSmall),
                child: Text(
                  _errorMessage,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
            const SizedBox(height: AppConstants.spacingMedium),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handlePinSubmit,
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.buttonPadding),
                  child: _isLoading
                      ? const SizedBox(
                          height: AppConstants.loadingIndicatorSize,
                          width: AppConstants.loadingIndicatorSize,
                          child: CircularProgressIndicator(
                            strokeWidth: AppConstants.loadingIndicatorStrokeWidth,
                          ),
                        )
                      : Text(widget.isSetup ? AppConstants.setPinLabel : AppConstants.verifyPinLabel),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}