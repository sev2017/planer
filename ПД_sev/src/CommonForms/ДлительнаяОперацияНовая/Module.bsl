
&НаКлиенте
Перем ИнтервалОжидания;

// @@@.ДОБАВЛЕНИЕ.17.02.2016 11:04:17.<ХЛ>.Балабанов
//
&НаКлиенте
Перем НачалоВыполнения;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ТекстСообщения = НСтр("ru = 'Пожалуйста, подождите...'");
	Если Не ПустаяСтрока(Параметры.ТекстСообщения) Тогда
		ТекстСообщения = Параметры.ТекстСообщения + Символы.ПС + ТекстСообщения;
		Элементы.ДекорацияПоясняющийТекстДлительнойОперации.Заголовок = ТекстСообщения;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.ИдентификаторЗадания) Тогда
		ИдентификаторЗадания = Параметры.ИдентификаторЗадания;
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Параметры.ВыводитьОкноОжидания Тогда
		ИнтервалОжидания = ?(Параметры.Интервал <> 0, Параметры.Интервал, 1);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", ИнтервалОжидания, Истина);
		// +++.ДОБАВЛЕНИЕ.17.02.2016 11:04:44.<ХЛ>.Балабанов
		НачалоВыполнения = ТекущаяДата();
		// ---.ДОБАВЛЕНИЕ.17.02.2016 11:04:44.<ХЛ>.Балабанов
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если Статус = "Выполняется" Тогда
		Отказ = Истина;
		ПодключитьОбработчикОжидания("Подключаемый_ОтменитьЗадание", 0.1, Истина);
	КонецЕсли;
			
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	ПриЗакрытииНаСервере()
	
КонецПроцедуры

#КонецОбласти

#Область Команды

