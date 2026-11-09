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
import '../../domain/activation_policy.dart';
import '../../domain/entities/device_session.dart';
import '../bloc/device_setup_bloc.dart';
import '../cubit/activation_cubit.dart';
import '../widgets/activation_text.dart';
import 'activation_gate_page.dart' show ActivationCodeFormatter;

/// Set up this terminal on one page: the activation code from the platform administrator (checked as
/// soon as it is complete: store name, kiosks), device name, device id, kiosk, cashier / captain and
/// delivery manager flags. "Activate" pairs AND activates the terminal in one call.
class DeviceSetupPage extends StatefulWidget {
  const DeviceSetupPage({super.key});

  @override
  State<DeviceSetupPage> createState() => _DeviceSetupPageState();
}

class _DeviceSetupPageState extends State<DeviceSetupPage> {
  final _form = GlobalKey<FormState>();
  final _code = TextEditingController();
  final _deviceName = TextEditingController();

  String? _kioskId;
  DeviceType _type = DeviceType.cashier;
  bool _kioskWise = false;
  bool _deliveryManager = false;
  bool _settleAssignedOnly = false;

  @override
  void initState() {
    super.initState();
    // Opened after an unpair: the bloc still holds the old session; read the stored state again.
    final bloc = context.read<DeviceSetupBloc>();
    if (bloc.state is! DeviceSetupUnpaired) bloc.add(const DeviceSetupEvent.started());
  }

  @override
  void dispose() {
    _code.dispose();
    _deviceName.dispose();
    super.dispose();
  }

  String? _required(String? v) => (v == null || v.trim().isEmpty) ? 'Required' : null;

  String? _completeCode(String? v) =>
      ActivationCode.isComplete(v ?? '') ? null : 'Enter the 12-character code (XXXX-XXXX-XXXX).';

