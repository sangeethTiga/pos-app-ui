import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes.dart';
import '../../../../app/theme.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/responsive/responsive.dart';
import '../../../terminal/terminal_cubit.dart';
import '../../domain/entities/device_session.dart';
import '../bloc/device_setup_bloc.dart';
import '../cubit/activation_cubit.dart';

/// Register this terminal. Step 1: store code + one-time registration code from the admin panel.
/// Step 2 ("Settings"): store, device name, device id, kiosk, cashier / captain, delivery manager flags.
class DeviceSetupPage extends StatefulWidget {
  const DeviceSetupPage({super.key});

  @override
  State<DeviceSetupPage> createState() => _DeviceSetupPageState();
}

class _DeviceSetupPageState extends State<DeviceSetupPage> {
  final _codesForm = GlobalKey<FormState>();
  final _settingsForm = GlobalKey<FormState>();
  final _storeCode = TextEditingController();
  final _registrationCode = TextEditingController();
  final _deviceName = TextEditingController();

  String? _kioskId;
  DeviceType _type = DeviceType.cashier;
  bool _kioskWise = false;
  bool _deliveryManager = false;
  bool _settleAssignedOnly = false;

  @override
  void dispose() {
    _storeCode.dispose();
    _registrationCode.dispose();
    _deviceName.dispose();
    super.dispose();
  }

  String? _required(String? v) => (v == null || v.trim().isEmpty) ? 'Required' : null;

  void _submitCodes() {
    if (!_codesForm.currentState!.validate()) return;
    context.read<DeviceSetupBloc>().add(
      DeviceSetupEvent.codesSubmitted(storeCode: _storeCode.text, registrationCode: _registrationCode.text),
    );
  }

  void _register() {
    if (!_settingsForm.currentState!.validate()) return;
    context.read<DeviceSetupBloc>().add(
      DeviceSetupEvent.registerSubmitted(
        deviceName: _deviceName.text,
        profile: DeviceProfile(
          deviceType: _type,
          kioskId: _kioskId,
          kioskWiseOrderListing: _kioskWise,
          deliveryManagerPos: _deliveryManager,
          settleAssignedOrdersOnly: _settleAssignedOnly,
        ),
      ),
    );
  }

