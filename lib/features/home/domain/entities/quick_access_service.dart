import 'package:equatable/equatable.dart';

/// The quick-access product tiles on the home screen. Kept as a closed enum
/// (rather than a free-form string) so the presentation layer can safely
/// map each type to its own icon/color without trusting content from the API.
enum QuickAccessServiceType {
  prepaidCard,
  cashAdvance,
  autoFinance,
  sendMoney,
  invest,
  business,
}

class QuickAccessService extends Equatable {
  final QuickAccessServiceType type;
  final String titleKey;
  final String descriptionKey;

  const QuickAccessService({
    required this.type,
    required this.titleKey,
    required this.descriptionKey,
  });

  @override
  List<Object?> get props => [type, titleKey, descriptionKey];
}
