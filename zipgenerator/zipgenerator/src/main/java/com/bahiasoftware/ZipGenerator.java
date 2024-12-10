package com.bahiasoftware;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Properties;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import org.apache.commons.io.FileUtils;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

public class ZipGenerator {

	public static void main(String[] args) {

		String excelFilePath = readConfigFile();
		String baseDir = readConfigBaseDir();
		if (excelFilePath == null || baseDir == null) {
			System.out.println("[ERROR] Revisa o archivo config.properties.");
			return;
		}

		FileInputStream fis = null;

		try {
			fis = new FileInputStream(excelFilePath);
			Workbook workbook = new XSSFWorkbook(fis);
			Sheet sheet = workbook.getSheetAt(0);

			// Lee cada fila do Excel
			for (Row row : sheet) {
				if (row.getRowNum() == 0)
					continue;

				String idImpresion = row.getCell(0).getStringCellValue();
				int anho = (int) row.getCell(1).getNumericCellValue();
				int mes = (int) row.getCell(2).getNumericCellValue();
				String fechaImpresion = row.getCell(3).getStringCellValue();

				// Crear la estructura de directorios
				// String dirPath = "target/" + anho + "/" + mes + "/";
				String dirPath = baseDir + anho + "/" + getMes(mes) + "/";
				File dir = new File(dirPath);
				if (!dir.exists()) {
					dir.mkdirs();
				}

				// Generar el archivo TXT
				String txtFilePath = dirPath + idImpresion + ".txt";
				try (BufferedWriter writer = new BufferedWriter(new FileWriter(
						txtFilePath))) {
					writer.write("IDIMPRESION: " + idImpresion);
					writer.newLine();
					writer.write("ANHO: " + anho);
					writer.newLine();
					writer.write("MES: " + mes);
					writer.newLine();
					writer.write("FECHAIMPRESION: " + fechaImpresion);
				}

				// Crear el archivo ZIP
				String zipFilePath = dirPath + idImpresion + ".zip";
				try (FileOutputStream fos = new FileOutputStream(zipFilePath);
						ZipOutputStream zos = new ZipOutputStream(fos)) {
					File txtFile = new File(txtFilePath);
					try (FileInputStream fisTxt = new FileInputStream(txtFile)) {
						ZipEntry zipEntry = new ZipEntry(txtFile.getName());
						zos.putNextEntry(zipEntry);
						byte[] buffer = new byte[1024];
						int length;
						while ((length = fisTxt.read(buffer)) > 0) {
							zos.write(buffer, 0, length);
						}
						zos.closeEntry();
					}

					// Establece a fecha de modificación do ZIP
					SimpleDateFormat sdf = new SimpleDateFormat(
							"dd/MM/yy HH:mm:ss,SSSSSSSSS"); // Formato de entrada da columna do excel
					Date fecha = sdf.parse(fechaImpresion);
					long timestamp = fecha.getTime();
					File zipFile = new File(zipFilePath);
					zipFile.setLastModified(timestamp);
				}

				// Eliminar el archivo TXT despuÃ©s de agregarlo al ZIP
				FileUtils.deleteQuietly(new File(txtFilePath));
			}

			workbook.close();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (fis != null)
					fis.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}

	// Lee a ruta do archivo Excel dende o archivo de configuración
	private static String readConfigFile() {
		Properties properties = new Properties();
		try (InputStream input = new FileInputStream(
				"src/main/resources/config.properties")) {
			properties.load(input);
			return properties.getProperty("excel.path");
		} catch (IOException e) {
			e.printStackTrace();
			return null;
		}
	}

	// Devolve a ruta donde vai a crear a estructura de carpetas para os zip
	private static String readConfigBaseDir() {
		Properties properties = new Properties();
		try (InputStream input = new FileInputStream(
				"src/main/resources/config.properties")) {
			properties.load(input);
			return properties.getProperty("base.dir");
		} catch (IOException e) {
			e.printStackTrace();
			return null;
		}
	}

	public static String getMes(int mes) {
		if (mes < 10) {
			return String.format("%02d", mes);
		}

		return String.valueOf(mes);
	}

}
