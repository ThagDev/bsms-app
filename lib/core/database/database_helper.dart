import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../constants/app_constants.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, DbConstants.dbName);

    return await openDatabase(
      path,
      version: DbConstants.dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // 1. BSI_COOKIE
    await db.execute('''
      CREATE TABLE ${DbConstants.tableCookie} (
        id INTEGER PRIMARY KEY,
        cookie TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // 2. BSI_LOCATION
    await db.execute('''
      CREATE TABLE ${DbConstants.tableLocation} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        lat REAL NOT NULL,
        lng REAL NOT NULL,
        timestamp TEXT NOT NULL,
        is_synced INTEGER DEFAULT 0
      )
    ''');

    // 3. BSI_TICKET
    await db.execute('''
      CREATE TABLE ${DbConstants.tableTicket} (
        ticket_id TEXT PRIMARY KEY,
        ticket_no TEXT,
        title TEXT,
        content TEXT,
        status TEXT,
        priority TEXT,
        atm_id TEXT,
        atm_code TEXT,
        customer_id TEXT,
        customer_name TEXT,
        address TEXT,
        created_date TEXT,
        sla_due_date TEXT,
        assigned_to TEXT,
        updated_date TEXT,
        raw_json TEXT
      )
    ''');

    // 4. BSI_PROVINCE
    await db.execute('''
      CREATE TABLE ${DbConstants.tableProvince} (
        province_id TEXT PRIMARY KEY,
        province_name TEXT NOT NULL
      )
    ''');

    // 5. BSI_CUSTOMER
    await db.execute('''
      CREATE TABLE ${DbConstants.tableCustomer} (
        customer_id TEXT PRIMARY KEY,
        customer_name TEXT NOT NULL,
        code TEXT,
        phone TEXT,
        address TEXT
      )
    ''');

    // 6. BSI_ERRORLIST
    await db.execute('''
      CREATE TABLE ${DbConstants.tableErrorList} (
        error_id TEXT PRIMARY KEY,
        error_name TEXT NOT NULL,
        error_code TEXT,
        description TEXT
      )
    ''');

    // 7. BSI_ERRORDETAIL
    await db.execute('''
      CREATE TABLE ${DbConstants.tableErrorDetail} (
        detail_id TEXT PRIMARY KEY,
        error_id TEXT NOT NULL,
        solution TEXT,
        note TEXT
      )
    ''');

    // 8. BSI_CONTACTLIST
    await db.execute('''
      CREATE TABLE ${DbConstants.tableContactList} (
        contact_id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        phone TEXT,
        email TEXT,
        role TEXT,
        department TEXT
      )
    ''');

    // 9. BSI_SERVERINFO
    await db.execute('''
      CREATE TABLE ${DbConstants.tableServerInfo} (
        id INTEGER PRIMARY KEY,
        ip TEXT NOT NULL,
        port INTEGER NOT NULL,
        use_https INTEGER DEFAULT 0,
        endpoint TEXT NOT NULL
      )
    ''');

    // 10. BSI_TINHTHANHVUNGDICHVU
    await db.execute('''
      CREATE TABLE ${DbConstants.tableTinhThanhVungDichVu} (
        id TEXT PRIMARY KEY,
        province_id TEXT,
        region_name TEXT,
        note TEXT
      )
    ''');

    // 11. BSI_PART
    await db.execute('''
      CREATE TABLE ${DbConstants.tablePart} (
        part_id TEXT PRIMARY KEY,
        part_code TEXT NOT NULL,
        part_name TEXT NOT NULL,
        quantity INTEGER DEFAULT 0,
        unit TEXT
      )
    ''');

    // 12. BSI_USER_DEVICE
    await db.execute('''
      CREATE TABLE ${DbConstants.tableUserDevice} (
        device_id TEXT PRIMARY KEY,
        device_name TEXT NOT NULL,
        serial TEXT,
        ticket_id TEXT,
        user_id TEXT,
        status TEXT
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Migration logic nếu version tăng
  }

  Future<void> clearAllData() async {
    final db = await database;
    final tables = [
      DbConstants.tableCookie,
      DbConstants.tableLocation,
      DbConstants.tableTicket,
      DbConstants.tableProvince,
      DbConstants.tableCustomer,
      DbConstants.tableErrorList,
      DbConstants.tableErrorDetail,
      DbConstants.tableContactList,
      DbConstants.tableTinhThanhVungDichVu,
      DbConstants.tablePart,
      DbConstants.tableUserDevice,
    ];
    for (final table in tables) {
      await db.delete(table);
    }
  }
}
