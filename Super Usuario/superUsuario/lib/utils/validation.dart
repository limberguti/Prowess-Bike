class Validation {
  static String upperValidation(String name) {
    List<String> upperName = name.trim().split("");
    for (int i = 0; i < name.length; i++) {
      if (i == 0) {
        upperName[0] = upperName[0].toUpperCase();
      } else {
        upperName[i] = upperName[i].toLowerCase();
      }
    }
    String nuevoNombre = upperName.join("");
    //print(nuevoNombre);
    return nuevoNombre;
  }

  static String dateBirthValidation(DateTime date) {
    //'${expiryLicense?.day}-${expiryLicense?.month}-${expiryLicense?.year}')
    String acum = "";
    int day = date.day.toInt();
    int month = date.month.toInt();
    int year = date.year.toInt();
    DateTime _selectedDateTime = DateTime.now();
    int actual = _selectedDateTime.year.toInt();
    if (year > actual) {
      acum += 'Compruebe la fecha ingresada\n';
    }
    return acum;
  }

  static String spaceValidation(String text) {
    List<String> correcText = text.trim().split(" ");
    String newText = "";
    for (int i = 0; i < text.length; i++) {
      if (i == 0) {
        newText = correcText[i];
      }
    }
    return newText;
  }

  static String? nameValidation(String? name) {
    String patttern = r'(^[A-ZÀ-ÝÑ]{1}([a-zà-ÿñ]*$){2,})';
    String pattern1 = r'^(?=.*\d).+$';
    String pattern2 = r'^(?=.*\s).+$';
    String pattern3 = r'(^[A-ZÀ-ÝÑ]{1}(.+))';
    String pattern4 = r'^(?=.*[A-ZÀ-ÝÑ]).{2,}$';

    var acum = '';

    RegExp regExp = new RegExp(patttern);
    RegExp regExp1 = new RegExp(pattern1);
    RegExp regExp2 = new RegExp(pattern2);
    RegExp regExp3 = new RegExp(pattern3);
    RegExp regExp4 = new RegExp(pattern4);

    if (regExp.hasMatch(name!)) {
      return null;
    } else {
      if (regExp1.hasMatch(name)) {
        acum += 'Ingrese solo letras\n';
      }
      if (regExp2.hasMatch(name)) {
        acum += 'Elimine los espacios en blanco\n';
      }
      if (name.length < 3) {
        acum += 'Ingrese más de 3 letras\n';
      }
      if (regExp4.hasMatch(name) && !regExp1.hasMatch(name)) {
        acum += 'Solo la primera letra con mayúscula\n';
      }
      if (!regExp3.hasMatch(name)) {
        acum += 'Ingrese la primera letra con mayúscula\n';
      }
      return acum + 'Ejemplo: Diego';
    }
  }

  static String? surnameValidation(String? apellido) {
    String patttern = r'(^[A-ZÀ-ÝÑ]{1}([a-zà-ÿñ]*$){2,})';
    String pattern1 = r'^(?=.*\d).+$';
    String pattern2 = r'^(?=.*\s).+$';
    String pattern3 = r'(^[A-ZÀ-ÝÑ]{1}(.+))';
    String pattern4 = r'^(?=.*[A-ZÀ-ÝÑ]).{2,}$';

    var acum = '';

    RegExp regExp = new RegExp(patttern);
    RegExp regExp1 = new RegExp(pattern1);
    RegExp regExp2 = new RegExp(pattern2);
    RegExp regExp3 = new RegExp(pattern3);
    RegExp regExp4 = new RegExp(pattern4);

    if (regExp.hasMatch(apellido!)) {
      return null;
    } else {
      if (regExp1.hasMatch(apellido)) {
        acum += 'Ingrese solo letras\n';
      }
      if (regExp2.hasMatch(apellido)) {
        acum += 'Elimine los espacios en blanco\n';
      }
      if (apellido.length < 3) {
        acum += 'Ingrese más de 3 letras\n';
      }
      if (regExp4.hasMatch(apellido) && !regExp1.hasMatch(apellido)) {
        acum += 'Solo la primera letra con mayúscula\n';
      }
      if (!regExp3.hasMatch(apellido)) {
        acum += 'Ingrese la primera letra con mayúscula\n';
      }
      return acum + 'Ejemplo: Padilla';
    }
  }

  static String? nationalityValidation(String? nacionalidad) {
    String patttern = r'(^[a-zA-ZÀ-ÿ\u00f1\u00d1]*$)';
    RegExp regExp = new RegExp(patttern);
    if (!regExp.hasMatch(nacionalidad!)) {
      return "No se admiten caracteres numéricos ni especiales";
    }
    return null;
  }

  static String? adressValidation(String? value) {
    String patttern = r'(^[A-ZÀ-ÝÑ][a-zà-ÿñ\sA-ZÀ-ÝÑ ]+?)$';
    String pattern1 = r'^(?=.*\d).+$';
    String pattern2 = r'(^[a-zà-ÿñ ]+)$';
    String pattern3 = r'(^[a-zà-ÿñ ]+[A-ZÀ-ÝÑ]+)$';

    var acum = '';

    RegExp regExp = new RegExp(patttern);
    RegExp regExp1 = new RegExp(pattern1);
    RegExp regExp2 = new RegExp(pattern2);
    RegExp regExp3 = new RegExp(pattern3);

    if (regExp.hasMatch(value!)) {
      return null;
    } else {
      if (regExp1.hasMatch(value)) {
        acum += 'Ingrese solo letras\n';
      }
      if (value.length < 2) {
        acum += 'Ingrese más de 2 letras\n';
      }
      if (regExp2.hasMatch(value) || regExp3.hasMatch(value)) {
        acum += 'Ingrese solo la primera letra con mayúscula\n';
      }
      return acum + 'Ejemplo: Quito';
    }
  }

  static String? phoneValidation(String? phone) {
    String patttern = r'(^[0-9]*$)'; //comprobar si funciona
    RegExp regExp = new RegExp(patttern);
    if (phone!.length == 0) {
      return "Celular Requerido";
    } else if (!regExp.hasMatch(phone)) {
      return "Celular requiere caracteres numéricos";
    } else if (phone.length != 10) {
      return "Celular requiere 10 caracteres";
    }
    return null;
  }

  static String? ageValidation(String? age) {
    String patttern = r'(^[0-9]*$)'; //comprobar si funciona
    var edad = int.tryParse(age!);
    RegExp regExp = new RegExp(patttern);
    if (!regExp.hasMatch(age)) {
      return "Edad requiere caracteres numéricos";
    }
    if (edad! >= 18 && edad <= 99) {
      return null;
    } else {
      return "Debes ser mayor de edad para registrarte";
    }
  }

  static String? idValidation(String? docId) {
    String patttern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(patttern);
    int suma = 0;
    if (!regExp.hasMatch(docId!)) {
      return "Cédula solo acepta caracteres numéricos";
    }
    if (docId.length == 10) {
      String pro = docId[0] + docId[1];
      int provincia = int.parse(pro);
      if (provincia < 25) {
        for (var i = 0; i < docId.length; i++) {
          int num = int.parse(docId[i]);
          if (i % 2 == 0) {
            num = num * 2;
            if (num > 9) {
              num = num - 9;
            }
          }
          suma = suma + num;
        }
        if (suma % 10 != 0) {
          int reusultado = 10 - (suma % 10);
          if (reusultado == num) {
            return null;
          } else {
            return "Cédula no válida";
          }
        }
      } else {
        return "Verifique su cédula";
      }
    } else if (docId.length != 10) {
      return "Por favor ingrese 10 dígitos";
    }
    return null;
  }

  static String? emailValidation(String email, List<dynamic>? emailList) {
    String patttern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(patttern);
    if (emailList != null) {
      int a = 0, j;
      for (j = 0; j < emailList.length; j++) {
        if (emailList[j] == email) {
          a = 1;
          break;
        }
      }
      if (a == 1) {
        return "Email ya se encuentra registrado";
      }
    }
    if (email.length == 0) {
      return "Email es requerido";
    } else if (!regExp.hasMatch(email)) {
      return "Ingrese un correo electrónico válido.";
    }
    return null;
  }

  static String? passwordValidation(String? pass) {
    if (pass == null || pass.isEmpty) {
      return 'Ingrese una contraseña temporal';
    } else if (pass.length < 6) {
      return "La contraseña requiere al menos 6 caracteres";
    }
    return null;
  }

  static String? licenseValidation(String? codLicencia) {
    String patttern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(patttern);
    int suma = 0;
    if (!regExp.hasMatch(codLicencia!)) {
      return "Numero de Licencia solo números\nEjemplo: 1727561729";
    }
    if (codLicencia.length == 10) {
      String pro = codLicencia[0] + codLicencia[1];
      int provincia = int.parse(pro);
      if (provincia < 25) {
        for (var i = 0; i < codLicencia.length; i++) {
          int num = int.parse(codLicencia[i]);
          if (i % 2 == 0) {
            num = num * 2;
            if (num > 9) {
              num = num - 9;
            }
          }
          suma = suma + num;
        }
        if (suma % 10 != 0) {
          int reusultado = 10 - (suma % 10);
          if (reusultado == num) {
            return null;
          } else {
            return "Numero de licencia no valida \nEjemplo: 1727561729";
          }
        }
      } else {
        return "Verifique su numero de Licencia \nEjemplo: 1727561729";
      }
    } else if (codLicencia.length != 10) {
      return "Por favor ingrese 10 dígitos \nEjemplo: 1727561729";
    }
    return null;
  }

  static String? typeLicenseValidation(String? tipoLicencia) {
    if (tipoLicencia!.length == 0) {
      return "Tipo de licencia requerido";
    } else if (tipoLicencia.length < 1 || tipoLicencia.length > 2) {
      return "Escoja entre A-B, \nSi es Profesional A-B";
    }
    return null;
  }

  static String? brandValidation(String? brand) {
    String pattern1 = r'^(?=.*\d).+$';

    RegExp regExp1 = new RegExp(pattern1);

    if (brand!.length < 2) {
      return "Mínimo 2 carácteres para la marca \nEjemplo: Honda";
    } else {
      if (regExp1.hasMatch(brand)) {
        return "Ingrese solo letras \nEjemplo: Honda";
      }
    }
    return null;
  }

  static String? modelValidation(String? modelo) {
    if (modelo!.length < 2) {
      return "Mínimo 2 carácteres para el modelo\nEjemplo: HR150L";
    }
    return null;
  }

  static String? numberRegistValidation(String? numRegistro) {
    String patttern = r'(^[0-9]*$)';
    RegExp regExp1 = new RegExp(patttern);
    if (!regExp1.hasMatch(numRegistro!)) {
      return "No se admiten letras ni caracteres especiales \nEjemplo: 1234567";
    }
    if (numRegistro.length < 7 || numRegistro.length > 7) {
      return "Solo debe ingresar 7 caracteres numericos\nEjemplo: 1234567";
    }
    return null;
  }

  static String? plateValidation(String? plate) {
    String pattern1 = r'^[A-Z]{2}[0-9]{3}[A-Z]$';
    String pattern2 = r'^(?=.*\s).+$';
    var acum = '';
    RegExp regExp = new RegExp(pattern1);
    RegExp regExp2 = new RegExp(pattern2);
    if (regExp.hasMatch(plate!)) {
      return null;
    } else {
      if (plate.length < 7) {
        acum += 'Se necesitan 3 letras y 3 numeros\n';
      }
      if (regExp.hasMatch(plate) || !regExp.hasMatch(plate)) {
        acum +=
            'Ingrese las primeras 2 letras con mayusculas \nseguido de los 3 numeros de la placa y la letra \nfinal en mayuscula';
      }
      if (regExp2.hasMatch(plate)) {
        acum += '\nSin espacios en blancos';
      }
      return acum + '\nEjemplo: AB123C';
    }
  }

  static String? ownerValidation(String? dueno) {
    String patttern = r'(^[A-ZÀ-ÝÑ][a-zà-ÿñ]+)(\s[A-ZÀ-ÝÑ][a-zà-ÿñ ]+)$';
    String pattern1 = r'^(?=.*\d).+$';
    String pattern2 = r'(^[a-zà-ÿñ ]+)$';
    String pattern4 = r'(^[a-zà-ÿñ ]+)(\s[a-zà-ÿñ ]+)$';
    String pattern5 = r'(^[A-ZÀ-ÝÑ][a-zà-ÿñ ]+)(\s[a-zà-ÿñ ]+)$';
    String pattern6 = r'(^[a-zà-ÿñ ]+[A-ZÀ-ÝÑ]+)$';

    var acum = '';

    RegExp regExp = new RegExp(patttern);
    RegExp regExp1 = new RegExp(pattern1);
    RegExp regExp2 = new RegExp(pattern2);
    RegExp regExp4 = new RegExp(pattern4);
    RegExp regExp5 = new RegExp(pattern5);
    RegExp regExp6 = new RegExp(pattern6);

    if (regExp.hasMatch(dueno!)) {
      return null;
    } else {
      if (regExp1.hasMatch(dueno)) {
        acum += 'Ingrese solo letras\n';
      }
      if (dueno.length < 2) {
        acum += 'Ingrese más de 2 letras\n';
      }
      if ((regExp4.hasMatch(dueno) ||
              regExp2.hasMatch(dueno) ||
              regExp5.hasMatch(dueno) ||
              regExp6.hasMatch(dueno) ||
              !regExp.hasMatch(dueno)) &&
          !regExp1.hasMatch(dueno)) {
        acum +=
            'Ingrese solo la primera letra de cada palabra\ncon mayúscula \nIngrese el Nombre y Apellido\n';
      }
      return acum + 'Ejemplo: Christian Novoa';
    }
  }
}
