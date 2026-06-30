enum DocumentSource { manual, camera, upload }

class HealthDocument {
  const HealthDocument({
    required this.id,
    required this.memberId,
    required this.title,
    required this.type,
    required this.hospitalName,
    required this.documentDate,
    this.source = DocumentSource.manual,
    this.fileName,
    this.fileSizeBytes,
  });

  final String id;
  final String memberId;
  final String title;
  final String type;
  final String hospitalName;
  final DateTime documentDate;
  final DocumentSource source;
  final String? fileName;
  final int? fileSizeBytes;
}
