// Dialog QR checkpoint untuk dicetak/ditempel di TPS (presentation).
//
// Render kode QR via pretty_qr_code yang sudah ada; tanpa dependency baru.

import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../checkpoints/domain/entities/checkpoint.dart';

/// Tampilkan dialog QR [checkpoint] (kode + nama + gambar QR).
Future<void> showCheckpointQrDialog(
  BuildContext context,
  Checkpoint checkpoint,
) {
  final String code = checkpoint.qrCode ?? checkpoint.code ?? '-';
  return showDialog<void>(
    context: context,
    builder: (BuildContext ctx) => AlertDialog(
      title: Text(
        checkpoint.name,
        style: AppTypography.labelLg,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            width: 200,
            height: 200,
            child: PrettyQrView.data(data: code),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(code, style: AppTypography.labelLg),
          const SizedBox(height: AppSpacing.xs),
          Text(
            AppStrings.adminQrPrintHint,
            style: AppTypography.bodySm,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: Text(AppStrings.closeButton),
        ),
      ],
    ),
  );
}
