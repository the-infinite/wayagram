import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:wayagram/core/utils/utils.dart';

class FundAmountDialog extends StatefulWidget {
  final String title;
  final double? initialAmount;
  final double? minAmount;
  final double? maxAmount;
  final VoidCallback? onConfirm;

  const FundAmountDialog({
    super.key,
    this.title = 'Enter Amount',
    this.onConfirm,
    this.initialAmount,
    this.minAmount,
    this.maxAmount,
  });

  @override
  State<FundAmountDialog> createState() => _AmountInputDialogState();
}

class _AmountInputDialogState extends State<FundAmountDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _formatter = NumberFormat("#,##0.00", "en_US");

  @override
  void initState() {
    super.initState();
    if (widget.initialAmount != null) {
      _amountController.text = _formatter.format(widget.initialAmount);
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  String? _validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an amount';
    }

    final cleanValue = value.replaceAll(RegExp(r'[^0-9.]'), '');
    final amount = double.tryParse(cleanValue);

    if (amount == null) {
      return 'Please enter a valid amount';
    }

    if (widget.minAmount != null && amount < widget.minAmount!) {
      return 'Amount must be at least ₦${_formatter.format(widget.minAmount)}';
    }

    if (widget.maxAmount != null && amount > widget.maxAmount!) {
      return 'Amount cannot exceed ₦${_formatter.format(widget.maxAmount)}';
    }

    return null;
  }

  double? _parseAmount(String value) {
    final cleanValue = value.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(cleanValue);
  }

  String _formatAmount(String text) {
    // Remove all non-digit characters except decimal point
    String numericValue = text.replaceAll(RegExp(r'[^0-9.]'), '');

    if (numericValue.isEmpty) return '';

    try {
      // Parse the numeric value
      double? value = double.tryParse(numericValue);
      if (value != null) {
        return _formatter.format(value);
      }
    } catch (_) {}

    return text;
  }

  @override
  Widget build(BuildContext context) {
    final wayTheme = Theme.of(context);
    return AlertDialog(
      title: Text(widget.title),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _amountController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              textAlign: TextAlign.center,
              style: wayTheme.textTheme.headlineSmall,
              decoration: InputDecoration(
                prefixText: '₦',
                prefixStyle: wayTheme.textTheme.headlineSmall,
                hintText: '0.00',
                errorMaxLines: 2,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: wayTheme.colorScheme.outline,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: wayTheme.colorScheme.primary,
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
              ],
              validator: _validateAmount,
              onChanged: (value) {
                if (value.isEmpty) return;

                final cursorPosition = _amountController.selection.start;
                final oldText = _amountController.text;
                final newText = _formatAmount(value);

                if (oldText != newText) {
                  // Calculate the number of added/removed characters
                  final diff = newText.length - oldText.length;

                  _amountController.text = newText;

                  // Adjust cursor position
                  if (cursorPosition != -1) {
                    final newPosition = cursorPosition + diff;
                    _amountController.selection = TextSelection.fromPosition(
                      TextPosition(
                          offset: newPosition.clamp(0, newText.length)),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => WayaNav.goBack(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final amount = _parseAmount(_amountController.text);
              WayaNav.goBack(result: amount);
            }
          },
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}
