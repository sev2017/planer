
&НаКлиенте
Процедура ПериодСозданияПриИзменении(Элемент)
	Объект.ДеньМесяца = 0;
КонецПроцедуры

&НаКлиенте
Процедура ДеньМесяцаПриИзменении(Элемент)
	Если ЗначениеЗаполнено(Объект.ПериодСоздания) Тогда
		Сообщить("при заданном параметре Период создания, конкретный день не может быть назначен!", СтатусСообщения.Важное);
		Объект.ДеньМесяца = 0;
	КонецЕсли;
КонецПроцедуры
