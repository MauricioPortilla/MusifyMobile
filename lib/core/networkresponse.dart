class NetworkResponse {
    final String status;
    final String message;
    final dynamic data;

    NetworkResponse({
        this.status,
        this.message,
        this.data
    });

    factory NetworkResponse.fromJson(Map<String, dynamic> json) {
        return NetworkResponse(
            status: json["status"],
            message: json["message"],
            data: json["data"]
        );
    }
}
