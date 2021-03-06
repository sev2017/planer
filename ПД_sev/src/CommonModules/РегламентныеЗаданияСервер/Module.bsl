Процедура ВыполнитьГенерацияДокументов(ТекДата = Неопределено) Экспорт 
	Перем Коннектор;
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ЖурналДокументов.ДоговорОбслуживания КАК ДоговорОбслуживания,
	               |	ЗаданияГенерацииДокументов.ПериодСоздания КАК ПериодСоздания,
	               |	ЗаданияГенерацииДокументов.ДеньМесяца КАК ДеньМесяца,
	               |	ЗаданияГенерацииДокументов.Ссылка КАК Ссылка,
	               |	ЗаданияГенерацииДокументов.ДоговорОбслуживания.Организация КАК Организация
	               |ИЗ
	               |	Справочник.ЗаданияГенерацииДокументов КАК ЗаданияГенерацииДокументов
	               |		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	               |			ЖурналГенерацииДокументовСрезПоследних.Период КАК Период,
	               |			ЖурналГенерацииДокументовСрезПоследних.ДоговорОбслуживания КАК ДоговорОбслуживания
	               |		ИЗ
	               |			РегистрСведений.ЖурналГенерацииДокументов.СрезПоследних КАК ЖурналГенерацииДокументовСрезПоследних
	               |		ГДЕ
	               |			ЖурналГенерацииДокументовСрезПоследних.Период МЕЖДУ НАЧАЛОПЕРИОДА(&ТекДата, МЕСЯЦ) И КОНЕЦПЕРИОДА(&ТекДата, МЕСЯЦ)) КАК ЖурналДокументов
	               |		ПО ЗаданияГенерацииДокументов.ДоговорОбслуживания = ЖурналДокументов.ДоговорОбслуживания
	               |ГДЕ
	               |	НЕ ЗаданияГенерацииДокументов.ПометкаУдаления
	               |	И ЖурналДокументов.ДоговорОбслуживания ЕСТЬ NULL
	               |	И ЗаданияГенерацииДокументов.ДатаНачалаДействияЗадания < &ТекДата
	               |	И ВЫБОР
	               |			КОГДА ЗаданияГенерацииДокументов.ПериодСоздания = ЗНАЧЕНИЕ(Перечисление.НачалоКонецМесяца.ПервыйДеньМесяца)
	               |					И ДЕНЬ(&ТекДата) <= ДЕНЬ(НАЧАЛОПЕРИОДА(&ТекДата, МЕСЯЦ))
	               |				ТОГДА ИСТИНА
	               |			КОГДА ЗаданияГенерацииДокументов.ПериодСоздания = ЗНАЧЕНИЕ(Перечисление.НачалоКонецМесяца.ПоследнийДеньМесяца)
	               |					И ДЕНЬ(&ТекДата) >= ДЕНЬ(КОНЕЦПЕРИОДА(&ТекДата, МЕСЯЦ))
	               |				ТОГДА ИСТИНА
	               |			КОГДА ЗаданияГенерацииДокументов.ДеньМесяца = ДЕНЬ(&ТекДата)
	               |					ИЛИ ЗаданияГенерацииДокументов.ДеньМесяца >= ДЕНЬ(КОНЕЦПЕРИОДА(&ТекДата, МЕСЯЦ))
	               |				ТОГДА ИСТИНА
	               |			ИНАЧЕ ЛОЖЬ
	               |		КОНЕЦ
	               |ИТОГИ ПО
	               |	Организация";
	Если ТекДата = Неопределено Тогда
		ТекДата = ТекущаяДата();
	КонецЕсли;
	Запрос.УстановитьПараметр("ТекДата", ТекДата);			 
	ВыборкаОрганизация = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	//Если Выборка.Количество() > 0 Тогда
	//	Коннектор = ОбменДаннымиСервер.ПодключитьКоннекторДляОбмена(Выборка.Организация);
	//	Если Коннектор = Неопределено Тогда
	//		Возврат
	//	КонецЕсли;		
	//КонецЕсли;
	Пока ВыборкаОрганизация.Следующий() Цикл 		
		Организация = ВыборкаОрганизация.Организация;
		//Коннектор = ОбменДаннымиСервер.ПодключитьКоннекторДляОбмена(Организация);
		//Если Коннектор = Неопределено Тогда
		//	Продолжить;
		//КонецЕсли;
		ВыборкаДоговора = ВыборкаОрганизация.Выбрать();
		Пока ВыборкаДоговора.Следующий() Цикл 
			УправлениеГенерациеДокументов.ВыполнитьГенерациюДокументовЛокально(ВыборкаДоговора.Ссылка, ТекДата);
			//УправлениеГенерациеДокументов.ВыполнитьГенерациюДокументов(Коннектор, ВыборкаДоговора.Ссылка);
		КонецЦикла;
	КонецЦикла;
	
	//ПроизвестиРассылкуНапоминаний();
