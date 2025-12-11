









class DeliveryMap {
    // Приватные поля (состояние карты)
    #map = null;                    // Объект Яндекс.Карты
    #marker = null;                 // Текущий маркер адреса
    #loader = null;                 // Элемент лоадера
    #addressInput = null;           // Поле ввода адреса
    #searchBtn = null;              // Кнопка поиска
    #isGeocodeTimedOut = false;     // Флаг таймаута геокодирования
    #containerId = null;            // ID контейнера (передаётся в конструкторе)

    constructor(containerId, options = {}) {
        this.#containerId = containerId;  // ✅ Контейнер передаём как параметр!
        this.options = options;
        
        // Проверяем можно ли создать карту
        if (this.#canInitialize()) {
            this.#init();
        }
    }

    // 🔒 ПРИВАТНЫЕ МЕТОДЫ:

    #canInitialize() {
        // Твоя текущая защита от повторного создания
        const container = document.getElementById(this.#containerId);
        return container && container.children.length === 0;
    }

    #init() {
        // 1. Находим элементы
        this.#findElements();
        
        // 2. Создаём карту
        this.#createMap();
        
        // 3. Настраиваем события
        this.#setupEvents();
        
        // 4. Инициализируем DaData
        this.#initDaData();
    }

    #findElements() {
        this.#loader = document.getElementById(`${this.#containerId}-loader`);
        this.#addressInput = document.getElementById('delivery-address');
        this.#searchBtn = document.getElementById('delivery-search-btn');
    }

    #createMap() {
        this.#map = new ymaps.Map(this.#containerId, {
            center: this.options.center || [55.76, 37.64],
            zoom: this.options.zoom || 10,
            controls: ['zoomControl']
        });
    }

    #setupEvents() {
        // Навешиваем обработчики на кнопки и поля
        if (this.#searchBtn) {
            this.#searchBtn.addEventListener('click', () => this.#processAddress());
        }
        // ... другие обработчики
    }

    #initDaData() {
        // Инициализация DaData для поля ввода
        // ... существующий код
    }

    #processAddress() {
        // Твоя текущая логика обработки адреса
        // с таймаутами, ошибками и т.д.
    }

    #showAddressOnMap(geoObject) {
        // Логика показа адреса на карте
        // с созданием маркера и балуна
    }

    #sanitizeAddress(address) {
        // Санитизация адреса
        return address.replace(/[<>"`\\\/]/g, '');
    }

    #hideLoader() {
        // Плавное скрытие лоадера
        if (this.#loader) {
            this.#loader.style.opacity = '0';
            setTimeout(() => {
                this.#loader.style.display = 'none';
            }, 200);
        }
    }

    // 🔓 ПУБЛИЧНЫЕ МЕТОДЫ (API класса):

    clear() {
        // Очистка карты (при закрытии модалки)
        if (this.#marker) {
            this.#map.geoObjects.remove(this.#marker);
            this.#marker = null;
        }
        this.#map.setCenter([55.76, 37.64], 8);
    }

    destroy() {
        // Полное уничтожение карты
        if (this.#map) {
            this.#map.destroy();
            this.#map = null;
        }
    }

    setCenter(coords, zoom) {
        // Программное изменение центра карты
        this.#map.setCenter(coords, zoom);
    }
}

class PickupMap {
    // Приватные поля
    #map = null;                    // Объект карты
    #selectedStoreMarker = null;    // Выбранный маркер магазина
    #loader = null;                 // Лоадер
    #stores = [];                   // Загруженные магазины
    #containerId = null;            // ID контейнера

    constructor(containerId, options = {}) {
        this.#containerId = containerId;  // ✅ Контейнер как параметр
        this.options = options;
        
        if (this.#canInitialize()) {
            this.#init();
        }
    }

    // 🔒 ПРИВАТНЫЕ МЕТОДЫ:

    #canInitialize() {
        const container = document.getElementById(this.#containerId);
        return container && container.children.length === 0;
    }

