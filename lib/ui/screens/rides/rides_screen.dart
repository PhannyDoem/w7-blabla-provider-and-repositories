import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week_3_blabla_project/ui/provider/ride_pref_provider.dart';
import '../../../model/ride/ride_filter.dart';
import 'widgets/ride_pref_bar.dart';

import '../../../model/ride/ride.dart';
import '../../../model/ride/ride_pref.dart';
import '../../../service/rides_service.dart';
import '../../theme/theme.dart';
import '../../../utils/animations_util.dart';
import 'widgets/ride_pref_modal.dart';
import 'widgets/rides_tile.dart';

///
///  The Ride Selection screen allow user to select a ride, once ride preferences have been defined.
///  The screen also allow user to re-define the ride preferences and to activate some filters.
///

// ignore: must_be_immutable
class RidesScreen extends StatelessWidget {
  RidesScreen({super.key});

  RideFilter currentFilter = RideFilter();

  void onBackPressed(BuildContext context) {
    // 1 - Back to the previous view
    Navigator.of(context).pop();
  }

  onRidePrefSelected(BuildContext context, RidePreference newPreference) async {
    // 1 - Update the current preference
    context.read<RidePrefProivder>().setCurrentPreference(newPreference);
  }

  void onPreferencePressed(BuildContext context) async {
    // Open a modal to edit the ride preferences
    RidePreference? newPreference = await Navigator.of(
      context,
    ).push<RidePreference>(
      AnimationUtils.createTopToBottomRoute(
        RidePrefModal(
            initialPreference:
                context.read<RidePrefProivder>().currentPreference),
      ),
    );

    if (newPreference != null) {
      // ignore: use_build_context_synchronously
      onRidePrefSelected(context, newPreference);
    }
  }

  void onFilterPressed() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          left: BlaSpacings.m,
          right: BlaSpacings.m,
          top: BlaSpacings.s,
        ),
        child: Consumer<RidePrefProivder>(
          builder: (context, ridePrefProvider, child) {
            RidePreference currentPreference =
                ridePrefProvider.currentPreference!;

            List<Ride> matchingRides = RidesService.instance.getRidesFor(
              currentPreference,
              currentFilter,
            );

            return Column(
              children: [
                // Top search Search bar
                RidePrefBar(
                  ridePreference: currentPreference,
                  onBackPressed: () => onBackPressed(context),
                  onPreferencePressed: () => onPreferencePressed(context),
                  onFilterPressed: onFilterPressed,
                ),

                Expanded(
                  child: ListView.builder(
                    itemCount: matchingRides.length,
                    itemBuilder: (ctx, index) =>
                        RideTile(ride: matchingRides[index], onPressed: () {}),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
