//
//  ViewController.swift
//  CoreDataAlexa
//
//  Created by Mac18 on 20/05/21.
//

import UIKit
import CoreData
class ViewController: UIViewController {
    
    
    
    
    
    var nombreEnviar: String?
    var telefonoEnviar: Int64?
    var direccionEnviar: String?
    var correoEnviar: String?
    var indiceEnviar: Int?
    var contactos = [Contacto]()
    // CONEXIÓN A LA BD
    let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var tablaC: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cargarCoreData()
        tablaC.reloadData()
       // let new = MiContacto(nombre: "Alexa", numero: 4431631965, direccion: "Morelia", correo: "aly17@hotmail.com")
       // contactos.append(new)
        // Do any additional setup after loading the view.
        tablaC.delegate = self
        tablaC.dataSource = self
        tablaC.register(UINib(nibName: "ContactoTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    override func viewWillAppear(_ animated: Bool) {
        tablaC.reloadData()
    }
    @IBAction func agregarC(_ sender: UIBarButtonItem) {
        let alerta = UIAlertController(title: "Agregar", message: "Nuevo contacto", preferredStyle: .alert)
        
        let accionAceptar = UIAlertAction(title: "Agregar", style: .default) { (_) in
            print("lalala")
            
            guard let nombreAlert = alerta.textFields?.first?.text else { return }
            guard let numeroAlert = Int64(alerta.textFields?[1].text ?? "00000000") else { return }
            guard let correoAlert = alerta.textFields?[2].text else { return }
            guard let ciudadAlert = alerta.textFields?[3].text else { return }
            let imagenTemp = UIImageView(image: #imageLiteral(resourceName: "cara"))
            //let nuevo = MiContacto(nombre: nombreAlert, numero: numeroAlert, direccion: ciudadAlert, correo: correoAlert)
            
            let nuevoC = Contacto(context: self.contexto)
            nuevoC.nombre = nombreAlert
            nuevoC.telefono = numeroAlert
            nuevoC.direccion = ciudadAlert
            nuevoC.correo = correoAlert
            nuevoC.imagen = imagenTemp.image!.pngData()
            
            self.contactos.append(nuevoC)
            self.guardarContacto()
            self.tablaC.reloadData()
        }
        
        alerta.addTextField { (nombreTF) in
            nombreTF.placeholder = "Nombre"
           
            nombreTF.autocapitalizationType = .words
        }
        
        alerta.addTextField { (numeroTF) in
            numeroTF.placeholder = "Número"
            numeroTF.keyboardType = .numberPad
        }
        
        alerta.addTextField { (correoTF) in
           correoTF.placeholder = "Correo"
        }
        
        alerta.addTextField { (ciudadTF) in
            ciudadTF.placeholder = "Dirección"
            ciudadTF.autocapitalizationType = .words
        }
        
        alerta.addAction(accionAceptar)
        
        
        let accionCancelar = UIAlertAction(title: "Calcelar", style: .cancel, handler: nil)
        
        alerta.addAction(accionCancelar)
        present(alerta, animated: true)
    }
    
    func guardarContacto(){
        do {
            try contexto.save()
         
        } catch let error as NSError {
            print("Error al guardar: \(error.localizedDescription)")
        }
        
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
extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tablaC.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ContactoTableViewCell
        celda.nombreLabel.text = contactos[indexPath.row].nombre
        celda.numeroLabel.text = "📲 \(contactos[indexPath.row].telefono)"
        celda.correoLabel.text = "📩 \(contactos[indexPath.row].correo ?? "Sin correo")"
        celda.imagenContactp.image = UIImage(data: contactos[indexPath.row].imagen!)
        return celda
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tablaC.deselectRow(at: indexPath, animated: true)
        nombreEnviar = contactos[indexPath.row].nombre
        direccionEnviar = contactos[indexPath.row].direccion
        correoEnviar = contactos[indexPath.row].correo
        telefonoEnviar = contactos[indexPath.row].telefono
        indiceEnviar = indexPath.row
        
        performSegue(withIdentifier: "editarContacto", sender: self)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let accionBorrar = UIContextualAction(style: .normal, title: "") { (_, _, _) in
            print("BORRAAAAR")
            self.contexto.delete(self.contactos[indexPath.row])
            self.contactos.remove(at: indexPath.row)
            self.guardarContacto()
            self.tablaC.reloadData()
        }
        accionBorrar.image = UIImage(named: "borrar")
        //accionBorrar.backgroundColor = .systemPink
        return UISwipeActionsConfiguration(actions: [accionBorrar])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let accionLlamada = UIContextualAction(style: .normal, title: "") { (_, _, _) in
            print("llamadaaa")
        }
        accionLlamada.image = UIImage(named: "llamada")
       // accionLlamada.backgroundColor =
        
        let accionMensaje = UIContextualAction(style: .normal, title: "") { (_, _, _) in
            print("correoooo")
        }
        accionMensaje.image = UIImage(named: "mensaje")
        return UISwipeActionsConfiguration(actions: [accionLlamada, accionMensaje])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editarContacto" {
            let ObjEditar = segue.destination as! EditarViewController
            ObjEditar.recibirNombre = nombreEnviar
            ObjEditar.recibirTelefono = telefonoEnviar
            ObjEditar.recibirCorreo = correoEnviar
            ObjEditar.recibirDireccion = direccionEnviar
            ObjEditar.indice = indiceEnviar
        }
    }
    }
    


