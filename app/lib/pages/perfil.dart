import 'dart:convert';
import 'dart:io';
import 'package:app/pages/widget.dart';
import 'package:app/token/accces_token-dart.dart';
import 'package:flutter/material.dart';
import 'package:app/utils/colors.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_picker/image_picker.dart';

class perfil extends StatefulWidget {
  const perfil({super.key});
  static const route = '/perfil';

  @override
  State<perfil> createState() => _perfilState();
}

class _perfilState extends State<perfil> {
  bool _mostrarIndicadorCarga = false;
  String firstName = "";
  String lastName = "";
  String email = "";
  String userName = "";
  String role = "";
  String image = "";

  bool _obscureTextActual = true;
  final bool _obscureTextNew = true;
  final bool _obscureTextNew2 = true;
  Auth auth = Auth();
  late int idUser;

  // Controladores de los campos password
  TextEditingController current_password = TextEditingController();
  TextEditingController new_password = TextEditingController();
  TextEditingController rep_new_password = TextEditingController();

  bool editar = false;
  //File? imagen;

  String? imagePath1;

  final picker = ImagePicker();

  Future<void> pickMedia(ImageSource source) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    XFile? file;
    file = await ImagePicker().pickImage(source: source);
    if (file != null) {
      imagePath1 = file.path;
      await updateImg();
    }
  }

  Image imagenFromBase64(String s) {
    return Image.memory(base64Decode(s));
  }

  String imageToBase64(String imagePath) {
    File imageFile = File(imagePath);

    if (!imageFile.existsSync()) {
      print('La imagen no existe en la ruta proporcionada.');
      return "";
    }

    List<int> imageBytes = imageFile.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);

    return base64Image;
  }

  Future<String> toBase64C(String ruta) async {
    if (ruta.isNotEmpty) {
      ImageProperties properties =
      await FlutterNativeImage.getImageProperties(ruta);
      File compressedFile = await FlutterNativeImage.compressImage(ruta,
          quality: 65,
          targetWidth: 400,
          targetHeight: (properties.height! * 400 / properties.width!).round());
      final bytes = await compressedFile.readAsBytes();
      String img64 = base64Encode(bytes);
      return img64;
    } else {
      return "";
    }
  }

  Future<void> updateImg() async {
    String img_64 = "";

    if (imagePath1 != null) {
      img_64 = await toBase64C(imagePath1!);
    }

    try {
      final response = await http.put(
        Uri.parse("http://${dotenv.env['BASE_URL']}/user/${idUser}/image"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${auth.token}',
        },
        body: jsonEncode(<String, dynamic>{"image": img_64}),
      );
      if (response.statusCode == 200) {
        image = img_64;
        print("imagen ingresada");
      } else {
        print("Error al crear reporte");
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  // Llamada API para cambiar contraseña
  Future<void> changePassword(BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('http://${dotenv.env['BASE_URL']}/user/change-password'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${auth.token}',
        },
        body: jsonEncode(<String, String>{
          "current_password": current_password.text,
          "new_password": new_password.text
        }),
      );
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
            msg: responseData['message'],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        // Si fue 200 que llama a logout para que se elimine el token, y limpiar token y navegar a la pantalla de login
        await logout(context);
        //await auth.clearToken();
        //Navigator.pushNamed(context, '/login');
      } else {
        Fluttertoast.showToast(
            msg: responseData['error'],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.red,
            textColor: Colors.red,
            fontSize: 12.0);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  // Widget de los campos de texto de password
  Widget sectionPassword(
      TextEditingController controller, String label, bool obscureText) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      height: 60,
      child: TextFormField(
        controller: controller,
        obscureText: _obscureTextActual,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: Icon(
              _obscureTextActual ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() {
                _obscureTextActual =
                !_obscureTextActual; // Cambia entre texto visible y oculto
              });
            },
          ),
          labelText: label,
        ),
      ),
    );
  }

  // Widget de la sección de cambiar contraseña
  Widget updatePassword(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          sectionPassword(
              current_password, "Contraseña Actual", _obscureTextActual),
          sectionPassword(new_password, "Nueva Contraseña", _obscureTextNew),
          sectionPassword(
              rep_new_password, "Repetir Nueva Contraseña", _obscureTextNew2),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              // Realiza una validacion de contraseñas antes de poder llamae a la API para cambiar contraseña
              onPressed: () async {
                if (new_password.text != rep_new_password.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Las contraseñas no coinciden')),
                  );
                } else if (current_password.text.isEmpty ||
                    new_password.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Existen campos vacios')));
                  // Validate returns true if the form is valid, or false otherwise.
                } else {
                  await changePassword(context);
                }
              },
              child: const Text('Cambiar'),
            ),
          ),
        ],
      ),
    );
  }

  // Llamada API para cerrar sesión
  Future<void> logout(BuildContext context) async {
    Navigator.pushNamed(context, '/login');
    setState(
          () {
        _mostrarIndicadorCarga = true;
      },
    );
    print("token logout: ${auth.token}");
    try {
      final response = await http.post(
        Uri.parse('http://${dotenv.env['BASE_URL']}/user/logout'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${auth.token}',
        },
      );
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
            msg: responseData['msg'],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        // Realizar accion de logout
        await auth.clearToken();
        Navigator.pushNamed(context, '/login');
      } else {
        Fluttertoast.showToast(
            msg: "Error al cerrar sesión",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.red,
            textColor: Colors.red,
            fontSize: 12.0);
      }
    } catch (e) {
      throw Exception(e);
    } finally {
      // Oculta el indicador de carga después de la solicitud
      setState(
            () {
          _mostrarIndicadorCarga = false;
        },
      );
    }
  }

  // Obtener información del usuario desde shared preferences
  Future<void> _obtenerInformacion(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      firstName = prefs.getString('firstName')!;
      lastName = prefs.getString('lastName')!;
      email = prefs.getString('email')!;
      role = prefs.getString('role')!;
      userName = prefs.getString('userName')!;
      image = prefs.getString('image')!;
    });
  }

  @override
  void initState() {
    super.initState();
    () async {
      await auth.loadToken();
      idUser = returnId(auth.token);
      //await _obtenerInformacion(context);
    }();
    _obtenerInformacion(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Perfil",
            textAlign: TextAlign.left,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: Column(
            children: [
              Stack(
                children: [
                  image != ""
                      ? Container(
                    margin: EdgeInsets.only(top: 20),
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.fitWidth,
                        image: MemoryImage(base64Decode(image)),
                      ),
                    ),
                  )
                      : Container(
                    margin: EdgeInsets.only(top: 20),
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white, // Color del círculo
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white, // Color del círculo
                      ),
                      margin: const EdgeInsets.only(left: 150, top: 150),
                      child: IconButton(
                        onPressed: () async {
                          await pickMedia(ImageSource.camera);
                          setState(() {});
                        },
                        icon: const Icon(Icons.camera_alt),
                      ),
                    ),
                  ),
                ],
              ),
              // Mostrar en pantalla la información del usuario
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: Text(
                  "$firstName $lastName",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                role,
                style:
                const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.only(left: 10),
                alignment: Alignment.centerLeft,
                width: MediaQuery.of(context).size.width * 0.8,
                height: 35,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.only(top: 20),
                child: Text(
                  "Correo: $email",
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 10),
                alignment: Alignment.centerLeft,
                width: MediaQuery.of(context).size.width * 0.8,
                height: 35,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.only(top: 5),
                child: Text(
                  "Usuario : $userName",
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              // Seccion de cambiar comtraseña
              Container(
                padding: const EdgeInsets.only(left: 10),
                alignment: Alignment.centerLeft,
                width: MediaQuery.of(context).size.width * 0.8,
                height: 35,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.only(top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Cambiar contraseña",
                      style:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (editar == true) {
                          editar = false;
                        } else {
                          editar = true;
                        }
                        setState(() {});
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        disabledBackgroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),

                      // Mostrar en pantalla la opcion de cambiar contraseña, si el usuario lo deseo
                      child: !editar
                          ? const Icon(Icons.edit)
                          : const Icon(Icons.arrow_drop_up),
                    ),
                  ],
                ),
              ),
              editar ? updatePassword(context) : const Text(""),
              ElevatedButton(
                onPressed: () async {
                  await logout(context);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                child: const Text("Cerrar Sesión",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ),
              if (_mostrarIndicadorCarga) const CircularProgressIndicator()
            ],
          ),
        ),
      ),
    );
  }
}