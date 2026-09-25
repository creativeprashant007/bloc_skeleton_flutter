class HomeUserUiModel {
  final String name;
  final String profileImageUrl;
  final String temperatureText;

  const HomeUserUiModel({
    required this.name,
    required this.profileImageUrl,
    required this.temperatureText,
  });

  factory HomeUserUiModel.initial() {
    return const HomeUserUiModel(
      name: 'User',
      profileImageUrl: '',
      temperatureText: '24° C',
    );
  }
}
