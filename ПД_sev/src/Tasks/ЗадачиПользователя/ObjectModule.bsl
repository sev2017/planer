Перем ПользовательВыполнятель Экспорт;  

Процедура ПередИнтерактивнымВыполнением(Отказ)
	// Вставить содержимое обработчика.
	//Пользователь = ПараметрыСеанса.ТекущийПользователь;
	//
	//Если НЕ Куратор = ПредопределенноеЗначение("Справочник.Пользователи.ПустаяСсылка")
	//	И Куратор.ТелеграмИД > 0 Тогда
	//	ТекстСообщения = "Пользователь <strong>" + Пользователь + "</strong> выполнил задачу" + Символы.ПС + Наименование + Символы.ПС + "<strong>С комментарием</strong> " + Символы.ПС + Комментарий;
	//	ИнтеграцияСTelegramСервер.СообщениеПользователю(Новый Структура("id", Куратор.ТелеграмИД), ТекстСообщения,,, "HTML");
	//КонецЕсли;	
КонецПроцедуры

Процедура ПриВыполнении(Отказ)
	Если НЕ Куратор = ПредопределенноеЗначение("Справочник.Пользователи.ПустаяСсылка")
		И Куратор.ТелеграмИД > 0 Тогда
		ТекстСообщения = "Пользователь <strong>" + ПользовательВыполнятель + "</strong> выполнил задачу" + Символы.ПС + Наименование + Символы.ПС + "<strong>С комментарием</strong> " + Символы.ПС + Комментарий;
		ИнтеграцияСTelegramСервер.СообщениеПользователю(Новый Структура("id", Куратор.ТелеграмИД), ТекстСообщения,,, "HTML");
	КонецЕсли;
	Если Не ПользовательВыполнятель = Исполнитель 
		И Исполнитель.ТелеграмИД > 0 Тогда
		ТекстСообщения = "Пользователь <strong>" + ПользовательВыполнятель + "</strong> выполнил задачу" + Символы.ПС + Наименование + Символы.ПС + "<strong>С комментарием</strong> " + Символы.ПС + Комментарий;
		ИнтеграцияСTelegramСервер.СообщениеПользователю(Новый Структура("id", Исполнитель.ТелеграмИД), ТекстСообщения,,, "HTML");		
	КонецЕсли;
КонецПроцедуры


ПользовательВыполнятель = ПараметрыСеанса.ТекущийПользователь;