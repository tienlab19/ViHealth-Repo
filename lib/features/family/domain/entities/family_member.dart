class FamilyMember {
  const FamilyMember({
    required this.id,
    required this.fullName,
    required this.nickname,
    required this.relationship,
    required this.age,
    required this.bloodType,
    required this.healthNote,
    required this.avatarLabel,
  });

  final String id;
  final String fullName;
  final String nickname;
  final String relationship;
  final int age;
  final String bloodType;
  final String healthNote;
  final String avatarLabel;
}
