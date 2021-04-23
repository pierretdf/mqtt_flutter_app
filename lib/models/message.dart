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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['topic'] = this.topic;
    data['payload'] = this.payload;
    data['qos'] = this.qos;
    data['retainValue'] = this.retainValue ? 1 : 0;
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
