//
//  Database.swift
//  Doctor Appointment Moveo
//
//  Created by Michael Sonnino on 30/07/2021.
//

import Foundation
import CoreData
import UserNotifications


class Database {
    
    //MARK: - "Server" - Automatic Update - we use a timer to constantly update the database essentially functioning as a server
    
    init() {
        // Here we init the database timer wich keeps refreshing the data
        startConstantUpdate()
    }
    
    // We use the timer to constantly update the database
    var timer: Timer?
    
    func startConstantUpdate() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
        timer?.fire()
    }
    
    // This code is run every second
    @objc func runTimedCode() {
        refreshAppointments()
    }
    
    //MARK: - Setup
    
    static let shared = Database()
    
    // CoreData context
    private let context = PersistenceController.shared.container.viewContext
    
    enum DBRequestResult {
        case success
        case failure
    }
    
    
    //MARK: - Create
    
    func createDoctor(doctor: Doctor, password: String) -> DBRequestResult {
        
        if !checkIfDoctorExists(email: doctor.email) {
            let newDoctor = DoctorEntity(context: context)
            newDoctor.id = doctor.id
            newDoctor.fName = doctor.fName
            newDoctor.lName = doctor.lName
            newDoctor.email = doctor.email
            newDoctor.password = password
            do {
                try context.save()
                return .success
            } catch {
                print("Error saving to context: \(error)")
            }
        }
        return .failure
        
    }
    
    func createPatient(patient: Patient, password: String) -> DBRequestResult {
        
        if !checkIfPatientExists(email: patient.email) {
            let newPatient = PatientEntity(context: context)
            newPatient.id = patient.id
            newPatient.fName = patient.fName
            newPatient.lName = patient.lName
            newPatient.email = patient.email
            newPatient.password = password
            do {
                try context.save()
                return .success
            } catch {
                print("Error saving to context: \(error)")
            }
        }
        return .failure
    }
    
    
    func createAppointment(appointment: Appointment) -> DBRequestResult {
        
        // We use fetchPatientEntity and fetchDoctorEntity so that we can maintain relationships in our database
        guard let patient = fetchPatientEntity(id: appointment.patientDetails.id) else {fatalError()}
        guard let doctor = fetchDoctorEntity(id: appointment.doctorDetails.id) else { fatalError()}
        
        let newAppointmentEntity = AppointmentEntity(context: context)
        newAppointmentEntity.id = appointment.id
        newAppointmentEntity.patient = patient
        newAppointmentEntity.doctor = doctor
        newAppointmentEntity.timeCreated = appointment.timeCreated
        newAppointmentEntity.timeStarting = appointment.timeStarting
        do {
            try context.save()
            return .success
        } catch {
            print("Error saving context: \(error)")
        }
        return .failure
    }
    
    
    //MARK: - Read (User Authentication)
        
    func authDoctor(email: String, password: String) -> Doctor? {
        if let doctor = fetchDoctorEntity(email: email) {
            if doctor.password == password {
                return creatDoctorFromEntity(entity: doctor)
            }
        }
        return nil
    }
    
    func authPatient(email: String, password: String) -> Patient? {
        if let patient = fetchPatientEntity(email: email) {
            if patient.password == password {
                return creatPatientFromEntity(entity: patient)
            }
        }
        return nil
    }
    
    //MARK: - Read (Fetching Data)

    // When fetching data from the DB we make sure to return objects that conform to our App's data structure
    
    // Fetch all doctors
    func fetchAllDoctors() -> [Doctor] {
        
        var doctors = [Doctor]()
        
        let request = NSFetchRequest<DoctorEntity>(entityName: "DoctorEntity")
        request.predicate = nil
        
        do {
            let fetchedDoctors = try context.fetch(request)
            for doctor in fetchedDoctors {
                let newDoctor = creatDoctorFromEntity(entity: doctor)
                doctors.append(newDoctor)
            }
        } catch {
            print("Error fetching all doctors: \(error)")
        }
        return doctors
    }
   
    // Fetch a single doctor from given ID
    func fetchDoctor(with id: UUID) -> Doctor? {
        let request = NSFetchRequest<DoctorEntity>(entityName: "DoctorEntity")
        let stringId = id.description
        request.predicate = NSPredicate(format: "id = %@", stringId)
        
        do {
            let doctors = try context.fetch(request)
            if let doctor = doctors.first {
                let newDoctor = creatDoctorFromEntity(entity: doctor)
                return newDoctor
            }
        } catch {
            print("Error with fetch request: \(error)")
        }
        return nil
    }
    
    // Fetch a single patient from given ID
    func fetchPatient(with id: UUID) -> Patient? {
        let request = NSFetchRequest<PatientEntity>(entityName: "PatientEntity")
        let stringId = id.description
        request.predicate = NSPredicate(format: "id = %@", stringId)
        
        do {
            let patients = try context.fetch(request)
            if let patient = patients.first {
                let newPatient = creatPatientFromEntity(entity: patient)
                return newPatient
            }
        } catch {
            print("Error with fetch request: \(error)")
        }
        return nil
    }
    
    //MARK: - Update
    
    //MARK: - Delete
    
    // Delete all appointments (This is just for debugging)
