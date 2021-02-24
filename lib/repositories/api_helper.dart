import 'dart:io';

import 'package:flutter_manga_app_bloc/repositories/api_exceptions.dart';
import 'package:http/http.dart' as http;

class ApiBaseHelper{

  final String _baseUrl = 'http://www.mangatown.com/';

  Future<dynamic> get (String url) async{
    var responseJson;
    try
    {
      final response = await http.get(_baseUrl + url);
      responseJson = _returnResponse(response);
    }
    
    on SocketException{throw FetchDataException('No internet connection');}

    return responseJson;
  }

  dynamic _returnResponse (http.Response response){

    switch(response.statusCode){
      case 200 : var responseHtml = response.body.toString(); return responseHtml;
      case 400 : throw BadRequestException(response.body.toString());
      case 401 : throw UnauthorizeException(response.body.toString());
      case 403 : 
      default  : throw FetchDataException('Error Ocurred While Communication With Server With Status Code ${response.statusCode}');
    }

  }

}