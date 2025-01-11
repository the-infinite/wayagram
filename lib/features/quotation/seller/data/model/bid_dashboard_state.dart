class BidDashboardState {
    BidDashboardState({
       this.isLoading = false,
         this.data,
         this.hasShop =  false,
    });

    final bool? isLoading;
    final dynamic data;
    final bool hasShop;

    BidDashboardState copyWith({
        bool? isLoading,
        dynamic data,
        bool? hasShop,
    }) {
        return BidDashboardState(
            isLoading: isLoading ?? this.isLoading,
            data: data ?? this.data,
            hasShop: hasShop ?? this.hasShop,
        );
    }

    factory BidDashboardState.fromJson(Map<String, dynamic> json){
        return BidDashboardState(
            isLoading: json["isLoading"] ?? false,
            data: json["data"],
            hasShop: json["hasShop"] ?? false,
        );
    }

    Map<String, dynamic> toJson() => {
        "isLoading": isLoading,
        "data": data,
        "hasShop": hasShop,
    };

}
