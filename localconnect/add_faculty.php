<?php
header('Content-Type: application/json');

// Database connection
$conn = new mysqli("localhost", "root", "", "localconnect");

if ($conn->connect_error) {
    die(json_encode(["error" => "Database connection failed"]));
}

// Get faculty name and department from request
$data = json_decode(file_get_contents("php://input"), true);
$facultyName = $data['name'] ?? '';
$department = $data['department'] ?? '';

if (empty($facultyName) || empty($department)) {
    echo json_encode(["error" => "Faculty name and department are required"]);
    exit;
}

// Insert faculty into database
$query = "INSERT INTO faculty (name, department) VALUES (?, ?)";
$stmt = $conn->prepare($query);
$stmt->bind_param("ss", $facultyName, $department);

if ($stmt->execute()) {
    echo json_encode(["success" => true]);
} else {
    echo json_encode(["error" => "Failed to add faculty"]);
}

$stmt->close();
$conn->close();
?>
