//
//  EditarViewController.swift
//  CoreDataAlexa
//
//  Created by Mac18 on 21/05/21.
//

import UIKit
import CoreData
class EditarViewController: UIViewController {
    var recibirNombre: String?
    var recibirTelefono: Int64?
    var recibirDireccion: String?
    var recibirCorreo: String?
    var indice: Int?
    var contactos = [Contacto]()
    // CONEXIÓN A LA BD
    let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var direccionTF: UITextField!
    @IBOutlet weak var correoTF: UITextField!
    @IBOutlet weak var telefonoTF: UITextField!
    @IBOutlet weak var imagenUser: UIImageView!
    @IBOutlet weak var nombreTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        cargarCoreData()
        imagenUser.image = UIImage(data: contactos[indice!].imagen!)
        // Do any additional setup after loading the view.
        nombreTF.text = recibirNombre
        correoTF.text = recibirCorreo
        telefonoTF.text = String(recibirTelefono!)
        direccionTF.text = recibirDireccion
        let gestura = UITapGestureRecognizer(target: self, action: #selector(clickImagen))
        gestura.numberOfTapsRequired = 1
        gestura.numberOfTouchesRequired = 1
        imagenUser.addGestureRecognizer(gestura)
        imagenUser.isUserInteractionEnabled =  true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    @objc func clickImagen(){
        //print("kjgdsfgjsdhg")
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func tomarfotoButton(_ sender: UIBarButtonItem) {
        let vc = UIImagePickerController()
        vc.sourceType = .savedPhotosAlbum
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func aceptarButton(_ sender: UIButton) {
        do {
            contactos[indice!].setValue(nombreTF.text, forKey: "nombre")
            //contactos[indice!].setValue(telefonoTF.text, forKey: "telefono")
            contactos[indice!].setValue(correoTF.text, forKey: "correo")
            contactos[indice!].setValue(direccionTF.text, forKey: "direccion")
            contactos[indice!].setValue(imagenUser.image?.pngData(), forKey: "imagen")
            
            try self.contexto.save()
            print("Se actualizó")
        } catch  {
            print("Error al actualizar \(error.localizedDescription)")
        }
        navigationController?.popViewController(animated: true)
    }
    @IBAction func cancelarButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    
    }
    

func cargarCoreData(){
    let fetchRequest : NSFetchRequest<Contacto> = Contacto.fetchRequest()
       // NSFetchRequest<Contacto> = Contacto.fetchRequest()
    do {
        contactos = try contexto.fetch(fetchRequest)
    } catch {
        print("Error al cargar los datos\(error.localizedDescription)")
    }
}
}

extension EditarViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imagenSelec = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            imagenUser.image = imagenSelec
        }
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    }

