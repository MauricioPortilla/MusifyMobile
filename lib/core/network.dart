import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:musify/core/core.dart';
import 'package:musify/core/networkresponse.dart';
import 'package:musify/core/session.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class Network {
    static void get(
        String resource, 
        Map<String, dynamic> data, 
        onSuccess(NetworkResponse response), 
        onFailure(NetworkResponse errorResponse), 
        onError()
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
                    "Authorization": Session.accessToken != null ? Session.accessToken : "",
                    "Accept-Language": "es"
                }
            );
            Map<String, dynamic> jsonDecoded = json.decode(response.body);
            if (jsonDecoded["status"] == "success") {
                onSuccess(NetworkResponse.fromJson(jsonDecoded));
            } else {
                onFailure(NetworkResponse.fromJson(jsonDecoded));
            }
        } catch (exception) {
            onError();
        }
    }

    static Future<NetworkResponse> futureGet(String resource, Map<String, dynamic> data) async {
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
                    "Authorization": Session.accessToken != null ? Session.accessToken : "",
                    "Accept-Language": "es"
                }
            );
            var jsonResponse = json.decode(response.body);
            return NetworkResponse.fromJson(jsonResponse);
        } catch (exception) {
            throw exception;
        }
    }

    static void getStreamBuffer(String resource, Map<String, dynamic> data, onSuccess(Uint8List buffer), onFailure(NetworkResponse data), onError()) async {
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
                    "Authorization": Session.accessToken != null ? Session.accessToken : "",
                    "Accept-Language": "es"
                }
            );
            if (response.statusCode == 200) {
                onSuccess(response.bodyBytes);
                return;
            }
            throw Exception();
        } catch (exception) {
            onError();
        }
    }
    
    static void post(String resource, Map<String, dynamic> data, onSuccess(NetworkResponse response), onFailure(NetworkResponse errorResponse), onError()) async {
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
                    "Authorization": Session.accessToken != null ? Session.accessToken : "",
                    "Accept-Language": "es"
                },
                body: jsonEncode(data)
            );
            Map<String, dynamic> jsonDecoded = json.decode(response.body);
            if (jsonDecoded["status"] == "success") {
                onSuccess(NetworkResponse.fromJson(jsonDecoded));
            } else {
                onFailure(NetworkResponse.fromJson(jsonDecoded));
            }
        } catch (exception) {
            onError();
        }
    }

    static void postMultimedia(String resource, Map<String, dynamic> data, List<File> files, onSuccess(NetworkResponse response), onFailure(NetworkResponse errorResponse), onError()) async {
        try {
            String query = resource;
            if (data != null) {
                data.forEach((key, value) {
                    query = query.replaceAll(key, value.toString());
                });
            }
            var request = http.MultipartRequest("POST", Uri.parse(Core.SERVER_URL + query));
            request.headers.addAll({
                "Authorization": Session.accessToken != null ? Session.accessToken : "",
                "Content-Type": "multipart/form-data",
                "Accept-Language": "es"
            });
            int counter = 0;
            for (var file in files) {
                request.files.add(http.MultipartFile.fromBytes(counter.toString(), await file.readAsBytes(), filename: basename(file.path)));
                counter++;
            }
            var response = await request.send();
            response.stream.transform(utf8.decoder).listen((value) {
                if (response.statusCode == 201) {
                    onSuccess(NetworkResponse.fromJson(json.decode(value)));
                } else {
                    onFailure(NetworkResponse());
                }
            });
        } catch (exception) {
            onError();
        }
    }

    static void put(String resource, Map<String, dynamic> data, onSuccess(NetworkResponse response), onFailure(NetworkResponse errorResponse), onError()) async {
        try {
            String query = resource;
            if (data != null) {
                data.forEach((key, value) {
                    query = query.replaceAll(key, value.toString());
                });
            }
            final http.Response response = await http.put(
                Core.SERVER_URL + query,
                headers: <String, String> {
                    "Content-Type": "application/json; charset=UTF-8",
                    "Authorization": Session.accessToken != null ? Session.accessToken : "",
                    "Accept-Language": "es"
                },
                body: jsonEncode(data)
            );
            Map<String, dynamic> jsonDecoded = json.decode(response.body);
            if (jsonDecoded["status"] == "success") {
                onSuccess(NetworkResponse.fromJson(jsonDecoded));
            } else {
                onFailure(NetworkResponse.fromJson(jsonDecoded));
            }
        } catch (exception) {
            onError();
        }
    }

    static void delete(String resource, Map<String, dynamic> data, onSuccess(NetworkResponse response), onFailure(NetworkResponse errorResponse), onError()) async {
        try {
            String query = resource;
            if (data != null) {
                data.forEach((key, value) {
                    query = query.replaceAll(key, value.toString());
                });
            }
            final response = await http.Client().send(
                http.Request("DELETE", Uri.parse(Core.SERVER_URL + query))
                    ..headers["Content-Type"] = "application/json; charset=UTF-8"
                    ..headers["Authorization"] = Session.accessToken != null ? Session.accessToken : ""
                    ..headers["Accept-Language"] = "es"
                    ..body = json.encode(data)
            );
            Map<String, dynamic> jsonDecoded = json.decode(await response.stream.bytesToString());
            if (jsonDecoded["status"] == "success") {
                onSuccess(NetworkResponse.fromJson(jsonDecoded));
            } else {
                onFailure(NetworkResponse.fromJson(jsonDecoded));
            }
        } catch (exception) {
            onError();
        }
    }
}