&НаКлиенте
Процедура Отмена(Команда)
	
	Подключаемый_ПроверитьВыполнениеЗадания(); // а вдруг задание уже выполнилось
	Если Статус = "Выполняется" Тогда
		// +++.ДОБАВЛЕНИЕ.17.02.2016 10:53:01..Балабанов
		ЗавершитьДлительнуюОперацию();
		// ---.ДОБАВЛЕНИЕ.17.02.2016 10:53:01..Балабанов
		Статус = Неопределено;
		Закрыть(РезультатВыполнения(Неопределено));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Результат = ПроверитьЗаданиеВыполнено();
	Статус = Результат.Статус;
	
	Если Результат.Прогресс <> Неопределено Тогда
		//ПрогрессСтрокой = ПрогрессСтрокой(Результат.Прогресс);
		// +++.ДОБАВЛЕНИЕ.17.02.2016 11:05:46.<ХЛ>.Балабанов
		Результат.Прогресс.Свойство("Процент", ПрогрессПроцент);
		Если Результат.Прогресс.Свойство("Текст") Тогда
			ПрогрессСтрокой = Результат.Прогресс.Текст;
		Иначе
			ПрогрессСтрокой = "";
		КонецЕсли;
		ПрошлоВремени = ТекущаяДата() - НачалоВыполнения;
		Если НЕ ЗначениеЗаполнено(ПрогрессПроцент) Тогда
			ТекстОсталось = НСтр("ru = 'Вычисляется...'");
		Иначе
			Осталось = ПрошлоВремени * (1 / ПрогрессПроцент * 100 - 1);//ПрошлоВремени * (ФормаИндикатора.МаксимальноеЗначение / ФормаИндикатора.Значение - 1);
			ТекстОсталось = "~" + ПолучитьПредставлениеОставшегосяВремени(Осталось);
		КонецЕсли;
		// ---.ДОБАВЛЕНИЕ.17.02.2016 11:05:46.<ХЛ>.Балабанов
		Если Не ПустаяСтрока(ПрогрессСтрокой) Тогда
			Элементы.ДекорацияПоясняющийТекстДлительнойОперации.Заголовок = ТекстСообщения + " " + ПрогрессСтрокой;
		КонецЕсли;
	ИначеЕсли Результат.Сообщения <> Неопределено И ВладелецФормы <> Неопределено Тогда
		ИдентификаторНазначения = ВладелецФормы.УникальныйИдентификатор;
		Для каждого СообщениеПользователю Из Результат.Сообщения Цикл
			СообщениеПользователю.ИдентификаторНазначения = ИдентификаторНазначения;
			СообщениеПользователю.Сообщить();
		КонецЦикла;
	КонецЕсли;
		
	Если Статус = "Выполнено" Тогда
		
		ПоказатьОповещение();
		Закрыть(РезультатВыполнения(Результат));
		Возврат;
		
	ИначеЕсли Статус = "Ошибка" Тогда
		
		ПоказатьПредупреждение(, ?(ПустаяСтрока(Результат.КраткоеПредставлениеОшибки), 
			НСтр("ru = 'Не удалось выполнить запрошенное действие.'"), Результат.КраткоеПредставлениеОшибки));
		Закрыть(РезультатВыполнения(Результат));
		Возврат;
		
	КонецЕсли;
	
	Если Параметры.ВыводитьОкноОжидания Тогда
		Если Параметры.Интервал = 0 Тогда
			ИнтервалОжидания = ИнтервалОжидания * 1.4;
			Если ИнтервалОжидания > 15 Тогда
				ИнтервалОжидания = 15;
			КонецЕсли;
		КонецЕсли;
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", ИнтервалОжидания, Истина);
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОтменитьЗадание()
	
	Отмена(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьОповещение()
	
	Если Параметры.ОповещениеПользователя = Неопределено Или Не Параметры.ОповещениеПользователя.Показать Тогда
		Возврат;
	КонецЕсли;
	
	Оповещение = Параметры.ОповещениеПользователя;
	
	НавигационнаяСсылкаОповещения = Оповещение.НавигационнаяСсылка;
	Если НавигационнаяСсылкаОповещения = Неопределено И ВладелецФормы <> Неопределено И ВладелецФормы.Окно <> Неопределено Тогда
		НавигационнаяСсылкаОповещения = ВладелецФормы.Окно.ПолучитьНавигационнуюСсылку();
	КонецЕсли;
	ПояснениеОповещения = Оповещение.Пояснение;
	Если ПояснениеОповещения = Неопределено И ВладелецФормы <> Неопределено И ВладелецФормы.Окно <> Неопределено Тогда
		ПояснениеОповещения = ВладелецФормы.Окно.Заголовок;
	КонецЕсли;
	
	ПоказатьОповещениеПользователя(?(Оповещение.Текст <> Неопределено, Оповещение.Текст, НСтр("ru = 'Действие выполнено'")), 
		НавигационнаяСсылкаОповещения, ПояснениеОповещения);

КонецПроцедуры
	
&НаСервере
Функция ПроверитьЗаданиеВыполнено()
	
	Возврат ДлительныеОперации.ОперацияВыполнена(ИдентификаторЗадания, Ложь, Параметры.ВыводитьПрогрессВыполнения,
		Параметры.ВыводитьСообщения);
	
КонецФункции

&НаКлиенте
Функция ПрогрессСтрокой(Прогресс)
	
	Результат = "";
	Если Прогресс = Неопределено Тогда
		Возврат Результат;
	КонецЕсли;
	
	Процент = 0;
	Если Прогресс.Свойство("Процент", Процент) Тогда
		Результат = Строка(Процент) + "%";
	КонецЕсли;
	Текст = 0;
	Если Прогресс.Свойство("Текст", Текст) Тогда
		Если Не ПустаяСтрока(Результат) Тогда
			Результат = Результат + " (" + Текст + ")";
		Иначе
			Результат = Текст;
		КонецЕсли;
	КонецЕсли;

	Возврат Результат;
	
КонецФункции

&НаКлиенте
Функция РезультатВыполнения(Статус)
	
	Если Статус = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("Статус", Статус.Статус);
	Результат.Вставить("АдресРезультата", Параметры.АдресРезультата);
	Результат.Вставить("АдресДополнительногоРезультата", Параметры.АдресДополнительногоРезультата);
	Результат.Вставить("КраткоеПредставлениеОшибки", Статус.КраткоеПредставлениеОшибки);
	Результат.Вставить("ПодробноеПредставлениеОшибки", Статус.ПодробноеПредставлениеОшибки);
	Возврат Результат;
	
КонецФункции
	
&НаСервере
Процедура ПриЗакрытииНаСервере()
	
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
КонецПроцедуры

// @@@.ДОБАВЛЕНИЕ.17.02.2016 11:02:09.<ХЛ>.Балабанов
//
&НаСервере
Процедура ЗавершитьДлительнуюОперацию()

	Задание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ИдентификаторЗадания);
	Если Задание.Состояние = СостояниеФоновогоЗадания.Активно Тогда
		Задание.Отменить();
	КонецЕсли;
	
КонецПроцедуры

// @@@.ДОБАВЛЕНИЕ.17.02.2016 11:18:01.<ХЛ>.Балабанов
//
&НаКлиенте
Функция ПолучитьПредставлениеОставшегосяВремени(ОсталосьСекунд)
	
	ОсталосьДней = Цел(ОсталосьСекунд / 86400);
	Осталось = ОсталосьСекунд - ОсталосьДней * 86400;
	ОсталосьЧасов = Цел(Осталось / 3600);
	Осталось = Осталось - ОсталосьЧасов * 3600;
	ОсталосьМинут = Цел(Осталось / 60);
	ОсталосьСекунд = Осталось - ОсталосьМинут * 60;
	Возврат ?(ОсталосьДней = 0, "", Строка(ОсталосьДней) + " д., ") + Формат(ОсталосьЧасов, "ЧЦ=2; ЧН=; ЧВН=") + ":" + Формат(ОсталосьМинут, "ЧЦ=2; ЧН=; ЧВН=") + ":" + Формат(ОсталосьСекунд, "ЧЦ=2; ЧН=; ЧВН=");
	
КонецФункции // ПолучитьПредставлениеОставшегосяВремени()

#КонецОбласти
