class downloadModel {
  Transmitting? transmitting;

  downloadModel({this.transmitting});

  downloadModel.fromJson(Map<String, dynamic> json) {
    transmitting = json['transmitting'] != null
        ? new Transmitting.fromJson(json['transmitting'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.transmitting != null) {
      data['transmitting'] = this.transmitting!.toJson();
    }
    return data;
  }
}

class Transmitting {
  String? key;
  var value;

  Transmitting({this.key, this.value});

  Transmitting.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['value'] = this.value;
    return data;
  }
}
