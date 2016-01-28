//
//  RxX.swift
//
//  Copyright © 2015 Alejandro Martinez. All rights reserved.
//

import RxSwift

extension ObservableType {
    func printOnNext(prefix prefix: String = "") -> Observable<E> {
        return self.doOn(onNext: { print("\(prefix)\($0)") })
    }
    
    func printOnNext(text: E -> String) -> Observable<E> {
        return self.doOn(onNext: { print(text($0)) })
    }
}
