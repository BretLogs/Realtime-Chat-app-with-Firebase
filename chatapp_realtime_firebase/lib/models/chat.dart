import 'package:chatapp_realtime_firebase/models/message.dart';

class Chat {
  Chat({
    required this.id,
    required this.participants,
    required this.messages,
  });

  Chat.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    participants = List<String>.from(json['participants']);
    messages = List.from(json['messages']).map((m) => Message.fromJson(m)).toList();
  }
  String? id;
  List<String>? participants;
  List<Message>? messages;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['participants'] = participants;
    data['messages'] = messages?.map((Message m) => m.toJson()).toList() ?? <Map<String, dynamic>>[];
    return data;
  }
}
