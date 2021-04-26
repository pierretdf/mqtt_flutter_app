class Message {
  int id;
  String topic;
  String payload;
  int qos;
  bool retainValue;

  // Constructor
  Message({this.id, this.topic, this.payload, this.qos, this.retainValue});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      topic: json['topic'],
      payload: json['payload'],
      qos: json['qos'],
      retainValue: json['retainValue'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['topic'] = topic;
    data['payload'] = payload;
    data['qos'] = qos;
    data['retainValue'] = retainValue ? 1 : 0;
    return data;
  }

  Message copyWith({
    int id,
    String topic,
    String payload,
    int qos,
    bool retainValue,
  }) {
    return Message(
      id: id ?? this.id,
      topic: topic ?? this.topic,
      payload: payload ?? this.payload,
      qos: qos ?? this.qos,
      retainValue: retainValue ?? this.retainValue,
    );
  }
}
