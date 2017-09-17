
#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ЗаполнитьСрокиПовторногоНапоминания();
	СрокПовторногоОповещения = "15м";
	СрокПовторногоОповещения = РаботаСНапоминаниямиКлиент.ОформитьВремя(СрокПовторногоОповещения);
	ОбновитьТаблицуНапоминаний();
	ОбновитьВремяВТаблицеНапоминаний();
	Активизировать();
КонецПроцедуры

&НаКлиенте
Процедура ПриПовторномОткрытии()
	ОбновитьТаблицуНапоминаний();
	ОбновитьВремяВТаблицеНапоминаний();
	ЭтотОбъект.ТекущийЭлемент = Элементы.СрокПовторногоОповещения;
	Активизировать();
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	ОтложитьАктивныеНапоминания();
	РаботаСНапоминаниямиКлиент.СброситьТаймерПроверкиТекущихОповещений();
	
	// Принудительное отключение обработчиков необходимо в связи с тем, что форма не выгружается из памяти.
	ОтключитьОбработчикОжидания("ОбновитьТаблицуНапоминаний");
	ОтключитьОбработчикОжидания("ОбновитьВремяВТаблицеНапоминаний");
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СрокПовторногоОповещенияПриИзменении(Элемент)
	СрокПовторногоОповещения = РаботаСНапоминаниямиКлиент.ОформитьВремя(СрокПовторногоОповещения);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыНапоминания

&НаКлиенте
Процедура НапоминанияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ОткрытьНапоминание();
КонецПроцедуры

&НаКлиенте
Процедура НапоминанияПриАктивизацииСтроки(Элемент)
	
	Если Элемент.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
		
	Источник = Элемент.ТекущиеДанные.Источник;
	ИсточникСтрокой = Элемент.ТекущиеДанные.ИсточникСтрокой;
	
	ЕстьИсточник = ЗначениеЗаполнено(Источник);
	Элементы.НапоминанияКонтекстноеМенюОткрыть.Доступность = ЕстьИсточник;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Изменить(Команда)
	РедактироватьНапоминание();
КонецПроцедуры

&НаКлиенте
Процедура КомандаОткрыть(Команда)
	ОткрытьНапоминание();
КонецПроцедуры

&НаКлиенте
Процедура Отложить(Команда)
	ОтложитьАктивныеНапоминания();
КонецПроцедуры

&НаКлиенте
Процедура Прекратить(Команда)
	//Если Элементы.Напоминания.ТекущиеДанные = Неопределено Тогда
	//	Возврат;
	//КонецЕсли;
	//
	//Для Каждого ИндексСтроки Из Элементы.Напоминания.ВыделенныеСтроки Цикл
	//	ДанныеСтроки = Напоминания.НайтиПоИдентификатору(ИндексСтроки);
	//
	//	ПараметрыНапоминания = НапоминанияПользователяКлиентСервер.ОписаниеНапоминания(ДанныеСтроки);
	//	
	//	ОтключитьНапоминание(ПараметрыНапоминания);
	//	НапоминанияПользователяКлиент.УдалитьЗаписьИзКэшаОповещений(ДанныеСтроки);
	//КонецЦикла;
	//
	//ОповеститьОбИзменении(Тип("РегистрСведенийКлючЗаписи.НапоминанияПользователя"));
	//
	//ОбновитьТаблицуНапоминаний();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПодключитьНапоминание(ПараметрыНапоминания)
	РаботаСНапоминаниямиСервер.ПодключитьНапоминание(ПараметрыНапоминания, Истина);
КонецПроцедуры

//&НаСервере
//Процедура ОтключитьНапоминание(ПараметрыНапоминания)
//	НапоминанияПользователяСлужебный.ОтключитьНапоминание(ПараметрыНапоминания);
//КонецПроцедуры

