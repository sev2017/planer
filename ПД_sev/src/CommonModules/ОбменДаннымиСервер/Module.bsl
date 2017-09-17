Функция ПодключитьКоннекторДляОбмена(Организация) Экспорт 
	Перем ЗначениеВозврата;
	
	//СтрокаПодключения = Константы.COMСтрокаПодключения.Получить();
	СтрокаПодключения = ОбщегоНазначенияПовтИсп.ПолучитьСтрокуСоединенияБухгалтерия(Организация);
	Если ПустаяСтрока(СтрокаПодключения) Тогда
		РаботаСЭлектроннойПочтойСервер.ОтправитьПисьмоОбОшибке("Пустая строка подключение, генерация документов невозможна!");	
	Иначе
		КомКоннектор =	Новый COMObject("V83.COMConnector");
		Попытка
			ЗначениеВозврата = КомКоннектор.Connect(СтрокаПодключения);
		Исключение
			ТекстОшибки ="Сбой инициализации коннектора для обмена, со строкой подключение: " + СтрокаПодключения + Символы.ПС + ОписаниеОшибки();
			РаботаСЭлектроннойПочтойСервер.ОтправитьПисьмоОбОшибке("Сбой инициализации коннектора для обмена!", ТекстОшибки);
		КонецПопытки;
	КонецЕсли;	
	
	Возврат ЗначениеВозврата
КонецФункции // ПодключитьКоннекторДляОбмена()

//Возвращает таблицу значений с результатом запроса
//Запрос - запрос на языке SQL
//Структура - структура в которой в качестве ключа задается имя колонки результирующей таблицы значений
//а в качестве значение имя колонки в таблице внешнего источника данных
Функция ЧитатьДанныйНаВнешнейТаблицеADO(Структура, Запрос, СтрокаСоединения, ТЗ = Неопределено) экспорт
	Если ТЗ = Неопределено Тогда 
		ТЗ = Новый ТаблицаЗначений;
		Для каждого Поле ИЗ Структура Цикл
			ТЗ.Колонки.Добавить(Поле.Ключ);
			//Сообщить(Поле.Ключ);
		КонецЦикла;
	КонецЕсли;	
	Соединение = Новый COMОбъект("ADODB.Connection");
	Соединение.Open(СтрокаСоединения);
	
	RS = Новый COMОбъект("ADODB.Recordset");                        
	RS.Open(Запрос, Соединение);
	Пока RS.EOF() = 0 Цикл
		НоваяСтрокаТЗ = ТЗ.Добавить();
        Для каждого Поле ИЗ Структура Цикл
		//	ТЗ.Колонки.обавить(Поле.Ключ);
		//	Сообщить(Поле.Ключ);
		// Можно обращаться и обрабатывать значения полей выборки.
			Ключ = Поле.Ключ;
			Значение = Структура[Ключ];
		//	Сообщить(Значение);
			ИД = RS.Fields(Значение).Value;
			НоваяСтрокаТЗ[Ключ] = ИД;
		//Код = RS.Fields("Code").Value;
		//Сообщить(ИД);
		КонецЦикла;
		// Обработка других полей
		RS.MoveNext();
	КонецЦикла;
	RS.Close();
	Соединение.Close(); 
	
	Возврат ТЗ;
КонецФункции

Функция ПодключитьсяКODBCFM(ТекстСообщения = "") Экспорт
	Сервер="localhost"; // IP адрес сайта
	ПользовательСервера="admin"; // имя пользователя базы данных
	ПарольСервера="8mmvg3gx"; // пароль пользователя базы данных
	БазаСервера="Invoices tr";  // название SQL базы данных
	Соединение = Новый COMОбъект("ADODB.Connection");
	//Соединение_param = "driver={MySQL ODBC 3.51 Driver}; server="+СокрЛП(Сервер)+"; uid="+СокрЛП(ПользовательСервера)+"; pwd="+СокрЛП(ПарольСервера)+"; database="+СокрЛП(БазаСервера)+"; STMT=SET CHARACTER SET utf8";
	Соединение_param = "driver={FileMaker ODBC}; server="+СокрЛП(Сервер)+"; uid="+СокрЛП(ПользовательСервера)+"; pwd="+СокрЛП(ПарольСервера)+"; database="+СокрЛП(БазаСервера)+"; STMT=SET CHARACTER SET cp1251";
	Попытка
		Соединение.open(Соединение_param);
		СоединениеУстановлено = Истина;
		//Сообщить("Соединение установлено");
	Исключение
		ТекстСообщения = ""+ТекущаяДата()+" Connection error: "+ОписаниеОшибки();
		Сообщить(ТекстСообщения);
		СоединениеУстановлено = Ложь;
		Возврат Неопределено
	КонецПопытки;
	
	Возврат Соединение;
КонецФункции
