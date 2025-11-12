<?php
session_start();
require_once __DIR__ . '/helpers.php';

$orderId = $_POST["order_id"] ?? '';
$userId = $_SESSION['user']['id'] ?? null;

if (!$userId || !$orderId) {
    $_SESSION['flash_cancel_error'][$orderId] = 'DATABASE_OPERATIONS_FAILED';
    header('Location: /my_orders.php');
    exit();
}

try {
    $connect = getDB();
    if (!$connect) {
        throw new Exception('DATABASE_CONNECT_FAILED');
    }

    $stmt = $connect->prepare("
    UPDATE orders 
    SET status = 'cancelled', 
        cancelled_at = NOW()
    WHERE order_id = ? AND user_id = ? AND status = 'pending_payment'
    ");
    if (!$stmt) {
        throw new Exception('ORDER_CANNOT_BE_CANCELLED');
    }
    
    $stmt->bind_param("ii", $orderId, $userId);
    $stmt->execute();
    
    if ($stmt->affected_rows === 0) {
        throw new Exception('DATABASE_OPERATIONS_FAILED');
    }

    //здесь доделать
    $_SESSION['flash_cancel_success'][$orderId] = 'CANCEL_ORDER_SUCCESS';
} catch (Exception $e) {
    $_SESSION['flash_cancel_error'][$orderId] = $e->getMessage();
    error_log($e->getMessage());
    header('Location: /my_orders.php');
} finally {
    if (isset($stmt)) $stmt->close();
    if (isset($connect)) $connect->close();
}

header('Location: /my_orders.php');
exit;
?>