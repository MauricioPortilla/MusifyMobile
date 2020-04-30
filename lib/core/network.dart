import 'dart:convert';

import 'package:musify/core/core.dart';
import 'package:musify/core/session.dart';
import 'package:http/http.dart' as http;

class Network {
    static void get(
        String resource, 
        Map<String, dynamic> data, 
        onSuccess(Map<String, dynamic> response), 
        onFailure(Map<String, dynamic> errorResponse)
    ) async {
        try {
            String query = resource;
            if (data != null) {
                data.forEach((key, value) {
                    query = query.replaceAll(key, value.toString());
                });
            }
            final http.Response response = await http.get(
                Core.SERVER_URL + query,
                headers: <String, String> {
                    "Content-Type": "application/json; charset=UTF-8",
                    "Authorization": Session.accessToken != null ? ("Bearer " + Session.accessToken) : ""
                }
            );
            Map<String, dynamic> jsonDecoded = json.decode(response.body);
            if (jsonDecoded["status"] == "success") {
                onSuccess(jsonDecoded);
            } else {
                onFailure(jsonDecoded);
            }
        } catch (exception) {
            onFailure(<String, dynamic> { 
                "status": "failure", 
                "message": "No se pudo establecer una conexión con el servidor." 
            });
            throw exception;
        }
    }

    static Future<Map<String, dynamic>> futureGet(String resource, Map<String, dynamic> data) async {
        try {
            String query = resource;
            if (data != null) {
                data.forEach((key, value) {
                    query = query.replaceAll(key, value.toString());
                });
            }
            final http.Response response = await http.get(
                Core.SERVER_URL + query,
                headers: <String, String> {
                    "Content-Type": "application/json; charset=UTF-8",
                    "Authorization": Session.accessToken != null ? ("Bearer " + Session.accessToken) : ""
                }
            );
            return json.decode(response.body);
        } catch (exception) {
            throw exception;
        }
    }
    
    static void post(
        String resource, 
        Map<String, dynamic> data, 
        onSuccess(Map<String, dynamic> response), 
        onFailure(Map<String, dynamic> errorResponse)
    ) async {
        try {
            String query = resource;
            if (data != null) {
                data.forEach((key, value) {
                    query = query.replaceAll(key, value.toString());
                });
            }
            final http.Response response = await http.post(
                Core.SERVER_URL + query,
                headers: <String, String> {
                    "Content-Type": "application/json; charset=UTF-8",
                    "Authorization": Session.accessToken != null ? ("Bearer " + Session.accessToken) : ""
                },
                body: jsonEncode(data)
            );
            Map<String, dynamic> jsonDecoded = json.decode(response.body);
            if (jsonDecoded["status"] == "success") {
                onSuccess(jsonDecoded);
            } else {
                onFailure(jsonDecoded);
            }
        } catch (exception) {
            onFailure(<String, dynamic> { 
                "status": "failure", 
                "message": "No se pudo establecer una conexión con el servidor." 
            });
            throw exception;
        }
    }
}
