import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../models/timbratura.dart';

class ExportService {
  static Future<String?> esportaTimbrature(List<Timbratura> timbrature, String nomeFile) async {
    if (timbrature.isEmpty) return null;

    var excel = Excel.createExcel();
    Sheet sheet = excel['Timbrature'];

    // Intestazioni
    final headers = ['Data', 'Ora', 'Tipo', 'Posizione'];
    for (int i = 0; i < headers.length; i++) {
      final cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
      cell.value = TextCellValue(headers[i]);
      cell.cellStyle = CellStyle(bold: true);
    }

    // Dati
    final dateFormat = DateFormat('dd/MM/yyyy');
    final timeFormat = DateFormat('HH:mm');

    for (int i = 0; i < timbrature.length; i++) {
      final t = timbrature[i];
      final row = i + 1;

      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row)).value = TextCellValue(dateFormat.format(t.dataOra));
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row)).value = TextCellValue(timeFormat.format(t.dataOra));
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row)).value = TextCellValue(t.tipoLabel);
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row)).value = TextCellValue(t.indirizzo ?? '-');
    }

    // Larghezza colonne
    sheet.setColumnWidth(0, 15);
    sheet.setColumnWidth(1, 10);
    sheet.setColumnWidth(2, 15);
    sheet.setColumnWidth(3, 40);

    // Salva il file
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$nomeFile.xlsx';
      final bytes = excel.save();
      
      if (bytes != null) {
        final file = File(filePath);
        await file.writeAsBytes(Uint8List.fromList(bytes));
        return filePath;
      }
      return null;
    } catch (e) {
      print('Errore export: $e');
      return null;
    }
  }
}
