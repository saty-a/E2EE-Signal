import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:laathi/utils/notification_service.dart';
import '../../../utils/helper/exception_handler.dart';
import '../values/constants.dart';
import '../values/env.dart';

class NetworkRequester {
  late Dio _dio;

  NetworkRequester._authenticatedRequest() {
    prepareAuthenticatedRequest();
  }

  NetworkRequester._authenticatedRequestNotification() {
    prepareAuthenticatedRequestForNotification();
  }

  NetworkRequester._request() {
    prepareRequest();
  }

  NetworkRequester.customContentType(String contentType) {
    debugPrint('CONTENT_TYPE: $contentType');
    prepareRequest(contentType: contentType);
  }

  static final NetworkRequester authenticated =
      NetworkRequester._authenticatedRequest();

  static final NetworkRequester authenticatedNotification =
      NetworkRequester._authenticatedRequestNotification();

  static final NetworkRequester request = NetworkRequester._request();

  /// Production
  Future<void> prepareRequest(
      {String contentType = Headers.jsonContentType}) async {
    BaseOptions dioOptions = BaseOptions(
      connectTimeout: const Duration(seconds: Timeouts.CONNECT_TIMEOUT),
      receiveTimeout: const Duration(seconds: Timeouts.RECEIVE_TIMEOUT),
      baseUrl: Env.baseURL,
      contentType: contentType,
      responseType: ResponseType.json,
      headers: {
        'Accept': Headers.jsonContentType,
      },
    );

    _dio = Dio(dioOptions);

    _dio.interceptors.clear();

    _dio.interceptors.add(LogInterceptor(
      error: true,
      request: true,
      requestBody: true,
      requestHeader: true,
      responseBody: true,
      responseHeader: true,
      logPrint: _printLog,
    ));
  }

  void prepareAuthenticatedRequest() {
    BaseOptions dioOptions = BaseOptions(
      connectTimeout: const Duration(seconds: Timeouts.CONNECT_TIMEOUT),
      receiveTimeout: const Duration(seconds: Timeouts.RECEIVE_TIMEOUT),
      baseUrl: Env.baseURL,
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
      headers: {
        'Accept': Headers.jsonContentType,
        'Authorization': 'Bearer ${'token here'}',
      },
    );

    _dio = Dio(dioOptions);

    _dio.interceptors.clear();

    (_dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };

    _dio.interceptors.addAll([
      LogInterceptor(
        error: true,
        request: true,
        requestBody: true,
        requestHeader: true,
        responseBody: true,
        responseHeader: true,
        logPrint: _printLog,
      ),
     // DioCacheManager(CacheConfig(baseUrl: Env.baseURL)).interceptor
    ]);
  }

  void prepareAuthenticatedRequestForNotification() async {
    var serverAccessTokenKey = await NotificationService().getAccessToken();
    log("accessToken $serverAccessTokenKey");

    BaseOptions dioOptions = BaseOptions(
      connectTimeout: const Duration(seconds: Timeouts.CONNECT_TIMEOUT),
      receiveTimeout: const Duration(seconds: Timeouts.RECEIVE_TIMEOUT),
      headers: {
        'Content-type': 'application/json',
        'Authorization':
            'Bearer $serverAccessTokenKey',
      },
    );

    _dio = Dio(dioOptions);

    _dio.interceptors.clear();

    (_dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };

    _dio.interceptors.addAll([
      LogInterceptor(
        error: true,
        request: true,
        requestBody: true,
        requestHeader: true,
        responseBody: true,
        responseHeader: true,
        logPrint: _printLog,
      ),
    //  DioCacheManager(CacheConfig(baseUrl: Env.baseURL)).interceptor
    ]);
  }

  _printLog(Object object) => log(object.toString());

  /// Get
  Future<dynamic> get({
    required String path,
    Map<String, dynamic>? query,
  }) async {
    try {
      final response = await _dio.get(path, queryParameters: query);
      return response.data;
    } on Exception catch (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack);
      return ExceptionHandler.handleError(error);
    }
  }

  /// Post
  Future<dynamic> post({
    required String path,
    Map<String, dynamic>? query,
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await _dio.post(
        path,
        queryParameters: query,
        data: data,
      );
      return response.data;
    } on Exception catch (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack);
      return ExceptionHandler.handleError(error);
    }
  }

  /// Put
  Future<dynamic> put({
    required String path,
    Map<String, dynamic>? query,
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await _dio.put(path, queryParameters: query, data: data);
      return response.data;
    } on Exception catch (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack);
      return ExceptionHandler.handleError(error);
    }
  }

  /// Patch
  Future<dynamic> patch({
    required String path,
    Map<String, dynamic>? query,
    Map<String, dynamic>? data,
  }) async {
    try {
      final response =
          await _dio.patch(path, queryParameters: query, data: data);
      return response.data;
    } on Exception catch (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack);
      return ExceptionHandler.handleError(error);
    }
  }

  /// Delete
  Future<dynamic> delete({
    required String path,
    Map<String, dynamic>? query,
    Map<String, dynamic>? data,
  }) async {
    try {
      final response =
          await _dio.delete(path, queryParameters: query, data: data);
      return response.data;
    } on Exception catch (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack);
      return ExceptionHandler.handleError(error);
    }
  }
}
