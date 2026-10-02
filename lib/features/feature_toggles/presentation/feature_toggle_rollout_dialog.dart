import 'package:flutter/material.dart';

import '../../../common/widgets/form_dialog.dart';
import '../../../common/widgets/rollout_slider.dart';
import '../data/models/request_models.dart';
import '../data/models/response_models.dart';
import 'feature_toggles_controller.dart';

Future<bool?> showEditRolloutDialog(
  BuildContext context, {
  required FeatureTogglesController controller,
  required GetFeatureToggle toggle,
}) {
  final formKey = GlobalKey<FormState>();
  double rollout = (toggle.rolloutPercentage ?? 0).toDouble();
  double iosRollout = (toggle.ios ?? 0).toDouble();
  double androidRollout = (toggle.android ?? 0).toDouble();
  double webRollout = (toggle.web ?? 0).toDouble();

  return showDialog<bool>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => FormDialog(
        title: 'Rollout: ${toggle.name}',
        formKey: formKey,
        submitLabel: 'Сохранить',
        onSubmit: () => controller.updateRollout(
          toggle.id,
          UpdateFeatureToggleRolloutRequest(
            rolloutPercentage: rollout.round(),
            iosRolloutPercentage: iosRollout.round(),
            androidRolloutPercentage: androidRollout.round(),
            webRolloutPercentage: webRollout.round(),
          ),
        ),
        builder: (context) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            RolloutSlider(
              label: 'Общий rollout',
              value: rollout,
              onChanged: (v) => setState(() => rollout = v),
            ),
            RolloutSlider(
              label: 'iOS',
              value: iosRollout,
              onChanged: (v) => setState(() => iosRollout = v),
            ),
            RolloutSlider(
              label: 'Android',
              value: androidRollout,
              onChanged: (v) => setState(() => androidRollout = v),
            ),
            RolloutSlider(
              label: 'Web',
              value: webRollout,
              onChanged: (v) => setState(() => webRollout = v),
            ),
          ],
        ),
      ),
    ),
  );
}
