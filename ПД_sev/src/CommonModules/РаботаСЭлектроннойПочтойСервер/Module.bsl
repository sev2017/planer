Процедура ОтправитьПисьмоОбОшибке(Тема = "", Сообщение = "") Экспорт 

ОтправитьПочтовоеСообщение(Тема, Сообщение, "sev@gks-service.ru");	

КонецПроцедуры

Функция ПолучитьДанныеДляПодключенияКСерверуПочты()
	стрПараметры = Новый Структура;
	стрПараметры.Вставить("Сервер", Константы.SMTPАдресСервера.Получить());
	стрПараметры.Вставить("Порт", Константы.SMTPПортСервера.Получить());
	стрПараметры.Вставить("ИмяПользователя", Константы.SMTPИмяПользователя.Получить());
	стрПараметры.Вставить("Пароль", Константы.SMTPПарольПользователя.Получить());
	
	Если Не ЗначениеЗаполнено(стрПараметры.Сервер) Тогда
		ВызватьИсключение "Не указан адрес SMTP сервера для отправки почтовых сообщений!";
	КонецЕсли;
	Если стрПараметры.Порт = 0 Тогда
		стрПараметры.Порт = 25;
	КонецЕсли;
		
	Возврат стрПараметры;
КонецФункции

Функция ПолучитьДанныеДляПодключенияКСерверуСМС()	
	Перем ЗначениеВозврата;
	стрПараметры = Новый Структура;
	стрПараметры.Вставить("ИмяПользователя", Константы.СМСИмяПользователя.Получить());
	стрПараметры.Вставить("Пароль", Константы.СМСПароль.Получить());
	стрПараметры.Вставить("Порт", Константы.СМСПорт.Получить());
	
	Если Не (ЗначениеЗаполнено(стрПараметры.ИмяПользователя) ИЛИ ЗначениеЗаполнено(стрПараметры.Пароль) ИЛИ ЗначениеЗаполнено(стрПараметры.Порт)) Тогда
		ОтправитьПисьмоОбОшибке("Не заполнены параметры подключения в серверу рассылки СМС!");
	Иначе
		ЗначениеВозврата = стрПараметры; 
	КонецЕсли;
	Возврат ЗначениеВозврата;
КонецФункции

Функция ОтправитьПочтовоеСообщение(Тема, Сообщение, Получатель, Отправитель = "", стрВложения = Неопределено, булУдалитьВложенияПослеОтправки = Ложь) Экспорт 
	ЗначениеВозврата = Истина;
	стрДанныеДляПодключения = ПолучитьДанныеДляПодключенияКСерверуПочты();
	Профиль = Новый ИнтернетПочтовыйПрофиль;
	Профиль.АдресСервераSMTP = стрДанныеДляПодключения.Сервер;
	Профиль.ПортSMTP = стрДанныеДляПодключения.Порт;
	Профиль.Пользователь = стрДанныеДляПодключения.ИмяПользователя;
	Профиль.ПользовательSMTP = стрДанныеДляПодключения.ИмяПользователя;
	Профиль.ПарольSMTP = стрДанныеДляПодключения.Пароль;
	Профиль.Пароль = стрДанныеДляПодключения.Пароль;
	Профиль.ИспользоватьSSLSMTP = Истина;
	//Профиль.ТолькоЗащищеннаяАутентификацияSMTP = Истина;
	//Профиль.АутентификацияSMTP = СпособSMTPАутентификации.БезАутентификации;
	ПочтовоеСообщение = Новый ИнтернетПочтовоеСообщение;
	
	Если ТипЗнч(Получатель) = Тип("Массив") Тогда
		Для каждого Стр Из Получатель Цикл
			ПочтовоеСообщение.Получатели.Добавить(Стр);	
		КонецЦикла;
	Иначе	
		ПочтовоеСообщение.Получатели.Добавить(Получатель);
	КонецЕсли; 
	Если Не стрВложения = Неопределено Тогда  
		Для каждого Вложение Из стрВложения Цикл
			ПочтовоеСообщение.Вложения.Добавить(Вложение.Значение, Вложение.Ключ);		
		КонецЦикла; 	
	КонецЕсли;
	Если ПустаяСтрока(Отправитель) Тогда
		ПочтовоеСообщение.Отправитель = стрДанныеДляПодключения.ИмяПользователя;	
	Иначе
		ПочтовоеСообщение.Отправитель = Отправитель;
	КонецЕсли;
	
	ПочтовоеСообщение.Тема = Тема;
	ПочтовоеСообщение.Тексты.Добавить(Сообщение);
		
	Почта = Новый ИнтернетПочта;
	
	Попытка
		Почта.Подключиться(Профиль);				
		Почта.Послать(ПочтовоеСообщение);
	Исключение
		Сообщить(ОписаниеОшибки());
		ЗначениеВозврата = Ложь;
	КонецПопытки;
	Почта.Отключиться();
	Возврат ЗначениеВозврата;
КонецФункции

