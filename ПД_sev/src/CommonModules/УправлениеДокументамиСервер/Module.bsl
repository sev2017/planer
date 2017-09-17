Процедура СинхронизироватьСчетаКлиентов() Экспорт 
	Попытка
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		               |	Организации.Ссылка КАК Организация
		               |ИЗ
		               |	Справочник.Организации КАК Организации
		               |ГДЕ
		               |	НЕ Организации.ПометкаУдаления";
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл 
			//ОсновнаяОрганизация = ОбщегоНазначенияПовтИсп.ПолучитьЗначениеКонстанты("УПОсновнаяОрганизация"); 
			ОсновнаяОрганизация = Выборка.Организация;
			СтрокаСоединения = ОбщегоНазначенияПовтИсп.ПолучитьСтрокуСоединенияFM(ОсновнаяОрганизация);//"DRIVER={FileMaker ODBC};SERVER=localhost;UID=admin;PWD=8mmvg3gx;DATABASE=Invoices tr;";
			Если ПустаяСтрока(СтрокаСоединения) Тогда
				Продолжить;
			КонецЕсли;
			//ЗапросSQL = "Select ""invoice id"", ""DATE"", company, total, summary from Invoices";
			ЗапросSQL = "Select inv.""invoice id"", inv.""DATE"", cust.Company, cust.inn, cust.""CUSTOMER ID MATCH FIELD"", inv.total, summary from Invoices AS inv, Customers AS cust 
			|where inv.""CUSTOMER ID MATCH FIELD"" = cust.""CUSTOMER ID MATCH FIELD""";
			стрПоля = Новый Структура("НомерFM, Дата, Наименование, ИНН, ID, СуммаДокумента, Комментарий", "invoice id", "DATE", "company", "inn", "CUSTOMER ID MATCH FIELD", "total", "summary");
			ТаблицаТипизированная = Новый ТаблицаЗначений;
			ТаблицаТипизированная.Колонки.Добавить("НомерFM", Новый ОписаниеТипов("Число",, Новый КвалификаторыЧисла(10, 0, ДопустимыйЗнак.Неотрицательный)));
			ТаблицаТипизированная.Колонки.Добавить("Дата", Новый ОписаниеТипов("Дата",, Новый КвалификаторыДаты(ЧастиДаты.Дата)));
			ТаблицаТипизированная.Колонки.Добавить("Наименование", Новый ОписаниеТипов("Строка", ,Новый КвалификаторыСтроки(100)));
			ТаблицаТипизированная.Колонки.Добавить("ИНН", Новый ОписаниеТипов("Строка", ,Новый КвалификаторыСтроки(100)));
			ТаблицаТипизированная.Колонки.Добавить("ID",Новый ОписаниеТипов("Число",, Новый КвалификаторыЧисла(10, 0, ДопустимыйЗнак.Неотрицательный)));
			ТаблицаТипизированная.Колонки.Добавить("СуммаДокумента", Новый ОписаниеТипов("Число",, Новый КвалификаторыЧисла(10, 2, ДопустимыйЗнак.Неотрицательный)));
			ТаблицаТипизированная.Колонки.Добавить("Комментарий", Новый ОписаниеТипов("Строка", ,Новый КвалификаторыСтроки(100)));
			ТЗ = ИнтеграцияСВнешнимиСистемамиСервер.ЧитатьДанныйНаВнешнейТаблицеADO(стрПоля, ЗапросSQL, СтрокаСоединения, ТаблицаТипизированная);
			ТаблицаОтсутствующихСчетов = ПолучитьТаблицуНеСинхронизированныхСчетов(ТЗ, ОсновнаяОрганизация);	
			
			Если ТаблицаОтсутствующихСчетов.Количество() > 0 Тогда
				СформиротьСчета(ТаблицаОтсутствующихСчетов, ОсновнаяОрганизация);	
			КонецЕсли;
		КонецЦикла;
		
		УправлениеДокументамиСервер.СинхронизироватьПризнакВыставленияДокументов();
	Исключение
		Сообщить(ОписаниеОшибки());
	КонецПопытки;
	
	ТекстСообщения = ОбщегоНазначения.ПолучитьТексИзМассиваСообщенийПользователю();
	Если Не ПустаяСтрока(ТекстСообщения) Тогда
		РаботаСЭлектроннойПочтойСервер.ОтправитьПисьмоОбОшибке("Ошибка РЗ СинхронизацияСFM", ТекстСообщения); 
	КонецЕсли;
КонецПроцедуры

Процедура СинхронизироватьПризнакВыставленияДокументов() Экспорт 
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	СчетПокупателя.Ссылка КАК Ссылка,
	               |	СчетПокупателя.НомерFM КАК НомерFM,
	               |	СчетПокупателя.Организация КАК Организация,
	               |	СчетПокупателя.ДокументыСформированы КАК ДокументыСформированы,
	               |	СчетПокупателя.СуммаДокумента КАК СуммаДокумента
	               |ИЗ
	               |	Документ.СчетПокупателя КАК СчетПокупателя
	               |ГДЕ
	               |	СчетПокупателя.Проведен
	               |	И НЕ СчетПокупателя.Отменен
	               |ИТОГИ ПО
	               |	Организация";
	ВыборкаОрганизация = ЗАпрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаОрганизация.Следующий() Цикл 
		Коннектор = ОбменДаннымиСервер.ПодключитьКоннекторДляОбмена(ВыборкаОрганизация.Организация);
		//МассивСформированнаыеКоннектор = Коннектор.NewObject("Массив");
		//МассивНеСформированнаыеКоннектор = Коннектор.NewObject("Массив"); \
		ТЗКоннектор = ПолучитьТаблицуСформированныхДокументов(Коннектор);
		ВыборкаСчет = ВыборкаОрганизация.Выбрать();
		Пока ВыборкаСчет.Следующий() Цикл 
			СтрокаТЗ = ТЗКоннектор.Найти(Формат(ВыборкаСчет.НомерFM, "ЧГ="), "НомерСчета");
			Если Не СтрокаТЗ = Неопределено 
				И СтрокаТЗ.СуммаДокумента = ВыборкаСчет.СуммаДокумента Тогда  
				
				Если Не ВыборкаСчет.ДокументыСформированы Тогда 
					ОбъектСчет = ВыборкаСчет.Ссылка.ПолучитьОбъект();
					ОбъектСчет.ДокументыСформированы = Истина;
					ОбъектСчет.Записать(РежимЗаписиДокумента.Проведение);
				КонецЕсли;
				
			ИначеЕсли ВыборкаСчет.ДокументыСформированы Тогда
					ОбъектСчет = ВыборкаСчет.Ссылка.ПолучитьОбъект();
					ОбъектСчет.ДокументыСформированы = Ложь;
					ОбъектСчет.Записать(РежимЗаписиДокумента.Проведение);			
			КонецЕсли;
			//Если ВыборкаСчет.ДокументыСформированы Тогда
			//	МассивСформированнаыеКоннектор.Добавить(Формат(ВыборкаСчет.НомерFM, "ЧГ="));			
			//Иначе
			//	МассивНеСформированнаыеКоннектор.Добавить(Формат(ВыборкаСчет.НомерFM, "ЧГ="));	
			//КонецЕсли;
				
		КонецЦикла;	
	КонецЦикла;

	

КонецПроцедуры

Функция ПолучитьТаблицуСформированныхДокументов(Коннектор)
	ЗапросКоннектор = Коннектор.NewObject("Запрос");
	ЗапросКоннектор.Текст = "ВЫБРАТЬ
							|	РеализацияТоваровУслуг.СчетНаОплатуПокупателю.Ссылка КАК СсылкаСчет,
							|	РеализацияТоваровУслуг.СчетНаОплатуПокупателю.Номер КАК Номер,
							|	РеализацияТоваровУслуг.СчетНаОплатуПокупателю.СуммаДокумента КАК СуммаДокумента
							|ИЗ
							|	Документ.РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
							|ГДЕ
							|	РеализацияТоваровУслуг.Проведен";
							//|	И РеализацияТоваровУслуг.СчетНаОплатуПокупателю.Номер В(&МассивНомеровСчета)";
	//ЗапросКоннектор.УстановитьПараметр("МассивНомеровСчета", МассивСформированнаыеКоннектор);
	ТЗКоннектор = ЗапросКоннектор.Выполнить().Выгрузить();
	ТЗКоннектор.Колонки.Добавить("НомерСчета");
	Для Каждого СтрокаСчет ИЗ ТЗКоннектор Цикл 
		СтрокаСчет.НомерСчета = СокрЛП(СтрокаСчет.Номер);	
	КонецЦикла;
	Возврат ТЗКоннектор	
КонецФункции

Функция ПолучитьТаблицуНеСинхронизированныхСчетов(ТаблицаСчетовFM, ОсновнаяОрганизация)
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ТаблицаСчетов.НомерFM КАК НомерFM,
	               |	ТаблицаСчетов.Дата КАК Дата,
	               |	ТаблицаСчетов.ИНН КАК ИНН,
	               |	ТаблицаСчетов.Наименование КАК Наименование,
	               |	ТаблицаСчетов.ID КАК ID,
	               |	ТаблицаСчетов.СуммаДокумента КАК СуммаДокумента,
	               |	ТаблицаСчетов.Комментарий КАК Комментарий
	               |ПОМЕСТИТЬ ТаблицаСчетов
	               |ИЗ
	               |	&ТаблицаСчетов КАК ТаблицаСчетов
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ТаблицаСчетов.НомерFM КАК НомерFM,
	               |	ТаблицаСчетов.Дата КАК Дата,
	               |	ТаблицаСчетов.ИНН КАК ИНН,
	               |	ТаблицаСчетов.Наименование КАК Наименование,
	               |	ТаблицаСчетов.ID КАК ID,
	               |	ТаблицаСчетов.СуммаДокумента КАК СуммаДокумента,
	               |	ТаблицаСчетов.Комментарий КАК Комментарий,
	               |	СчетаПокупателя.Ссылка КАК Ссылка
	               |ИЗ
	               |	ТаблицаСчетов КАК ТаблицаСчетов
	               |		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	               |			СчетПокупателя.Ссылка КАК Ссылка,
	               |			СчетПокупателя.НомерFM КАК НомерFM,
	               |			СчетПокупателя.Изменил КАК Изменил
	               |		ИЗ
	               |			Документ.СчетПокупателя КАК СчетПокупателя
	               |		ГДЕ
	               |			СчетПокупателя.Организация = &Организация) КАК СчетаПокупателя
	               |		ПО ТаблицаСчетов.НомерFM = СчетаПокупателя.НомерFM
	               |ГДЕ
	               |	(СчетаПокупателя.Ссылка ЕСТЬ NULL
	               |			ИЛИ СчетаПокупателя.Изменил = ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяССылка))";
	Запрос.УстановитьПараметр("Организация", ОсновнаяОрганизация);			   
	Запрос.УстановитьПараметр("ТаблицаСчетов", ТаблицаСчетовFM);
	ТаблицаСчетов = Запрос.Выполнить().Выгрузить();
	
	Возврат ТаблицаСчетов;	
КонецФункции

Функция НайтиСоздатьКонтрагента(Наименование, ИНН = Неопределено, ID)
	Перем ЗначениеВозврата;
	КонтрагентСсылка = Справочники.Контрагенты.НайтиПоРеквизиту("НомерFM", ID);
	Если КонтрагентСсылка = ПредопределенноеЗначение("Справочник.Контрагенты.ПустаяСсылка") Тогда 	
		Если ЗначениеЗаполнено(ИНН) Тогда
			КонтрагентСсылка = Справочники.Контрагенты.НайтиПоРеквизиту("ИНН", ИНН);
			Если КонтрагентСсылка = ПредопределенноеЗначение("Справочник.Контрагенты.ПустаяСсылка") Тогда
				КонтрагентСсылка = СоздатьКонтрагента(Новый Структура("Наименование, ПолноеНаименование, ИНН, НомерFM", Наименование, Наименование, ИНН, ID));
			КонецЕсли;
		Иначе
			КонтрагентСсылка = Справочники.Контрагенты.НайтиПоРеквизиту("ПолноеНаименование", Наименование);
			Если КонтрагентСсылка = ПредопределенноеЗначение("Справочник.Контрагенты.ПустаяСсылка") Тогда
				КонтрагентСсылка = СоздатьКонтрагента(Новый Структура("Наименование, ПолноеНаименование, НомерFM", Наименование, Наименование, ID));
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	ЗначениеВозврата = КонтрагентСсылка;
	Возврат	ЗначениеВозврата;

КонецФункции // НайтиСоздатьКонтрагента(ИНН, Наименование)()

Функция СоздатьКонтрагента(стрПараметры) Экспорт 
	Перем ЗначениеВозврата;
	Если Не стрПараметры.Свойство("Наименование") Тогда
		Сообщить("Не заполнен обязательный параметр Наименование", СтатусСообщения.Важное);
		Возврат ЗначениеВозврата;	
	КонецЕсли;
	
	КонтрагентОбъект = Справочники.Контрагенты.СоздатьЭлемент();
	ЗаполнитьЗначенияСвойств(КонтрагентОбъект, стрПараметры);
	Если Не стрПараметры.Свойство("ЮрФизЛицо") Тогда 
		КонтрагентОбъект.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ЮрЛицо;	
	КонецЕсли;
	КонтрагентОбъект.ИмпортИЗFM = Истина;
	КонтрагентОбъект.Записать();
	
	Возврат КонтрагентОбъект.Ссылка;
КонецФункции

Процедура СформиротьСчета(ТаблицаСчетов, ОсновнаяОрганизация)
	СтрокаСоединения = ОбщегоНазначенияПовтИсп.ПолучитьСтрокуСоединенияFM(ОсновнаяОрганизация);
	Для Каждого СтрокаСчет ИЗ ТаблицаСчетов Цикл 		
		ТЗТовары = Неопределено;
		УникальныйИдентификатор = Новый УникальныйИдентификатор;
		АдресТаблицы = ПоместитьВоВременноеХранилище(ТЗТовары, УникальныйИдентификатор);
		ПолучитьТаблицуТоваровИзFM(Новый Структура("НомерСчета", СтрокаСчет.НомерFM), АдресТаблицы, СтрокаСоединения); 
		ТаблицаТоваров = ПолучитьИзВременногоХранилища(АдресТаблицы);
		Если СтрокаСчет.Ссылка = null Тогда
			НовыйСчет = Документы.СчетПокупателя.СоздатьДокумент();
		Иначе
			НовыйСчет = СтрокаСчет.Ссылка.ПолучитьОбъект();
		КонецЕсли;
		Контрагент = НайтиСоздатьКонтрагента(СтрокаСчет.Наименование, СтрокаСчет.ИНН, СтрокаСчет.ID);
		НовыйСчет.Контрагент = Контрагент; 
		//НовыйСчет.Организация = ОбщегоНазначенияПовтИсп.ПолучитьЗначениеКонстанты("УПОсновнаяОрганизация");
		НовыйСчет.Организация = ОсновнаяОрганизация;
		ЗаполнитьЗначенияСвойств(НовыйСчет, СтрокаСчет, "НомерFM, Дата, СуммаДокумента, Комментарий");
		НовыйСчет.Товары.Очистить();
		Для Каждого СтрокаТовар ИЗ ТаблицаТоваров Цикл 
			НоваяСтрока = НовыйСчет.Товары.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТовар);
			НоваяСтрока.Наименование = СокрЛП(СтрокаТовар.Наименование);
			НоваяСтрока.Наименование = СТРЗаменить(НоваяСтрока.Наименование, Символ(0), "");
		КонецЦикла;
		НовыйСчет.ИмпортИзFM = Истина;
		Если Не НовыйСчет.ПометкаУдаления Тогда
			НовыйСчет.Записать(РежимЗаписиДокумента.Проведение);
		Иначе
			НовыйСчет.Записать(РежимЗаписиДокумента.Запись);
		КонецЕсли;
	КонецЦикла;	
КонецПроцедуры

Процедура ПолучитьТаблицуТоваровИзFM(стрПараметры, АдресХранилища, СтрокаСоединения) Экспорт 
	//СтрокаСоединения = ОбщегоНазначенияПовтИсп.ПолучитьЗначениеКонстанты("FMСтрокаПодключения");
	ЗапросSQL = "Select inv.service, inv.Item, inv.Qty, inv.""Unit Price"", inv.Amount from ""Invoice Data"" AS inv where inv.""INVOICE ID MATCH FIELD"" = " + Формат(стрПараметры.НомерСчета,"ЧГ=");
	стрПоля = Новый Структура("Наименование, Количество, Цена, Сумма, Услуга", "Item", "Qty", "Unit Price", "Amount", "service");
	ТЗ = ИнтеграцияСВнешнимиСистемамиСервер.ЧитатьДанныйНаВнешнейТаблицеADO(стрПоля, ЗапросSQL, СтрокаСоединения);
	ПоместитьВоВременноеХранилище(ТЗ, АдресХранилища);
КонецПроцедуры

Функция ПроверитьЗаполнениеРеквизитовКонтргента(Коннектор, Контрагент) Экспорт 
	ЗначениеВозврата = "";	
	КонтрагентБП = Коннектор.Справочники.Контрагенты.НайтиПоРеквизиту("ИНН", Контрагент.ИНН);
	Если КонтрагентБП = Коннектор.Справочники.Контрагенты.ПустаяСсылка() И Контрагент.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ЮрЛицо    
			//И (ПустаяСтрока(Контрагент.КПП) ИЛИ ПустаяСтрока(Контрагент.ПолноеНаименование) 
			И (ПустаяСтрока(Контрагент.ПолноеНаименование) 
				ИЛИ ПустаяСтрока(Контрагент.ЮридическийАдрес)) Тогда
		ЗначениеВозврата = "Для Контрагента не заполнены основные реквизиты(КПП, ПолноеНаименование, ЮридическийАдрес). Для продолжения работы все эти реквизиты должны быть заполнены!";
	КонецЕсли;
	
	Возврат ЗначениеВозврата;
КонецФункции // ПроверитьЗаполнениеРеквизитовКонтргента()

Функция ПроверитьДатуЗапретаРедактирования(Коннектор, ДатаДокументов)
	СообщениеПользователю = "";
	ЗапросКоннектор = Коннектор.NewObject("Запрос");
	ЗапросКоннектор.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
							|	ГраницыЗапретаИзмененияДанных.Организация.Наименование КАК НаименованиеОрганизации,
							|	ГраницыЗапретаИзмененияДанных.ГраницаЗапретаИзменений КАК ДатаГраницы
							|ИЗ
							|	РегистрСведений.ГраницыЗапретаИзмененияДанных КАК ГраницыЗапретаИзмененияДанных
							|ГДЕ
							|	ГраницыЗапретаИзмененияДанных.Пользователь = НЕОПРЕДЕЛЕНО";
	Выборка = ЗапросКоннектор.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Если ДатаДокументов < Выборка.ДатаГраницы Тогда
						
			СообщениеПользователю = "Для организации " + Выборка.НаименованиеОрганизации + " формирование документов раньше " + Формат(Выборка.ДатаГраницы, "ДФ=dd.MM.yyyy") + " запрещено! " + Символы.ПС + "Для открытия периода обратитесь в бухгалтерию.";  	
	    КонецЕсли;
	КонецЕсли;
	
	Возврат СообщениеПользователю
КонецФункции // ПроверитьДатуЗапретаРедактирования()

Процедура ПроверитьНаличиеСформированногоДокументаВоВнешнейБД(стрПараметры, АдресХранилища) Экспорт 
	булДокументыСформированы = Истина;
	СообщениеПользователю = "";
	стрВозврат = Новый Структура("СчетПокупателя", стрПараметры.СсылкаСчет);
	ссылкаСчет = стрПараметры.СсылкаСчет;
	ДлительныеОперации.СообщитьПрогресс(, "Выполняется подключение к внешней базе");
	Коннектор = ОбменДаннымиСервер.ПодключитьКоннекторДляОбмена(стрПараметры.СсылкаСчет.Организация);
	ДлительныеОперации.СообщитьПрогресс(, "Выполняется поиск документа " + ссылкаСчет + " во внешней базе");
	СчетНаОплатуСсылка = Коннектор.Документы.СчетНаОплатуПокупателю.НайтиПоНомеру(Строка(ссылкаСчет.НомерFM), ссылкаСчет.Дата);
	Если СчетНаОплатуСсылка = Коннектор.Документы.СчетНаОплатуПокупателю.ПустаяСсылка() Тогда
		СообщениеПользователю = ПроверитьЗаполнениеРеквизитовКонтргента(Коннектор, ссылкаСчет.Контрагент);
		булДокументыСформированы = Ложь;
	Иначе
		стрЗапросФайлы = Новый Структура;
		стрЗапросФайлы.Вставить("СчетНаОплату", СчетНаОплатуСсылка);
		РТУСсылка =  Коннектор.Документы.РеализацияТоваровУслуг.НайтиПоРеквизиту("СчетНаОплатуПокупателю", СчетНаОплатуСсылка);		
		Если НЕ РТУСсылка = Коннектор.Документы.РеализацияТоваровУслуг.ПустаяСсылка() Тогда
			//стрЗапросФайлы.Вставить("Акт", РТУСсылка);
			СчетФактураСсылка =  Коннектор.Документы.СчетФактураВыданный.НайтиПоРеквизиту("ДокументОснование", РТУСсылка);
			Если НЕ СчетФактураСсылка = Коннектор.Документы.СчетФактураВыданный.ПустаяСсылка() Тогда
				стрЗапросФайлы.Вставить("СФ", СчетФактураСсылка);	
			КонецЕсли;
			//Если РТУСсылка.Товары.Количество() > 0 Тогда 
			//	стрЗапросФайлы.Вставить("ТоварнаяНакладная", РТУСсылка);
			//КонецЕсли;
			//Если РТУСсылка.Услуги.Количество() > 0 Тогда 
			//	стрЗапросФайлы.Вставить("Акт", РТУСсылка);
			//КонецЕсли;				
			стрЗапросФайлы.Вставить("РТУ", РТУСсылка);
		Иначе
			булДокументыСформированы = Ложь;	
		КонецЕсли;
		Если стрПараметры.Свойство("ПоДоверенности") Тогда
			стрЗапросФайлы.Вставить("ПоДоверенности", стрПараметры.ПоДоверенности);
		КонецЕсли;
		
		стрPDFФайлыДокументов = УправлениеГенерациеДокументов.СформироватьФайлыДокументов(Коннектор, стрЗапросФайлы, "(Счет " + ссылкаСчет.Номер + ")");
		стрВозврат.Вставить("Файлы", стрPDFФайлыДокументов);
		стрВозврат.Вставить("Дата", СчетНаОплатуСсылка.Дата);
	КонецЕсли;

	стрВозврат.Вставить("булДокументыСформированы", булДокументыСформированы);
	стрВозврат.Вставить("СообщениеПользователю", СообщениеПользователю);
	
	ПоместитьВоВременноеХранилище(стрВозврат, АдресХранилища);
КонецПроцедуры // ПроверитьНаличиеСформированногоДокументаВоВнешнейБД()

Процедура СформироватьДокумнтыПоСчету(стрПараметры, АдресХранилища = Неопределено) Экспорт 
	Перем ТЗТовары, СообщениеОбОшибке, СчетНаОплатуСсылка;
	
	УникальныйИдентификатор = Новый УникальныйИдентификатор;
	//АдресТаблицы = ПоместитьВоВременноеХранилище(ТЗТовары, УникальныйИдентификатор);	
	//ПолучитьТаблицуТоваровИзFM(стрПараметры, АдресТаблицы);
	//ТЗТовары = ПолучитьИзВременногоХранилища(АдресТаблицы);
	ТЗТовары = стрПараметры.СчетПокупателя.Товары.Выгрузить(); 
	Коннектор = ОбменДаннымиСервер.ПодключитьКоннекторДляОбмена(стрПараметры.СчетПокупателя.Организация);
	СообщениеПользователю = ПроверитьЗаполнениеРеквизитовКонтргента(Коннектор, стрПараметры.СчетПокупателя.Контрагент);
	Если ПустаяСтрока(СообщениеПользователю) Тогда
		СообщениеПользователю = ПроверитьДатуЗапретаРедактирования(Коннектор, стрПараметры.Дата);	
	КонецЕсли;
	Если Не ПустаяСтрока(СообщениеПользователю) Тогда
		ВызватьИсключение СообщениеПользователю;
	КонецЕсли;
	Коннектор.НачатьТранзакцию();
	Если стрПараметры.ПереформироватьДокументы Тогда
		СсылкаСчетНаОплату = Коннектор.Документы.СчетНаОплатуПокупателю.НайтиПоНомеру(Строка(стрПараметры.СчетПокупателя.НомерFM), стрПараметры.СчетПокупателя.Дата);
		Если СсылкаСчетНаОплату = Коннектор.Документы.СчетНаОплатуПокупателю.ПустаяСсылка() Тогда
			СсылкаСчетНаОплату = Неопределено;
		КонецЕсли;
	КонецЕсли;
	//Если Не СсылкаСчетНаОплату = Неопределено 
	//	И Не СчетНаОплатуСсылка = Коннектор.Документы.СчетНаОплатуПокупателю.ПустаяСсылка() Тогда
	//	
	//КонецЕсли;

	СсылкаСчетНаОплату = УправлениеГенерациеДокументов.СоздатьСчетНаОплатуПокупателяСТоваром(СсылкаСчетНаОплату, Коннектор, стрПараметры.СчетПокупателя, ТЗТовары, стрПараметры.Дата); 
	Если Не СсылкаСчетНаОплату = Неопределено Тогда 
		стрРТУиСФ = УправлениеГенерациеДокументов.СоздатьДокументРТУ(Коннектор, СсылкаСчетНаОплату, стрПараметры.Дата, стрПараметры.Префикс, стрПараметры.ПереформироватьДокументы);
	КонецЕсли;
	Коннектор.ЗафиксироватьТранзакцию();
	
	стрРТУиСФ.Вставить("СчетНаОплату", СсылкаСчетНаОплату);
	//Если стрРТУиСФ.РТУ.Товары.Количество() > 0 Тогда 
	//	стрРТУиСФ.Вставить("ТоварнаяНакладная", стрРТУиСФ.РТУ);
	//КонецЕсли;
	//Если стрРТУиСФ.РТУ.Услуги.Количество() > 0 Тогда 
	//	стрРТУиСФ.Вставить("Акт", стрРТУиСФ.РТУ);
	//КонецЕсли;		
	стрРТУиСФ.Вставить("РТУ", стрРТУиСФ.РТУ);
	Если стрПараметры.Свойство("ПоДоверенности") Тогда
		стрРТУиСФ.Вставить("ПоДоверенности", стрПараметры.ПоДоверенности);
	КонецЕсли;	
	стрPDFФайлыДокументов = УправлениеГенерациеДокументов.СформироватьФайлыДокументов(Коннектор, стрРТУиСФ, "(Счет " + стрПараметры.НомерСчета + ")");
	стрПараметры.Вставить("Файлы", стрPDFФайлыДокументов);
	ПоместитьВоВременноеХранилище(стрПараметры, АдресХранилища);
КонецПроцедуры // ПроверитьНаличиеСформированногоДокументаВоВнешнейБД()
