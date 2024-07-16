class Constants {
    static Map<String, String> httpRequestHeadersWithJsonBody(token) => {
        "Authorization": "Token $token",
        "Content-Type": "application/json"
    };
    static Map<String, String> httpRequestHeaders(token) => {
        "Authorization": "Token $token",
    };
    static Map<String, String> httpRequestHeadersWithJsonBodyWithoutToken() => {
        "Content-Type": "application/json"
    };
    static const String defaultErrorMsg = "An unexpected error happened.";

    static const String initialUnselectedGroup = "All";

    static const List<Map> todoStatusOptions = [
        {
            "label": "Postponed",
            "id": 1
        },
        {
            "label": "Pendent",
            "id": 2
        },
        {
            "label": "Doing",
            "id": 3
        },
        {
            "label": "Done",
            "id": 4
        }
    ];
    static const List<Map> todoPriorityOptions = [
        {
            "label": "Urgent",
            "id": 1
        },
        {
            "label": "High",
            "id": 2
        },
        {
            "label": "Normal",
            "id": 3
        },
        {
            "label": "Low",
            "id": 4
        }
    ];

    static const String dateFormatEn = "MM/dd/yyyy - hh:mm a";
    static const String dateFormatPT = "dd/MM/yyyy - HH:mm";
    static DateTime oldFodderDate = DateTime(1900);
    static DateTime fodderDate = DateTime(2100);
    static DateTime today0hour = DateTime.now().toUtc().copyWith(hour:0, minute:0, second:0, millisecond:0, microsecond: 0);

    static const Map blockUserErrors = {
        "trial_ended": {
            "title": "Your free trial has ended!",
            "description":"To continue using the app, please subscribe.",
            "callToAction":"Subscribe",
        },
        "subscription_unpaid": {
            "title": "Subscription Payment Failed",
            "description": "It looks like your subscription payment did not go through. Please update your payment information to continue using the app.",
            "callToAction": "Update Payment",
        },
        "subscription_canceled": {
            "title": "Subscription Canceled",
            "description": "Your subscription has been canceled. To regain access, please renew the subscription",
            "callToAction": "Renew subscription",
        },
    };
    static const List<int> trialStatus = [1,2];

    static List<Map> paymentMethodOptions = [
        {"label": "PIX", "id": 1},
        {"label": "Dinheiro", "id": 2},
        {"label": "Cartão", "id": 3},
        {"label": "Pagamento recorrente", "id": 4},
        {"label": "Outros", "id": 5},
    ];
}
