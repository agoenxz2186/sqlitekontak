
import 'package:sqflite/sqflite.dart';

class DBHelper{
   static Database? _db;

   static Future<Database> db()async{
      return _db ??= await konekDB();
   }

   static Future<Database> konekDB()async{
      return await openDatabase('dataku.db',
        version: 1,
        onUpgrade: (db, verold, vernew){

        },
        onCreate: (db, ver){
            db.execute(""" 
              CREATE TABLE kontak(
                  id INTEGER PRIMARY KEY,
                  nama TEXT,
                  gender TEXT,
                  alamat TEXT
              )
            """);
        }
      );
   }
}