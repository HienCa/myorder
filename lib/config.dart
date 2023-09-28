//Gía trị cố định của biến
// ignore_for_file: non_constant_identifier_names
//chung
int ACTIVE = 1; // HOẠT ĐỘNG
int DEACTIVE = 0;
// NGỪNG HOẠT ĐỘNG
//EMPLOYEE:
String MALE = "1"; // NAM
String FEMALE = "2"; // NỮ
String OTHER = "3"; //KHÁC

//ROLE:
int OWNER = 1; // CHỦ NHÀ HÀNG
int EMPLOYEE = 2; // NHÂN VIÊN

//ORDER:
int ORDER_STATUS_SERVING = 1; // ĐANG PHỤC VỤ
int ORDER_STATUS_PAID = 2; // ĐÃ THANH TÓAN
int ORDER_STATUS_CANCEL = 3; // ĐÃ HỦY BÀN

//ORDER_DETAIL
int FOOD_STATUS_IN_CHEFT = 1; // CHỜ CHẾ BIẾN
int FOOD_STATUS_FINISH = 2; // ĐÃ HOÀN THÀNH
int FOOD_STATUS_CANCEL = 3; // ĐÃ HỦY
String FOOD_STATUS_IN_CHEFT_STRING = "CHỜ CHẾ BIẾN";
String FOOD_STATUS_FINISH_STRING = "HOÀN THÀNH";
String FOOD_STATUS_CANCEL_STRING = "ĐÃ HỦY";
//TABLE:
int TABLE_STATUS_EMPTY = 1; // BÀN TRỐNG
int TABLE_STATUS_SERVING = 2; // ĐANG PHỤC VỤ
int TABLE_STATUS_MERGED = 3; // GỘP BÀN
int TABLE_STATUS_SPLIT = 4; // TÁCH BÀN
int TABLE_STATUS_CANCEL = 5; // HỦY BÀN
int TABLE_STATUS_BOOKING = 6; // HỦY BÀN

// text length
const maxlengthName = 50;
const minlengthName = 2;

const maxlengthCCCD = 12;
const minlengthCCCD = 10;

const maxlengthPhone = 12;
const minlengthPhone = 10;

const maxlengthAddress = 255;
const minlengthAddress = 4;

const maxlengthUnitName = 50;
const minlengthUnitName = 2;

const maxlengthCategoryName = 50;
const minlengthCategoryName = 2;

const maxlengthAreaTableName = 2;
const minlengthAreaTableName = 1;

const maxlengthAreaName = 50;
const minlengthAreaName = 2;

const maxlength50 = 50;
const maxlength255 = 50;
const minlength1 = 1;
const minlength2 = 2;
const minlength0 = 0;

final List<String> ROLE_OPTION = <String>[
  'Nhân viên',
  'Quản lý',
  'Thu ngân',
  'Chủ nhà hàng'
];
