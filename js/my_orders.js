document.addEventListener('click', function(e) {
    const cancelBtn = e.target.closest('[data-action="cancel"]');
    if (cancelBtn) {
        const orderId = cancelBtn.dataset.orderId;
        const modalText = document.querySelector('#order-cancel-modal .account_delete_modal_entry_text');
        if (modalText) {
            modalText.textContent = `Вы уверены что хотите отменить заказ ${orderId}?`;
        }
        document.getElementById('cancel-order-id').value = orderId;
        openModal('order-cancel-modal');
    }
})

document.getElementById('close-order-cancel-modal').addEventListener('click', function() {
    closeModal('order-cancel-modal');
});

document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') {
        closeModal('order-cancel-modal');
    }
});