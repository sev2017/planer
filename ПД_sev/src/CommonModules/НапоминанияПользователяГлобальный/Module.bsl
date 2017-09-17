////////////////////////////////////////////////////////////////////////////////
// Подсистема "Напоминания пользователя".
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Открывает форму текущих напоминаний пользователя.
//
Процедура ПроверитьТекущиеНапоминания() Экспорт

	//ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента();
	//ИнтервалПроверкиНапоминаний = ПараметрыРаботыКлиента.НастройкиНапоминаний.ИнтервалПроверкиНапоминаний;
	//ИнтервалПроверкиНапоминаний = 60;	
	// Открываем форму текущих оповещений.
	ВремяБлижайшего = Неопределено;
	//ИнтервалСледующейПроверки = ИнтервалПроверкиНапоминаний * 60;
	ИнтервалСледующейПроверки = 60;
	
	Если РаботаСНапоминаниямиКлиент.ПолучитьТекущиеОповещения(ВремяБлижайшего).Количество() > 0 Тогда
		РаботаСНапоминаниямиКлиент.ОткрытьФормуОповещения();
	ИначеЕсли ЗначениеЗаполнено(ВремяБлижайшего) Тогда
		ИнтервалСледующейПроверки = Макс(Мин(ВремяБлижайшего - ТекущаяДата(), ИнтервалСледующейПроверки), 1);
	КонецЕсли;
	
	ПодключитьОбработчикОжидания("ПроверитьТекущиеНапоминания", ИнтервалСледующейПроверки, Истина);
	
КонецПроцедуры

#КонецОбласти
