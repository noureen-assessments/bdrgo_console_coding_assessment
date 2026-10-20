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

/// Permission sets from the matrix in `/docs/roles` (reads a test does not
/// need are left out).
const viewerPermissions = Permissions({
  TripPermission.read,
  AlertPermission.read,
  KpiPermission.read,
});

const supportPermissions = Permissions({
  TripPermission.read,
  TripPermission.refund,
  AlertPermission.read,
  AlertPermission.acknowledge,
  PiiPermission.read,
});

const dispatcherPermissions = Permissions({
  TripPermission.read,
  TripPermission.create,
  TripPermission.assign,
  TripPermission.cancel,
  DriverPermission.track,
  DriverPermission.message,
  AlertPermission.read,
  AlertPermission.acknowledge,
  KpiPermission.read,
  PiiPermission.read,
});

/// A Doha user with [permissions]; the role is only a label.
CurrentUser userWith(Permissions permissions) => CurrentUser(
  id: 'u2',
  name: 'Vera Viewer',
  email: 'viewer.doha@demo.test',
  role: UserRole.viewer,
  city: const City(id: 'city_doh', name: 'Doha'),
  permissions: permissions,
);
