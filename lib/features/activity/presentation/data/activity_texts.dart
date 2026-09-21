// Teks tampilan aktivitas bersama (presentation).
//
// Dipakai ActivityPage dan Home agar deskripsi + label status dari
// waste log tidak diduplikasi.

import '../../../../core/constants/app_enums.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/status_widgets.dart';
import '../../../waste/domain/entities/waste_log.dart';

/// Status UI untuk satu waste log.
({StatusType type, String label}) activityStatusOf(WasteLogStatus status) {
  return switch (status) {
    WasteLogStatus.verified => (
        type: StatusType.success,
        label: AppStrings.activityStatusSuccess,
      ),
    WasteLogStatus.pending => (
        type: StatusType.warning,
        label: AppStrings.activityStatusPending,
      ),
    WasteLogStatus.rejected => (
        type: StatusType.error,
        label: AppStrings.verificationFailed,
      ),
  };
}

/// Deskripsi aktivitas dari waste log dan nama checkpoint.
String activityDescriptionOf(WasteLog log, String checkpointName) {
  return '${AppStrings.activityLogPrefix} ${log.category.value} '
      '${AppStrings.activityLogAt} $checkpointName';
}
