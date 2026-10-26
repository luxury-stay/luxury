<?php
// Cấu hình kết nối database
define('DB_SERVER', 'DESKTOP-LV1B447\SQLEXPRESS');  // ← tên server trong SSMS của bạn
define('DB_NAME',   'luxury_stay');
define('DB_USER',   '');   // để trống nếu dùng Windows Authentication
define('DB_PASS',   '');
session_start();

function getDB() {
    static $conn = null;
    if ($conn === null) {
        $conn = new mysqli(DB_HOST, DB_USER, DB_PASS, DB_NAME);
        if ($conn->connect_error) {
            die(json_encode(['error' => 'Kết nối DB thất bại: ' . $conn->connect_error]));
        }
        $conn->set_charset('utf8mb4');
    }
    return $conn;
}

function requireLogin() {
    if (empty($_SESSION['user_id'])) {
        header('Location: ../login.html');
        exit;
    }
}

function requireStaff() {
    requireLogin();
    if (!in_array($_SESSION['role'], ['staff', 'admin'])) {
        header('Location: ../index.html');
        exit;
    }
}

function jsonResponse($data, $code = 200) {
    http_response_code($code);
    header('Content-Type: application/json; charset=utf-8');
    echo json_encode($data, JSON_UNESCAPED_UNICODE);
    exit;
}
?>
