import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/theme/app_dimensions.dart';
import '../../../../core/utils/responsive.dart';
import '../bloc/driver_detail/driver_detail_bloc.dart';
import 'driver_detail_panel.dart';

class LiveMapLayout extends StatelessWidget {
  const LiveMapLayout({required this.map, super.key});

  final Widget map;

  @override
  Widget build(BuildContext context) {
    final isOpen = context.select(
      (DriverDetailBloc bloc) => bloc.state is! DriverDetailClosed,
    );
    final isMobile = context.isMobile;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Stack(
            children: [
              map,
              if (isOpen && isMobile)
                Positioned(
                  left: AppDimensions.spaceSm,
                  right: AppDimensions.spaceSm,
                  bottom: AppDimensions.spaceSm,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxHeight: AppDimensions.driverPanelMaxHeight,
                    ),
                    child: const DriverDetailPanel(),
                  ),
                ),
            ],
          ),
        ),
        if (isOpen && !isMobile)
          const SizedBox(
            width: AppDimensions.driverPanelWidth,
            child: DriverDetailPanel(),
          ),
      ],
    );
  }
}
