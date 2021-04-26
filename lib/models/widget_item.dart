class WidgetItem {
  int id;
  String name;
  String topic;
  String type;
  String pubTopic; // Optionnal
  String payload;
  String jsonPath;

  // Constructor
  WidgetItem(
      {this.id,
      this.name,
      this.topic,
      this.type,
      this.pubTopic,
      this.payload,
      this.jsonPath});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'topic': topic,
      'type': type,
      'pubTopic': pubTopic,
      'payload': payload,
      'jsonPath': jsonPath,
    };
  }

  Map<String, dynamic> toJson() {
    //This will be used to convert WidgetItem objects that
    //are to be stored into the datbase in a form of JSON
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['topic'] = topic;
    data['type'] = type;
    data['pubTopic'] = pubTopic;
    data['payload'] = payload;
    data['jsonPath'] = jsonPath;
    return data;
  }

  WidgetItem copyWith({
    int id,
    String name,
    String topic,
    String type,
    String pubTopic,
    String payload,
    String jsonPath,
  }) {
    return WidgetItem(
      id: id ?? this.id,
      name: name ?? this.name,
      topic: topic ?? this.topic,
      type: type ?? this.type,
      pubTopic: pubTopic ?? this.pubTopic,
      payload: payload ?? this.payload,
      jsonPath: jsonPath ?? this.jsonPath,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WidgetItem &&
        other.id == id &&
        other.name == name &&
        other.topic == topic &&
        other.type == type &&
        other.pubTopic == pubTopic &&
        other.payload == payload &&
        other.jsonPath == jsonPath;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        topic.hashCode ^
        type.hashCode ^
        pubTopic.hashCode ^
        payload.hashCode ^
        jsonPath.hashCode;
  }
}
