import '../../../../core/constants/app_strings.dart';
import '../../domain/entities/user_role.dart';

extension UserRoleLabel on UserRole {
  String get label => switch (this) {
    UserRole.superAdmin => AppStrings.roleSuperAdmin,
    UserRole.opsManager => AppStrings.roleOpsManager,
    UserRole.dispatcher => AppStrings.roleDispatcher,
    UserRole.support => AppStrings.roleSupport,
    UserRole.viewer => AppStrings.roleViewer,
    UserRole.unknown => AppStrings.roleUnknown,
  };
}
