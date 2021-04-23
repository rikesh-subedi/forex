//
//  ExchangeRepository.swift
//  Forex
//
//  Created by Subedi, Rikesh on 14/01/21.
//

import SwiftUI
import Combine
import CoreData

enum ForexError: Error {
    case networkError(value: String)
}
class ExchangeRepository : ExchangeRepositoryInterface{
    var viewContext : NSManagedObjectContext
    var cancellable: AnyCancellable?
    init(persistentController: PersistenceController) {
        viewContext = persistentController.container.viewContext
    }
    func fetchExchanges(src: String, tryCached: Bool = true) -> Future<ExchangeResponse, Error> {
        //fetch offline
        let pub = Future<ExchangeResponse, Error>.init({promise in

            if tryCached, let exchangeResponse = self.getPersistedData() {
                promise(.success(exchangeResponse))
            } else {
                self.cancellable = CurrencyService.getExchangeList(src: src)
                    .execute()
                    .sink { (error) in
                        promise(.failure(ForexError.networkError(value: "Unable to fetch data")))
                    } receiveValue: { (response) in
                        self.persistData(data: response)
                        promise(.success(response))
                    }

            }

        })
        return pub
    }

    private func persistData(data: ExchangeResponse) {
        guard let response = try? JSONEncoder().encode(data), let responseString = String.init(data: response, encoding: String.Encoding.utf8) else {
            return
        }
        let entity = NSEntityDescription.entity(forEntityName: "ExchangeResponseOffline",
                                                in: viewContext)!
        var managedObject:NSManagedObject? = nil
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "ExchangeResponseOffline")
        if let exchangeResponseEntity = try? viewContext.fetch(fetchRequest), let firstItem = exchangeResponseEntity.first {
            managedObject = firstItem
        } else {
            managedObject = NSManagedObject(entity: entity, insertInto: viewContext)
        }
        managedObject?.setValue(responseString, forKey: "response")
        managedObject?.setValue(Date(), forKey: "timestamp")
        do {
            try viewContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    private func getPersistedData() -> ExchangeResponse? {
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "ExchangeResponseOffline")
        do {
            let exchangeResponseEntity = try viewContext.fetch(fetchRequest)
            if let firstItem = exchangeResponseEntity.first, let response = firstItem.value(forKey: "response") as? String {
                if let timestamp = firstItem.value(forKey: "timestamp") as? Date, Date().timeIntervalSince(timestamp) < 30 * 60 {
                    return try? JSONDecoder().decode(ExchangeResponse.self, from: response.data(using: String.Encoding.utf8)!)
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return nil
    }
}
