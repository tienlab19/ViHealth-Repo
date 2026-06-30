import '../entities/family_dashboard.dart';
import '../repositories/family_health_repository.dart';

class GetFamilyDashboard {
  const GetFamilyDashboard(this.repository);

  final FamilyHealthRepository repository;

  Future<FamilyDashboard> call() {
    return repository.getDashboard();
  }
}
