package dsg;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Iterator;

import javax.imageio.IIOImage;
import javax.imageio.ImageIO;
import javax.imageio.ImageWriteParam;
import javax.imageio.ImageWriter;
import javax.imageio.stream.ImageOutputStream;

public class ImageCompress {

	private static final String WORK_DIR = "F:\\PROJECT\\sql2008tune\\pic\\";
	private static final float COMPRESS_RATE = 0.5f;

	public static void main(String[] args) throws Exception {
		compressImage();

	}

	public static void compressImage() throws Exception {
		BufferedImage image = getBufferedImageByLocal(new File(WORK_DIR + "1.jpg"));

		File compressedImageFile = new File(WORK_DIR + "compress.jpg");
		OutputStream os = new FileOutputStream(compressedImageFile);

		Iterator<ImageWriter> writers = ImageIO.getImageWritersByFormatName("jpg");
		ImageWriter writer = (ImageWriter) writers.next();

		ImageOutputStream ios = ImageIO.createImageOutputStream(os);
		writer.setOutput(ios);

		ImageWriteParam param = writer.getDefaultWriteParam();
		// Check if canWriteCompressed is true
		if (param.canWriteCompressed()) {
			param.setCompressionMode(ImageWriteParam.MODE_EXPLICIT);
			param.setCompressionQuality(COMPRESS_RATE);
		}
		writer.write(null, new IIOImage(image, null, null), param);
	}

	public static BufferedImage getBufferedImageByLocal(File file) {
		InputStream is = null;
		BufferedImage img = null;
		try {
			is = new FileInputStream(file);
			img = ImageIO.read(is);
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			try {
				is.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		return img;
	}
}
