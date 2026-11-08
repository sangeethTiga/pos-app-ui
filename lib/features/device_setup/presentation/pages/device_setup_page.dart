import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes.dart';
import '../../../../core/error/failure.dart';
import '../../../terminal/terminal_cubit.dart';
import '../bloc/device_setup_bloc.dart';

/// Pair this terminal: store code + one-time registration code from the admin panel.
class DeviceSetupPage extends StatefulWidget {
  const DeviceSetupPage({super.key});

  @override
  State<DeviceSetupPage> createState() => _DeviceSetupPageState();
}

class _DeviceSetupPageState extends State<DeviceSetupPage> {
  final _form = GlobalKey<FormState>();
  final _storeCode = TextEditingController();
  final _registrationCode = TextEditingController();
  final _deviceName = TextEditingController(text: 'POS');

  @override
  void dispose() {
    _storeCode.dispose();
    _registrationCode.dispose();
    _deviceName.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_form.currentState!.validate()) return;
    context.read<DeviceSetupBloc>().add(
      DeviceSetupEvent.submitted(
        storeCode: _storeCode.text,
        registrationCode: _registrationCode.text,
        deviceName: _deviceName.text,
      ),
    );
  }

  String? _required(String? v) => (v == null || v.trim().isEmpty) ? 'Required' : null;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DeviceSetupBloc, DeviceSetupState>(
      listener: (context, state) {
        if (state is DeviceSetupPaired) {
          context.read<TerminalCubit>().start(state.session);
          context.go(Routes.lock);
        }
      },
      builder: (context, state) {
        final busy = state is DeviceSetupSubmitting;
        return Scaffold(
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Card(
                margin: const EdgeInsets.all(24),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _form,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('Pair this terminal', style: Theme.of(context).textTheme.headlineSmall),
                        const SizedBox(height: 8),
                        Text(
                          'Ask a manager for the store code and a registration code from the admin panel.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          key: const Key('storeCode'),
                          controller: _storeCode,
                          enabled: !busy,
                          textCapitalization: TextCapitalization.characters,
                          decoration: const InputDecoration(labelText: 'Store code', hintText: 'ST-0007'),
                          validator: _required,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          key: const Key('registrationCode'),
                          controller: _registrationCode,
                          enabled: !busy,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Registration code'),
                          validator: _required,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          key: const Key('deviceName'),
                          controller: _deviceName,
                          enabled: !busy,
                          decoration: const InputDecoration(labelText: 'Terminal name', hintText: 'POS-1 Main counter'),
                          validator: _required,
                          onFieldSubmitted: (_) => _submit(),
                        ),
                        if (state is DeviceSetupFailure) ...[
                          const SizedBox(height: 16),
                          Text(
                            state.failure.userMessage,
                            key: const Key('setupError'),
                            style: TextStyle(color: Theme.of(context).colorScheme.error),
                          ),
                        ],
                        const SizedBox(height: 24),
                        FilledButton(
                          key: const Key('pairButton'),
                          onPressed: busy ? null : _submit,
                          child: busy
                              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                              : const Text('Pair terminal'),
                        ),
                      ],
                    ),
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
