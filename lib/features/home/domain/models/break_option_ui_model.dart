import 'package:equatable/equatable.dart';

class BreakOptionUiModel extends Equatable {
  final String id;
  final String title;
  final String subtitle;
  final bool isPaid;
  final bool isStarted;

  const BreakOptionUiModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.isPaid,
    this.isStarted = false,
  });

  BreakOptionUiModel copyWith({
    String? id,
    String? title,
    String? subtitle,
    bool? isPaid,
    bool? isStarted,
  }) {
    return BreakOptionUiModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      isPaid: isPaid ?? this.isPaid,
      isStarted: isStarted ?? this.isStarted,
    );
  }

  @override
  List<Object?> get props => [id, title, subtitle, isPaid, isStarted];
}
