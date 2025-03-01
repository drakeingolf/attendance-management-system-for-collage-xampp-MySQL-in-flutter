<?php
header("Content-Type: application/json");

// Connect to database
$db = new mysqli('localhost', 'root', '', 'localconnect');

if ($db->connect_error) {
    die(json_encode(["status" => "error", "message" => "Database connection failed"]));
}

// Read input data
$username = isset($_POST['username']) ? $_POST['username'] : '';
$password = isset($_POST['password']) ? $_POST['password'] : '';

// Check if username and password are provided
if (empty($username) || empty($password)) {
    echo json_encode(["status" => "error", "message" => "Missing username or password"]);
    exit();
}

// Prepare SQL statement (Direct password comparison - NOT SECURE for production)
$stmt = $db->prepare("SELECT * FROM users WHERE username = ? AND password = ?");
$stmt->bind_param("ss", $username, $password);
$stmt->execute();
$result = $stmt->get_result();

// Check if user exists
if ($result->num_rows == 1) {
    $user = $result->fetch_assoc();
    
    // Send response with role
    echo json_encode([
        "status" => "Success",
        "role" => $user['role'],
        "message" => "Login successful"
    ]);
} else {
    echo json_encode(["status" => "error", "message" => "Invalid credentials"]);
}

// Close connection
$stmt->close();
$db->close();
?>
