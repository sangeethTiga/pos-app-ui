import '../../domain/entities/device_activation.dart';

const _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

/// "9 Dec 2026" in [toLocal]'s time zone (the store's when given, else the device's).
String activationDate(DateTime utc, [DateTime Function(DateTime utc)? toLocal]) {
  final d = toLocal != null ? toLocal(utc.toUtc()) : utc.toLocal();
  return '${d.day} ${_months[d.month - 1]} ${d.year}';
}

/// "Not activated", "Expired on 9 Dec 2026", "Suspended", "Revoked", "Starts on ...", "Active until ...".
String activationHeadline(ActivationVerdict v, [DateTime Function(DateTime utc)? toLocal]) => switch (v.block) {
  null => v.expiresAt == null ? 'Active' : 'Active until ${activationDate(v.expiresAt!, toLocal)}',
  ActivationBlock.notActivated => 'Not activated',
  ActivationBlock.scheduled => v.startsAt == null ? 'Scheduled' : 'Starts on ${activationDate(v.startsAt!, toLocal)}',
  ActivationBlock.expired => v.expiresAt == null ? 'Expired' : 'Expired on ${activationDate(v.expiresAt!, toLocal)}',
  ActivationBlock.suspended => 'Suspended',
  ActivationBlock.revoked => 'Revoked',
};

const askAdministrator = 'Ask your administrator for an activation code for this terminal.';

/// One or two sentences under the headline.
String activationExplanation(ActivationVerdict v) => switch (v.block) {
  null => 'This terminal may take orders.',
  ActivationBlock.notActivated => askAdministrator,
  ActivationBlock.scheduled =>
    'The activation of this terminal has not started yet. New orders open on the start date.',
  ActivationBlock.expired => 'The activation of this terminal has ended. $askAdministrator',
  ActivationBlock.suspended => 'Your administrator suspended this terminal. Ask them to resume it or for a new code.',
  ActivationBlock.revoked => 'The activation of this terminal was revoked. $askAdministrator',
};

/// "Activation expires in 3 days" / "in 1 day" / "today".
String expiryWarning(int days) => switch (days) {
  <= 0 => 'Activation expires today',
  1 => 'Activation expires in 1 day',
  _ => 'Activation expires in $days days',
};
