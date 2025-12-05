//обработчик кнопки оплаты
document.querySelectorAll('.order_right_pay_button').forEach(button => {
    button.addEventListener('click', async function() {
        const orderId = this.getAttribute('data-order-id');
        const isDelivery = document.getElementById('order-type-delivery').classList.contains('chosen');
        const deliveryAddress = document.getElementById('order-right-delivery-address').innerText;
        const pickupAddress = document.getElementById('order-right-pickup-address').innerText;
        const originalText = button.textContent;

        // ДОБАВИЛ: Сброс предыдущих ошибок адреса
        document.getElementById("error-pay-delivery-no-address")?.classList.remove("open");
        document.getElementById("error-pay-pickup-no-address")?.classList.remove("open");

        button.disabled = true;
        button.textContent = 'Создаем платеж...';
        
        // ИЗМЕНИЛ: Убрал else, добавил ранний return
        if (isDelivery && deliveryAddress.includes("не указан")) {
            document.getElementById("error-pay-delivery-no-address")?.classList.add("open");
            button.disabled = false;  // ДОБАВИЛ: Разблокируем кнопку
            button.textContent = originalText;
            return;  // ДОБАВИЛ: Выходим из функции
        }
        
        if (!isDelivery && pickupAddress.includes("не указан")) {
            document.getElementById("error-pay-pickup-no-address")?.classList.add("open");
            button.disabled = false;  // ДОБАВИЛ: Разблокируем кнопку
            button.textContent = originalText;
            return;  // ДОБАВИЛ: Выходим из функции
        }

        try {
            // ПЕРЕДАЕМ order_id В POST
            const response = await fetch('/create_payment.php', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-Requested-With': 'XMLHttpRequest'  // ДОБАВИЛ: Заголовок для AJAX
                },
                body: JSON.stringify({
                    order_id: orderId
                })
            });
                            
            // ДОБАВИЛ: Проверка что ответ JSON
            let result;
            try {
                result = await response.json();
            } catch (jsonError) {
                showUserError('Некорректный ответ от сервера');
                return;
            }
            
            // ИЗМЕНИЛ: Улучшенная обработка HTTP ошибок
            if (!response.ok) {
                // ДОБАВИЛ: Специальная обработка для ORDER_ALREADY_PAID
                if (response.status === 409 && result.error === 'ORDER_ALREADY_PAID') {
                    window.location.href = `/order_success.php?orderId=${orderId}`;
                    return;
                }
                
                // ДОБАВИЛ: Получение понятного сообщения об ошибке
                const errorMessage = getErrorMessage(response.status, result?.error);
                showUserError(errorMessage);
                return;
            }
            
            // ДОБАВИЛ: Проверка что есть confirmation_url
            if (!result.confirmation_url) {
                showUserError('Не получена ссылка для оплаты');
                return;
            }
            
            window.location.href = result.confirmation_url;

        } catch (error) {
            console.error('Full error:', error);
            
            // ИЗМЕНИЛ: Заменил alert на красивый показ ошибки
            if (error.name === 'TypeError' && error.message.includes('Failed to fetch')) {
                showUserError('Нет соединения с сервером. Проверьте интернет.');
            } else {
                showUserError('Ошибка при создании платежа. Попробуйте позже.');
            }

        } finally {
            button.disabled = false;
            button.textContent = originalText;
        }
    });
});

// ДОБАВИЛ: Функция показа ошибок пользователю (вместо alert)
function showUserError(message) {
    // УДАЛИЛ: alert('Ошибка: ' + error.message);
    
    // Создаем красивый alert
    const alertDiv = document.createElement('div');
    alertDiv.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        background: #f8d7da;
        color: #721c24;
        padding: 15px;
        border-radius: 5px;
        border: 1px solid #f5c6cb;
        z-index: 10000;
        max-width: 400px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        animation: slideIn 0.3s ease-out;
    `;
    
    alertDiv.innerHTML = `<strong>Ошибка оплаты:</strong><br>${message}`;
    document.body.appendChild(alertDiv);
    
    // Автоудаление через 5 секунд
    setTimeout(() => {
        if (alertDiv.parentNode) {
            alertDiv.parentNode.removeChild(alertDiv);
        }
    }, 5000);
    
    // Добавляем анимацию
    const style = document.createElement('style');
    style.textContent = `
        @keyframes slideIn {
            from { transform: translateX(100%); opacity: 0; }
            to { transform: translateX(0); opacity: 1; }
        }
    `;
    document.head.appendChild(style);
}

// ДОБАВИЛ: Функция получения понятных сообщений об ошибках
function getErrorMessage(status, errorCode) {
    // Маппинг HTTP статусов
    const statusMessages = {
        400: 'Неверный запрос',
        401: 'Требуется авторизация',
        403: 'Доступ запрещен',
        404: 'Заказ не найден',
        409: 'Конфликт при обработке заказа',
        422: getValidationMessage(errorCode),
        429: 'Слишком много запросов. Попробуйте через минуту',
        500: 'Внутренняя ошибка сервера',
        502: 'Платежная система временно недоступна',
        503: 'Сервис временно недоступен'
    };
    
    // Сначала пробуем получить по статусу
    let message = statusMessages[status] || 'Произошла ошибка';
    
    // ДОБАВИЛ: Особые случаи для 409
    if (status === 409) {
        if (errorCode === 'PAYMENT_IN_PROGRESS') {
            return 'Платеж уже обрабатывается. Подождите 5 секунд.';
        }
    }
    
    return message;
}

// ДОБАВИЛ: Функция для валидационных ошибок (422)
function getValidationMessage(errorCode) {
    const messages = {
        'EMPTY_USER_PHONE': 'Укажите номер телефона в профиле',
        'INVALID_PHONE_FORMAT': 'Неверный формат телефона',
        'RECEIPT_TOTAL_MISMATCH': 'Ошибка расчета суммы. Обновите страницу',
        'INVALID_PAYMENT_DATA': 'Неверные данные для оплаты'
    };
    
    return messages[errorCode] || 'Ошибка в данных';
}