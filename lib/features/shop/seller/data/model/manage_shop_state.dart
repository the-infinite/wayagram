class ManageShopState {
    ManageShopState({
       this.isLoading = false,
         this.data,
         this.hasShop =  false,
    });

    final bool? isLoading;
    final dynamic data;
    final bool hasShop;

    ManageShopState copyWith({
        bool? isLoading,
        dynamic data,
        bool? hasShop,
    }) {
        return ManageShopState(
            isLoading: isLoading ?? this.isLoading,
            data: data ?? this.data,
            hasShop: hasShop ?? this.hasShop,
        );
    }

    factory ManageShopState.fromJson(Map<String, dynamic> json){ 
        return ManageShopState(
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
