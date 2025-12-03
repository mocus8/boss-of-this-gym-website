<?php
function checkYooKassaStatus($paymentId) {
    try {
        require_once __DIR__ . '/../vendor/autoload.php';
        require_once __DIR__ . '/envLoader.php';
        
        $yookassa = new \YooKassa\Client();
        $yookassa->setAuth(getenv('YOOKASSA_SHOP_ID'), getenv('YOOKASSA_API_KEY'));
        
        $payment = $yookassa->getPaymentInfo($paymentId);
        return $payment->getStatus();

    } catch (\YooKassa\Common\Exceptions\NotFoundException $e) {
        return 'not_found';

    } catch (Exception $e) {
        error_log("YooKassa API error: " . $e->getMessage());
        return 'api_error';
    }
}
?>