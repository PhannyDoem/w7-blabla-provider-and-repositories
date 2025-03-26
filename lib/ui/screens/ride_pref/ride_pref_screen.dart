import 'package:flutter/material.dart';
import 'package:week_3_blabla_project/ui/provider/ride_pref_provider.dart';
import 'package:week_3_blabla_project/ui/widgets/errors/bla_error_screen.dart';
import '../../../model/ride/ride_pref.dart';
import '../../theme/theme.dart';
import '../../../utils/animations_util.dart';
import '../rides/rides_screen.dart';
import 'widgets/ride_pref_form.dart';
import 'widgets/ride_pref_history_tile.dart';
import 'package:provider/provider.dart';


const String blablaHomeImagePath = 'assets/images/blabla_home.png';

///
/// This screen allows user to:
/// - Enter his/her ride preference and launch a search on it
/// - Or select a last entered ride preferences and launch a search on it
///

class RidePrefScreen extends StatelessWidget {
  const RidePrefScreen({super.key});

  Future<void> _onRidePrefSelected(
      BuildContext context, RidePreference newPreference) async {
    // 1 - Update the current preference
    context.read<RidePrefProivder>().setCurrentPreference(newPreference);

    // 2 - Navigate to the rides screen (with bottom to top animation)
    await Navigator.of(context).push(
      AnimationUtils.createBottomToTopRoute(
        RidesScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RidePrefProivder>(
      builder: (context, ridePrefProvider, child) {
        // Get the past preferences state
        final pastPreferencesState = ridePrefProvider.pastPreferencesState;

        // Handle the different states of pastPreferences
        if (pastPreferencesState.isLoading) {
          return const BlaError(message: 'loading');
        } else if (pastPreferencesState.isError) {
          return const BlaError(message: 'No connection. Try later');
        } else if (pastPreferencesState.isSuccess &&
            pastPreferencesState.data != null) {
          // If the state is success, display the screen as normal
          RidePreference? currentRidePreference =
              ridePrefProvider.currentPreference;
          List<RidePreference> pastPreferences = pastPreferencesState.data!;

          return Stack(
            children: [
              // 1 - Background Image
              const BlaBackground(),

              // 2 - Foreground content
              Column(
                children: [
                  const SizedBox(height: BlaSpacings.m),
                  Text(
                    "Your pick of rides at low price",
                    style: BlaTextStyles.heading.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 100),
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: BlaSpacings.xxl),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // 2.1 Display the Form to input the ride preferences
                        RidePrefForm(
                          initialPreference: currentRidePreference,
                          onSubmit: (newPreference) =>
                              _onRidePrefSelected(context, newPreference),
                        ),
                        const SizedBox(height: BlaSpacings.m),

                        // 2.2 Display list of past preferences (latest to oldest)
                        SizedBox(
                          height: 200,
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: pastPreferences.length,
                            itemBuilder: (ctx, index) => RidePrefHistoryTile(
                              ridePref: pastPreferences[index],
                              onPressed: () => _onRidePrefSelected(
                                  context, pastPreferences[index]),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        } else {
          return const BlaError(message: 'No preferences available');
        }
      },
    );
  }
}

class BlaBackground extends StatelessWidget {
  const BlaBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 340,
      child: Image.asset(
        blablaHomeImagePath,
        fit: BoxFit.cover, // Adjust image fit to cover the container
      ),
    );
  }
}
