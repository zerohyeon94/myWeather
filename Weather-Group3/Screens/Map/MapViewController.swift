//
//  MapViewController.swift
//  Weather-Group3
//
//  Created by SR on 2023/10/02.
//

import CoreLocation
import MapKit
import UIKit

class MapViewController: UIViewController {
    let buttonSize: CGFloat = 50.0
    
    var currentLatitude: Double = 37.5729
    var currentLongitude: Double = 126.9794
    
    var temperature: Int = 0
    var pressure: Int = 0
    var humidity: Int = 0
    
    var pinTintColor: UIColor = .systemBackground
    var annotationText: String = "24℃"
    var systemImageName: String = "thermometer.low"
    
    let mapView = MKMapView()
    let completeButton = UIButton()
    let locationButton = UIButton()
    let listButton = UIButton()
    let layerButton = UIButton()
    
    let manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        getCurrentLocation()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
        showLocation(latitude: currentLatitude, longitude: currentLongitude, pinTintColor: pinTintColor, annotationText: annotationText, systemImageName: systemImageName)
    }
}

extension MapViewController {
    private func setup() {
        mapView.delegate = self
        mapView.mapType = .hybrid
        
        view.addSubview(mapView)
        view.addSubview(completeButton)

        view.addSubview(locationButton)
        view.addSubview(listButton)
        view.addSubview(layerButton)
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        listButton.translatesAutoresizingMaskIntoConstraints = false
        layerButton.translatesAutoresizingMaskIntoConstraints = false
        
        completeButton.setTitle("완료", for: .normal)
        completeButton.setTitleColor(.label, for: .normal)
        completeButton.backgroundColor = .secondarySystemBackground
        completeButton.layer.cornerRadius = 8
        completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        
        locationButton.setImage(UIImage(systemName: "location"), for: .normal)
        locationButton.tintColor = .label
        locationButton.backgroundColor = .secondarySystemBackground
        locationButton.layer.cornerRadius = 8
        locationButton.addTarget(self, action: #selector(locationButtonTapped), for: .touchUpInside)
        
        listButton.setImage(UIImage(systemName: "list.bullet"), for: .normal)
        listButton.tintColor = .label
        listButton.backgroundColor = .secondarySystemBackground
        listButton.layer.cornerRadius = 8
        listButton.addTarget(self, action: #selector(listButtonTapped), for: .touchUpInside)
        
        layerButton.setImage(UIImage(systemName: "square.3.layers.3d"), for: .normal)
        layerButton.tintColor = .label
        layerButton.backgroundColor = .secondarySystemBackground
        layerButton.layer.cornerRadius = 8
        layerButton.addTarget(self, action: #selector(layerButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            completeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            completeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            completeButton.widthAnchor.constraint(equalToConstant: buttonSize),
            completeButton.heightAnchor.constraint(equalToConstant: buttonSize),
            
            locationButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            locationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            locationButton.widthAnchor.constraint(equalToConstant: buttonSize),
            locationButton.heightAnchor.constraint(equalToConstant: buttonSize),
            
            listButton.topAnchor.constraint(equalTo: completeButton.bottomAnchor, constant: 8),
            listButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            listButton.widthAnchor.constraint(equalToConstant: buttonSize),
            listButton.heightAnchor.constraint(equalToConstant: buttonSize),
            
            layerButton.topAnchor.constraint(equalTo: listButton.bottomAnchor, constant: 8),
            layerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            layerButton.widthAnchor.constraint(equalToConstant: buttonSize),
            layerButton.heightAnchor.constraint(equalToConstant: buttonSize),
        ])
    }
    
    @objc
    func completeButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    func locationButtonTapped(_ sender: UIButton) {
        getCurrentLocation()
        showLocation(latitude: currentLatitude, longitude: currentLongitude, pinTintColor: pinTintColor, annotationText: annotationText, systemImageName: systemImageName)
    }
    
    @objc
    func listButtonTapped(_ sender: UIButton) {
        let alertController = UIAlertController(title: "My Regions", message: "지도에 표시되는 지역 정보", preferredStyle: .actionSheet)
        let option1 = UIAlertAction(title: "서울", style: .default) { [self] _ in
            mapView.removeAnnotations(mapView.annotations)
            currentLatitude = 37.5729
            currentLongitude = 126.9794
            systemImageName = "thermometer.low"
            annotationText = "\(temperature)℃"
            getWeatherInfo(currentLatitude: currentLatitude, currentLongitude: currentLongitude)
        }
        let option2 = UIAlertAction(title: "제주", style: .default) { [self] _ in
            mapView.removeAnnotations(mapView.annotations)
            currentLatitude = 33.4996
            currentLongitude = 126.5312
            systemImageName = "thermometer.low"
            annotationText = "\(temperature)℃"
            getWeatherInfo(currentLatitude: currentLatitude, currentLongitude: currentLongitude)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
               
        alertController.addAction(option1)
        alertController.addAction(option2)
        alertController.addAction(cancelAction)
               
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }
               
        present(alertController, animated: true, completion: nil)
    }
    
    @objc
    func layerButtonTapped(_ sender: UIButton) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let option1 = UIAlertAction(title: "기온", style: .default) { _ in
            self.setCustomPin(pinTintColor: .white, annotationText: "\(self.temperature)℃", systemImageName: "thermometer.low")
        }
        let option2 = UIAlertAction(title: "기압", style: .default) { _ in
            self.setCustomPin(pinTintColor: .white, annotationText: "\(self.pressure)", systemImageName: "mountain.2")
        }
        let option3 = UIAlertAction(title: "습도", style: .default) { _ in
            self.setCustomPin(pinTintColor: .white, annotationText: "\(self.humidity)%", systemImageName: "humidity")
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(option1)
        alertController.addAction(option2)
        alertController.addAction(option3)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
}

extension MapViewController: CLLocationManagerDelegate {
    private func getCurrentLocation() {
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func showLocation(latitude: Double, longitude: Double, pinTintColor: UIColor, annotationText: String, systemImageName: String) {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let span = MKCoordinateSpan(latitudeDelta: 5.0, longitudeDelta: 5.0)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
        setCustomPin(pinTintColor: pinTintColor, annotationText: annotationText, systemImageName: systemImageName)
    }
    
    func setCustomPin(pinTintColor: UIColor, annotationText: String, systemImageName: String) {
        let customPin = CustomAnnotation(pinTintColor: pinTintColor,
                                         annotationText: annotationText,
                                         systemImageName: systemImageName)
        
        customPin.coordinate = CLLocationCoordinate2D(latitude: currentLatitude, longitude: currentLongitude)
        mapView.addAnnotation(customPin)
    }
    
    func getWeatherInfo(currentLatitude: Double, currentLongitude: Double) {
        let baseURL = "https://api.openweathermap.org/data/2.5/forecast"
        let apiKey = WeatherAPIService().apiKey
        let urlString = "\(baseURL)?lat=\(currentLatitude)&lon=\(currentLongitude)&appid=\(apiKey)"
        
        WeatherAPIService().getLocalWeather(url: urlString) { result in
            switch result {
            case .success(let weatherResponse):
                DispatchQueue.main.async {
                    if let firstWeather = weatherResponse.list.first {
                        let tempChange = Int(firstWeather.main.temp - 273.15)
                        self.temperature = tempChange
                        self.pressure = firstWeather.main.pressure
                        self.humidity = firstWeather.main.humidity
                    }
                    print("#mapVC: \(weatherResponse.list)")
                }
            case .failure:
                print("실패: error")
            }
        }
        showLocation(latitude: currentLatitude, longitude: currentLongitude, pinTintColor: pinTintColor, annotationText: annotationText, systemImageName: systemImageName)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            currentLatitude = location.coordinate.latitude
            currentLongitude = location.coordinate.longitude
            manager.stopUpdatingLocation()
            getWeatherInfo(currentLatitude: currentLatitude, currentLongitude: currentLongitude)
        }
    }
}
