<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ page import="java.util.Locale" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Base64" %>


<html>
<head>
    <title>Ray's Grocery - Product Information</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<%@ include file="header.jsp" %>

<%
try {
    // Load driver class
    Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
} catch (java.lang.ClassNotFoundException e) {
    out.println("ClassNotFoundException: " + e);
}

// connection
String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
String uid = "sa";
String pw = "304#sa#pw";
NumberFormat currency = NumberFormat.getCurrencyInstance(Locale.US);

// Get product name to search for
// TODO: Retrieve and display info for the product

String pname, imageurl, binaryurl, imgSrc, image;
String productId = request.getParameter("id");
double doublevalue = Double.parseDouble(productId); 
int intValue = (int) doublevalue; 
String sql = "SELECT productName, productPrice, productImageURL, productImage FROM product WHERE productId = ?";
try (Connection con = DriverManager.getConnection(url, uid, pw);
    PreparedStatement pst = con.prepareStatement(sql)) {
    pst.setInt(1, intValue);
    ResultSet rst = pst.executeQuery();

    if (rst.next()) {
        pname = rst.getString("productName");
        double price = rst.getDouble("productPrice");
        byte[] img = rst.getBytes("productImage");
         if (img != null && img.length > 0) {
            image = Base64.getEncoder().encodeToString(img);
            imgSrc = "data:image/jpeg;base64," + image;
            out.println("<img src="+imgSrc+">");
         }
            out.println("<h1>" + pname + "</h1>");
            out.println("<h4>ID: " + intValue + "</h4>");
            out.println("<h4>Price: " + currency.format(price) + "</h4>");
        

        // TODO: If there is a productImageURL, display using IMG tag
        // TODO: Retrieve any image stored directly in the database.
        // Note: Call displayImage.jsp with product id as a parameter.
    } 

    rst.close();
} catch (SQLException ex) {
    out.println("SQLException: " + ex);
}

// TODO: Add links to Add to Cart and Continue Shopping

%>
<br> 
<a href="addcart.jsp" align="left" class="cart">
        <button id = "shopping2">
                <h2 align="center">Add to Cart</h2>     
        </button>
</a>
<br>
<br>
<a href="listprod.jsp?productName=" align="left" class="shopping">
        <button id = "shopping">
                <h2 align="center">Continue Shopping</h2>     
        </button>
</a>

</body>
</html>