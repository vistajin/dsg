/*
 * COPYRIGHT. HSBC HOLDINGS PLC 2017. ALL RIGHTS RESERVED.
 * 
 * This software is only to be used for the purpose for which it has been
 * provided. No part of it is to be reproduced, disassembled, transmitted,
 * stored in a retrieval system nor translated in any human or computer
 * language in any way or for any other purposes whatsoever without the prior
 * written consent of HSBC Holdings plc.
 */
package sqlserver;

import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Iterator;
import java.util.Scanner;

import javax.imageio.IIOImage;
import javax.imageio.ImageIO;
import javax.imageio.ImageWriteParam;
import javax.imageio.ImageWriter;
import javax.imageio.stream.ImageOutputStream;

public class SqlServerUtils {

    private static final String JDBC_DRIVER = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
    private static final String CONN_URL = "jdbc:sqlserver://HKW20021915.hbap.adroot.hsbc:1433;databaseName=dsg";
    private static final String DB_USER = "dsgusr";
    private static final String DB_PSWD = "dsgAbc~123";
    private static final String WORK_DIR = "C:\\TEMP\\34028369-VistaJin\\01-new-projects\\201709-dsg\\";

    private static final float COMPRESS_RATE = 0.05f;

    public static void main(String[] args) throws Exception {
        while (true) {
            Scanner scanner = new Scanner(System.in);
            System.out.println("Enter your action:");
            System.out.println("1. Insert new image to table");
            System.out.println("2. Compress image in table");
            System.out.println("3. Get image from table");
            System.out.println("4. Exit");
            System.out.print("> ");
            String action = scanner.next();
            switch (action) {
            case "1":
                System.out.print("\nEnter image file name: ");
                insertImage(WORK_DIR + scanner.next());
                break;
            case "2":
                System.out.print("\nEnter image id to compress: ");
                compressImageAndSave(Integer.parseInt(scanner.next()));
                break;
            case "3":
                System.out.print("\nEnter image id to extract: ");
                getImageData(Integer.parseInt(scanner.next()));
                break;
            case "4":
                scanner.close();
                System.out.print("bye");
                System.exit(0);
                break;
            default:
                System.err.println("Invalid action, please enter again!");
            }
        }
    }

    public static Connection getConnection() {
        try {
            Class.forName(JDBC_DRIVER);
            Connection conn = DriverManager.getConnection(CONN_URL, DB_USER, DB_PSWD);
            System.out.println("Connected to sql server successfully.");
            return conn;
        } catch (Exception e) {
            System.err.println("Failed to connect to database.");
            e.printStackTrace();
            return null;
        }
    }

    public static void closeConnection(final Connection con) {
        if (con != null) {
            try {
                con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public static void insertImage(final String img) {
        PreparedStatement pstmt = null;
        Connection conn = null;
        try {
            conn = getConnection();
            File file = new File(img);
            FileInputStream fis = new FileInputStream(file);
            pstmt = conn.prepareStatement("insert into t_img values(?)");
            pstmt.setBinaryStream(1, fis, (int) file.length());
            pstmt.executeUpdate();
            System.out.println("Saved new image to table successfully: " + img + "\n");
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeStatement(pstmt);
            closeConnection(conn);
        }
    }

    public static void closeStatement(PreparedStatement pstmt) {
        if (pstmt != null) {
            try {
                pstmt.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public static void getImageData(final int id) {
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = getConnection();
            ps = conn.prepareStatement("select img from t_img where id = ?");
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                byte[] fileBytes = rs.getBytes(1);
                OutputStream targetFile = new FileOutputStream(WORK_DIR + "extracted.jpg");
                targetFile.write(fileBytes);
                targetFile.close();
            }
            rs.close();
            System.out.println("Got image from table to " + WORK_DIR + "extracted.jpg\n");
        } catch (Exception e) {
            System.err.println("Failed to getImageData.");
            e.printStackTrace();
        } finally {
            closeStatement(ps);
            closeConnection(conn);
        }
    }

    public static void compressImageAndSave(final int id) throws Exception {
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = getConnection();
            ps = conn.prepareStatement("select img from t_img where id = ?");
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                byte[] fileBytes = rs.getBytes(1);
                InputStream in = new ByteArrayInputStream(fileBytes);
                BufferedImage image = ImageIO.read(in);

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
                ps.close();

                FileInputStream fis = new FileInputStream(compressedImageFile);                
                ps = conn.prepareStatement("update t_img set img=? where id=?");
                ps.setBinaryStream(1, fis, (int) compressedImageFile.length());
                ps.setInt(2, id);
                ps.executeUpdate();
                System.out.println("Compressed image and update to table successfully.\n");
            }
            rs.close();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeStatement(ps);
            closeConnection(conn);
        }
    }
}
