import 'package:flutter/material.dart';
import 'package:kontak/db_helper.dart';
import 'package:kontak/kontak_form.dart';

class KontakList extends StatefulWidget {
  const KontakList({ Key? key }) : super(key: key);

  @override
  _KontakListState createState() => _KontakListState();
}

class _KontakListState extends State<KontakList> {
  List data = [];

  @override
  void initState() {
    super.initState();
    bacaData();  
  }
 
  void bacaData()async{
      final db = await DBHelper.db();
      final ls = await db.rawQuery('SELECT * FROM kontak');
      
      data = ls;
      setState((){});
  }

  void hapusData(Map itm)async{
      final db = await DBHelper.db();
      final r =await db.delete('kontak', where: 'id=?', whereArgs: [itm['id']]);

      bacaData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Daftar Kontak')
        ),
        body: ListView(
          children:[
              for(var item in data)
                Card(
                  child: ListTile(
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: (){
                           showDialog(context: context, 
                            builder: (c)=>AlertDialog(
                              title:Text('Konfirmasi'),
                              content: Text('Apakah anda yakin ingin hapus data?'),
                              actions:[
                                  TextButton(onPressed: (){
                                      hapusData(item);
                                       Navigator.pop(context);
                                  }, child: Text('Ya')),
                                  TextButton(onPressed: (){
                                      Navigator.pop(context);
                                  }, child: Text('Nggak Jadi')),
                                     
                              ]
                            )
                          );
                        }
                      ),
                      onTap:(){
                          Navigator.push(context, MaterialPageRoute(
                            builder:(c)=>KontakForm(data: item)
                          ));
                      },
                      title: Text('${item['nama']}'),
                      leading: Icon( item['gender'] == 'L' ? 
                                Icons.male : Icons.female ),
                      subtitle: Text('${item['alamat']}'),
                  ),
                )
          ]
        )
    );
  }
}