import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/notes_provider.dart';
import '../constants/app_constants.dart';

class PinSetupScreen extends StatefulWidget {
  final bool isForgotPin;

  const PinSetupScreen({
    Key? key,
    this.isForgotPin = false,
  }) : super(key: key);

  @override
  State<PinSetupScreen> createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends State<PinSetupScreen> {
  final _pinController = TextEditingController();
  final _confirmPinController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _pinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    // Hide keyboard before proceeding
    FocusScope.of(context).unfocus();
    
    setState(() => _isLoading = true);

    try {
      if (widget.isForgotPin) {
        // Delete all notes and reset PIN
        await context.read<NotesProvider>().deleteAllNotes();
        await context.read<AuthProvider>().resetPin();
      }
      
      await context.read<AuthProvider>().setPin(_pinController.text);
      
      if (!mounted) return;
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.isForgotPin ? AppConstants.pinResetSuccessMessage : AppConstants.pinSetSuccessMessage),
          backgroundColor: Colors.green,
          duration: Duration(seconds: AppConstants.snackbarDurationShort),
        ),
      );

      // Navigate back with success
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${AppConstants.errorMessage}$e'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: AppConstants.snackbarDurationLong),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_isLoading) return false;
        // Hide keyboard when back is pressed
        FocusScope.of(context).unfocus();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.isForgotPin ? AppConstants.resetPinLabel : AppConstants.setUpPinLabel),
          leading: _isLoading ? null : AppBar().leading,
        ),
        body: GestureDetector(
          onTap: () {
            // Hide keyboard when tapping outside
            FocusScope.of(context).unfocus();
          },
          child: AbsorbPointer(
            absorbing: _isLoading,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(AppConstants.contentPadding),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.isForgotPin) ...[
                        Text(
                          AppConstants.warningLabel,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: AppConstants.warningFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: AppConstants.spacingLarge),
                      ],
                      TextFormField(
                        controller: _pinController,
                        decoration: InputDecoration(
                          labelText: AppConstants.enterPinLabel,
                          border: const OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        maxLength: AppConstants.pinLength,
                        obscureText: true,
                        enabled: !_isLoading,
                        textInputAction: TextInputAction.next,
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
                      SizedBox(height: AppConstants.spacingMedium),
                      TextFormField(
                        controller: _confirmPinController,
                        decoration: InputDecoration(
                          labelText: AppConstants.confirmPinLabel,
                          border: const OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        maxLength: AppConstants.pinLength,
                        obscureText: true,
                        enabled: !_isLoading,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _handleSubmit(),
                        validator: (value) {
                          if (value != _pinController.text) {
                            return AppConstants.pinMismatchMessage;
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: AppConstants.spacingLarge),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleSubmit,
                          child: Padding(
                            padding: EdgeInsets.all(AppConstants.buttonPadding),
                            child: _isLoading
                                ? SizedBox(
                                    height: AppConstants.loadingIndicatorSize,
                                    width: AppConstants.loadingIndicatorSize,
                                    child: CircularProgressIndicator(
                                      strokeWidth: AppConstants.loadingIndicatorStrokeWidth,
                                    ),
                                  )
                                : Text(widget.isForgotPin ? AppConstants.resetPinLabel : AppConstants.setPinLabel),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}