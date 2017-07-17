//
//  Server.swift
//  uPort-demo-ios
//
//  Created by Oksana Hanailiuk on 7/17/17.
//  Copyright © 2017 1. All rights reserved.
//

import UIKit
import Alamofire

class Server {
    let serverUrl = "https://testservername/api/"
    let apiVersion = "v1/"
    
    static let sharedInstance = Server()
    private init() {}
    
    func sendRequest(request: IRequest, responseHandler: @escaping (_ response: IResponse?) -> Void) {
        
        Reachability.isConnectedToNetwork(completion: { [weak self] result in
            if result {
                Alamofire.request((self?.buildUrlForRequest(request: request))!, method: request.method(), parameters: request.params(), encoding: request.encoding(), headers: request.headers()).responseJSON(completionHandler:{
                    response in
                    self?.handleResponse(request: request, response: response, responseHandler: responseHandler)
                })
            } else {
                ShowNoInternetConnectionAlertCommand().execute(with: Texts.noInternetConnectionMessage)
            }
        })
    }
    
    private func handleResponse(request: IRequest, response: DataResponse<Any>, responseHandler: (_ response: IResponse?) -> Void) {
        let isSuccess = response.response?.statusCode == SuccessResponseCode
        var cdUportResponse: IResponse?
        if isSuccess {
            cdUportResponse = self.handleSuccessResponse(request: request, response: response)
        } else {
            cdUportResponse = self.handleErrorResponse(request: request, response: response)
        }
        cdUportResponse?.isSuccess = isSuccess
        responseHandler(cdUportResponse)
    }
    
    private func handleSuccessResponse(request: IRequest, response: DataResponse<Any>) -> IResponse? {
        switch request.type() {
        case .uportUri:
            return BaseResponse(response: response)
        }
    }
    
    private func handleErrorResponse(request: IRequest, response: DataResponse<Any>) -> IResponse? {
        let cdUportResponse = BaseResponse()
        if let json = response.result.value {
            if let responseDictionary = json as? NSDictionary {
                cdUportResponse.error = responseDictionary as? Dictionary<String, String>
            }
        } else {
            cdUportResponse.handleUnspecifiedError()
        }
        return cdUportResponse
    }
    
    private func buildUrlForRequest(request: IRequest) -> String {
        let fullURL = serverUrl + apiVersion + request.url()
        print("\n\nFull URL is: " + fullURL)
        return serverUrl + apiVersion + request.url()
    }
}

