import 'package:badrgo_console_assesment/features/auth/domain/entities/city.dart';
import 'package:badrgo_console_assesment/features/auth/domain/entities/current_user.dart';
import 'package:badrgo_console_assesment/features/auth/domain/entities/permission.dart';
import 'package:badrgo_console_assesment/features/auth/domain/entities/permissions.dart';
import 'package:badrgo_console_assesment/features/auth/domain/entities/user_role.dart';

const dispatcher = CurrentUser(
  id: 'u1',
  name: 'Dana Dispatcher',
  email: 'dispatch.doha@demo.test',
  role: UserRole.dispatcher,
  city: City(id: 'city_doh', name: 'Doha'),
  permissions: Permissions({TripPermission.read, TripPermission.assign}),
);

/// A `GET /api/me` body as the sandbox sends it.
Map<String, Object?> meJson() => {
  'user': {
    'id': 'u1',
    'name': 'Dana Dispatcher',
    'email': 'dispatch.doha@demo.test',
  },
  'role': 'dispatcher',
  'roleDescription': 'Assigns trips',
  'city': {'id': 'city_doh', 'name': 'Doha', 'currency': 'QAR'},
  'permissions': {
    'trip': ['read', 'assign'],
    'kpi': ['read'],
  },
};
