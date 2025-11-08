<?php
require_once __DIR__ . '/src/helpers.php';

// Получаем подпись из заголовка для ее проверки (таким образом не получиться подделать post запроси пометить заказ как оплаченный)
$signature = $_SERVER['HTTP_SIGNATURE'] ?? '';
$input = file_get_contents('php://input');

//проверка подписи
$hash = base64_encode(hash_hmac('sha256', $input, getenv('YOOKASSA_API_KEY'), true));
if ($signature !== "sha256=" . $hash) {
    http_response_code(403);
    error_log("Invalid webhook signature");
    exit('Invalid signature');
}

if (empty($input)) {
    http_response_code(400);
    exit('Empty request');
}

$data = json_decode($input, true);

if (json_last_error() !== JSON_ERROR_NONE) {
    error_log("ERROR: Invalid JSON");
    http_response_code(400);
    exit('Invalid JSON');
}

if ($data['event'] === 'payment.succeeded') {
    $payment = $data['object'];
    $orderId = $payment['metadata']['orderId'] ?? null;;
    
    if (!$orderId) {
        error_log("ERROR: No orderId in metadata");
        http_response_code(200); // Все равно возвращаем 200 для ЮКассы
        exit('OK');
    }

    // Обновляем статус заказа
    try {
        $connect = getDB();
        if (!$connect) {
            throw new Exception('Database connection failed');
        }

        $stmt = $connect->prepare("UPDATE orders SET paid_at = NOW(), status = 'paid' WHERE order_id = ?");
        if (!$stmt) {
            throw new Exception('Prepare failed: ' . $connect->error);
        }
        $stmt->bind_param("i", $orderId);
        $result = $stmt->execute();
        if (!$result) {
            throw new Exception('Execute failed: ' . $stmt->error);
        }
    } catch (Exception $e) {
        // ЛОГИРОВАНИЕ ОШИБОК (в реальном проекте использовать логирование в отдельный файл)
        error_log("WEBHOOK ERROR: " . $e->getMessage());
    } finally {
        if (isset($stmt)) $stmt->close();
        if (isset($connect)) $connect->close();
    }
}
http_response_code(200);
echo 'OK';
?>