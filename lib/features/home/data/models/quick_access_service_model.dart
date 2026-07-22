import 'package:no_wait/features/home/domain/entities/quick_access_service.dart';

class QuickAccessServiceModel {
  final String type;
  final String titleKey;
  final String descriptionKey;

  const QuickAccessServiceModel({
    required this.type,
    required this.titleKey,
    required this.descriptionKey,
  });

  factory QuickAccessServiceModel.fromJson(Map<String, dynamic> json) {
    return QuickAccessServiceModel(
      type: json['type'] as String,
      titleKey: json['titleKey'] as String,
      descriptionKey: json['descriptionKey'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'type': type,
    'titleKey': titleKey,
    'descriptionKey': descriptionKey,
  };

  QuickAccessService toEntity() => QuickAccessService(
    type: QuickAccessServiceType.values.firstWhere(
      (t) => t.name == type,
      orElse: () => QuickAccessServiceType.business,
    ),
    titleKey: titleKey,
    descriptionKey: descriptionKey,
  );
}
