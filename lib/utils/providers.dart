import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restautant_client/utils/services/network_service.dart';

final networkServiceProvider =
    Provider<NetworkService>((ref) => NetworkService(Dio(BaseOptions(
          connectTimeout: 50000,
          receiveTimeout: 50000,
          contentType: 'application/json',
        ))));
