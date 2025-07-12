import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/io_client.dart';

Future<IOClient> createSecureIOClient() async {
  final sslCert = await rootBundle.load('assets/certs/tmdb.cer');
  final context = SecurityContext(withTrustedRoots: false);
  context.setTrustedCertificatesBytes(sslCert.buffer.asInt8List());

  final httpClient = HttpClient(context: context);
  httpClient.badCertificateCallback =
      (X509Certificate cert, String host, int port) => true;

  return IOClient(httpClient);
}
