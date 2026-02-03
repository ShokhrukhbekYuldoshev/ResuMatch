import 'package:file_picker/file_picker.dart';
import 'package:read_pdf_text/read_pdf_text.dart';

class PDFService {
  /// Extracts plain text from a selected PDF file.
  Future<Map<String, String>?> extractText() async {
    // 1. Pick the file
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result == null || result.files.single.path == null) return null;

    // 2. Get file details
    final name = result.files.single.name;

    // 3. Extract text from the PDF
    String text = await ReadPdfText.getPDFtext(result.files.single.path!);
    // 4. Return both text and name
    return {"text": text, "name": name};
  }
}
