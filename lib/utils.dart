//Gía trị cố định của biến
// ignore_for_file: non_constant_identifier_names

class Config {
  //chung
  static int ACTIVE = 1; // HOẠT ĐỘNG
  static int DEACTIVE = 0; // NGỪNG HOẠT ĐỘNG

  //EMPLOYEE:
  static int MALE = 1; // NAM
  static int FEMALE = 2; // NỮ
  static int OTHER = 3; //KHÁC

  //ROLE:
  static int OWNER = 1; // CHỦ NHÀ HÀNG
  static int EMPLOYEE = 2; // NHÂN VIÊN

  //ORDER:
  static int ORDER_STATUS_SERVING = 1; // ĐANG PHỤC VỤ
  static int ORDER_STATUS_PAID = 2; // ĐÃ THANH TÓAN
  static int ORDER_STATUS_CANCEL = 3; // ĐÃ HỦY BÀN

  //ORDER_DETAIL
  static int FOOD_STATUS_IN_CHEFT = 1; // CHỜ CHẾ BIẾN
  static int FOOD_STATUS_FINISH = 2; // ĐÃ HOÀN THÀNH
  static int FOOD_STATUS_CANCEL = 3; // ĐÃ HỦY

  //TABLE:
  static int TABLE_STATUS_EMPTY = 1; // BÀN TRỐNG
  static int TABLE_STATUS_SERVING = 2; // ĐANG PHỤC VỤ
  static int TABLE_STATUS_MERGED = 3; // GỘP BÀN
  static int TABLE_STATUS_SPLIT = 4; // TÁCH BÀN
  static int TABLE_STATUS_CANCEL = 5; // HỦY BÀN
}

//Các phương phức hay dùng
class Utils {
  //block special characterset

  //block space
  static String removeWhitespace(String input) {
    return input.replaceAll(' ', '');
  }

  //checkMail
  static isValidEmail(String email) {
    final RegExp regex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return regex.hasMatch(email);
  }

  //checkPhone
  static bool startsWithZero(String phoneNumber) {
    return phoneNumber.startsWith('0');
  }

  //check number of characters
  static bool isStringLengthValid(String input,
      {int minLength = 0, int maxLength = 255}) {
    int length = input.length;
    return length >= minLength && length <= maxLength;
  }
  
  static getValidSubstring(String input, int maxLength) {
    if (input.length > maxLength) {
      return input.substring(0, maxLength);
    } else {
      return input;
    }
  }

  //check string and number
  static String getValidCharacters(String input) {
    final RegExp regex = RegExp(r'[a-zA-Z0-9]');
    return input.split('').where((char) => regex.hasMatch(char)).join('');
  }

  // get valid string 
  String getValidText(String input) {
    final RegExp regex = RegExp(r'[a-zA-Z]+');
    final Iterable<Match> matches = regex.allMatches(input);
    final List<String> validMatches = matches.map((match) => match.group(0)!).toList();
    final String validText = validMatches.join('');
  return validText;
}
}
