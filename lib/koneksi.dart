import 'package:cloud_firestore/cloud_firestore.dart';

class Koneksi{
  static Koneksi koneksi = Koneksi();

  //deklarasi config data
  CollectionReference db = Firestore.instance.collection('tanaman');
  CollectionReference db1 = Firestore.instance.collection('event');

  Future<String> AddTanaman(String nama_tanaman,String cara_menanam,String cara_merawat,String deskripsi_tanaman,String hasil_olahan,String gambar,String created)async{
    Map<String , dynamic> data = {
      "nama_tanaman": nama_tanaman,
      "cara_menanam": cara_menanam,
      "cara_merawat": cara_merawat,
      "deskripsi_tanaman": deskripsi_tanaman,
      "hasil_olahan": hasil_olahan,
      "gambar": gambar,
      "created": created,
    };
    DocumentReference dokumen = await db.add(data);
    return dokumen.documentID;
  }

  Future<String> AddEvent(String judul_event,String deskripsi_event,String waktu_laksana,String gambar,String created)async{
    Map<String , dynamic> data = {
      "judul_event": judul_event,
      "deskripsi_event": deskripsi_event,
      "waktu_laksana": waktu_laksana,
      "gambar": gambar,
      "created" :  created
    };
    DocumentReference dokumen = await db1.add(data);
    return dokumen.documentID;
  }

  Future UpdateTanaman(String id,String nama_tanaman,String cara_menanam,String cara_merawat,String deskripsi_tanaman,String hasil_olahan,String gambar)async{
    if(gambar == 'kosong') {
      Map<String , dynamic> data = {
        "nama_tanaman": nama_tanaman,
        "cara_menanam": cara_menanam,
        "cara_merawat": cara_merawat,
        "deskripsi_tanaman": deskripsi_tanaman,
        "hasil_olahan": hasil_olahan,
      };
      await db.document(id).updateData(data);
    }else{
      Map<String , dynamic> data = {
        "nama_tanaman": nama_tanaman,
        "cara_menanam": cara_menanam,
        "cara_merawat": cara_merawat,
        "deskripsi_tanaman": deskripsi_tanaman,
        "hasil_olahan": hasil_olahan,
        "gambar": gambar,
      };
      await db.document(id).updateData(data);
    }
  }

  Future UpdateEvent(String id,String judul_event,String deskripsi_event,String waktu_laksana,String gambar)async{

    if(gambar == 'kosong'){
      Map<String , dynamic> data = {
        "judul_event": judul_event,
        "deskripsi_event": deskripsi_event,
        "waktu_laksana": waktu_laksana,
      };
      await db1.document(id).updateData(data);
    }else{
      Map<String , dynamic> data = {
        "judul_event": judul_event,
        "deskripsi_event": deskripsi_event,
        "waktu_laksana": waktu_laksana,
        "gambar": gambar,
      };
      await db1.document(id).updateData(data);
    }
  }

  Future HapusTanaman(String id)async{
    await db.document(id).delete();
  }

  Future HapusEvent(String id)async{
    await db1.document(id).delete();
  }

  Future<List<DocumentSnapshot>> GetTanaman()async{
    QuerySnapshot result = await db
        .orderBy('created',descending: true)
        .getDocuments();
    return result.documents;
  }

  Future<List<DocumentSnapshot>> GetEvent()async{
    QuerySnapshot result = await db1
        .orderBy('created',descending: true)
        .getDocuments();
    return result.documents;
  }

}