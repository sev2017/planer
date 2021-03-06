
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Объект.Исполнитель = ОбщегоНазначенияПовтИсп.ПолучитьЗначениеПараметраСеанса("ТекущийПользователь");
	Объект.Куратор = ОбщегоНазначенияПовтИсп.ПолучитьЗначениеПараметраСеанса("ТекущийПользователь");
	
	Если Параметры.Свойство("Объект") Тогда 
		Объект.Объект = Параметры.Объект;
		Объект.Наименование = ОбщегоНазначения.ПредметСтрокой(Объект.Объект);
		Элементы.ПредметНапоминания.Заголовок = ОбщегоНазначения.ПредметСтрокой(Объект.Объект);
	КонецЕсли;
	
	//Если ЗначениеЗаполнено(Объект.Источник) Тогда
	//	ЗаполнитьСписокРеквизитовИсточника();
	//КонецЕсли;
	
	
		
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ЗаполнитьСрокиПовторногоНапоминания();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСрокиПовторногоНапоминания()
	Для Каждого Элемент Из Элементы.СрокПовторногоОповещения.СписокВыбора Цикл
		Элемент.Представление = РаботаСНапоминаниямиКлиент.ОформитьВремя(Элемент.Значение); 
	КонецЦикла;
КонецПроцедуры	

&НаКлиенте
Процедура ПредметНапоминанияНажатие(Элемент)
	Если ЗначениеЗаполнено(Объект.Объект) Тогда
		ПоказатьЗначение(, Объект.Объект)
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	ИнтервалВремени = РаботаСНапоминаниямиКлиент.ПолучитьИнтервалВремениИзСтроки(СпособУстановкиВремениНапоминания);
	ТекДата = ТекущаяДата();
	Объект.СрокНапоминания = ТекДата + ИнтервалВремени;
	Объект.ВремяВыполнения = Объект.СрокНапоминания; 
	Записать();
	Состояние(НСтр("ru = 'Напоминание добавлено'"));
	Закрыть();
КонецПроцедуры

#КонецОбласти
