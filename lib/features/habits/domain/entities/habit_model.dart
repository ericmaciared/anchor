class HabitModel {
  final String id;
  final String name;
  bool isSelected;
  bool isCustom;
  int currentStreak;
  DateTime? lastCompletedDate;

  HabitModel({
    required this.id,
    required this.name,
    this.isSelected = true,
    this.isCustom = false,
    this.currentStreak = 0,
    this.lastCompletedDate,
  });

  HabitModel copyWith({
    String? id,
    String? name,
    bool? isSelected,
    bool? isCustom,
    int? currentStreak,
    DateTime? lastCompletedDate,
  }) {
    return HabitModel(
      id: id ?? this.id,
      name: name ?? this.name,
      isSelected: isSelected ?? this.isSelected,
      isCustom: isCustom ?? this.isCustom,
      currentStreak: currentStreak ?? this.currentStreak,
      lastCompletedDate: lastCompletedDate ?? this.lastCompletedDate,
    );
  }
}