//    func deleteAllAppointments() {
//        let request = NSFetchRequest<AppointmentEntity>(entityName: "AppointmentEntity")
//        request.predicate = nil
//
//        do {
//            let appointments = try context.fetch(request)
//            for appointment in appointments {
//                context.delete(appointment)
//            }
//            do {
//                try context.save()
//            } catch {
//                print("Error saving to context: \(error)")
//            }
//        } catch {
//            print("Error with fetch request: \(error)")
//        }
//    }
    
    
    // Cancel appointment (Before it has started)
    func cancelAppointment(id: UUID) -> DBRequestResult {
        if let appointmentToCancel = fetchAppointmentEntity(id: id) {
            
//             Make sure the appointment hasn't started yet
            if appointmentToCancel.timeStarting! < Date() {
                return .failure
            }
            
            // Since this appointment is being cancelled before it started we make sure to update all following appointments' starting time
            
            if let appointments = appointmentToCancel.doctor!.appointments as? Set<AppointmentEntity> {
                for appointment in appointments {
                    if appointment.timeCreated! > appointmentToCancel.timeCreated! {
                        appointment.timeStarting! -= TimeInterval(Appointment.constantDurationInSeconds)
                    }
                }
                context.delete(appointmentToCancel)
                do {
                    try context.save()
                    return .success
                } catch {
                    print("Error saving to context: \(error)")
                }
            }
        }
        return .failure
    }
    
    //MARK: - "Server methods" - these methods run every second to keep the database updated
    
    // Delete all finished appointments. This method is called every second.
    // This function also send a notification when an appointment is starting
    
    private func refreshAppointments() {
        let request = NSFetchRequest<AppointmentEntity>(entityName: "AppointmentEntity")
        request.predicate = nil
        
        let now = Date()
        do {
            let appointments = try context.fetch(request)
            for appointment in appointments {
                
                // If "now" is in the ±1 sec of appointment starting time we send a notification
                if (appointment.timeStarting! - 0.7 <= now) && (now <= appointment.timeStarting! + 0.7) {
                    
                    // In reality we would have a server apporprietly set up to send Push Notifications.
                    // The notification would be sent to the relevant user of course. Here we just prompt the notification on the device with the patient's name
                    
                    sendUserNotification(to: appointment.patient!)
                    
                }
                // If "now" is has passed the time of the appointment duration we delete this appointment
                if (now > (appointment.timeStarting! + TimeInterval(Appointment.constantDurationInSeconds))) {
                    context.delete(appointment)
                }
            }
            do {
                try context.save()
            } catch {
                print("Error saving to context: \(error)")
            }
        } catch {
            print("Error with fetch request: \(error)")
        }
    }
    
    private func sendUserNotification(to patient: PatientEntity) {
        
        // Create notification content
        let content = UNMutableNotificationContent()
        content.title = "Appontment Starting"
        content.body = "\(patient.fName!) \(patient.lName!) your appointment is now starting"
        content.sound = .default
        
        // Create the trigger for notification
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        
        // Register the notification
        // Create the request
        let notificationId = UUID()
        let uuidString = notificationId.uuidString
        let request = UNNotificationRequest(identifier: uuidString,
                    content: content, trigger: trigger)

        // Schedule the request with the system.
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
           if error != nil {
            print("Error scheduling notification request: \(error!.localizedDescription)")
           }
        }
        
    }
    
    //MARK: - Helpers functions
    
    private func checkIfDoctorExists(email: String) -> Bool {
        let request = NSFetchRequest<DoctorEntity>(entityName: "DoctorEntity")
        request.predicate = NSPredicate(format: "email = %@", email)
        
        do {
            let doctors = try context.fetch(request)
            if doctors.first != nil {
                print("Doctor user with email \(email) exists")
                return true
            }
        } catch {
            print("Error with fetch request: \(error)")
        }
        return false
    }
    
    private func checkIfPatientExists(email: String) -> Bool {
        let request = NSFetchRequest<PatientEntity>(entityName: "PatientEntity")
        request.predicate = NSPredicate(format: "email = %@", email)
        
        do {
            let patients = try context.fetch(request)
            if patients.first != nil {
                print("Patient user with email \(email) exists")
                return true
            }
        } catch {
            print("Error with fetch request: \(error)")
        }
        return false
    }
    
    //MARK: - Helpers - Fetching Entities
    // We fetch entities to maintain the database's relationships
    
    private func fetchDoctorEntity(id: UUID) -> DoctorEntity? {
        let request = NSFetchRequest<DoctorEntity>(entityName: "DoctorEntity")
        let stringId = id.description
        request.predicate = NSPredicate(format: "id = %@", stringId)
        
        do {
            let doctors = try context.fetch(request)
            if let doctor = doctors.first {
                return doctor
            }
        } catch {
            print("Error with fetch request: \(error)")
        }
        return nil
    }
    
    private func fetchPatientEntity(id: UUID) -> PatientEntity? {
        let request = NSFetchRequest<PatientEntity>(entityName: "PatientEntity")
        let stringId = id.description
        request.predicate = NSPredicate(format: "id = %@", stringId)
        
        do {
            let patients = try context.fetch(request)
            if let patient = patients.first {
                return patient
            }
        } catch {
            print("Error with fetch request: \(error)")
        }
        return nil
    }
    
    private func fetchDoctorEntity(email: String) -> DoctorEntity? {
        let request = NSFetchRequest<DoctorEntity>(entityName: "DoctorEntity")
        request.predicate = NSPredicate(format: "email = %@", email)
        
        do {
            let doctors = try context.fetch(request)
            if let doctor = doctors.first {
                return doctor
            }
        } catch {
            print("Error with fetch request: \(error)")
        }
        return nil
    }
    
    private func fetchPatientEntity(email: String) -> PatientEntity? {
        let request = NSFetchRequest<PatientEntity>(entityName: "PatientEntity")
        request.predicate = NSPredicate(format: "email = %@", email)
        
        do {
            let patients = try context.fetch(request)
            if let patient = patients.first {
                return patient
            }
        } catch {
            print("Error with fetch request: \(error)")
        }
        return nil
    }
    
    private func fetchAppointmentEntity(id: UUID) -> AppointmentEntity? {
        let request = NSFetchRequest<AppointmentEntity>(entityName: "AppointmentEntity")
        let stringId = id.description
        request.predicate = NSPredicate(format: "id = %@", stringId)
        
        do {
            let appointments = try context.fetch(request)
            if let appointment = appointments.first {
                return appointment
            }
        } catch {
            print("Error with fetch request: \(error)")
        }
        return nil
    }
    
    //MARK: - Helpers - Converting Entities to Objects
    // We convert DB entities to objects that conform to our app's structs
    
    private func creatPatientFromEntity(entity patientEntity: PatientEntity) -> Patient {
        var appointment: Appointment? = nil
        if patientEntity.appointment != nil {
            appointment = createAppointmentFromEntity(entity: patientEntity.appointment!)
        }
        let patient = Patient(id: patientEntity.id!, fName: patientEntity.fName!, lName: patientEntity.lName!, email: patientEntity.email!, appointment: appointment)
        
        return patient
    }
    
    private func creatDoctorFromEntity(entity doctorEntity: DoctorEntity) -> Doctor {
        
        var doctor = Doctor(id: doctorEntity.id!, fName: doctorEntity.fName!, lName: doctorEntity.lName!, email: doctorEntity.email!, appointments: [])
        
        if let appointments = doctorEntity.appointments as? Set<AppointmentEntity> {
            for appointment in appointments {
                let newAppointment = createAppointmentFromEntity(entity: appointment)
                doctor.appointments.append(newAppointment)
            }
        }
        
        return doctor
    }
    
    private func createAppointmentFromEntity(entity appointmentEntity: AppointmentEntity) -> Appointment {
        
        let doctorDetails = Appointment.DoctorDetails(id: appointmentEntity.doctor!.id!, fName: appointmentEntity.doctor!.fName!, lName: appointmentEntity.doctor!.lName!)
        
        let patientDetails = Appointment.PatientDetails(id: appointmentEntity.patient!.id!, fName: appointmentEntity.patient!.fName!, lName: appointmentEntity.patient!.lName!)
        
        let newAppointment = Appointment(id: appointmentEntity.id!, patientDetails: patientDetails, doctorDetails: doctorDetails, timeCreated: appointmentEntity.timeCreated!, timeStarting: appointmentEntity.timeStarting!)
        
        return newAppointment
        
    }
    
    
}

