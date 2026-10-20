import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/theme/app_dimensions.dart';
import '../../../../core/utils/responsive.dart';
import '../../../auth/domain/entities/current_user.dart';
import '../../../auth/presentation/bloc/auth/auth_bloc.dart';
import '../../../auth/presentation/widgets/permission_gate.dart';
import '../navigation/nav_destination.dart';
import '../navigation/nav_destinations.dart';
import '../widgets/mobile_navigation.dart';
import '../widgets/no_access_view.dart';
import '../widgets/section_placeholder.dart';
import '../widgets/shell_app_bar.dart';
import '../widgets/web_navigation.dart';

/// The signed-in frame around every section: app bar, menu and the section.
///
/// The menu lists only the sections the user's permissions allow, and the
/// section is wrapped in a [PermissionGate] that shows [NoAccessView]
/// without the permission. Both rebuild when the permissions change.
class ShellPage extends StatelessWidget {
  const ShellPage({this.destination, super.key});

  /// The open section; null when the user may open no section at all.
  final NavDestination? destination;

  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthBloc bloc) {
      final state = bloc.state;
      if (state is AuthAuthenticated) return state.user;
      return null;
    });
    // Briefly null while signing out, before the page is replaced.
    if (user == null) return const Scaffold();

    final destinations = NavDestinations.allowedFor(user.permissions);
    if (context.isMobile) return _buildMobile(context, user, destinations);
    return _buildWeb(context, user, destinations);
  }

  Widget _buildMobile(
    BuildContext context,
    CurrentUser user,
    List<NavDestination> destinations,
  ) {
    return Scaffold(
      appBar: ShellAppBar(user: user),
      drawer: destinations.isEmpty
          ? null
          : MobileNavigation(
              destinations: destinations,
              selectedIndex: _selectedIndex(destinations),
              onSelected: (selected) => _open(context, selected),
            ),
      body: _buildSection(),
    );
  }

  Widget _buildWeb(
    BuildContext context,
    CurrentUser user,
    List<NavDestination> destinations,
  ) {
    return Scaffold(
      appBar: ShellAppBar(user: user),
      body: Row(
        children: [
          if (destinations.isNotEmpty) ...[
            WebNavigation(
              destinations: destinations,
              selectedIndex: _selectedIndex(destinations),
              onSelected: (selected) => _open(context, selected),
            ),
            const VerticalDivider(width: AppDimensions.dividerThin),
          ],
          Expanded(child: _buildSection()),
        ],
      ),
    );
  }

  Widget _buildSection() {
    final destination = this.destination;
    if (destination == null) return const NoAccessView.noSections();
    return PermissionGate(
      permission: destination.permission,
      fallback: NoAccessView.section(destination.label),
      child: SectionPlaceholder(destination: destination),
    );
  }

  /// Null when the open section is not in the menu (no access).
  int? _selectedIndex(List<NavDestination> destinations) {
    final destination = this.destination;
    if (destination == null) return null;
    final index = destinations.indexOf(destination);
    if (index < 0) return null;
    return index;
  }

  /// Replaces the page, so switching sections never piles up old sections
  /// (and their realtime connections) on the back stack.
  void _open(BuildContext context, NavDestination selected) {
    if (selected == destination) return;
    Navigator.of(context).pushNamedAndRemoveUntil(selected.route, (_) => false);
  }
}
