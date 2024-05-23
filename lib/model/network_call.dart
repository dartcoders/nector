import 'package:nector/model/network_request.dart';
import 'package:nector/model/network_response.dart';

class NectorNetworkCall {
  final int id;
  DateTime createdTime = DateTime.now();
  String client = '';
  bool isLoading = true;
  String method = '';
  String endpoint = '';
  String server = '';
  String uri = '';
  int duration = 0;

  NectorNetworkRequest? networkRequest;
  NectorNetworkResponse? networkResponse;

  NectorNetworkCall(this.id);
}
