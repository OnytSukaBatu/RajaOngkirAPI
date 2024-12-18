import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class HomeGetx extends GetxController {
  String key = 'cd39a910acbd73608a178f5a95d962ec';

  String urlProvinsi = 'https://api.rajaongkir.com/starter/province';
  String urlKota = 'https://api.rajaongkir.com/starter/city';
  String urlOngkir = 'https://api.rajaongkir.com/starter/cost';

  RxString kotaAsal = ''.obs;
  RxString kotaTujuan = ''.obs;
  RxString kurir = ''.obs;

  RxString idKotaAsal = ''.obs;
  RxString idKotaTujuan = ''.obs;

  TextEditingController beratBarang = TextEditingController();
  TextEditingController kotaAsalController = TextEditingController();
  TextEditingController kotaTujuanController = TextEditingController();

  RxList dataProvinsi = [].obs;
  RxList dataKota = [].obs;

  RxList filterKotaAsal = [].obs;
  RxList filterKotaTujuan = [].obs;

  RxList resultOngkir = [].obs;

  TextStyle style = const TextStyle(
    fontSize: 12,
  );

  // PADA API HANYA BISA MENGGUNAKAN 3 KURIR INI
  List lisKurir = ['jne', 'tiki', 'pos'];

  void getProvinsi() async {
    http.Response response = await http.get(
      Uri.parse(urlProvinsi),
      headers: {
        "key": key,
      },
    );

    Map data = jsonDecode(response.body);
    dataProvinsi = data['rajaongkir']['results'];
  }

  void getKota() async {
    http.Response response = await http.get(
      Uri.parse(urlKota),
      headers: {
        "key": key,
      },
    );

    Map data = jsonDecode(response.body);
    dataKota.value = data['rajaongkir']['results'];
  }

  void onchangedKotaAsal(String query) {
    if (query.isEmpty) {
      filterKotaAsal.value = dataKota;
    } else {
      filterKotaAsal.value = dataKota
          .where((city) => city['city_name']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    }
  }

  void onchangedKotaTujuan(String query) {
    if (query.isEmpty) {
      filterKotaTujuan.value = dataKota;
    } else {
      filterKotaTujuan.value = dataKota
          .where((city) => city['city_name']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    }
  }

  void pilihKotaAsal() {
    Get.bottomSheet(
      Obx(
        () => Container(
          color: Colors.white,
          child: Column(
            children: [
              TextField(
                controller: kotaAsalController,
                decoration: const InputDecoration(
                  hintText: 'CARI KOTA ASAL',
                ),
                onChanged: onchangedKotaAsal,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filterKotaAsal.length,
                  itemBuilder: (_, index) {
                    Map indexData = filterKotaAsal[index];
                    return ListTile(
                      title: Text(
                        indexData['city_name'],
                        style: style,
                      ),
                      onTap: () {
                        kotaAsal.value = indexData['city_name'];
                        idKotaAsal.value = indexData['city_id'];
                        Get.back();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void pilihKotaTujuan() {
    Get.bottomSheet(
      Obx(
        () => Container(
          color: Colors.white,
          child: Column(
            children: [
              TextField(
                controller: kotaTujuanController,
                decoration: const InputDecoration(
                  hintText: 'CARI KOTA TUJUAN',
                ),
                onChanged: onchangedKotaTujuan,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filterKotaTujuan.length,
                  itemBuilder: (_, index) {
                    Map indexData = filterKotaTujuan[index];
                    return ListTile(
                      title: Text(
                        indexData['city_name'],
                        style: style,
                      ),
                      onTap: () {
                        kotaTujuan.value = indexData['city_name'];
                        idKotaTujuan.value = indexData['city_id'];
                        Get.back();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void pilihKurir() {
    Get.bottomSheet(
      Container(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: lisKurir.length,
                itemBuilder: (_, index) {
                  String indexData = lisKurir[index].toString().toUpperCase();
                  return ListTile(
                    title: Text(
                      indexData,
                      style: style,
                    ),
                    onTap: () {
                      kurir.value = indexData;
                      Get.back();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getOngkir() async {
    http.Response response = await http.post(
      Uri.parse(urlOngkir),
      headers: {
        "key": key,
      },
      body: {
        "origin": idKotaAsal.value,
        "destination": idKotaTujuan.value,
        "weight": beratBarang.text,
        "courier": kurir.value.toLowerCase(),
      },
    );

    Map data = jsonDecode(response.body);
    Map get = data['rajaongkir']['results'][0];
    resultOngkir.value = get['costs'];
    log(resultOngkir.toString());
  }

  @override
  void onInit() {
    getKota();
    super.onInit();
  }
}
