<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

$servername = "localhost";
$username = "root";  // Update if needed
$password = "";      // Update if needed
$dbname = "localconnect"; // Update with your actual database

$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    echo json_encode(["status" => "Error", "message" => "Database connection failed"]);
    exit();
}

// Get POST data
$input_username = $_POST['username'] ?? '';
$input_password = $_POST['password'] ?? '';

if (empty($input_username) || empty($input_password)) {
    echo json_encode(["status" => "Error", "message" => "Missing credentials"]);
    exit();
}

// Query the database
$sql = "SELECT * FROM users WHERE username = '$input_username' AND password = '$input_password'";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();
    echo json_encode([
        "status" => "Success",
        "role" => $row["role"],
        "admin_name" => $row["username"]
    ]);
} else {
    echo json_encode(["status" => "Error", "message" => "Invalid credentials"]);
}

$conn->close();
?>
