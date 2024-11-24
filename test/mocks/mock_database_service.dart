import 'package:flutter_app/src/core/data/local/database_service.dart';
import 'package:flutter_app/src/core/data/repositories/data_repository.dart';
import 'package:mockito/annotations.dart';

// Generate mocks for both DatabaseService and DataRepository
@GenerateMocks([DatabaseService, DataRepository])
void main() {}
