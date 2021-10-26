import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kontak/db_helper.dart';
import 'package:kontak/kontak_list.dart';

class KontakForm extends StatefulWidget {
  final Map? data;
  const KontakForm({ this.data, Key? key }) : super(key: key);

  @override
  _KontakFormState createState() => _KontakFormState(data);
}

class _KontakFormState extends State<KontakForm> {
  late TextEditingController txtNama, txtAlamat;
  Map? data;
  String gender = '';
  bool isLoading = false;

  _KontakFormState(this.data){
    txtNama = TextEditingController(text:data?['nama'] ?? '' );
    txtAlamat = TextEditingController(text: data?['alamat'] ?? ''  );
    gender = data?['gender'] ?? '';
  }

  void simpanData()async{
    setState((){ isLoading = true; });
      
      final lID = this.data?['id'] ??  (await lastID()) + 1  ;
      final data = {
        'id': lID ,
        'nama' : txtNama.value.text,
        'gender': gender,
        'alamat': txtAlamat.value.text
      };
    print('simpan Data : $data');
    final db = await DBHelper.db();

    int ret = 0;
    if( this.data?['id'] != null ){
       ret = await db.update('kontak', data, where:'id=?', 
          whereArgs: [ this.data?['id'] ]
      );
    }else{
       ret = await db.insert('kontak', data);
    }
    print('hasil simpan $ret');

    setState((){ isLoading = false; });

    Navigator.push(context, MaterialPageRoute(builder: (c)=>KontakList()));
  }

  Future<int> lastID()async{
     final db = await DBHelper.db();
     final ls = await db.rawQuery('SELECT id FROM kontak ORDER BY id DESC LIMIT 1 OFFSET 0');
     if( ls.isEmpty ){
        return 0;
     }
     return int.tryParse( '${ls[0]['id']}' ) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Kontak Form'),
          actions: [
              IconButton(
                icon: const Icon(Icons.list_alt),
                onPressed:(){
                   Navigator.push(context, MaterialPageRoute(
                      builder:(c)=>KontakList()
                   ));
                }
              ),
              IconButton(
                icon: const Icon(Icons.save),
                onPressed:(){
                   simpanData();
                }
              )
          ],
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                          TextFormField(
                            controller: txtNama,
                            decoration: const InputDecoration(
                              label: Text('Nama')
                            ),
                          ),
                          DropdownButtonFormField(items: const [
                              DropdownMenuItem(child: Text('Pilih Jenis Kelamin'), 
                                value: ''),
                              DropdownMenuItem(child: Text('Laki-Laki'), value:'L'),
                              DropdownMenuItem(child: Text('Perempuan'), value:'P'),
                            ],
                            onChanged: (s){
                               gender = '$s';
                            },
                            value: gender,
                            decoration: const InputDecoration(
                              label:Text('Jenis Kelamin')
                            ),  
                          ),
                          TextFormField(
                            controller: txtAlamat,
                            decoration:const InputDecoration(
                              label: Text('Alamat')
                            )
                          ),
                      ],
                    ),
                  ),
                ),
              )
            ),

            Visibility(
              visible: isLoading,
              child: Container(
                  child:Center(child: CupertinoActivityIndicator() )
              ),
            )
          ],
        )
    );
  }

}