Функция ОтправитьСМССообщение(Сообщение, Получатель) Экспорт 
	стрПараметрыПодключения = ПолучитьДанныеДляПодключенияКСерверуСМС();
	Если стрПараметрыПодключения = Неопределено Тогда
		Возврат Неопределено
	КонецЕсли;		
	Профиль 						= Новый ИнтернетПочтовыйПрофиль;
	Профиль.АутентификацияSMTP 		= СпособSMTPАутентификации.Plain;
	Профиль.АдресСервераSMTP 		= "web.mirsms.ru";
	Профиль.ПортSMTP 				= стрПараметрыПодключения.Порт;//2525;
	Профиль.ПользовательSMTP 		= стрПараметрыПодключения.ИмяПользователя;//"36000";
	Профиль.ПарольSMTP 				= стрПараметрыПодключения.Пароль;//"42129361";
	
	ПочтовоеСообщение 				= Новый ИнтернетПочтовоеСообщение;
	Получатель 						= "8" + Получатель + "@web.mirsms.ru";
	
	ПочтовоеСообщение.Получатели.Добавить(Получатель);
	ПочтовоеСообщение.Отправитель 	= "default@web.mirsms.ru";
	ПочтовоеСообщение.Тема 			= "Интернет-заказ";
	ПочтовоеСообщение.Тексты.Добавить(Сообщение);
	
	Почта 							= Новый ИнтернетПочта;
	
	Попытка
		Почта.Подключиться(Профиль);
		Почта.Послать(ПочтовоеСообщение);
	Исключение
		Сообщить(ОписаниеОшибки());
		Возврат Ложь;
	КонецПопытки;
	
	Почта.Отключиться();
	
	Возврат Истина;
КонецФункции

Процедура СформироватьРассылкуПервичнойДокументации(стрВложения = Неопределено, ссылкаЗаданиеГенерации) Экспорт 
	ДоговорОбслуживания = ссылкаЗаданиеГенерации.ДоговорОбслуживания;
	Тема = "Документы за обслуживание " + ДоговорОбслуживания.Контрагент.ПолноеНаименование;
	СообщениеСМС = "Документы за обслуживание " + ДоговорОбслуживания.Контрагент.Наименование + " сформированы"; 
	Сообщение = "Электронные копии первичных документов.
				|Оригиналы документов будут доставлены по адресу: " + ДоговорОбслуживания.АдресДоставкиДокументов;
	
				
	МассивСотрудниковПолучателей = ссылкаЗаданиеГенерации.ОтветственныеСотрудники.ВыгрузитьКолонку("Сотрудник");
	МассивАдресовПолучателей = Новый Массив;
	МассивПолучателейСМС = Новый Массив;
	Для Каждого Сотрудник Из МассивСотрудниковПолучателей Цикл 
		Если Не ПустаяСтрока(Сотрудник.АдресЭлектроннойПочты) Тогда
			МассивАдресовПолучателей.Добавить(Сотрудник.АдресЭлектроннойПочты);
		КонецЕсли;
		Если Сотрудник.ИзвещатьПоСМС И Не ПустаяСтрока(Сотрудник.МобильныйТелефон) Тогда 		
			МассивПолучателейСМС.Добавить(Сотрудник.МобильныйТелефон);			
		КонецЕсли;
	КонецЦикла;
	Если ссылкаЗаданиеГенерации.ОтправлятьКопииДокументовКлиенту Тогда
		Если Не ПустаяСтрока(ДоговорОбслуживания.Контрагент.АдресЭлектроннойПочты) Тогда
			МассивАдресовПолучателей.Добавить(ДоговорОбслуживания.Контрагент.АдресЭлектроннойПочты);	
		Иначе
			ОтправитьПисьмоОбОшибке("У контрагента " + ДоговорОбслуживания.Контрагент + "Не заполнен адрес электронной почты!"); 
		КонецЕсли;
	КонецЕсли;
	Если Не стрВложения = Неопределено Тогда						
		РаботаСЭлектроннойПочтойСервер.ОтправитьПочтовоеСообщение(Тема, Сообщение, МассивАдресовПолучателей, , стрВложения, Истина); 	
	Иначе
		РаботаСЭлектроннойПочтойСервер.ОтправитьПочтовоеСообщение(Тема, Сообщение, МассивАдресовПолучателей, , , Истина); 	
	КонецЕсли;
	
	Если МассивПолучателейСМС.Количество() > 0 Тогда
		Для Каждого ПолучательСМС ИЗ МассивПолучателейСМС Цикл 
			ОтправитьСМССообщение(СообщениеСМС, ПолучательСМС);
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры
	
Процедура ДобавитьПочтовыАдресВБазу(СтрокаПочтовыйАдрес) Экспорт;
	ПочтовыйАдрес = СокрЛП(СтрокаПочтовыйАдрес);
	ПочтовыйАдресСсылка = Справочники.ПочтовыеАдреса.НайтиПоНаименованию(ПочтовыйАдрес);
	Если ПочтовыйАдресСсылка = ПредопределенноеЗначение("Справочник.ПочтовыеАдреса.ПустаяСсылка") Тогда
		НовыйПочтовыАдрес = Справочники.ПочтовыеАдреса.СоздатьЭлемент();
		НовыйПочтовыАдрес.Наименование = ПочтовыйАдрес;
		НовыйПочтовыАдрес.Записать();
	КонецЕсли;
	
КонецПроцедуры