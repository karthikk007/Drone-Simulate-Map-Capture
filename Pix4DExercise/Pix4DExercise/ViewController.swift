//
//  ViewController.swift
//  Pix4DExercise
//
//  Created by Andrei Mitache on 20.10.17.
//  Copyright © 2017 pix4d. All rights reserved.
//

import UIKit
import MapKit

enum MissionState {
    case idle
    case preparing
    case inProgress
}



class ViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var commandButton: UIButton!
    
    var missionState: MissionState = .idle
    
    @IBOutlet weak var progressView: UIProgressView!
    
    var drone : P4DDrone = P4DDroneSimulator()
    var droneAnnotation: DroneAnnotation?
    var droneAnnotationView: MKAnnotationView?
    
    var capturePlan = CapturePlan()
    
    var mission: P4DDroneMission?
    
    var timer = Timer()
    
    var photosTaken: [P4DDroneMediaDescriptor] = []

    @IBOutlet weak var showImagesButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // setup map
        mapView.mapType = .standard
        mapView.isRotateEnabled = false
        mapView.delegate = self
        
        // setup UI
        setMissionState(state: .idle)
        
        // setup drone monitoring
        self.timer.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.1,
                                          target: self,
                                          selector: #selector(self.monitorDroneInfo),
                                          userInfo: nil,
                                          repeats: true)
        
        progressView.isHidden = true
        showImagesButton.isHidden = true
        
        drone.connect { (error) in
            
            // center map to drone
            let droneCoord = self.drone.state.location.location2D
            let region = MKCoordinateRegionMakeWithDistance(droneCoord, 200, 200)
            self.mapView.setRegion(region, animated: true)
            
            // show drone home position
            let annotation = MKPointAnnotation();
            annotation.coordinate = self.drone.state.homeLocation;
            self.mapView.addAnnotation(annotation);
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func commandPressed() {
        
        switch self.missionState {
        case .idle:
            startMission()
        case .preparing:
            break
        case .inProgress:
            stopMission()
        }
    }
    
    func setMissionState(state: MissionState) {
        missionState = state
        DispatchQueue.main.async {
            switch self.missionState {
            case .idle:
                self.commandButton.setTitle("START",for: .normal)
            case .preparing:
                self.commandButton.setTitle("Preparing",for: .normal)
            case .inProgress:
                self.commandButton.setTitle("ABORT",for: .normal)
            }
        }
    }
    
    // MARK: - commands
    
    func stopMission() {
        
        drone.stopAndLoiter(completion: { error in
            print("drone stopped");
            // mission finish callback will be called by the drone
            self.drone.goHome(completion: { (error) in
                print("go home")
            }, withFinish: { (error) in
                print("go home finished.")
            })
        })
    }
    
    func startMission() {
        let mission = createMission()
        
        progressView.isHidden = true
        self.showImagesButton.isHidden = true
        
        photosTaken = [P4DDroneMediaDescriptor]()
        deleteDirectory()
        
        show(mission: mission)
        
        // setup callback for photo taken
        drone.camera.photoTakenCallback = { mediaDescriptor in
            print("photo taken: \(mediaDescriptor.mediaId)")
            self.photosTaken.append(mediaDescriptor)
        }
        
        self.setMissionState(state: .preparing)
        drone.prepare(mission, withProgress: { progress in
            print("mission prepare progress: \(progress)")
        }, withFinish: { error in
            print("mission prepare finished")
            
            self.drone.startMission(completion: { (error) in
                print("mission started")
                self.setMissionState(state: .inProgress)
            }, withFinish: { (error) in
                print("mission finished")
                self.setMissionState(state: .idle)
                self.downloadImages()
            })
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPhotos" {
            if let vc = segue.destination.childViewControllers[0] as? PhotosViewController {
                vc.photos = photosTaken
            }
        }
    }
    
    
    func downloadImages() {
        
        // TODO: implement download of images from the drone using drone.camera.downloadMediaList(...)
        // TODO: show download progress
        
        progressView.isHidden = false
        commandButton.isHidden = true
        self.progressView.setProgress(0, animated: true)
        
        var progress: Float = 0
        var count: Int = 0
        
        drone.camera.downloadMediaList(photosTaken, data: { (desc, data, error) in
            count += 1
            progress = Float(count) / Float(self.photosTaken.count)
            self.progressView.progress = progress
                
            print("\(String(describing: desc?.mediaId))")
            let image = UIImage(data: data!)
            self.saveImages(id: (desc?.mediaId)!, image: image!)
        }) { (error) in
            print("finished download")
            self.showImagesButton.isHidden = false
            self.commandButton.isHidden = false
        }
        
    }
    
    func directoryCheck() {
        if !isDocumentryExists() {
            createDirectory()
        }
    }
    
    @IBAction func unwindSeguefromDetailDetail(_ sender: UIStoryboardSegue) {
    }
    
    func saveImages(id: String, image: UIImage) {
        if let data = UIImagePNGRepresentation(image) {
            directoryCheck()
            let filename = getDocumentsDirectory().appending("/\(id)")
            let url = URL(fileURLWithPath: filename)
            try? data.write(to: url)
        }
    }
    
    func isDocumentryExists() -> Bool {
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("pix4d")
        
        print("kk path = \(paths)")
        
        if !fileManager.fileExists(atPath: paths) {
            return false
        } else {
            return true
        }
    }
    
    func getDocumentsDirectory() -> String {
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("pix4d")
        print("kk path = \(paths)")
        return paths
    }
    
    func createDirectory() {
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("pix4d")
        
        if !fileManager.fileExists(atPath: paths) {
            try! fileManager.createDirectory(atPath: paths, withIntermediateDirectories: true, attributes: nil)
        } else {
            print("kk Already dictionary created.")
        }
    }
    
    func deleteDirectory() {
        let fileManager = FileManager.default
        let paths = getDocumentsDirectory()
        
        if fileManager.fileExists(atPath: paths) {
            try! fileManager.removeItem(atPath: paths)
        } else {
            print("kk something wrong")
        }
    }
    
    
    // MARK: - mission
    
    func createMission() -> P4DDroneMission {
        
        // using the current drone location as the center of the mission
//        let coord = self.drone.state.location.location2D
        let coord = self.drone.state.homeLocation
        
        capturePlan = CapturePlan()
        capturePlan.centerCoordinate = coord
        capturePlan.rectangleWidth = 100
        capturePlan.rectangleHeight = 150
        capturePlan.rectangleRotation = 0//20
        capturePlan.rectangleBorder = 5
        capturePlan.flightAltitude = 50
        capturePlan.overlapFront = 0.5      // 50% front overlap
        capturePlan.overlapSide = 0.6       // 60% side overlap
        capturePlan.cameraPitch = 0
        
        let mission = FlightPlanning.createDroneMission(with: capturePlan,
                                                        cameraParameters: drone.camera.cameraParameters)
        
        self.mission = mission
        return mission;
    }
    
    func show(mission: P4DDroneMission) {
        
        // remove previous overlays
        mapView.removeOverlays(mapView.overlays)
        
        addPolygon()
        
        var points: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
        for waypoint in mission.waypoints {
            points.append(waypoint.location.location2D)
        }
        
        let overlays = points.map { MKCircle(center: CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude), radius: 1)
        }
        mapView.addOverlays(overlays)
        

        let annotations = points.map { PathAnnotation(coordinate: CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude))
        }


        mapView.addAnnotations(annotations)
        
        
        let polyline = MKPolyline(coordinates: &points, count: points.count)
        mapView.add(polyline)
    }
    
    
    // MARK: - drone update
    
    @objc func monitorDroneInfo() {
        if drone.state.connected {
            let droneCoord = self.drone.state.location.location2D
            self.showDrone(at: droneCoord, yaw: droneYawInRad())
        }
    }
    
    func showDrone(at coordinate: CLLocationCoordinate2D, yaw: Double) {
        if droneAnnotation == nil {
            droneAnnotation = DroneAnnotation(coordinate: coordinate)
            mapView.addAnnotation(droneAnnotation!)
        }
        droneAnnotation?.coordinate = coordinate
        droneAnnotationView?.transform = CGAffineTransform(rotationAngle: CGFloat(yaw))
    }
    
    func droneYawInRad() -> Double {
        let degrees = drone.state.orientation.yaw
        return (.pi * degrees) / 180
    }
    
    func yawInRad(_ coordinate: CLLocationCoordinate2D) -> Double {
        
        var degrees = drone.state.orientation.yaw
        
        if let mission = mission {
            for wayPoint in mission.waypoints {
                if areSameCoordinates(a: coordinate, b: wayPoint.location.location2D) {
                    degrees = wayPoint.orientation.yaw
                }
            }
        }

        return (.pi * degrees) / 180
    }
    
    func areSameCoordinates(a: CLLocationCoordinate2D, b: CLLocationCoordinate2D) -> Bool {
        if a.latitude == b.latitude && a.longitude == b.longitude {
            return true
        }
        
        return false
    }
    
    // MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if let annotation = annotation as? DroneAnnotation {
            let identifier = "Drone";
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
                dequeuedView.annotation = annotation
                droneAnnotationView = dequeuedView
            } else {
                droneAnnotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            }
            
            if let droneAnnotationView = droneAnnotationView {
                droneAnnotationView.canShowCallout = false
                droneAnnotationView.image = UIImage.init(named: "drone.png")
                
                droneAnnotationView.transform = CGAffineTransform(rotationAngle: CGFloat(droneYawInRad()))
            }
            
            return droneAnnotationView
        }

        if let annotation = annotation as? PathAnnotation {
            let identifier = "Path";
            var pathAnnotationView: MKAnnotationView?
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
                dequeuedView.annotation = annotation
                pathAnnotationView = dequeuedView
            } else {
                pathAnnotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            }

            if let pathAnnotationView = pathAnnotationView {
                pathAnnotationView.canShowCallout = false
                pathAnnotationView.image = UIImage.init(named: "photo_marker")
                pathAnnotationView.transform = CGAffineTransform(rotationAngle: CGFloat(yawInRad(annotation.coordinate)))
                pathAnnotationView.transform = pathAnnotationView.transform.scaledBy(x: 1.4, y: 1.4)
            }

            return pathAnnotationView
        }
        
        if annotation is MKPointAnnotation {
            let identifier = "Home";
            var pinView: MKPinAnnotationView;
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                pinView = dequeuedView
            } else {
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            }
            return pinView
        }
        
        return nil
    }
    
    func addPolygon() {
        
        let waypoints: [P4DDroneWaypoint] = FlightPlanning.getRectanglePoints(capturePlan,
                                                                              cameraParameters: drone.camera.cameraParameters) as! [P4DDroneWaypoint]
        
        let points = waypoints.map { $0.location.location2D }
        
        let locations = points.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
        let polygon = MKPolygon(coordinates: locations, count: locations.count)
        mapView.add(polygon)

    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        if overlay is MKPolygon {
            let renderer = MKPolygonRenderer(polygon: overlay as! MKPolygon)
            renderer.fillColor = UIColor.black.withAlphaComponent(0.25)
            renderer.strokeColor = UIColor.green
            renderer.lineWidth = 3
            return renderer
        } else if overlay is MKCircle {
            let renderer = MKCircleRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.orange
            renderer.lineWidth = 2.0
            return renderer
        } else if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            let color = UIColor.blue
            renderer.strokeColor = color
            renderer.lineWidth = 1.0
            return renderer
        }
        
        return MKPolylineRenderer()
    }
}

