//
//  Const.swift
//  SwiftTCAShopDemo
//
//  Created by YcLin on 2025/2/22.
//



// App Airtable token : patTklF2FVC4la9pW.9de8f6ac62e2e4563775464e53b623c38052351793f73aa998a3180028c740b7
// https://api.airtable.com/v0/appMbNBmi4RxMRNIc/drinks
// https://api.airtable.com/v0/appMbNBmi4RxMRNIc/drinks?sort[][field]=category&sort[][direction]=asc


enum DataLoadingStatus {
    case notStarted
    case loading
    case success
    case error
}

enum NetworkError:Error{
    case decodeError
    case responseError
    case downloadError
}


//extension Color {
//    func getBgColor() -> Color {
//        return Color("MainColor")
//    }
//}
