class UserProfile {
  UserProfile({
    required this.uid,
    required this.name,
    required this.pfpURL,
  });

  UserProfile.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    name = json['name'];
    pfpURL = json['pfpURL'];
  }
  String? uid;
  String? name;
  String? pfpURL;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['pfpURL'] = pfpURL;
    data['uid'] = uid;
    return data;
  }
}
