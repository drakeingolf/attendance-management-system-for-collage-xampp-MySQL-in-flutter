<?php
header('Content-Type: application/json');

// Database connection
$conn = new mysqli("localhost", "root", "", "localconnect");

if ($conn->connect_error) {
    die(json_encode(["error" => "Database connection failed"]));
}

// Get faculty name from request
$data = json_decode(file_get_contents("php://input"), true);
$facultyName = $data['name'] ?? '';

if (empty($facultyName)) {
    echo json_encode(["error" => "Faculty name is required"]);
    exit;
}

// Start transaction
$conn->begin_transaction();

try {
    // Delete faculty from users table (assuming faculty username is stored in users table)
    $query1 = "DELETE FROM users WHERE username = ?";
    $stmt1 = $conn->prepare($query1);
    $stmt1->bind_param("s", $facultyName);
    $stmt1->execute();
    $stmt1->close();

    // Delete faculty from faculty table
    $query2 = "DELETE FROM faculty WHERE name = ?";
    $stmt2 = $conn->prepare($query2);
    $stmt2->bind_param("s", $facultyName);
    $stmt2->execute();
    $stmt2->close();

    // Commit transaction
    $conn->commit();

    echo json_encode(["success" => true]);
} catch (Exception $e) {
    $conn->rollback();
    echo json_encode(["error" => "Failed to delete faculty and associated records"]);
}

$conn->close();
?>