&НаКлиенте
Процедура ОбновитьТаблицуНапоминаний() 

	ОтключитьОбработчикОжидания("ОбновитьТаблицуНапоминаний");
	
	ВремяБлижайшего = Неопределено;
	ТаблицаНапоминаний = РаботаСНапоминаниямиКлиент.ПолучитьТекущиеОповещения(ВремяБлижайшего);
	Для Каждого Напоминание Из ТаблицаНапоминаний Цикл
		НайденныеСтроки = Напоминания.НайтиСтроки(Новый Структура("Источник,ВремяСобытия", Напоминание.Источник, Напоминание.ВремяСобытия));
		Если НайденныеСтроки.Количество() > 0 Тогда
			ЗаполнитьЗначенияСвойств(НайденныеСтроки[0], Напоминание, , "СрокНапоминания");
		Иначе
			НоваяСтрока = Напоминания.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Напоминание);
		КонецЕсли;
	КонецЦикла;
	
	СтрокиНаУдаление = Новый Массив;
	Для Каждого Напоминание Из Напоминания Цикл
		Если ЗначениеЗаполнено(Напоминание.Источник) И ПустаяСтрока(Напоминание.ИсточникСтрокой) Тогда
			ОбновитьПредставленияПредметов();
		КонецЕсли;
			
		СтрокаНайдена = Ложь;
		Для Каждого СтрокаКэша Из ТаблицаНапоминаний Цикл
			Если СтрокаКэша.Источник = Напоминание.Источник И СтрокаКэша.ВремяСобытия = Напоминание.ВремяСобытия Тогда
				СтрокаНайдена = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Если Не СтрокаНайдена Тогда 
			СтрокиНаУдаление.Добавить(Напоминание);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого Строка Из СтрокиНаУдаление Цикл
		Напоминания.Удалить(Строка);
	КонецЦикла;
	
	УстановитьВидимость();
	
	Интервал = 15; // Обновление таблицы не реже чем 1 раз в 15 сек.
	Если ВремяБлижайшего <> Неопределено Тогда 
		Интервал = Макс(Мин(Интервал, ВремяБлижайшего - ТекущаяДата()), 1); 
	КонецЕсли;
	
	ПодключитьОбработчикОжидания("ОбновитьТаблицуНапоминаний", Интервал, Истина);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьПредставленияПредметов()
	
	Для Каждого Напоминание Из Напоминания Цикл
		Если ЗначениеЗаполнено(Напоминание.Источник) Тогда
			Напоминание.ИсточникСтрокой = ОбщегоНазначения.ПредметСтрокой(Напоминание.Источник);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Функция МодульЧисла(Число)
	Если Число >= 0 Тогда
		Возврат Число;
	Иначе
		Возврат -Число;
	КонецЕсли;
КонецФункции

