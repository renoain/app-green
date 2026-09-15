// Widget test komponen card: InfoCard, PointCard, ArticleCard,
// ActivityCard, RewardCard.

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:go_green/core/theme/app_theme.dart';
import 'package:go_green/core/widgets/card_widgets.dart';
import 'package:go_green/core/widgets/status_widgets.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    theme: AppTheme.light(),
    home: Scaffold(
      body: SingleChildScrollView(child: child),
    ),
  );
}

void main() {
  group('InfoCard', () {
    testWidgets('menampilkan judul dan deskripsi', (WidgetTester tester) async {
      await tester.pumpWidget(
        _wrap(
          const InfoCard(
            title: 'Buang Sampah',
            subtitle: 'Ambil foto di checkpoint terdekat',
            icon: LucideIcons.recycle,
          ),
        ),
      );

      expect(find.text('Buang Sampah'), findsOneWidget);
      expect(find.text('Ambil foto di checkpoint terdekat'), findsOneWidget);
    });

    testWidgets('memicu onTap saat ditekan', (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        _wrap(
          InfoCard(
            title: 'Lihat Poin',
            icon: LucideIcons.star,
            onTap: () => tapped = true,
          ),
        ),
      );

      await tester.tap(find.byType(InfoCard));
      expect(tapped, isTrue);
    });
  });

  group('PointCard', () {
    testWidgets('menampilkan label dan poin berformat ribuan', (WidgetTester tester) async {
      await tester.pumpWidget(
        _wrap(
          const PointCard(
            point: 1250,
            label: 'Total Poin',
            icon: LucideIcons.coins,
          ),
        ),
      );

      expect(find.text('Total Poin'), findsOneWidget);
      expect(find.text('1.250'), findsOneWidget);
    });
  });

  group('ArticleCard', () {
    testWidgets('menampilkan judul, ringkasan, dan tanggal', (WidgetTester tester) async {
      await tester.pumpWidget(
        _wrap(
          ArticleCard(
            title: 'Pilah Sampah',
            excerpt: 'Cara sederhana memilah sampah.',
            date: DateTime(2026, 9, 12),
          ),
        ),
      );

      expect(find.text('Pilah Sampah'), findsOneWidget);
      expect(find.text('Cara sederhana memilah sampah.'), findsOneWidget);
      expect(find.text('12 Sep 2026'), findsOneWidget);
    });

    testWidgets('memicu onTap saat ditekan', (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        _wrap(
          ArticleCard(
            title: 'Pilah Sampah',
            date: DateTime(2026, 9, 12),
            onTap: () => tapped = true,
          ),
        ),
      );

      await tester.tap(find.byType(ArticleCard));
      expect(tapped, isTrue);
    });
  });

  group('ActivityCard', () {
    testWidgets('menampilkan deskripsi, tanggal, poin, dan status success',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        _wrap(
          ActivityCard(
            date: DateTime(2026, 9, 12),
            description: 'Buang sampah organik di TPS Kelurahan',
            point: 25,
          ),
        ),
      );

      expect(find.text('Buang sampah organik di TPS Kelurahan'), findsOneWidget);
      expect(find.text('12 Sep 2026'), findsOneWidget);
      expect(find.text('+25'), findsOneWidget);
      expect(find.text('Berhasil'), findsOneWidget);
    });

    testWidgets('menampilkan status menunggu dan poin negatif',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        _wrap(
          ActivityCard(
            date: DateTime(2026, 9, 10),
            description: 'Poin dipakai untuk donasi',
            point: -10,
            status: StatusType.warning,
          ),
        ),
      );

      expect(find.text('-10'), findsOneWidget);
      expect(find.text('Menunggu verifikasi'), findsOneWidget);
    });

    testWidgets('memicu onTap saat ditekan', (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        _wrap(
          ActivityCard(
            date: DateTime(2026, 9, 12),
            description: 'Buang sampah organik',
            point: 25,
            onTap: () => tapped = true,
          ),
        ),
      );

      await tester.tap(find.byType(ActivityCard));
      expect(tapped, isTrue);
    });
  });

  group('RewardCard', () {
    testWidgets('menampilkan judul, deskripsi, dan harga poin', (WidgetTester tester) async {
      await tester.pumpWidget(
        _wrap(
          const RewardCard(
            title: 'Paket Sembako',
            description: 'Bahan pokok untuk kebutuhan mingguan.',
            pointCost: 300,
            icon: LucideIcons.gift,
          ),
        ),
      );

      expect(find.text('Paket Sembako'), findsOneWidget);
      expect(find.text('Bahan pokok untuk kebutuhan mingguan.'), findsOneWidget);
      expect(find.text('300 Poin'), findsOneWidget);
    });

    testWidgets('memicu onTap saat ditekan', (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        _wrap(
          RewardCard(
            title: 'Saldo E-Wallet',
            description: 'Isi saldo e-wallet.',
            pointCost: 150,
            icon: LucideIcons.wallet,
            onTap: () => tapped = true,
          ),
        ),
      );

      await tester.tap(find.byType(RewardCard));
      expect(tapped, isTrue);
    });
  });
}