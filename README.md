Redirecter
==========
Аналог сокращателя ссылок. Поддерживает добавление ссылок через авторизацию с https и анти-спам проверкой с помощью 
recapcha.<br>
<br>
<br>
Для работы необходимо:<br>
 1) Вставить приватный и публичный ключи в redir_https.rb <br>
 2) Вставить публиный ключ в views/add_link.erb (https://developers.google.com/recaptcha/docs/display).<br>
 3) Вставить свой домен в views/new_link.erb <br>
 4) Указать в redir.rb путь к redir.rb, он используется при текущей организации для доступа к файлу паролей и файлам с 
ссылками, в общем случае может быть любым при сохранении структуры каталогов.<br>
<br>
<br>
<br>
todo:<br>
1) Перевод readme на английский<br>
2) Подробное коментирование<br>
3) Улучшение интерфейса <br>
4) Использование базы данных для хранения учётных записей  <br>
5) Авторизация с помощью социальных сетей  <br>

Если с стандартным гемом recaptcha не работает - попробуйте использовать подправленный verify.rb - в нём закоментирована обработка сообщений ошибок.