  /// Registered: start the terminal, then the activation gate unless already activated.
  Future<void> _start(BuildContext context, DeviceSession session) async {
    context.read<TerminalCubit>().start(session);
    final activation = context.read<ActivationCubit>();
    await activation.start(session.deviceId);
    if (!context.mounted) return;
    context.go(activation.state.canSell ? Routes.lock : Routes.activation);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DeviceSetupBloc, DeviceSetupState>(
      listener: (context, state) {
        if (state is DeviceSetupPaired) _start(context, state.session);
        if (state is DeviceSetupReady && state.failure == null && !state.submitting) {
          // New store: forget a kiosk picked for another store.
          if (!state.preview.kiosks.any((k) => k.id == _kioskId)) setState(() => _kioskId = null);
        }
      },
      builder: (context, state) {
        final r = context.r;
        final theme = Theme.of(context);
        // Material text grows on 4K screens (never shrinks on phones); touch-sized checkboxes/radios.
        final grow = math.max(1.0, r.density);
        return Theme(
          data: theme.copyWith(
            materialTapTargetSize: MaterialTapTargetSize.padded,
            textTheme: grow == 1 ? theme.textTheme : theme.textTheme.apply(fontSizeFactor: grow),
          ),
          child: Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(child: state is DeviceSetupReady ? _settings(context, state, r) : _codes(context, state, r)),
          ),
        );
      },
    );
  }

  // ---- Step 1 ---------------------------------------------------------------------------------

  Widget _codes(BuildContext context, DeviceSetupState state, Responsive r) {
    final busy = state is DeviceSetupVerifying;
    return Column(
      children: [
        const _Header(title: 'Register Device'),
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(r.gutter * 1.5),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: math.max(460, r.s(600))),
                child: _SectionCard(
                  child: Form(
                    key: _codesForm,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Ask a manager for the store code and a registration code from the admin panel.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          key: const Key('storeCode'),
                          controller: _storeCode,
                          enabled: !busy,
                          textCapitalization: TextCapitalization.characters,
                          decoration: _input('Store code*', hint: 'ST-0007'),
                          validator: _required,
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          key: const Key('registrationCode'),
                          controller: _registrationCode,
                          enabled: !busy,
                          keyboardType: TextInputType.number,
                          decoration: _input('Registration code*'),
                          validator: _required,
                          onFieldSubmitted: (_) => _submitCodes(),
                        ),
                        if (state is DeviceSetupFailure) ...[
                          const SizedBox(height: 14),
                          _Error(state.failure, key: const Key('setupError')),
                        ],
                        const SizedBox(height: 22),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: _NavyButton(
                            key: const Key('continueButton'),
                            label: 'Continue',
                            busy: busy,
                            onPressed: _submitCodes,
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
      ],
    );
  }

  // ---- Step 2 ---------------------------------------------------------------------------------

  Widget _settings(BuildContext context, DeviceSetupReady state, Responsive r) {
    final p = state.preview;
    final busy = state.submitting;
    final text = Theme.of(context).textTheme;
    return Column(
      children: [
        _Header(
          title: 'Settings',
          onBack: busy ? null : () => context.read<DeviceSetupBloc>().add(const DeviceSetupEvent.back()),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(r.gutter, 8, r.gutter, r.s(32) + 8),
            child: Center(
              child: ConstrainedBox(
                // One centred column; wide enough for the cards, not a line across a TV.
                constraints: BoxConstraints(maxWidth: math.max(560, r.s(860))),
                child: Form(
                  key: _settingsForm,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Store
                      Container(
                        key: const Key('storeCard'),
                        padding: EdgeInsets.symmetric(
                          horizontal: math.max(16, r.s(28)),
                          vertical: math.max(16, r.s(24)),
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade500),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p.storeName, style: text.titleLarge?.copyWith(fontWeight: FontWeight.w500)),
                            const SizedBox(height: 4),
                            Text(
                              'Store code ${p.storeCode}${p.rePair ? '  ·  re-pairing an existing terminal' : ''}',
                              style: text.bodySmall?.copyWith(color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),
                      // Device name
                      TextFormField(
                        key: const Key('deviceName'),
                        controller: _deviceName,
                        enabled: !busy,
                        decoration: _input('Device name*'),
                        validator: _required,
                      ),
                      const SizedBox(height: 16),
                      // Device id + copy
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              key: const Key('hardwareId'),
                              initialValue: p.hardwareId,
                              readOnly: true,
                              decoration: _input(null),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            key: const Key('copyHardwareId'),
                            tooltip: 'Copy device ID',
                            icon: const Icon(Icons.copy_outlined, size: 28),
                            onPressed: () async {
                              await Clipboard.setData(ClipboardData(text: p.hardwareId));
                              if (context.mounted) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(content: Text('Device ID copied')));
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Kiosk
                      _SectionCard(
                        title: 'KIOSK Settings',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (p.kiosks.isNotEmpty) ...[
                              DropdownButtonFormField<String?>(
                                key: const Key('kiosk'),
                                initialValue: _kioskId,
                                isExpanded: true,
                                decoration: _input(null),
                                items: [
                                  const DropdownMenuItem<String?>(child: Text('No kiosk')),
                                  for (final k in p.kiosks)
                                    DropdownMenuItem<String?>(
                                      value: k.id,
                                      child: Text(k.name, overflow: TextOverflow.ellipsis),
                                    ),
                                ],
                                onChanged: busy ? null : (v) => setState(() => _kioskId = v),
                              ),
                              const SizedBox(height: 8),
                            ],
                            _CheckRow(
                              key: const Key('kioskWise'),
                              label: 'Kiosk Wise Order Listing',
                              value: _kioskWise,
                              onChanged: busy ? null : (v) => setState(() => _kioskWise = v),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 22),
                      // Role
                      _SectionCard(
                        child: RadioGroup<DeviceType>(
                          groupValue: _type,
                          onChanged: (v) {
                            if (!busy && v != null) setState(() => _type = v);
                          },
                          child: Column(
                            children: [
                              for (final t in DeviceType.values)
                                InkWell(
                                  key: Key('type-${t.name}'),
                                  onTap: busy ? null : () => setState(() => _type = t),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    child: Row(
                                      children: [
                                        Radio<DeviceType>(value: t, activeColor: PosColors.accent),
                                        SizedBox(width: r.s(24)),
                                        Flexible(
                                          child: Text(
                                            t == DeviceType.cashier ? 'Cashier Device' : 'Captain Device',
                                            style: text.titleLarge?.copyWith(letterSpacing: 0.4),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),
                      // Delivery manager
                      _SectionCard(
                        title: 'Delivery Manager Settings',
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Column(
                            children: [
                              _CheckRow(
                                key: const Key('deliveryManagerPos'),
                                label: 'Delivery Manager POS',
                                value: _deliveryManager,
                                onChanged: busy ? null : (v) => setState(() => _deliveryManager = v),
                              ),
                              _CheckRow(
                                key: const Key('settleAssignedOnly'),
                                label: 'Settle Assigned Orders Only',
                                value: _settleAssignedOnly,
                                onChanged: busy ? null : (v) => setState(() => _settleAssignedOnly = v),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (state.failure != null) ...[
                        const SizedBox(height: 16),
                        _Error(state.failure!, key: const Key('setupError')),
                      ],
                      const SizedBox(height: 24),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: _NavyButton(
                          key: const Key('registerButton'),
                          label: 'Register Device',
                          busy: busy,
                          onPressed: _register,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  InputDecoration _input(String? label, {String? hint}) => InputDecoration(
    labelText: label,
    hintText: hint,
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
  );
}

class _Header extends StatelessWidget {
  const _Header({required this.title, this.onBack});

  final String title;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    return SizedBox(
      width: double.infinity,
      height: math.max(56, r.s(72)),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (onBack != null)
            Positioned(
              left: 4,
              child: IconButton(
                key: const Key('backButton'),
                icon: const Icon(Icons.arrow_back_ios_new),
                onPressed: onBack,
              ),
            ),
          // Clear of the back button; one line.
          Padding(
            padding: EdgeInsets.symmetric(horizontal: r.minTap + 12),
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child, this.title});

  final Widget child;
  final String? title;

  @override
  Widget build(BuildContext context) => Material(
    color: PosColors.card,
    elevation: 1.5,
    shadowColor: Colors.black26,
    borderRadius: BorderRadius.circular(14),
    child: Padding(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null) ...[
            Text(title!, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 14),
          ],
          child,
        ],
      ),
    ),
  );
}

class _CheckRow extends StatelessWidget {
  const _CheckRow({super.key, required this.label, required this.value, required this.onChanged});

  final String label;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onChanged == null ? null : () => onChanged!(!value),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(label, style: Theme.of(context).textTheme.titleMedium)),
          Checkbox(
            value: value,
            activeColor: PosColors.accent,
            onChanged: onChanged == null ? null : (v) => onChanged!(v ?? false),
          ),
        ],
      ),
    ),
  );
}

class _NavyButton extends StatelessWidget {
  const _NavyButton({super.key, required this.label, required this.busy, required this.onPressed});

  final String label;
  final bool busy;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: math.max(232, context.r.s(300)),
    height: context.r.tap(56),
    child: FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: PosColors.navy,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      onPressed: busy ? null : onPressed,
      child: busy
          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
          : Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: math.max(16, context.r.f(18)), color: Colors.white),
            ),
    ),
  );
}

class _Error extends StatelessWidget {
  const _Error(this.failure, {super.key});

  final Failure failure;

  @override
  Widget build(BuildContext context) =>
      Text(failure.userMessage, style: TextStyle(color: Theme.of(context).colorScheme.error));
}