&НаКлиенте
Процедура ОбновитьВремяВТаблицеНапоминаний()
	ОтключитьОбработчикОжидания("ОбновитьВремяВТаблицеНапоминаний");
	
	Для Каждого СтрокаТаблицы Из Напоминания Цикл
		ПредставлениеВремени = НСтр("ru = 'срок не определен'");
		
		Если ЗначениеЗаполнено(СтрокаТаблицы.ВремяСобытия) Тогда
			ТекущаяДата = ТекущаяДата();
			Время = ТекущаяДата - СтрокаТаблицы.ВремяСобытия;
			Если СтрокаТаблицы.ВремяСобытия - НачалоДня(СтрокаТаблицы.ВремяСобытия) < 60 // События "на весь день".
				И НачалоДня(СтрокаТаблицы.ВремяСобытия) = НачалоДня(ТекущаяДата) Тогда
					ПредставлениеВремени = НСтр("ru = 'сегодня'");
			Иначе
				Если МодульЧисла(Время) > 60*60*24 Тогда
					Время = НачалоДня(ТекущаяДата()) - НачалоДня(СтрокаТаблицы.ВремяСобытия);
				КонецЕсли;
				ПредставлениеВремени = ПредставлениеИнтервалаВремени(Время);
			КонецЕсли;
		КонецЕсли;
		
		Если СтрокаТаблицы.ВремяСобытияСтрока <> ПредставлениеВремени Тогда
			СтрокаТаблицы.ВремяСобытияСтрока = ПредставлениеВремени;
		КонецЕсли;
		
	КонецЦикла;
	
	ПодключитьОбработчикОжидания("ОбновитьВремяВТаблицеНапоминаний", 5, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ОтложитьАктивныеНапоминания()
	ИнтервалВремени = РаботаСНапоминаниямиКлиент.ПолучитьИнтервалВремениИзСтроки(СрокПовторногоОповещения);
	ТекДата = ТекущаяДата();
	Для Каждого СтрокаТаблицы Из Напоминания Цикл
		СтрокаТаблицы.СрокНапоминания = ТекДата + ИнтервалВремени;
		
		ПараметрыНапоминания = РаботаСНапоминаниямиКлиент.ОписаниеНапоминания(СтрокаТаблицы);
		
		ПодключитьНапоминание(ПараметрыНапоминания);
		//НапоминанияПользователяКлиент.ОбновитьЗаписьВКэшеОповещений(СтрокаТаблицы);
	КонецЦикла;
	ОбновитьТаблицуНапоминаний();
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьНапоминание()
	Если Элементы.Напоминания.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Источник = Элементы.Напоминания.ТекущиеДанные.Источник;
	Если ЗначениеЗаполнено(Источник) Тогда
		ПоказатьЗначение(, Источник);
	Иначе
		РедактироватьНапоминание();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьНапоминание()
	Источник = Элементы.Напоминания.ТекущиеДанные.Источник; 
	ПоказатьЗначение(,Источник);
	//ПараметрыНапоминания = Новый Структура("Пользователь,Источник,ВремяСобытия");
	//ЗаполнитьЗначенияСвойств(ПараметрыНапоминания, Элементы.Напоминания.ТекущиеДанные);
	//
	//ОткрытьФорму("РегистрСведений.НапоминанияПользователя.Форма.Напоминание", Новый Структура("Ключ", ПолучитьКлючЗаписи(ПараметрыНапоминания)));
КонецПроцедуры

//&НаСервере
//Функция ПолучитьКлючЗаписи(ПараметрыНапоминания)
//	Возврат РегистрыСведений.НапоминанияПользователя.СоздатьКлючЗаписи(ПараметрыНапоминания);
//КонецФункции

&НаКлиенте
Процедура УстановитьВидимость()
	ЕстьДанныеВТаблице = Напоминания.Количество() > 0;
	
	Если Не ЕстьДанныеВТаблице И ЭтотОбъект.Открыта() Тогда
		ЭтотОбъект.Закрыть();
	КонецЕсли;
	
	Элементы.ПанельКнопок.Доступность = ЕстьДанныеВТаблице;
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСрокиПовторногоНапоминания()
	Для Каждого Элемент Из Элементы.СрокПовторногоОповещения.СписокВыбора Цикл
		Элемент.Представление = РаботаСНапоминаниямиКлиент.ОформитьВремя(Элемент.Значение); 
	КонецЦикла;
КонецПроцедуры	

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "Запись_НапоминанияПользователя" Тогда 
		ОбновитьТаблицуНапоминаний();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Функция ПредставлениеИнтервалаВремени(Знач КоличествоВремени)
	Результат = "";
	
	ПредставлениеНедель = НСтр("ru = 'неделю'") + "," + НСтр("ru = 'недели'") + "," + НСтр("ru = 'недель'");
	ПредставлениеДней = НСтр("ru = 'день'") + "," + НСтр("ru = 'дня'") + "," + НСтр("ru = 'дней'");
	ПредставлениеЧасов = НСтр("ru = 'час'") + "," + НСтр("ru = 'часа'") + "," + НСтр("ru = 'часов'");
	ПредставлениеМинут = НСтр("ru = 'минуту'") + "," + НСтр("ru = 'минуты'") + "," + НСтр("ru = 'минут'");
	
	КоличествоВремени = Число(КоличествоВремени);
	ТекущаяДата = ТекущаяДата();
	
	СобытиеНаступило = Истина;
	СобытиеСегодня = НачалоДня(ТекущаяДата - КоличествоВремени) = НачалоДня(ТекущаяДата);
	ШаблонПредставления = НСтр("ru = '%1 назад'");
	Если КоличествоВремени < 0 Тогда
		ШаблонПредставления = НСтр("ru = 'через %1'");
		КоличествоВремени = -КоличествоВремени;
		СобытиеНаступило = Ложь;
	КонецЕсли;
	
	КоличествоНедель = Цел(КоличествоВремени / 60/60/24/7);
	КоличествоДней   = Цел(КоличествоВремени / 60/60/24);
	КоличествоЧасов  = Цел(КоличествоВремени / 60/60);
	КоличествоМинут  = Цел(КоличествоВремени / 60);
	КоличествоСекунд = Цел(КоличествоВремени);
	
	КоличествоСекунд = КоличествоСекунд - КоличествоМинут * 60;
	КоличествоМинут  = КоличествоМинут - КоличествоЧасов * 60;
	КоличествоЧасов  = КоличествоЧасов - КоличествоДней * 24;
	КоличествоДней   = КоличествоДней - КоличествоНедель * 7;
	
	Если КоличествоНедель > 4 Тогда
		Если СобытиеНаступило Тогда
			Возврат НСтр("ru = 'очень давно'");
		Иначе
			Возврат НСтр("ru = 'еще не скоро'");
		КонецЕсли;
		
	ИначеЕсли КоличествоНедель > 1 Тогда
		Результат = ОбщегоНазначения.ЧислоЦифрамиПредметИсчисленияПрописью(КоличествоНедель, ПредставлениеНедель);
	ИначеЕсли КоличествоНедель > 0 Тогда
		Результат = НСтр("ru = 'неделю'");
		
	ИначеЕсли КоличествоДней > 1 Тогда
		Если НачалоДня(ТекущаяДата) - НачалоДня(ТекущаяДата - КоличествоВремени) = 60*60*24 * 2 Тогда
			Если СобытиеНаступило Тогда
				Возврат НСтр("ru = 'позавчера'");
			Иначе
				Возврат НСтр("ru = 'послезавтра'");
			КонецЕсли;
		Иначе
			Результат = ОбщегоНазначения.ЧислоЦифрамиПредметИсчисленияПрописью(КоличествоДней, ПредставлениеДней);
		КонецЕсли;
	ИначеЕсли КоличествоЧасов + КоличествоДней * 24 > 3 И Не СобытиеСегодня Тогда
			Если СобытиеНаступило Тогда
				Возврат НСтр("ru = 'вчера'");
			Иначе
				Возврат НСтр("ru = 'завтра'");
			КонецЕсли;
	ИначеЕсли КоличествоДней > 0 Тогда
		Результат = НСтр("ru = 'день'");
	ИначеЕсли КоличествоЧасов > 1 Тогда
		Результат = ОбщегоНазначения.ЧислоЦифрамиПредметИсчисленияПрописью(КоличествоЧасов, ПредставлениеЧасов);
	ИначеЕсли КоличествоЧасов > 0 Тогда
		Результат = НСтр("ru = 'час'");
		
	ИначеЕсли КоличествоМинут > 1 Тогда
		Результат = ОбщегоНазначения.ЧислоЦифрамиПредметИсчисленияПрописью(КоличествоМинут, ПредставлениеМинут);
	ИначеЕсли КоличествоМинут > 0 Тогда
		Результат = НСтр("ru = 'минуту'");
		
	Иначе
		Возврат НСтр("ru = 'сейчас'");
	КонецЕсли;
	
	Результат = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонПредставления, Результат);
	
	Возврат Результат;
КонецФункции

#КонецОбласти
