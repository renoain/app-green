// Provider lapisan profil (mode dummy json-server).

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/profile_dummy_datasource.dart';

/// Provider data source profil dummy (json-server, tanpa Supabase).
final Provider<ProfileDummyDatasource> profileDummyDatasourceProvider =
    Provider<ProfileDummyDatasource>(
  (Ref ref) => ProfileDummyDatasource(),
);
