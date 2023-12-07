//Gía trị cố định của biến
// ignore_for_file: non_constant_identifier_names, constant_identifier_names
//chung
String RESTAURANT_NAME = "MỲ CAY HIỀN CA";
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
int ORDER_STATUS_CANCEL = 3; // ĐÃ HỦY ĐƠN HÀNG
int ORDER_STATUS_BOOKING = 3; // BOOKING
int ORDER_STATUS_TAKE_AWAY = 4; // TAKE AWAY
int ORDER_STATUS_ALL = 4; // TAKE AWAY

//ORDER_DETAIL
int FOOD_STATUS_IN_CHEF = 1; // CHỜ CHẾ BIẾN
int FOOD_STATUS_COOKING = 2; // ĐANG CHẾ BIẾN
int FOOD_STATUS_FINISH = 3; // ĐÃ HOÀN THÀNH
int FOOD_STATUS_CANCEL = 4; // ĐÃ HỦY
String FOOD_STATUS_IN_CHEF_STRING = "CHỜ XÁC NHẬN";
String FOOD_STATUS_FINISH_STRING = "HOÀN THÀNH";
String FOOD_STATUS_CANCEL_STRING = "ĐÃ HỦY";
String FOOD_STATUS_COOKING_STRING = "ĐANG CHẾ BIẾN";

//WAREHOUSE RECEIPT
int WAREHOUSE_STATUS_WAITING = 1; //CHỜ XỬ LÝ
int WAREHOUSE_STATUS_FINISH = 2; //HOÀN THÀNH
int WAREHOUSE_STATUS_CANCEL = 2; //HOÀN THÀNH
String WAREHOUSE_STATUS_WAITING_STRING = "CHỜ XỬ LÝ"; //CHỜ XỬ LÝ
String WAREHOUSE_STATUS_FINISH_STRING = "HOÀN THÀNH"; //HOÀN THÀNH
String WAREHOUSE_STATUS_CANCEL_STRING = "ĐÃ HỦY"; //HOÀN THÀNH

//CHEF/BAR
int CHEF_BAR_STATUS = 0; // BÌNH THƯỜNG
int CHEF_BAR_STATUS_ACTIVE = 1; // CẦN CHẾ BIẾN
int CHEF_BAR_STATUS_DEACTIVE = 2; // ĐÃ YÊU CẦU DỪNG CHẾ BIẾN

//TABLE:
int TABLE_STATUS_EMPTY = 1; // BÀN TRỐNG
int TABLE_STATUS_SERVING = 2; // ĐANG PHỤC VỤ
int TABLE_STATUS_MERGED = 3; // GỘP BÀN
int TABLE_STATUS_SPLIT = 4; // TÁCH BÀN
int TABLE_STATUS_CANCEL = 5; // HỦY BÀN
int TABLE_STATUS_BOOKING = 6; // BÀN BOOKING

//VAT - PAYMENT
int VAT_PERCENT = 10;

//DISCOUNT - PAYMENT
int CATEGORY_ALL = 1; // giam gia tren bill
int CATEGORY_FOOD = 2; // theo mon an
int CATEGORY_DRINK = 3; // nuoc uong
int CATEGORY_OTHER = 4; // khac
int CATEGORY_GIFT = 5; // mon tang

//CALCULATOR
int MIN_PRICE = 1000;
int MAX_PRICE = 1000000000;
int MIN_PERCENT = 1;
int MAX_PERCENT = 1;

//TABLE
int MIN_SLOT_TABLE = 1;
int MAX_SLOT_TABLE = 50;

//TYPE
const int SUCCESS = 1;
const int ERROR = 2;
const int WARNING = 3;
const int INFO = 4;

//VALUE TYPE
const int TYPE_PRICE = 1;
const int TYPE_PERCENT = 2;

// text length
const maxlengthName = 50;
const minlengthName = 2;

const maxlengthCCCD = 12;
const minlengthCCCD = 10;

const maxlengthPhone = 10;
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
const maxlength255 = 255;
const minlength1 = 1;
const minlength2 = 2;
const minlength0 = 0;

final List<String> ROLE_OPTION = <String>[
  'Nhân viên',
  'Quản lý',
  'Thu ngân',
  'Chủ nhà hàng'
];
final List<String> TIME_OPTION = <String>[
  'Hôm nay',
  'Hôm qua',
  'Tuần này',
  'Tháng này',
  'Tháng trước',
  '3 tháng gần nhất',
  'Năm nay',
  'Năm trước',
  '3 năm gần nhất',
  'Tất cả các năm',
];

void filterTime(int timeOption, DateTime startDate, DateTime endDate) {
  DateTime now = DateTime.now();
  switch (timeOption) {
    case 0: //hôm nay
      startDate = DateTime(now.year, now.month, now.day);
      endDate = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
      break;
    case 1: //hôm qua
      startDate = DateTime(now.year, now.month, now.day - 1);
      endDate = DateTime(now.year, now.month, now.day - 1, 23, 59, 59, 999);
      break;
    case 2: //tuần này
      startDate = now.subtract(Duration(days: now.weekday - 1));
      endDate = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
      break;
    case 3: //tháng này
      startDate = DateTime(now.year, now.month, 1);
      endDate = DateTime(now.year, now.month + 1, 0, 23, 59, 59, 999);
      break;
    case 4: //tháng trước
      startDate = DateTime(now.year, now.month - 1, 1);
      endDate = DateTime(now.year, now.month, 0, 23, 59, 59, 999);
      break;
    case 5: //3 tháng gần nhất
      startDate = DateTime(now.year, now.month - 2, now.day);
      endDate = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
      break;
    case 6: //năm nay
      startDate = DateTime(now.year, 1, 1);
      endDate = DateTime(now.year, 12, 31, 23, 59, 59, 999);
      break;
    case 7: //năm trước
      startDate = DateTime(now.year - 1, 1, 1);
      endDate = DateTime(now.year - 1, 12, 31, 23, 59, 59, 999);
      break;
    case 8: //3 năm gần nhất
      startDate = DateTime(now.year - 2, now.month, now.day);
      endDate = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
      break;
    case 9: //tất cả các năm
      startDate = DateTime(1970, 1, 1);
      // endDate = DateTime(2100, 12, 31, 23, 59, 59, 999);
      endDate = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
      break;
    default:
      startDate = DateTime(now.year, now.month, now.day);
      endDate = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
  }
}

//discount
const discountMin = 1000; //1,000
const discountMax = 10000000; //10,000,000

//KEY SharedPreferences
const DAILY_SALE_KEY = "date_dailySale";