  void _activate() {
    if (!_form.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final bloc = context.read<DeviceSetupBloc>();
    // Only a kiosk of the store behind the current code (the list goes when the code is edited).
    final kiosks = switch (bloc.state) {
      DeviceSetupUnpaired(:final preview?) => preview.kiosks,
      _ => const <KioskOption>[],
    };
    final kioskId = kiosks.any((k) => k.id == _kioskId) ? _kioskId : null;
    bloc.add(
      DeviceSetupEvent.activateSubmitted(
        code: _code.text,
        deviceName: _deviceName.text,
        profile: DeviceProfile(
          deviceType: _type,
          kioskId: kioskId,
          kioskWiseOrderListing: _kioskWise,
          deliveryManagerPos: _deliveryManager,
          settleAssignedOrdersOnly: _settleAssignedOnly,
        ),
      ),
    );
  }

  /// Paired and activated: start the terminal. The activation came with the setup response and is
  /// already stored, so the gate decision needs no extra round trip.
  Future<void> _start(BuildContext context, DeviceSession session) async {
    context.read<TerminalCubit>().start(session);
    final activation = context.read<ActivationCubit>();
    await activation.start(session.deviceId);
    if (!context.mounted) return;
    context.go(activation.state.canSell ? Routes.lock : Routes.activation);
  }

  /// A new store behind the code: forget choices that do not fit it.
  void _onPreview(SetupPreview p) {
    setState(() {
      if (!p.kiosks.any((k) => k.id == _kioskId)) _kioskId = null;
      if (p.deviceTypes.isNotEmpty && !p.deviceTypes.contains(_type)) _type = p.deviceTypes.first;
    });
    // Re-pairing an existing terminal: keep its name unless one was typed.
    if (_deviceName.text.trim().isEmpty && p.deviceName != null) _deviceName.text = p.deviceName!;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DeviceSetupBloc, DeviceSetupState>(
      listenWhen: (a, b) =>
          b is DeviceSetupPaired ||
          (b is DeviceSetupUnpaired && b.preview != null && (a is! DeviceSetupUnpaired || a.preview != b.preview)),
      listener: (context, state) {
        if (state is DeviceSetupPaired) _start(context, state.session);
        if (state is DeviceSetupUnpaired && state.preview != null) _onPreview(state.preview!);
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
            body: SafeArea(
              child: _page(context, state is DeviceSetupUnpaired ? state : const DeviceSetupUnpaired(), r),
            ),
          ),
        );
      },
    );
  }

  Widget _page(BuildContext context, DeviceSetupUnpaired state, Responsive r) {
    final p = state.preview;
    final busy = state.submitting;
    final text = Theme.of(context).textTheme;
    final types = p == null || p.deviceTypes.isEmpty ? DeviceType.values : p.deviceTypes;
    final kiosks = p?.kiosks ?? const <KioskOption>[];
    return Column(
      children: [
        const _Header(title: 'Set up terminal'),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(r.gutter, 8, r.gutter, r.s(32) + 8),
            child: Center(
              child: ConstrainedBox(
                // One centred column; wide enough for the cards, not a line across a TV.
                constraints: BoxConstraints(maxWidth: math.max(560, r.s(860))),
                child: Form(
                  key: _form,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Activation code + the store behind it
                      _SectionCard(
                        title: 'Activation code',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text('Enter the activation code from your platform administrator.', style: text.bodyMedium),
                            const SizedBox(height: 14),
                            TextFormField(
                              key: const Key('activationCodeField'),
                              controller: _code,
                              enabled: !busy,
                              textCapitalization: TextCapitalization.characters,
                              autocorrect: false,
                              enableSuggestions: false,
                              inputFormatters: [ActivationCodeFormatter()],
                              style: const TextStyle(fontSize: 22, letterSpacing: 2),
                              decoration: _input('Activation code*', hint: 'XXXX-XXXX-XXXX'),
                              validator: _completeCode,
                              onChanged: (v) => context.read<DeviceSetupBloc>().add(DeviceSetupEvent.codeChanged(v)),
                            ),
                            if (state.checking) ...[
                              const SizedBox(height: 14),
                              const Row(
                                key: Key('previewChecking'),
                                children: [
                                  SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2)),
                                  SizedBox(width: 12),
                                  Text('Checking the code…'),
                                ],
                              ),
                            ],
                            if (state.previewFailure case final f?) ...[
                              const SizedBox(height: 14),
                              _Error(f, key: const Key('previewError')),
                            ],
                            if (p != null) ...[
                              const SizedBox(height: 14),
                              Container(
                                key: const Key('storeCard'),
                                padding: EdgeInsets.symmetric(
                                  horizontal: math.max(16, r.s(28)),
                                  vertical: math.max(16, r.s(24)),
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.grey.shade500),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(p.storeName, style: text.titleLarge?.copyWith(fontWeight: FontWeight.w500)),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Store code ${p.storeCode}'
                                      '${p.rePair ? '  ·  re-pairing terminal ${p.deviceCode ?? ''}'.trimRight() : ''}',
                                      style: text.bodySmall?.copyWith(color: Colors.grey.shade600),
                                    ),
                                  ],
                                ),
                              ),
                            ],
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
                      // Device id + copy
                      if (state.hardwareId case final hardwareId?) ...[
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                key: const Key('hardwareId'),
                                initialValue: hardwareId,
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
                                await Clipboard.setData(ClipboardData(text: hardwareId));
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(content: Text('Device ID copied')));
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 16),
                      // Kiosk (the list comes with the code)
                      _SectionCard(
                        title: 'KIOSK Settings',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (kiosks.isNotEmpty) ...[
                              // A new store rebuilds the field so a cleared choice shows as cleared.
                              KeyedSubtree(
                                key: ValueKey(p?.storeId),
                                child: DropdownButtonFormField<String?>(
                                  key: const Key('kiosk'),
                                  initialValue: _kioskId,
                                  isExpanded: true,
                                  decoration: _input(null),
                                  items: [
                                    const DropdownMenuItem<String?>(child: Text('No kiosk')),
                                    for (final k in kiosks)
                                      DropdownMenuItem<String?>(
                                        value: k.id,
                                        child: Text(k.name, overflow: TextOverflow.ellipsis),
                                      ),
                                  ],
                                  onChanged: busy ? null : (v) => setState(() => _kioskId = v),
                                ),
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
                              for (final t in types)
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
                          key: const Key('activateButton'),
                          label: 'Activate',
                          busy: busy,
                          onPressed: _activate,
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
  const _Header({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    return SizedBox(
      width: double.infinity,
      height: math.max(56, r.s(72)),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: r.minTap + 12),
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.black),
          ),
        ),
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
      Text(setupFailureMessage(failure), style: TextStyle(color: Theme.of(context).colorScheme.error));
}
