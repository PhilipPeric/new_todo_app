# Приложение для организации тасок в рамках ШМР 2023

### Что сделано 
- [x] Сохранение данных локально
- [x] Offline first
- [x] Unit тесты
- [x] Интеграционные тесты
- [x] Разделение слоев уровней работы с данными
- [x] CI\CD: тесты, анализатор кода, билд и деплой в Firebase App Distribution, используя github actions
- [x] firebase analytics
- [x] firebase remote config
- [x] firebase crashlitics
- [x] темная тема
- [x] flutter flavours
...

### flutter flavours - варианты запуска
flutter run -t lib/main_dev.dart  --flavor=dev
flutter run -t lib/main_prod.dart  --flavor=prod

запущенные версии отличаются шильдиками в правом верхнем углу

![Скриншот](https://github.com/PhilipPeric/new_todo_app/blob/release/homework_4/screenshots/Screenshot_20230717_021856.png)

### Как запустить 
1. Переименовать файл .env.example в .env
2. Прописать свой токен в .env
3. Запустить flutter pub run build_runner build
4. Готово - можно запускать проект на эмуляторе

### Как запустить интеграционные тесты 
Чисто по клику на зеленую стрелочку в ui android studio

https://github.com/PhilipPeric/new_todo_app/assets/35840908/cda0e7f3-80b9-4266-9c11-0c0a3a70adb7

[Скачать](https://github.com/PhilipPeric/new_todo_app/releases/download/3.0/app-arm64-v8a-release.apk)

![Скриншот](https://github.com/PhilipPeric/new_todo_app/blob/main/screenshots/tasks.png)

![Скриншот](https://github.com/PhilipPeric/new_todo_app/blob/main/screenshots/edit_task.png)

