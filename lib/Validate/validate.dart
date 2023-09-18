String validateName(String text) {
  if (text.isEmpty) {
    return 'Tên nhân viên không được để trống ';
  }
  return '';
}
String validateEmail(String txt) {
  if (txt.isEmpty) {
    return "Email không được để trống ";
  }
  final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
  if (!emailRegExp.hasMatch(txt)) {
    return "Email không đúng định dạng";
  }
  return "";
}
String validateTel(String txt) {
  if ( txt.isEmpty) {
    return "Tel không được để trống ";
  }
  final emailRegExp = RegExp(r'^(\d{4}-\d{4}-\d{4}|\d-\d-\d|\d{2}-\d+)$');
  if (!emailRegExp.hasMatch(txt)) {
    return "Tel không đúng định dạng \n(Vd: xxxx-xxxx-xxxx,xx-xxx..,x-x-x)";
  }
  return "";
}
String validateUser(String text) {
  if (text.isEmpty) {
    return 'Username không được để trống ';
  }
  return '';
}
String validatePass(String text) {
  if (text.isEmpty) {
    return 'Password không được để trống ';
  }
  return '';
}
