import 'dart:io';

import 'package:dio/dio.dart';
import 'package:app_loja/models/cepaberto_address.dart';

const token = 'f5f429fcb2c25d32c7c7be27afbdf315';

class CepAbertoService {
  Future<CepAbertoAddress> getAddressFromCep(String cep) async {
    final cleanCep = cep.replaceAll('.', '').replaceAll('-', '');
    final endpoint = "https://www.cepaberto.com/api/v3/cep?cep=$cleanCep";

    final Dio dio = Dio();

    dio.options.headers[HttpHeaders.authorizationHeader] = 'Token token=$token';

    try {
      final response = await dio.get<Map<String, dynamic>>(endpoint);

      if (response.data.isEmpty) {
        return Future.error('CEP Inválido');
      }

      final CepAbertoAddress address = CepAbertoAddress.fromMap(response.data);

      return address;
    } on DioError {
      return Future.error('Erro ao buscar CEP');
    }
  }
}
