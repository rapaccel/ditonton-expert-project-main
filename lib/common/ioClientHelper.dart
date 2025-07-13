import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/io_client.dart';
import 'package:collection/collection.dart';

Future<IOClient> createSecureIOClient() async {
  final sslCert = await rootBundle.load('assets/certs/themoviedb.pem');
  final trustedCertBytes = sslCert.buffer.asUint8List();

  final context = SecurityContext(withTrustedRoots: false);
  context.setTrustedCertificatesBytes(trustedCertBytes);

  final httpClient = HttpClient(context: context);

  httpClient.badCertificateCallback =
      (X509Certificate cert, String host, int port) {
    final serverCert = cert.der;
    final isMatch = const ListEquality().equals(serverCert, trustedCertBytes);

    if (!isMatch) {
      print(
          "SSL Pinning Failed: server certificate doesn't match the pinned one");
    } else {
      print("SSL Pinning Success: certificate matched");
    }

    return const ListEquality().equals(serverCert, trustedCertBytes);
  };

  return IOClient(httpClient);
}
