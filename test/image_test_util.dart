import 'dart:async';
import 'dart:io';

import 'package:mockito/mockito.dart';

R provideMockedNetworkImages<R>(R body(),
    {List<int> imageBytes = _transparentImage}) {
  return HttpOverrides.runZoned(
    body,
    createHttpClient: (_) => _createMockImageHttpClient(_, imageBytes),
  );
}

class MockHttpClient extends Mock implements HttpClient {
  final HttpClientRequest? httpClientRequestForGetUrl;

  MockHttpClient({
    this.httpClientRequestForGetUrl,
  });

  @override
  Future<HttpClientRequest> getUrl(Uri? url) async {
    return super.noSuchMethod(
      Invocation.method(#getUrl, [url]),
      returnValue: httpClientRequestForGetUrl ?? MockHttpClientRequest(),
      returnValueForMissingStub:
          httpClientRequestForGetUrl ?? MockHttpClientRequest(),
    );
  }
}

class MockHttpClientRequest extends Mock implements HttpClientRequest {}

class MockHttpClientResponse extends Mock implements HttpClientResponse {
  @override
  HttpClientResponseCompressionState get compressionState => super.noSuchMethod(
        Invocation.getter(#compressionState),
        returnValue: HttpClientResponseCompressionState.notCompressed,
        returnValueForMissingStub:
            HttpClientResponseCompressionState.notCompressed,
      );
}

class MockHttpHeaders extends Mock implements HttpHeaders {}

MockHttpClient _createMockImageHttpClient(
  SecurityContext? _,
  List<int> imageBytes,
) {
  final request = MockHttpClientRequest();
  final client = MockHttpClient(httpClientRequestForGetUrl: request);
  final response = MockHttpClientResponse();
  final headers = MockHttpHeaders();

  when(client.getUrl(any))
      .thenAnswer((_) => Future<HttpClientRequest>.value(request));
  when(request.headers).thenReturn(headers);
  when(request.close())
      .thenAnswer((_) => Future<HttpClientResponse>.value(response));
  when(response.contentLength).thenReturn(_transparentImage.length);
  when(response.statusCode).thenReturn(HttpStatus.ok);
  when(response.listen(any)).thenAnswer((Invocation invocation) {
    final void Function(List<int>)? onData = invocation.positionalArguments[0];
    final void Function()? onDone = invocation.namedArguments[#onDone];
    final void Function(Object, [StackTrace?])? onError =
        invocation.namedArguments[#onError];
    final bool? cancelOnError = invocation.namedArguments[#cancelOnError];

    return Stream<List<int>>.fromIterable(<List<int>>[imageBytes]).listen(
        onData,
        onDone: onDone,
        onError: onError,
        cancelOnError: cancelOnError);
  });

  return client;
}

const List<int> _transparentImage = <int>[
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x0A,
  0x49,
  0x44,
  0x41,
  0x54,
  0x78,
  0x9C,
  0x63,
  0x00,
  0x01,
  0x00,
  0x00,
  0x05,
  0x00,
  0x01,
  0x0D,
  0x0A,
  0x2D,
  0xB4,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
];
