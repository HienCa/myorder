//Gía trị cố định của biến
// ignore_for_file: non_constant_identifier_names, constant_identifier_names, camel_case_types
//chung
import 'package:myorder/caches/caches.dart';
import 'package:myorder/models/role.dart';

String RESTAURANT_NAME = "VH Funny Food";
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
int TABLE_STATUS_TAKE_AWAY = 7; // BÀN BOOKING

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

enum TIME_OPTION_ENUM {
  TODAY,
  YESTERDAY,
  THIS_WEEK,
  THIS_MONTH,
  LAST_MONTH,
  LAST_THREE_MONTHS,
  THIS_YEAR,
  LAST_YEAR,
  LAST_THREE_YEARS,
  ALL_YEARS,
}

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

//ROLE

var LIST_ROLE_OPTION = [
  Role(role_id: ROLE_CUSTOMER, name: ROLE_CUSTOMER_STRING),
  Role(role_id: ROLE_STAFF, name: ROLE_STAFF_STRING),
  Role(role_id: ROLE_MANAGER, name: ROLE_MANAGER_STRING),
  Role(role_id: ROLE_CASHIER, name: ROLE_CASHIER_STRING),
  Role(role_id: ROLE_OWNER, name: ROLE_OWNER_STRING),
  Role(role_id: ROLE_CHEF, name: ROLE_CHEF_STRING),
  Role(role_id: ROLE_BAR, name: ROLE_BAR_STRING),
  Role(role_id: ROLE_OTHER, name: ROLE_OTHER_STRING),
];
const int ROLE_CUSTOMER = 1;
const int ROLE_STAFF = 2;
const int ROLE_MANAGER = 3;
const int ROLE_CASHIER = 4;
const int ROLE_OWNER = 5;
const int ROLE_CHEF = 6;
const int ROLE_BAR = 7;
const int ROLE_OTHER = 8;
const String ROLE_CUSTOMER_STRING = "Khách hàng";
const String ROLE_STAFF_STRING = "Nhân viên phục vụ";
const String ROLE_MANAGER_STRING = "Quản lý";
const String ROLE_CASHIER_STRING = "Thu Ngân";
const String ROLE_OWNER_STRING = "Chủ quán";
const String ROLE_CHEF_STRING = "Nhân viên bếp";
const String ROLE_BAR_STRING = "Nhân viên quầy bar";
const String ROLE_OTHER_STRING = "Nhân viên khác";

//KEY SharedPreferences
const CACHE_DAILY_SALE_KEY = "date_dailySale";
MyCacheManager myCacheManager = MyCacheManager();
const CACHE_EMPLOYEE_ID_KEY = "currentEmployeeId";
const CACHE_EMPLOYEE_NAME_KEY = "currentEmployeeName";
const CACHE_EMPLOYEE_ROLE_KEY = "currentEmployeeRole";
