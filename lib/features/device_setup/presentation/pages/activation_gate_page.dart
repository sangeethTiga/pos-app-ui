import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../terminal/widgets/sync_chip.dart';
import '../../domain/activation_policy.dart';
import '../cubit/activation_cubit.dart';
import '../widgets/activation_text.dart';

/// Shown instead of the sell screen while this terminal is not activated (and from Settings ->
/// Activation to enter a renewal code). Syncing, existing orders, logout and settings stay reachable.
class ActivationGatePage extends StatefulWidget {
  const ActivationGatePage({
    super.key,
    required this.storeName,
    required this.deviceCode,
    this.toLocal,
    this.loggedIn = false,
    this.renew = false,
    this.onOrders,
    this.onLogout,
    this.onLogin,
    this.onPrinters,
    this.showSyncChip = true,
  });

  final String storeName;
  final String deviceCode;

  /// UTC -> store time for the dates shown.
  final DateTime Function(DateTime utc)? toLocal;

  /// A cashier is logged in: offer Orders and Logout, else Staff login.
  final bool loggedIn;

  /// Opened on purpose while valid (renewal): no automatic leave, closes after a successful code.
  final bool renew;
  final VoidCallback? onOrders;
  final VoidCallback? onLogout;
  final VoidCallback? onLogin;
  final VoidCallback? onPrinters;
  final bool showSyncChip;

  @override
  State<ActivationGatePage> createState() => _ActivationGatePageState();
}

class _ActivationGatePageState extends State<ActivationGatePage> {
  final _code = TextEditingController();

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  void _submit(ActivationCubit cubit) {
    FocusScope.of(context).unfocus();
    cubit.activate(_code.text);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return BlocConsumer<ActivationCubit, ActivationState>(
      listenWhen: (a, b) => a.activating && !b.activating && b.activationError == null,
      listener: (context, s) {
        _code.clear();
        if (widget.renew && s.canSell && Navigator.of(context).canPop()) Navigator.of(context).pop();
      },
      builder: (context, s) {
        final cubit = context.read<ActivationCubit>();
        final v = s.verdict;
        final ok = v.canSell;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Terminal activation'),
            automaticallyImplyLeading: widget.renew,
            actions: [if (widget.showSyncChip) const SyncChip()],
          ),
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(ok ? Icons.verified_outlined : Icons.lock_outline, size: 48, color: scheme.primary),
                      const SizedBox(height: 12),
                      Text(
                        widget.storeName,
                        key: const Key('activationStoreName'),
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleLarge,
                      ),
                      Text(
                        'Terminal ${widget.deviceCode}',
                        key: const Key('activationDeviceCode'),
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        s.loaded ? activationHeadline(v, widget.toLocal) : 'Checking activation…',
                        key: const Key('activationStatus'),
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: ok ? scheme.primary : scheme.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        ok ? 'Enter a new code to renew the activation.' : activationExplanation(v),
                        key: const Key('activationExplanation'),
                        textAlign: TextAlign.center,
                      ),
                      if (!ok)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            'New orders are blocked. Syncing, existing orders, logout and settings still work.',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                      const SizedBox(height: 24),
                      TextField(
                        key: const Key('activationCodeField'),
                        controller: _code,
                        enabled: !s.activating,
                        textAlign: TextAlign.center,
                        textCapitalization: TextCapitalization.characters,
                        autocorrect: false,
                        enableSuggestions: false,
                        inputFormatters: [ActivationCodeFormatter()],
                        style: const TextStyle(fontSize: 22, letterSpacing: 2),
                        decoration: InputDecoration(
                          labelText: 'Activation code',
                          hintText: 'XXXX-XXXX-XXXX',
                          errorText: s.activationError,
                          errorMaxLines: 3,
                        ),
                        onChanged: (_) => cubit.clearError(),
                        onSubmitted: (_) => _submit(cubit),
                      ),
                      const SizedBox(height: 16),
                      FilledButton(
                        key: const Key('activateButton'),
                        onPressed: s.activating ? null : () => _submit(cubit),
                        style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                        child: s.activating
                            ? const SizedBox.square(dimension: 22, child: CircularProgressIndicator(strokeWidth: 2.5))
                            : const Text('Activate'),
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        key: const Key('refreshActivationButton'),
                        onPressed: s.refreshing ? null : cubit.refresh,
                        style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(44)),
                        icon: s.refreshing
                            ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2))
                            : const Icon(Icons.refresh),
                        label: const Text('Refresh status'),
                      ),
                      if (s.refreshError case final e?)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            e,
                            key: const Key('activationRefreshError'),
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodySmall?.copyWith(color: scheme.error),
                          ),
                        ),
                      const SizedBox(height: 16),
                      const Divider(),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 8,
                        children: [
                          if (widget.loggedIn && widget.onOrders != null)
                            TextButton.icon(
                              key: const Key('activationOrders'),
                              onPressed: widget.onOrders,
                              icon: const Icon(Icons.receipt_long),
                              label: const Text('Orders'),
                            ),
                          if (widget.onPrinters != null)
                            TextButton.icon(
                              key: const Key('activationPrinters'),
                              onPressed: widget.onPrinters,
                              icon: const Icon(Icons.print),
                              label: const Text('Printer settings'),
                            ),
                          if (widget.loggedIn && widget.onLogout != null)
                            TextButton.icon(
                              key: const Key('activationLogout'),
                              onPressed: widget.onLogout,
                              icon: const Icon(Icons.logout),
                              label: const Text('Logout'),
                            ),
                          if (!widget.loggedIn && !widget.renew && widget.onLogin != null)
                            TextButton.icon(
                              key: const Key('activationStaffLogin'),
                              onPressed: widget.onLogin,
                              icon: const Icon(Icons.login),
                              label: const Text('Staff login'),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Keeps the field as XXXX-XXXX-XXXX while typing or pasting (upper case, code alphabet only).
class ActivationCodeFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Deleting a dash deletes the character before it.
    var input = newValue.text;
    if (input.length < oldValue.text.length &&
        oldValue.text.replaceAll('-', '') == input.replaceAll('-', '') &&
        input.isNotEmpty) {
      input = ActivationCode.normalize(input);
      input = input.substring(0, input.length - 1);
    }
    final text = ActivationCode.format(input);
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
