class NectorNetworkRequest {
  int size = 0;
  dynamic body = '';
  String? contentType = '';
  DateTime time = DateTime.now();
  Map<String, dynamic> queryParamters = <String, dynamic>{};
  Map<String, dynamic> headers = <String, dynamic>{};
}
