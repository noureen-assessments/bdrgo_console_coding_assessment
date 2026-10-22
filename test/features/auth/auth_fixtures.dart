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

CurrentUser userWith(Permissions permissions) => CurrentUser(
  id: 'u2',
  name: 'Vera Viewer',
  email: 'viewer.doha@demo.test',
  role: UserRole.viewer,
  city: const City(id: 'city_doh', name: 'Doha'),
  permissions: permissions,
);
