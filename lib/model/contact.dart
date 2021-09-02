class Contact {
  String? _id;
  String? _name;
  String? _email;

  Contact(this._id, this._name, this._email);

  Contact.map(dynamic obj) {
    this._id = obj['id'];
    this._name = obj['name'];
    this._email = obj['email'];
  }

  String get id => _id!;

  String get name => _name!;

  String get email => _email!;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['name'] = _name;
    map['email'] = _email;
    return map;
  }

  Contact.fromMap(Map<String, dynamic> map, String id) {
    this._id = id ?? '';
    this._name = map['name'];
    this._email = map['email'];
  }
}