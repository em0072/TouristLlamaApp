//
//  MessageSwiftUIVC+MessageCellDelegate.swift
//  TouristLlama
//
//  Created by Evgeny Mitko on 02/10/2023.
//

import Foundation
import MessageKit
import EventKit
import EventKitUI
import Agrume
import OSLog
import MapKit
import Kingfisher

extension MessageSwiftUIVC: MessageCellDelegate {
    
    func didTapImage(in cell: MessageCollectionViewCell) {
        guard let indexPath = messagesCollectionView.indexPath(for: cell),
              let message = messages.item(at: indexPath.section),
              message.type == .userImage else {
                   return
           }
        if let imageIndex = mediaMessages.firstIndex(where: { $0.id == message.id }) {
            let overlay = AgrumeOverlay() { [weak self] in
                    guard let self else { return }
                    self.saveImage()
            }
            agrume = Agrume(dataSource: self, startIndex: imageIndex, overlayView: overlay, enableLiveText: true)
            agrume?.show(from: self)
        }
    }

    func saveImage() {
        guard let agrume else { return }
        let message = mediaMessages[agrume.currentIndex]
        if let image = message.image?.image {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        } else if let url = message.image?.url {
            KingfisherManager.shared.retrieveImage(with: url) { result in
                switch result {
                case .success(let imageResult):
                    UIImageWriteToSavedPhotosAlbum(imageResult.image, nil, nil, nil);
                case .failure:
                    Logger.default.error("Can't save image from url")
                }
            }
        }

    }

    func didSelectURL(_ url: URL) {
        UIApplication.shared.open(url)
    }
    
    func didSelectDate(_ date: Date) {
        let store = EKEventStore()
        let event = EKEvent(eventStore: store)
        event.startDate = date
        event.endDate = date
        let controller = EKEventEditViewController()
        controller.event = event
        controller.eventStore = store
        controller.editViewDelegate = self
        present(controller, animated: true)
    }
    
    func didSelectAddress(_ addressComponents: [String : String]) {
        Task {
            do {
                let address = addressComponents.reduce("", {
                    var component = $0
                    if !component.isEmpty {
                        component +=  ", "
                    }
                    component +=  $1.value
                    return component
                })
                let coordinates = try await coordinates(for: address)
                
                let regionDistance: CLLocationDistance = 100
                let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
                let options = [
                    MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
                    MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
                ]
                let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
                let mapItem = MKMapItem(placemark: placemark)
                mapItem.name = address
                mapItem.openInMaps(launchOptions: options)
            } catch {
                Logger.default.error("\(error.localizedDescription)")
            }
        }
    }
    
    func coordinates(for address: String) async throws -> CLLocationCoordinate2D {
        let geocoder = CLGeocoder()
        let placemark = try await geocoder.geocodeAddressString(address)
        guard let coordinate = placemark.first?.location?.coordinate else {
            throw CustomError(text: "Can't get coordinate")
        }
        return coordinate
    }
    
    
    func didSelectPhoneNumber(_ phoneNumber: String) {
        if let url = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            Logger.default.error("Can't call this number")
        }
    }
}

extension MessageSwiftUIVC: EKEventEditViewDelegate {
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        controller.dismiss(animated: true)
    }
}

