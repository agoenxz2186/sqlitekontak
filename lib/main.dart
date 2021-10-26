import 'package:flutter/material.dart';
import 'package:kontak/kontak_form.dart';

void main(){
   runApp(
      const MaterialApp(
        title: 'Aplikasi Kontak',
        debugShowCheckedModeBanner: false,
        home: KontakForm(),
      )
   );
}