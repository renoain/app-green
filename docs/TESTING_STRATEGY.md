# TESTING STRATEGY - Go Green

Strategi testing project. Wajib diikuti untuk semua task.

---

## 1. Framework

| Jenis            | Framework               | Catatan             |
| ---------------- | ----------------------- | ------------------- |
| Unit test        | flutter_test            | Logic domain & data |
| Widget test      | flutter_test            | Komponen reusable   |
| Integration test | integration_test        | Alur end-to-end     |
| Mocking          | mocktail                | Mock dependency     |
| Coverage         | flutter test --coverage | Target minimal      |

---

## 2. Scope per Layer

### 2.1 Domain

- Usecase: wajib unit test.
- Entity: unit test jika ada logic (mis. validasi).
- Repository interface: tidak perlu test (interface saja).

### 2.2 Data

- Model: unit test untuk fromJson/toJson.
- Datasource: unit test dengan mock HTTP client.
- Repository implementation: unit test dengan mock datasource.

### 2.3 Presentation

- Provider/notifier: unit test.
- Widget reusable: widget test.
- Halaman: widget test minimal (render tanpa error).

### 2.4 Integration

- Alur end-to-end: login, buang sampah, tukar poin.
- Dijalankan di device fisik atau emulator.

---

## 3. Target Coverage

| Fase   | Target                                                    |
| ------ | --------------------------------------------------------- |
| MVP    | Minimal unit test untuk logic inti (poin, validasi, hash) |
| Fase 2 | Minimal 70% untuk layer domain & data                     |
| Fase 3 | Minimal 80% untuk layer domain & data                     |

---

## 4. Struktur Folder Test

test/
widget_test.dart (test build aplikasi)
widget/
components/
app_button_test.dart
input_test.dart
app_bar_and_loading_test.dart
pages/
auth_flow_test.dart
unit/
features/
auth/
waste/
points/
core/
utils/
integration/
login_flow_test.dart
waste_flow_test.dart

Catatan: folder unit/ dan integration/ dibuat saat logic domain dan data
sudah ada. Folder widget/pages/ terisi seiring halaman dibuat.

---

## 5. Test Baru

- Setiap fitur baru wajib disertai minimal 1 unit test.
- Setiap komponen reusable wajib disertai minimal 1 widget test.
- Setiap bug fix wajib disertai test yang mereproduksi bug.
- Test ditaruh di folder sesuai layer.
- Widget test yang memakai router memakai MaterialApp.router dengan
  appRoutes dari lib/core/router/app_router.dart.

---

## 6. Verifikasi Wajib

Sebelum task dianggap selesai:

1. flutter analyze - OK / warning / error.
2. flutter test - OK / gagal / belum ditest.
3. Task UI: screenshot terlampir.
4. Task kamera/GPS: dites di device fisik.
5. Update CHANGELOG.
6. Update docs terkait jika ada perubahan.

---

## 7. Command

```bash
# Analyze
flutter analyze

# Test semua
flutter test

# Test dengan coverage
flutter test --coverage

# Test folder tertentu
flutter test test/unit/
flutter test test/widget/
flutter test test/integration/

# Test file tertentu
flutter test test/unit/features/waste/calculate_points_test.dart
```

---

## 8. Aturan Test

- Test harus deterministik (tidak flaky).
- Test tidak boleh depend ke network asli.
- Test tidak boleh depend ke waktu sistem (mock waktu).
- Test tidak boleh depend ke urutan eksekusi.
- Test harus cepat (di bawah 1 detik per test).
- Test harus jelas: nama test menggambarkan perilaku.
- Test harus independen: satu test tidak depend ke test lain.
- Widget test dengan timer (mis. splash) wajib memajukan waktu
  (`tester.pump(Duration)`) lalu `pumpAndSettle()` agar tidak ada timer
  pending.

---

## 9. Contoh Test

### 9.1 Unit Test (Domain)

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:go_green/features/points/domain/usecases/calculate_points_usecase.dart';

void main() {
  group('CalculatePointsUsecase', () {
    test('harus mengembalikan 10 poin untuk sampah organik', () {
      final usecase = CalculatePointsUsecase();
      final result = usecase.call(category: 'organik', hasStreak: false);
      expect(result, 10);
    });

    test('harus mengembalikan 15 poin untuk sampah daur ulang', () {
      final usecase = CalculatePointsUsecase();
      final result = usecase.call(category: 'daur_ulang', hasStreak: false);
      expect(result, 15);
    });

    test('harus menambah bonus streak jika hasStreak true', () {
      final usecase = CalculatePointsUsecase();
      final result = usecase.call(category: 'organik', hasStreak: true);
      expect(result, greaterThan(10));
    });
  });
}
```

### 9.2 Widget Test

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_green/core/widgets/app_button_widgets.dart';

void main() {
  testWidgets('PrimaryButton harus menampilkan label', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PrimaryButton(
            text: 'Login',
            onPressed: () {},
          ),
        ),
      ),
    );

    expect(find.text('Login'), findsOneWidget);
  });
}
```

---

## 10. Status Dokumen

- Versi: 1.1
- Terakhir update: 2026-09-14
- Perubahan: tulis ulang struktur yang rusak; hapus konten
  SECURITY_AND_VALIDATION.md yang terselip; tambah catatan widget test
  timer dan MaterialApp.router.