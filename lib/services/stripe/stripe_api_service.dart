import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

enum ApiServiceMethodeType {
  get,
  post,
}

const baseUrl = "https://api.stripe.com/v1/endpoint";

final Map<String, String> requestHeaders = {
  'Content-Type': 'application/x-www-form-urlencoded',
  'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET_KEY']}',
};

Future<Map<String, dynamic>?> stripeApiService({
  required ApiServiceMethodeType requestMethod,
  required Map<String, dynamic>? requestBody,
  required String endpoint,
}) async {
  final requestUrl = "$baseUrl/$endpoint";
  try {
   final requestResponse = requestMethod == ApiServiceMethodeType.get
        ? await http.get(
            Uri.parse(requestUrl),
            headers: requestHeaders,
          )
        : await http.post(
            Uri.parse(requestUrl),
            headers: requestHeaders,
            body: requestBody,
          );

      if(requestResponse.statusCode == 200){
        return json.decode(requestResponse.body);
      }else{
        print(requestResponse.body);
        throw Exception("Failedto fetch data: ${requestResponse.body}");
      }

   
  } catch (error) {
    print(error.toString());
    return null;
  }
}
