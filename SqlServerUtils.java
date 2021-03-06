/*
 * COPYRIGHT. HSBC HOLDINGS PLC 2017. ALL RIGHTS RESERVED.
 * 
 * This software is only to be used for the purpose for which it has been
 * provided. No part of it is to be reproduced, disassembled, transmitted,
 * stored in a retrieval system nor translated in any human or computer
 * language in any way or for any other purposes whatsoever without the prior
 * written consent of HSBC Holdings plc.
 */

import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Scanner;

import javax.imageio.IIOImage;
import javax.imageio.ImageIO;
import javax.imageio.ImageWriteParam;
import javax.imageio.ImageWriter;
import javax.imageio.stream.ImageOutputStream;

public class SqlServerUtils {

    private static final String JDBC_DRIVER = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
    private static final String CONN_URL = "jdbc:sqlserver://192.168.7.1:1433;databaseName=dsg_test";
    private static final String DB_USER = "dba01";
    private static final String DB_PSWD = "dba1024";
    private static final String WORK_DIR = "C:\\TEMP\\34028369-VistaJin\\01-new-projects\\201709-dsg\\";

    private static final float COMPRESS_RATE = 0.05f;

    public static void main(String[] args) throws Exception {
        while (true) {
            Scanner scanner = new Scanner(System.in);
            System.out.println("Enter your action:");
            System.out.println("1. Insert new image to table");
            System.out.println("2. Compress image in table");
            System.out.println("3. Get image from table");
            System.out.println("4. Call spsavebaneditlog");
            System.out.println("5. Call spMaterialByBatchID");
            System.out.println("6. Exit");

            System.out.print("> ");
            String action = scanner.next();
            switch (String.valueOf(action.charAt(0))) {
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
                    System.out.print("\nStart Call spsavebaneditlog ...");

                    List<Thread> threads = new ArrayList<Thread>();
                    SqlServerUtils ss = new SqlServerUtils();
                    for (int i = 0; i < 500; i++) {
                        Runnable task = ss.new SPRunable();
                        Thread worker = new Thread(task);
                        worker.setName(String.valueOf(i));
                        worker.start();
                        threads.add(worker);
                    }
                    int running = 0;
                    do {
                        running = 0;
                        for (Thread thread : threads) {
                            if (thread.isAlive()) {
                                running++;
                            }
                        }
//                        System.out.println("We have " + running + " running threads. ");
                    } while (running > 0);

                    // callStoreProcedure();
                    System.out.print("\nEnd Call spsavebaneditlog\n");
                    break;
                case "5":
                    System.out.print("\nStart Call spMaterialByBatchID ...");

                    List<Thread> threads2 = new ArrayList<Thread>();
                    SqlServerUtils ss2 = new SqlServerUtils();
                    for (int i = 0; i < Integer.valueOf(action.substring(2)); i++) {
                        Runnable task = ss2.new SPMaterialRunable();
                        Thread worker = new Thread(task);
                        worker.setName(String.valueOf(i));
                        worker.start();
                        threads2.add(worker);
                    }
                    int running2 = 0;
                    do {
                        running2 = 0;
                        for (Thread thread : threads2) {
                            if (thread.isAlive()) {
                                running2++;
                            }
                        }
//                        System.out.println("We have " + running + " running threads. ");
                    } while (running2 > 0);

                    // callStoreProcedure();
                    System.out.print("\nEnd Call spMaterialByBatchID\n");
                    break;
                case "6":
                    scanner.close();
                    System.out.print("bye");
                    System.exit(0);
                    break;
                default:
                    System.err.println("Invalid action, please enter again!");
            }
        }
    }

    public static void callStoreProcedure() {
        Connection conn = null;
        try {
            conn = getConnection();
            CallableStatement cs = conn.prepareCall("{call dsg_test.dbo.spsavebaneditlog(?,?,?)}");
            cs.setString(1, "MB00201155");
            cs.setString(2, "TEST1");
            cs.setString(3, "ADD");
            cs.executeUpdate();
        } catch (Exception e) {
            System.err.println("Failed to callStoreProcedure spsavebaneditlog.");
            e.printStackTrace();
        } finally {
            closeConnection(conn);
        }
    }

    public static void callMaterialStoreProcedure() {
        long now = System.currentTimeMillis();
        Connection conn = null;
        try {
            conn = getConnection();
            CallableStatement cs = conn.prepareCall(
                    "{call dsg_test.dbo.spMaterialByBatchID(null,null,null,?,null,null," +
                            "null,null,null,?,null,?,null,null,null,null,null," +
                            "null,null,null,null,null,null,null,null,null,null,null,null,null)}");
            cs.setString(1, "\'18EK-PWS0172\'");
            cs.setInt(2, 1);
            cs.setInt(3, 1);
            cs.executeUpdate();
        } catch (Exception e) {
            System.err.println("Failed to callMaterialStoreProcedure spMaterialByBatchID.");
            e.printStackTrace();
        } finally {
            closeConnection(conn);
            System.out.println("Call spMaterialByBatchID on thread id(" + Thread.currentThread().getId()+ ") takes "
            + (System.currentTimeMillis() - now) + "s");
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
            //pstmt = conn.prepareStatement("insert into t_img values(?)");
            pstmt = conn.prepareStatement("update ban_makebill_picture set picture=? where mb_number='123'");
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


    class SPRunable implements Runnable {
        @Override
        public void run() {
            SqlServerUtils.callStoreProcedure();
        }
    }

    class SPMaterialRunable implements Runnable {
        @Override
        public void run() {
            SqlServerUtils.callMaterialStoreProcedure();
        }
    }
}