    #init() {
        this.#createMap();
        this.#loadStores();
    }

    #createMap() {
        this.#map = new ymaps.Map(this.#containerId, {
            center: this.options.center || [55.8, 37.64],
            zoom: this.options.zoom || 8
        });
    }

    async #loadStores() {
        try {
            const response = await fetch('src/getStores.php');
            this.#stores = await response.json();
            this.#renderStores();
            this.#hideLoader();
        } catch (error) {
            console.error('Ошибка загрузки магазинов:', error);
            this.#hideLoader();
        }
    }

    #renderStores() {
        this.#stores.forEach((store, index) => {
            if (store.coordinates?.length === 2) {
                this.#createStoreMarker(store, index);
            }
        });
    }

    #createStoreMarker(store, index) {
        // Создание маркера магазина с балуном
        const placemark = new ymaps.Placemark(store.coordinates, {
            balloonContent: this.#createBalloonContent(store, index)
        }, {
            iconLayout: 'default#image',
            iconImageHref: '/img/custom_map_pin.png',
            iconImageSize: [60, 55]
        });
        
        this.#map.geoObjects.add(placemark);
        
        // Обработчик открытия балуна
        placemark.events.add('balloonopen', () => {
            this.#setupStoreSelection(store, placemark, index);
        });
    }

    #createBalloonContent(store, index) {
        // Генерация HTML для балуна
        return `
            <div style="min-width: 250px;">
                <strong>${store.address}</strong><br>
                <div>${store.work_hours}</div>
                <div>${store.phone}</div>
                <button id="select-pickup-store-${index}">
                    Заберу отсюда
                </button>
            </div>
        `;
    }

    #setupStoreSelection(store, marker, index) {
        // Настройка выбора магазина
        const selectBtn = document.getElementById(`select-pickup-store-${index}`);
        
        if (this.#isStoreSelected(store.address)) {
            // Если магазин уже выбран
            selectBtn.textContent = '✅ Магазин выбран';
            selectBtn.disabled = true;
        } else {
            // Если не выбран - настраиваем клик
            selectBtn.addEventListener('click', () => {
                this.#selectStore(store.id, store.address, marker, index);
            });
        }
    }

    #isStoreSelected(address) {
        // Проверка, выбран ли уже этот магазин
        const currentAddress = document.getElementById('order-right-pickup-address').innerText;
        return currentAddress === address;
    }

    async #selectStore(storeId, address, marker, index) {
        // AJAX запрос на сохранение выбора
        try {
            const response = await fetchWithRetry('src/saveDeliveryAddress.php', {
                method: 'POST',
                body: JSON.stringify({ delivery_type: 'pickup', store_id: storeId })
            });
            
            if (response.success) {
                this.#updateSelectedStore(marker, index);
                this.#updateUI(address);
            }
        } catch (error) {
            console.error('Ошибка выбора магазина:', error);
        }
    }

    #updateSelectedStore(newMarker, index) {
        // Сброс предыдущего выбранного маркера
        if (this.#selectedStoreMarker) {
            this.#selectedStoreMarker.options.set({
                iconImageHref: '/img/custom_map_pin.png'
            });
        }
        
        // Установка нового выбранного маркера
        newMarker.options.set({
            iconImageHref: '/img/custom_map_pin_chosen.png'
        });
        
        this.#selectedStoreMarker = newMarker;
    }

    #updateUI(address) {
        // Обновление UI после выбора магазина
        document.getElementById('order-right-pickup-address').innerText = address;
        
        // Обновление всех кнопок выбора
        document.querySelectorAll('[id^="select-pickup-store-"]').forEach(btn => {
            btn.textContent = 'Заберу отсюда';
            btn.disabled = false;
        });
    }

    #hideLoader() {
        // Скрытие лоадера
        if (this.#loader) {
            this.#loader.style.opacity = '0';
            setTimeout(() => {
                this.#loader.style.display = 'none';
            }, 200);
        }
    }

    // 🔓 ПУБЛИЧНЫЕ МЕТОДЫ:

    clear() {
        // Очистка выбранного магазина
        if (this.#selectedStoreMarker) {
            this.#selectedStoreMarker.options.set({
                iconImageHref: '/img/custom_map_pin.png'
            });
            this.#selectedStoreMarker = null;
        }
        
        // Сброс кнопок
        document.querySelectorAll('[id^="select-pickup-store-"]').forEach(btn => {
            btn.textContent = 'Заберу отсюда';
            btn.disabled = false;
        });
        
        this.#map.setCenter([55.76, 37.64], 8);
    }

    destroy() {
        // Уничтожение карты
        if (this.#map) {
            this.#map.destroy();
            this.#map = null;
        }
    }

    addStore(store) {
        // Динамическое добавление магазина
        this.#stores.push(store);
        this.#createStoreMarker(store, this.#stores.length - 1);
    }
}