// Импортируем модуль ES6 класса
import { ErrorModal } from './utils.js';

// Храним все модалки заказов через встроенный js класс Map(), наборы ключ -> значение
const errorModals = new Map();

// Инициализация всех модалок при загрузке
document.addEventListener('DOMContentLoaded', () => {
    // Для заказа создаем свою модалку
    document.querySelectorAll('.order[data-order-id]').forEach(orderElement => {
        // id этого заказа
        const orderId = orderElement.dataset.orderId;

        // id модалки и текста для этого заказа
        const modalId = `error-modal-${orderId}`;
        const textId = `error-modal-text-${orderId}`;

        const orderModal = new ErrorModal(modalId, textId);

        // Настраиваем кнопки открытия (оплата)
        const payButton = orderElement.querySelector('[data-action="pay"]');
        if (payButton) {
            orderModal.addOpenButton(payButton);
        }

        // Настраиваем кнопки открытия (отмена)
        const cancelButton = orderElement.querySelector('[data-action="cancel"]');
        if (cancelButton) {
            orderModal.addOpenButton(cancelButton);
        }

        // Сохраняем в Map для быстрого доступа
        errorModals.set(orderId, orderModal);
    });
});

// обработчик кнопок отмены заказа: подготавливаем форму
document.addEventListener('click', function(e) {
    const cancelBtn = e.target.closest('[data-action="cancel"]');
    if (cancelBtn) {
        // Берем ID из родительского .order
        const orderElement = cancelBtn.closest('.order');
        const orderId = orderElement.dataset.orderId;

        // Проверка на корректный id заказа
        if (!orderId || !orderId.match(/^\d+$/)) {
            // тут нормальное логирование потом
            console.error('Invalid orderId from button:', orderId);
            headerModal.open('Ошибка данных заказа, обновите страницу и попробуйте еще раз')
            return; // Не открываем модалку вообще
        }
        

        // id заказа в скрытое поле формы
        document.getElementById('cancel-order-id').value = orderId;

        // меняем текст формы
        const orderDeleteText = document.getElementById('order-delete-modal-entry-text');
        if (orderDeleteText) {
            orderDeleteText.textContent = `Вы уверены что хотите отменить заказ ${orderId}?`;
        }

        openModal('order-cancel-modal');
    }
})

// Обработчик кнопки закрытия модалки (с формой внутри) отмены заказа
document.getElementById('close-order-cancel-modal').addEventListener('click', function() {
    closeModal('order-cancel-modal');
});

// Обработчик подтверждения формы отмены заказа
document.getElementById('cancel-order-form').addEventListener('submit', async function(e) {
    e.preventDefault();

    const submitButton = this.querySelector('button[type="submit"]');
    if (submitButton.classList.contains('processing')) return;

    const originalText = submitButton.textContent;

    // Закртие всех модалок
    ErrorModal.closeAll();

    // блокируем кнопку на время выполнения скрипта
    submitButton.classList.add('processing');
    submitButton.disabled = true;
    submitButton.textContent = 'Отменяем...';

    // Получаем и проверяем id заказа
    const orderId = document.getElementById('cancel-order-id').value;
    if (!orderId || !orderId.match(/^\d+$/)) {
        // Потом нормально логировать
        console.error('Invalid orderId in cancel form:', orderId);

        headerModal.open('Не удалось определить номер заказа. Пожалуйста, обновите страницу и попробуйте снова.');

        // Разблокируем кнопку
        submitButton.classList.remove('processing');
        submitButton.disabled = false;
        submitButton.textContent = originalText;

        return;
    }

    const errorModal = errorModals.get(orderId);
    if (!errorModal) {
        headerModal.open('Ошибка данных заказа, обновите страницу и попробуйте еще раз')
        return;
    }

    const orderElement = document.querySelector(`.order[data-order-id="${orderId}"]`);
    if (!orderElement) {
        // Потом нормально логировать
        console.error('Cant find orderElement in cancel form:', orderId);

        errorModal.open('Не удалось определить номер заказа. Пожалуйста, обновите страницу и попробуйте снова.');

        // Разблокируем кнопку
        submitButton.classList.remove('processing');
        submitButton.disabled = false;
        submitButton.textContent = originalText;

        return;
    }

    // Тут не нужен таймаут (как в create_payment) к api т.к. это не внешнее api

     try {
        // Подготавливаем данные
        const formData = new FormData();
        formData.append('order_id', orderId);

        // Передаём данные в POST
        const response = await fetch('/src/cancelOrder.php', {
            method: 'POST',
            body: formData
        });

        // Проверка что ответ JSON
        let result;
        try {
            result = await response.json();
        } catch (jsonError) {
            errorModal.open('Некорректный ответ от сервера, попробуйте еще раз');
            return;
        }
        
        if (!response.ok) {
            // Если этот заказ уже отменен
            if (response.status === 409 && result.error === 'ORDER_ALREADY_CANCELLED') {
                errorModal.open('Заказ уже отменен, обновите страницу');
                return;
            }

            // Получение и показ понятного сообщения об ошибке
            const errorMessage = getErrorMessage(response.status, result?.error);
            errorModal.open(errorMessage);
            return;
        }

        // Обновляем статус
        const statusElement = orderElement.querySelector('[data-field="status"]');
        if (statusElement) {
            statusElement.innerHTML = 'Статус заказа: <br>отменён';
        }
        
        // Скрываем кнопки действий
        orderElement.querySelectorAll('[data-action]').forEach(btn => {
            btn.remove();
        });

        headerModal.open('Заказ был успешно отменен.');

     } catch (error) {
        // Потом нормально логировать
        console.error('Cant cancel order:', orderId);

        if (error.name === 'TypeError' && error.message.includes('Failed to fetch')) {
            // Если ошибки связаны с сетью
            errorModal.open('Нет соединения с сервером. Проверьте интернет соединение.');
        } else {
            // Другие ошибки
            errorModal.open('Ошибка при отмене заказа. Попробуйте позже.');
        }

     } finally {
        submitButton.classList.remove('processing');
        submitButton.disabled = false;
        submitButton.textContent = originalText;
     }
});

document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') {
        closeModal('order-cancel-modal');
    }
});

document.querySelectorAll('[data-action="pay"]').forEach(button => {
    button.addEventListener('click', async function() {

        const orderId = this.getAttribute('data-order-id');

        // Блокируем кнопку на время запроса
        this.disabled = true;
        const originalText = this.textContent;
        this.textContent = 'Обработка...';

        try {
            // ПЕРЕДАЕМ order_id В POST
            const response = await fetch('/create_payment.php', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    order_id: orderId
                })
            });
            
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }

            const rawText = await response.text();
            const result = JSON.parse(rawText);
            
            if (result.confirmation_url) {
                window.location.href = result.confirmation_url;
            } else {
                throw new Error(result.error || 'Payment error');
            }
        } catch (error) {
            this.disabled = false;
            this.textContent = originalText;
            
            const errorText = getErrorMessage(error.message);
            alert(errorText);
        }
    });
});