import 'dart:typed_data';
import 'package:http/http.dart' as http;

Future<Uint8List> getImageBytes(String url) async {
  http.Response response = await http.get(Uri.parse(url));
  return response.bodyBytes;
}
