import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'app_database.dart';

/// On-device database file `pos_terminal.sqlite` in the app support directory.
AppDatabase openAppDatabase() => AppDatabase(driftDatabase(name: 'pos_terminal'));

/// For tests.
AppDatabase openTestDatabase(QueryExecutor executor) => AppDatabase(executor);
