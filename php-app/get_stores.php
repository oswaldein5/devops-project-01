<?php
require_once 'connection.php';

if (isset($_GET['city_id'])) {
    $cityId = $_GET['city_id'];

    $stmt = $pdo->prepare("SELECT * FROM stores WHERE city_id = ?");
    $stmt->execute([$cityId]);
    $stores = $stmt->fetchAll(PDO::FETCH_ASSOC);

    header('Content-Type: application/json');
    echo json_encode($stores);
} else {
    http_response_code(400);
    echo json_encode(['error' => 'City ID is required']);
}
?>