КонецПроцедуры

Процедура ПроизвестиРассылкуНапоминаний() Экспорт 
	ТаблицаПользователей = УправлениеПользователями.ПолучитьТаблицуПользователейДляPushУведомлений();	
	ТаблицаНапоминанийДляИсполнителя = РаботаСНапоминаниямиСервер.ПолучитьВсеАктивныеНапоминания();
	ТаблицаНапоминанийДляКуратора = РаботаСНапоминаниямиСервер.ПолучитьВсеАктивныеНапоминанияДляКуратора();	
	МассивОбщихНапоминаний = Новый Массив;
	Для Каждого Напоминание ИЗ ТаблицаНапоминанийДляИсполнителя Цикл 
		Если Не ЗначениеЗаполнено(Напоминание.Пользователь) Тогда
			МассивОбщихНапоминаний.Добавить(Напоминание);
			Продолжить;
		КонецЕсли;
		УстройствоПолучательСтрокаТЗ = ТаблицаПользователей.Найти(Напоминание.Пользователь, "Пользователь");
		Если УстройствоПолучательСтрокаТЗ = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		стрПараметрыНапоминания = Новый Структура;
		Если ПустаяСтрока(Напоминание.Комментарий) Тогда
			стрПараметрыНапоминания.Вставить("ТекстСообщения", Напоминание.Наименование);
		Иначе	
			стрПараметрыНапоминания.Вставить("ТекстСообщения", Напоминание.Комментарий);
		КонецЕсли;
		//стрПараметрыНапоминания.Вставить("Заголовок", Напоминание.Наименование);
		
		//СтруктураСообщения = Новый Структура;
		//СтруктураСообщения.Вставить("chat_id", Формат(УстройствоПолучательСтрокаТЗ.ТелеграмИД,"ЧГ="));	
		//СтруктураСообщения.Вставить("text" , стрПараметрыНапоминания.ТекстСообщения);
		ИнтеграцияСTelegramСервер.СообщениеПользователю(Новый Структура("id", УстройствоПолучательСтрокаТЗ.ТелеграмИД), "Напоминание: " + Символы.ПС + стрПараметрыНапоминания.ТекстСообщения); 
		//ИнтеграцияСВнешнимиСистемамиСервер.ОтправитьPushСообщение(УстройствоПолучательСтрокаТЗ.Устройство, стрПараметрыНапоминания); 	
	КонецЦикла;

	Для Каждого Напоминание ИЗ ТаблицаНапоминанийДляКуратора Цикл 
		УстройствоПолучательСтрокаТЗ = ТаблицаПользователей.Найти(Напоминание.Куратор, "Пользователь");
		Если УстройствоПолучательСтрокаТЗ = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		стрПараметрыНапоминания = Новый Структура;
		Если ПустаяСтрока(Напоминание.Комментарий) Тогда
			стрПараметрыНапоминания.Вставить("ТекстСообщения", Напоминание.Наименование);
		Иначе	
			стрПараметрыНапоминания.Вставить("ТекстСообщения", Напоминание.Комментарий);
		КонецЕсли;
		//стрПараметрыНапоминания.Вставить("Заголовок", Напоминание.Наименование);
		
		//СтруктураСообщения = Новый Структура;
		//СтруктураСообщения.Вставить("chat_id", Формат(УстройствоПолучательСтрокаТЗ.ТелеграмИД,"ЧГ="));	
		//СтруктураСообщения.Вставить("text" , стрПараметрыНапоминания.ТекстСообщения);
		ИнтеграцияСTelegramСервер.СообщениеПользователю(Новый Структура("id", УстройствоПолучательСтрокаТЗ.ТелеграмИД), "Задача не выполнена: " + Символы.ПС + стрПараметрыНапоминания.ТекстСообщения + Символы.ПС + 
		"<strong>Исполнитель:</strong> " + Напоминание.Пользователь + Символы.ПС + "<strong>Дата выполнения:</strong> " + Напоминание.ВремяВыполнения,,, "HTML"); 
		//ИнтеграцияСВнешнимиСистемамиСервер.ОтправитьPushСообщение(УстройствоПолучательСтрокаТЗ.Устройство, стрПараметрыНапоминания); 	
	КонецЦикла;

КонецПроцедуры