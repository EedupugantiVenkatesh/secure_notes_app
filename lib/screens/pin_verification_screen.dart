import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/notes_provider.dart';
import '../constants/app_constants.dart';
import 'pin_setup_screen.dart';

class PinVerificationScreen extends StatefulWidget {
  const PinVerificationScreen({Key? key}) : super(key: key);

  @override
  State<PinVerificationScreen> createState() => _PinVerificationScreenState();
}

class _PinVerificationScreenState extends State<PinVerificationScreen> {
  final _pinController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _verifyPin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final isValid = await context.read<AuthProvider>().verifyPin(_pinController.text);
      if (mounted) {
        if (isValid) {
          // Load notes before navigating
          await context.read<NotesProvider>().loadNotes();
          Navigator.of(context).pop(true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(AppConstants.invalidPinMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${AppConstants.errorMessage}$e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleForgotPin() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppConstants.forgotPinAction),
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

    if (confirmed == true && mounted) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PinSetupScreen(isForgotPin: true),
        ),
      );

      if (result == true && mounted) {
        // Load notes after successful PIN reset
        await context.read<NotesProvider>().loadNotes();
        Navigator.of(context).pop(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_isLoading) return false;
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppConstants.enterPinLabel),
          leading: _isLoading ? null : AppBar().leading,
        ),
        body: AbsorbPointer(
          absorbing: _isLoading,
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.contentPadding),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _pinController,
                    decoration: const InputDecoration(
                      labelText: AppConstants.enterPinLabel,
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: AppConstants.pinLength,
                    obscureText: true,
                    enabled: !_isLoading,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppConstants.pinRequiredMessage;
                      }
                      if (value.length != AppConstants.pinLength) {
                        return AppConstants.pinLengthMessage;
                      }
                      if (!RegExp(r'^\d{4}$').hasMatch(value)) {
                        return AppConstants.pinNumbersOnlyMessage;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppConstants.spacingLarge),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _verifyPin,
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
                            : const Text(AppConstants.verifyPinAction),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingMedium),
                  TextButton(
                    onPressed: _isLoading ? null : _handleForgotPin,
                    child: const Text(AppConstants.forgotPinAction),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
} 