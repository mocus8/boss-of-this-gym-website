<?php
session_start();
require_once __DIR__ . '/smscFunctions.php';

header('Content-Type: application/json');

$input = json_decode(file_get_contents('php://input'), true);
$phone = $input['phone'] ?? '';

if (empty($code)) {
    echo json_encode(['success' => false, 'error' => 'Введите код']);
    exit;
}

$result = verify_sms_code($code);
echo json_encode($result);
?>