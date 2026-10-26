<?php
require_once 'config.php';
header('Content-Type: application/json; charset=utf-8');

$action = $_GET['action'] ?? $_POST['action'] ?? '';

switch ($action) {
    case 'login':
        $email = trim($_POST['email'] ?? '');
        $password = $_POST['password'] ?? '';
        $db = getDB();
        $stmt = $db->prepare("SELECT id, full_name, email, password, role FROM users WHERE email = ?");
        $stmt->bind_param('s', $email);
        $stmt->execute();
        $user = $stmt->get_result()->fetch_assoc();

        if ($user && password_verify($password, $user['password'])) {
            $_SESSION['user_id'] = $user['id'];
            $_SESSION['full_name'] = $user['full_name'];
            $_SESSION['email'] = $user['email'];
            $_SESSION['role'] = $user['role'];
            jsonResponse([
                'success' => true,
                'user' => [
                    'id' => $user['id'],
                    'name' => $user['full_name'],
                    'email' => $user['email'],
                    'role' => $user['role']
                ]
            ]);
        }
        jsonResponse(['success' => false, 'message' => 'Email hoặc mật khẩu không đúng'], 401);
        break;

    case 'register':
        $name = trim($_POST['full_name'] ?? '');
        $email = trim($_POST['email'] ?? '');
        $phone = trim($_POST['phone'] ?? '');
        $password = $_POST['password'] ?? '';
        if (!$name || !$email || !$password) {
            jsonResponse(['success' => false, 'message' => 'Vui lòng điền đủ thông tin'], 400);
        }
        $hash = password_hash($password, PASSWORD_DEFAULT);
        $db = getDB();
        $stmt = $db->prepare("INSERT INTO users (full_name, email, phone, password, role) VALUES (?, ?, ?, ?, 'customer')");
        $stmt->bind_param('ssss', $name, $email, $phone, $hash);
        if ($stmt->execute()) {
            jsonResponse(['success' => true, 'message' => 'Đăng ký thành công']);
        }
        jsonResponse(['success' => false, 'message' => 'Email đã tồn tại'], 400);
        break;

    case 'logout':
        session_destroy();
        jsonResponse(['success' => true]);
        break;

    case 'me':
        if (empty($_SESSION['user_id'])) {
            jsonResponse(['logged_in' => false]);
        }
        jsonResponse([
            'logged_in' => true,
            'user' => [
                'id' => $_SESSION['user_id'],
                'name' => $_SESSION['full_name'],
                'email' => $_SESSION['email'],
                'role' => $_SESSION['role']
            ]
        ]);
        break;

    default:
        jsonResponse(['error' => 'Invalid action'], 400);
}
?>
