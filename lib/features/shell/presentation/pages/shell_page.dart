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
import '../widgets/shell_app_bar.dart';
import '../widgets/web_navigation.dart';

class ShellPage extends StatelessWidget {
  const ShellPage.section({
    required NavDestination this.destination,
    required Widget this.page,
    super.key,
  });

  const ShellPage.noSections({super.key}) : destination = null, page = null;

  final NavDestination? destination;
  final Widget? page;

  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthBloc bloc) {
      final state = bloc.state;
      if (state is AuthAuthenticated) return state.user;
      return null;
    });
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
    final page = this.page;
    if (destination == null || page == null) {
      return const NoAccessView.noSections();
    }
    return PermissionGate(
      permission: destination.permission,
      fallback: NoAccessView.section(destination.label),
      child: page,
    );
  }

  int? _selectedIndex(List<NavDestination> destinations) {
    final destination = this.destination;
    if (destination == null) return null;
    final index = destinations.indexOf(destination);
    if (index < 0) return null;
    return index;
  }

  void _open(BuildContext context, NavDestination selected) {
    if (selected == destination) return;
    Navigator.of(context).pushNamedAndRemoveUntil(selected.route, (_) => false);
  }
}
