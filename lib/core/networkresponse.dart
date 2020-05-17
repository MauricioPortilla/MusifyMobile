class NetworkResponse {
    final String status;
    final String message;
    final dynamic data;
    final Map<String, dynamic> json;

    NetworkResponse({
        this.status,
        this.message,
        this.data,
        this.json
    });

    factory NetworkResponse.fromJson(Map<String, dynamic> json) {
        return NetworkResponse(
            status: json["status"],
            message: json["message"],
            data: json["data"],
            json: json
        );
    }
}
