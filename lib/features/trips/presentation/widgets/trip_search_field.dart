import 'package:flutter/material.dart';

import '../../../../config/theme/app_dimensions.dart';
import '../../../../config/theme/app_styles.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_strings.dart';

class TripSearchField extends StatefulWidget {
  const TripSearchField({
    required this.search,
    required this.onSubmitted,
    super.key,
  });

  final String? search;
  final ValueChanged<String?> onSubmitted;

  @override
  State<TripSearchField> createState() => _TripSearchFieldState();
}

class _TripSearchFieldState extends State<TripSearchField> {
  late final _controller = TextEditingController(text: widget.search);

  @override
  void didUpdateWidget(TripSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.search != widget.search) {
      _controller.text = widget.search ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppDimensions.searchFieldWidth,
      child: TextField(
        controller: _controller,
        textInputAction: TextInputAction.search,
        onSubmitted: _submit,
        decoration: InputDecoration(
          hintText: AppStrings.searchTrips,
          prefixIcon: const Icon(AppAssets.search),
          border: AppStyles.inputBorder,
          isDense: true,
          suffixIcon: widget.search == null
              ? null
              : IconButton(
                  tooltip: AppStrings.clearSearch,
                  onPressed: () => widget.onSubmitted(null),
                  icon: const Icon(AppAssets.clear),
                ),
        ),
      ),
    );
  }

  void _submit(String text) {
    final trimmed = text.trim();
    widget.onSubmitted(trimmed.isEmpty ? null : trimmed);
  }
}
