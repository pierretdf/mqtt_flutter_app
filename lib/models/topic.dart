class Topic {
  int id;
  int brokerId;
  String title;

  // Constructor
  Topic({this.id, this.brokerId, this.title});

  factory Topic.fromJson(Map<String, dynamic> json) {
    // This will be used to convert JSON objects that are coming from
    // querying the database and converting it into a Topic object
    return Topic(
      id: json['id'],
      brokerId: json['brokerId'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    //This will be used to convert Topic objects that
    //are to be stored into the datbase in a form of JSON
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['brokerId'] = this.brokerId;
    data['title'] = this.title;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'brokerId': brokerId,
      'title': title,
    };
  }

  @override
  String toString() => 'Topic(id: $id, brokerId: $brokerId, title: $title)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Topic &&
        other.id == id &&
        other.brokerId == brokerId &&
        other.title == title;
  }

  @override
  int get hashCode => id.hashCode ^ brokerId.hashCode ^ title.hashCode;

  Topic copyWith({
    int id,
    int brokerId,
    String title,
  }) {
    return Topic(
      id: id ?? this.id,
      brokerId: brokerId ?? this.brokerId,
      title: title ?? this.title,
    );
  }
}
