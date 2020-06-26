class Subscription {
    final int subscriptionId;
    final int accountId;
    final double cost;
    final DateTime startDate;
    final DateTime endDate;

    Subscription({
        this.subscriptionId,
        this.accountId,
        this.cost,
        this.startDate,
        this.endDate
    });

    factory Subscription.fromJson(Map<String, dynamic> json) {
        return Subscription(
            subscriptionId: json["subscription_id"],
            accountId: json["account_id"],
            cost: json["cost"],
            startDate: DateTime.parse(json["start_date"]),
            endDate: DateTime.parse(json["end_date"])
        );
    }
}
