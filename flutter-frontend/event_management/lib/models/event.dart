class Event {
  final int? id;
  final String title;
  final String? description;
  final String? location;
  final DateTime startDate;
  final DateTime endDate;
  final String status;
  final int? createdBy;

  Event({
    this.id,
    required this.title,
    this.description,
    this.location,
    required this.startDate,
    required this.endDate,
    required this.status,
    this.createdBy,
  });

  // Factory to parse from JSON
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      location: json['location'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      status: json['status'],
      createdBy: json['created_by'],
    );
  }

  // Convert to JSON (for POST requests)
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'location': location,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'status': status,
      'created_by': createdBy,
    };
  }
}
