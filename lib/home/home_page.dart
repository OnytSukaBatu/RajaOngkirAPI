import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raja_ongkir_febrian/home/home_getx.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final HomeGetx ctrl = Get.put(HomeGetx());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                TextButton(
                  onPressed: () => ctrl.pilihKotaAsal(),
                  child: Text(
                    'PILIH KOTA ASAL',
                    style: ctrl.style,
                  ),
                ),
                Obx(
                  () => Text(
                    'KOTA ASAL : ${ctrl.kotaAsal.toUpperCase()}',
                    style: ctrl.style,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () => ctrl.pilihKotaTujuan(),
                  child: Text(
                    'KOTA TUJUAN',
                    style: ctrl.style,
                  ),
                ),
                Obx(
                  () => Text(
                    'KOTA TUJUAN : ${ctrl.kotaTujuan.toUpperCase()}',
                    style: ctrl.style,
                  ),
                ),
              ],
            ),
            TextField(
              controller: ctrl.beratBarang,
              decoration: const InputDecoration(
                hintText: 'BERAT BARANG (GRAM)',
              ),
              keyboardType: TextInputType.number,
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () => ctrl.pilihKurir(),
                  child: Text(
                    'PILIH KURIR',
                    style: ctrl.style,
                  ),
                ),
                Obx(
                  () => Text(
                    'KURIR : ${ctrl.kurir}',
                    style: ctrl.style,
                  ),
                ),
              ],
            ),
            OutlinedButton(
              onPressed: () => ctrl.getOngkir(),
              child: const Text(
                'HITUNG ONGKIR',
              ),
            ),
            Expanded(
              child: Obx(
                () => ListView.builder(
                  itemCount: ctrl.resultOngkir.length,
                  itemBuilder: (_, index) {
                    Map indexData = ctrl.resultOngkir[index];
                    return ListTile(
                      title: Text(
                        '${indexData['service']} ${indexData['description']}',
                      ),
                      subtitle: Text(
                        'Harga: ${indexData['cost'][0]['value']}, estimasi: ${indexData['cost'][0]['etd']} Hari',
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
