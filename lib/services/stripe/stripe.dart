import 'package:flutter_saas/services/stripe/stripe_api_service.dart';

Future<void> init({
  required String email,
  required String name,
}) async {
  Map<String, dynamic>? customer = await createCustomer(
    email: email,
    name: name,
  );
  if (customer == null || customer["id"] == null) {
    throw Exception('Failed to create customer.');
  }

  Map<String, dynamic>? paymentIntent = await createPaymentIntent(
    customerId: customer["id"],
  );

  if(paymentIntent == null || paymentIntent["client_secret"]==null){
    throw Exception('Failed to create payment intent.');

  }
}

Future<Map<String, dynamic>?> createCustomer({
  required String email,
  required String name,
}) async {
  final customerCreatingResponce = await stripeApiService(
      requestMethod: ApiServiceMethodeType.post,
      endpoint: "customers",
      requestBody: {
        "name": name,
        "email": email,
        "description": 'text Extractor Pro plan',
      });

  return customerCreatingResponce;
}

Future<Map<String, dynamic>?> createPaymentIntent(
    {required String customerId}) async {
  final paymentIntentCreationResponce = await stripeApiService(
    requestMethod: ApiServiceMethodeType.post,
    endpoint: "payment_intents",
    requestBody: {
      'customer': customerId,
      'automatic_payment_methods[enabled]': 'true',
    },
  );

  return paymentIntentCreationResponce;
}
