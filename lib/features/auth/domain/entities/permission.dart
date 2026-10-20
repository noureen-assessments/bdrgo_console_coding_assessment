enum PermissionResource {
  user('user', UserPermission.values),
  session('session', SessionPermission.values),
  city('city', CityPermission.values),
  driver('driver', DriverPermission.values),
  rider('rider', RiderPermission.values),
  trip('trip', TripPermission.values),
  alert('alert', AlertPermission.values),
  kpi('kpi', KpiPermission.values),
  pii('pii', PiiPermission.values),
  simulator('simulator', SimulatorPermission.values);

  const PermissionResource(this.value, this.actions);

  final String value;

  final List<Permission> actions;

  static PermissionResource? fromValue(String value) =>
      values.where((resource) => resource.value == value).firstOrNull;

  Permission? action(String value) =>
      actions.where((action) => action.value == value).firstOrNull;
}

sealed class Permission {
  PermissionResource get resource;

  String get value;
}

enum UserPermission implements Permission {
  create('create'),
  list('list'),
  get('get'),
  update('update'),
  delete('delete'),
  setRole('set-role'),
  ban('ban'),
  impersonate('impersonate'),
  setPassword('set-password'),
  setEmail('set-email');

  const UserPermission(this.value);

  @override
  final String value;

  @override
  PermissionResource get resource => PermissionResource.user;
}

enum SessionPermission implements Permission {
  list('list'),
  revoke('revoke'),
  delete('delete');

  const SessionPermission(this.value);

  @override
  final String value;

  @override
  PermissionResource get resource => PermissionResource.session;
}

enum CityPermission implements Permission {
  read('read'),
  create('create'),
  update('update');

  const CityPermission(this.value);

  @override
  final String value;

  @override
  PermissionResource get resource => PermissionResource.city;
}

enum DriverPermission implements Permission {
  read('read'),
  create('create'),
  update('update'),

  track('track'),

  message('message');

  const DriverPermission(this.value);

  @override
  final String value;

  @override
  PermissionResource get resource => PermissionResource.driver;
}

enum RiderPermission implements Permission {
  read('read'),
  create('create'),
  update('update');

  const RiderPermission(this.value);

  @override
  final String value;

  @override
  PermissionResource get resource => PermissionResource.rider;
}

enum TripPermission implements Permission {
  read('read'),
  create('create'),
  assign('assign'),
  cancel('cancel'),
  refund('refund');

  const TripPermission(this.value);

  @override
  final String value;

  @override
  PermissionResource get resource => PermissionResource.trip;
}

enum AlertPermission implements Permission {
  read('read'),
  acknowledge('acknowledge');

  const AlertPermission(this.value);

  @override
  final String value;

  @override
  PermissionResource get resource => PermissionResource.alert;
}

enum KpiPermission implements Permission {
  read('read');

  const KpiPermission(this.value);

  @override
  final String value;

  @override
  PermissionResource get resource => PermissionResource.kpi;
}

enum PiiPermission implements Permission {
  read('read');

  const PiiPermission(this.value);

  @override
  final String value;

  @override
  PermissionResource get resource => PermissionResource.pii;
}

enum SimulatorPermission implements Permission {
  control('control');

  const SimulatorPermission(this.value);

  @override
  final String value;

  @override
  PermissionResource get resource => PermissionResource.simulator;
}
