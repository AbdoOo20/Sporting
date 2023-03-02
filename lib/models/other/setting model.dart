
class SettingModel{
  late int id;
  late String newsTicker;
  late String intellectualProperty;
  late String membershipTerms;
  late String privacyPolicy;
  late String evacuationResponsibilaty;
  late String vision;
  late int userCount;
  late String value;

  SettingModel({
    required this.id,
    required this.newsTicker,
    required this.intellectualProperty,
    required this.membershipTerms,
    required this.privacyPolicy,
    required this.evacuationResponsibilaty,
    required this.vision,
    required this.userCount,
    required this.value,
  });

  factory SettingModel.fromJSON(Map<String, dynamic> json) {
    return SettingModel(
      id: json['id'],
      newsTicker: json['news_ticker'],
      intellectualProperty: json['intellectual_property'],
      membershipTerms: json['membership_terms'],
      privacyPolicy: json['privacy_policy'],
      evacuationResponsibilaty: json['Evacuation_responsibilaty'],
      vision: json['vision'],
      userCount: json['users_count'],
      value: json['switch'],
    );
  }
}